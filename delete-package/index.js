module.exports = (github, context, core) => {
    const utils = require("./utils")(github, context, core);
    const actions = require("./actions")(github, context, core);

    async function run() {
        try {
            const config = utils.getConfig();
            const octokit = github.getOctokit(config.token, {
                log: {
                    debug: () => core.info,
                    info: () => core.info,
                    warn: core.info,
                    error: core.error
                },
            });

            await actions.deleteTagRegexMatchOrderGreaterThan(config, octokit);

        } catch (error) {
            core.setFailed(error.message);
        }
    }

}