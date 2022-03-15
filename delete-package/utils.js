const core = require("@actions/core");

/**
 * Parse input from env.
 * @returns Config
 */
let getConfig = function () {
    const config = {
        owner: core.getInput("owner", { required: true }),
        name: core.getInput("name", { required: true }),
        token: core.getInput("token", { required: true }),

        // optional
        dryRun: false,
        dryRunTmp: core.getInput("dry-run") || "false",
        type: core.getInput("type") || "container",

        untaggedKeepLatest: core.getInput("untagged-keep-latest") || null,
        taggedKeepLatest: core.getInput("tagged-keep-latest") || null,
        tagRegex: core.getInput("tag-regex") || null
    };

    const definedOptionsCount = [

        config.untaggedKeepLatest,
        config.taggedKeepLatest,
        config.tagRegex
    ].filter((x) => x !== null).length;

    if (definedOptionsCount == 0) {
        throw new Error("no any required options defined");
    }
    // else if (definedOptionsCount > 1) {
    //   throw new Error("too many selectors defined, use only one");
    // }

    if (config.untaggedKeepLatest) {
        if (
            isNaN((config.untaggedKeepLatest = parseInt(config.untaggedKeepLatest)))
        ) {
            throw new Error("untagged-keep-latest is not number");
        }
    }

    if (config.taggedKeepLatest) {
        if (
            isNaN((config.taggedKeepLatest = parseInt(config.taggedKeepLatest)))
        ) {
            throw new Error("tagged-keep-latest is not number");
        }
        if (!config.tagRegex)
            throw new Error("regex must be provided when tagged-keep-latest set");
    }

    if (config.dryRunTmp !== 'true' && config.dryRun !== 'false') {
        throw new Error("invalid value: dry-run must be true or false");
    } else if (config.dryRunTmp === 'true') {
        config.dryRun = true;
    }


    if (config.type !== 'maven' && config.type !== 'container') {
        throw new Error("invalid value: type must be one of: container maven");
    }

    return config;
};



let findPackageVersionsTagRegexMatchOrderGreaterThan = async function (
    octokit,
    owner,
    name,
    type,
    taggedKeepLatest,
    untaggedKeepLatest,
    regex
) {
    const pkgs = [];
    const untaggedPkgs = [];
    for await (const pkgVer of iteratePackageVersions(octokit, owner, name, type)) {
        core.info(`🔎 found pkgVer ${pkgVer.metadata.container.tags}...`);
        if (type === "container") {
            const versionTags = pkgVer.metadata.container.tags;
            if (regex && versionTags.length > 0) {
                for (let tag of versionTags) {
                    if (!regex.test(tag)) {
                        continue;
                    }
                    core.info(`🔎 tag ${tag} matches. VersionId: ${pkgVer.id}. Deleting...`);
                    pkgs.push(pkgVer);
                    break;
                }
            } else if (versionTags.length === 0 && untaggedKeepLatest != null) {
                untaggedPkgs.push(pkgVer);
            }
        } else {
            const tag = pkgVer.name;
            if (regex) {
                if (regex.test(tag)) {
                    core.info(`🔎 tag ${tag} matches. VersionId: ${pkgVer.id}. Deleting...`);
                    pkgs.push(pkgVer);
                    break;
                }
            }
        }
    }

    pkgs.sort((a, b) => {
        return new Date(b.updated_at) - new Date(a.updated_at);
    });

    untaggedPkgs.sort((a, b) => {
        return new Date(b.updated_at) - new Date(a.updated_at);
    });
    const pkgsToDelete = [];
    if (pkgs.length > 0) {
        core.info(`🔎  ${pkgs.length} tagged packages to delete. Keeping top ${taggedKeepLatest}...`);
        for (let pkg of pkgs.slice(taggedKeepLatest))
            pkgsToDelete.push(pkg);
    }
    if (untaggedPkgs.length > 0) {
        core.info(`🔎  ${untaggedPkgs.length} untagged packages to delete. Keeping top ${untaggedKeepLatest}...`);
        for (let pkg of untaggedPkgs.slice(untaggedKeepLatest))
            pkgsToDelete.push(pkg);
    }
    core.info(`🔎  ${pkgsToDelete.length} total packages to delete...`);
    return pkgsToDelete;
};

let iteratePackageVersions = async function* (octokit, owner, name, type) {
    for await (const response of octokit.paginate.iterator(
        octokit.rest.packages.getAllPackageVersionsForPackageOwnedByOrg,
        {
            package_type: type,
            package_name: name,
            org: owner,
            state: "active",
            per_page: 100,
        }
    )) {
        for (let packageVersion of response.data) {
            yield packageVersion;
        }
    }
};

let deletePackageVersion = async (octokit, owner, name, type, versionId) => {
    core.info(`deleting package ${owner}/${name}:${versionId}`);
    await octokit.rest.packages.deletePackageVersionForOrg({
        package_type: type,
        package_name: name,
        org: owner,
        package_version_id: versionId,
    });
};

function sleep(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}

module.exports = {
    getConfig,
    deletePackageVersion,
    findPackageVersionsTagRegexMatchOrderGreaterThan,
    sleep,
};