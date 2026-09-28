import fs from "node:fs";
import Handlebars from "handlebars";
import YAML from "yaml";

const [templatePath, variablesPath, outputPath] = process.argv.slice(2);
const ESCAPED_OPEN = "\uE000HANDLEBARS_ESCAPED_OPEN\uE001";

const template = fs
    .readFileSync(templatePath, "utf8")
    .replaceAll("\\{{", ESCAPED_OPEN);

const variables = YAML.parse(
    fs.readFileSync(variablesPath, "utf8")
);

const compiled = Handlebars.compile(template, {
    strict: true
});

const output = compiled(variables)
    .replaceAll(ESCAPED_OPEN, "{{");

fs.writeFileSync(outputPath, output);
