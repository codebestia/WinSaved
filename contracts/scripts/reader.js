import { promises as fs } from "fs";
import path from "path";
import { fileURLToPath } from 'url';   // To convert URL to file path
import { dirname } from 'path';        // To extract the directory name

// Get the current module's URL and convert it to a file path
const __filename = fileURLToPath(import.meta.url);

// Get the directory name from the file path
const __dirname = dirname(__filename);

export async function getCompiledCode(filename) {
    const sierraFilePath = path.join(
    path.dirname(__filename),
    `../target/dev/${filename}.contract_class.json`
    );
    const casmFilePath = path.join(
    path.dirname(__filename),
    `../target/dev/${filename}.compiled_contract_class.json`
    );

    const code = [sierraFilePath, casmFilePath].map(async (filePath) => {
        const file = await fs.readFile(filePath);
        return JSON.parse(file.toString("ascii"));
    });

    const [sierraCode, casmCode] = await Promise.all(code);

    return {
        sierraCode,
        casmCode,
    };
}