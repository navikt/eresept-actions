const utils = require("./utils");
const core = require("@actions/core");


async function deleteTagRegexMatchOrderGreaterThan(config, octokit) {
    core.info(`🔎 finding latest tagged ${config.taggedKeepLatest} packages matching regex ${config.tagRegex}. Also finding latest untagged ${config.untaggedKeepLatest} packages...`);

    const pkgs = await utils.findPackageVersionsTagRegexMatchOrderGreaterThan(
        octokit,
        config.owner,
        config.name,
        config.type,
        config.taggedKeepLatest,
        config.untaggedKeepLatest,
        new RegExp(config.tagRegex)
    );

    core.startGroup(`🗑 delete ${pkgs.length} packages`);

    for (const pkg of pkgs) {
        if (!config.dryRun) {
            await utils.deletePackageVersion(
                octokit,
                config.owner,
                config.name,
                config.type,
                pkg.id
            );
        }
        core.info(`✅ package #${pkg.id} deleted.`);
    }

    core.endGroup();
}

module.exports = { deleteTagRegexMatchOrderGreaterThan };