import fs from "node:fs";
import Handlebars from "handlebars";
import YAML from "yaml";

const [templatePath, variablesPath, outputPath] = process.argv.slice(2);
const ESCAPED_OPEN = "\uE000HANDLEBARS_ESCAPED_OPEN\uE001";

function printError(error, filePath, source) {
    console.error(`Error in ${filePath}:`);
    console.error(error.message);

    // YAML errors generally provide linePos with line and column.
    const yamlLine = error.linePos?.[0]?.line;

    // Handlebars errors may provide a location with start.line.
    const templateLine = error.location?.start?.line;

    const line = yamlLine ?? templateLine;

    if (line != null) {
        console.error(`At line ${line}`);
        const lines = source.split("\n");
        const start = Math.max(1, line - 2);
        const end = Math.min(lines.length, line + 2);

        for (let i = start; i <= end; i++) {
            console.error(
                `${i === line ? ">" : " "} ${String(i).padStart(4)} | ${lines[i - 1]}`
            );
        }
    }
}

let template;
let variables;

try {
    template = fs
        .readFileSync(templatePath, "utf8")
        .replaceAll("\\{{", ESCAPED_OPEN);
} catch (error) {
    console.error(`Could not read template ${templatePath}:`, error.message);
    process.exit(1);
}

try {
    variables = YAML.parse(fs.readFileSync(variablesPath, "utf8"));
} catch (error) {
    printError(error, variablesPath, fs.readFileSync(variablesPath, "utf8"));
    process.exit(1);
}

let compiled;
try {
    compiled = Handlebars.compile(template, { strict: true });
} catch (error) {
    printError(error, templatePath, template);
    process.exit(1);
}

let output;
try {
    output = compiled(variables).replaceAll(ESCAPED_OPEN, "{{");
} catch (error) {
    printError(error, templatePath, template);
    process.exit(1);
}

fs.writeFileSync(outputPath, output);
