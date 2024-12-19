import flatLinter from "@typescript-eslint/eslint-plugin";
import typescriptParser from "@typescript-eslint/parser";
import prettier from "eslint-plugin-prettier";
import react from "eslint-plugin-react";

export default [
  {
    files: ["**/*.{ts,tsx,js,jsx}"],
    languageOptions: {
      parser: typescriptParser,
      parserOptions: {
        project: "./tsconfig.json",
      },
    },
    settings: {
      react: {
        pragma: "React",
        version: "detect",
      },
    },
    plugins: {
      "@typescript-eslint": flatLinter,
      prettier,
      react,
    },
    rules: {
      "prettier/prettier": "error",
    },
  },
  {
    files: ["*.ts"],
    rules: {
      camelcase: [2, { properties: "never" }],
    },
  },
];
