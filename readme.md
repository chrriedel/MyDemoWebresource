# Project Description

This project serves as a template for developers to quickly set up a TypeScript-based web resource for Model-Driven Apps. It includes configurations for linting, formatting, building, and testing, ensuring a consistent development environment.

## Folder Structure

### Key Files and Directories

- **.vscode/**: Contains Visual Studio Code configurations for debugging.
  - `launch.json`: Configuration for attaching to a Model-Driven App in Edge.

- **eslint.config.mjs**: Configuration for ESLint, including TypeScript and React plugins.

- **initScirpt/**: Contains the initialization script to set up the project.
  - `init-project.sh`: Script to initialize the project, install dependencies, and set up configurations.

- **package.json**: Defines project metadata, scripts, and dependencies.
  - Scripts include `lint`, `lint:fix`, `build`, `start`, and `dist`.

- **src/**: Source directory for TypeScript files.
  - `Forms/`: Contains example TypeScript files for forms.
  - `index.ts`: Entry point for the application.

- **tsconfig.json**: TypeScript configuration file.

- **webpack.common.js**: Common Webpack configuration.
- **webpack.dev.js**: Webpack configuration for development.
- **webpack.prod.js**: Webpack configuration for production.

## Setup Instructions

1. **Clone the repository**:
  ```sh
   git clone https://github.com/chrriedel/ts-webresource-template.git
   cd <project-folder>

2. **Install dependencies**:
    ```sh
    npm install

3.**Start the npm with --watch for dev inline debugging purpose**:
    ```sh
    npm start

4.**Build the project for testing and debugging purpose**:
    ```sh
    npm run-script build

5.**Build the code for production use** (creates a minified .js file):
    ```sh
    npm run-script dist

6. **Lint the code**:
   ```sh
   npm run lint

7. **Fix linting issues**:
   ```sh
   npm run lint:fix

## Development Workflow

- **Linting**: ESLint is configured to enforce code quality and consistency. Run `npm run lint` to check for issues and `npm run lint:fix` to automatically fix them.
- **Formatting**: Prettier is used for code formatting. The configuration is defined in `.prettierrc.json`.
- **Building**: Webpack is used to bundle the project. Use `npm run build` for development builds and `npm run dist` for production builds.
- **Debugging**: Use the configuration in `.vscode/launch.json` to attach to a Model-Driven App in Edge for debugging.

# Initialization Script

The `init-project.sh` script is an interactive setup script designed to help you initialize a new TypeScript-based web resource project for Model-Driven Apps. It guides you through the process of setting up your project by asking a series of questions and configuring the project based on your responses.

## Prerequisites

The script just needs VSCode installed :-)

## Script Details

### User Prompts

The script prompts the user for the following information:

1. **Project Folder Name**:
   - Asks for the name of the project folder.
   - Example: `Enter a project foldername:`

2. **Namespace Prefix**:
   - Asks for a namespace prefix to be used in the project.
   - Example: `Enter your nameSpace prefix:`

3. **Output File Name**:
   - Asks for the name of the output file, including the file extension (e.g., `.js`).
   - Example: `Enter your outputFile name (including file extension (.js)):`

4. **ESLint Configuration**:
   - Asks if you want to add ESLint to the project for code linting.
   - Example: `Do you want to add eslint to the project? Enter 'y' for true, or 'n' for false:`
   - Sets a boolean variable (`varesLint`) based on the user's input.

5. **Prettier Configuration**:
   - Asks if you want to add Prettier to the project for code formatting.
   - Example: `Do you want to add prettier to the project? Enter 'y' for true, or 'n' for false:`
   - Sets a boolean variable (`varPrettier`) based on the user's input.

6. **Jest Configuration**:
   - Asks if you want to add Jest to the project for unit testing.
   - Example: `Do you want to add unit testing to your project? Enter 'y' for true, or 'n' for false:`
   - Sets a boolean variable (`varJest`) based on the user's input.

### Installation and Setup

The script performs the following tasks to set up the project:

1. **Install Homebrew**:
   - Checks if Homebrew is installed and installs it if necessary.

2. **Install Node.js**:
   - Checks if Node.js is installed and installs it using Homebrew if necessary.

3. **Install VS Code Extensions**:
   - Installs recommended VS Code extensions for Power Platform Tools, npm-intellisense, and Edge DevTools.

4. **Create Project Structure**:
   - Creates the project directory and navigates into it.
   - Creates necessary directories (`src`, `src/Forms`, `.vscode`).
   - Initializes a Node.js project with `npm init -y`.
   - Creates a `.gitignore` file.

5. **Install TypeScript and Definitions**:
   - Installs TypeScript and required TypeScript definitions for Power Platform.
   - Creates a basic TypeScript configuration file (`tsconfig.json`).

6. **Create Webpack Configuration**:
   - Installs Webpack and related packages.
   - Creates common, development, and production Webpack configuration files.
   - Updates `package.json` scripts to include Webpack commands.

7. **Set Up ESLint** (if enabled):
   - Creates an ESLint configuration file (`eslint.config.mjs`).
   - Installs ESLint and related packages.
   - Adds linting scripts to `package.json`.
   - Installs the ESLint VS Code extension.

8. **Set Up Prettier** (if enabled):
   - Creates a Prettier configuration file (`.prettierrc.json`).
   - Installs Prettier.
   - Installs the Prettier VS Code extension.

9. **Set Up Jest** (if enabled):
   - Installs Jest and related packages.
   - Creates a Jest configuration file (`jest.config.js`).
   - Updates the `test` script in `package.json`.
   - Adds Jest configuration to `launch.json` for debugging unit tests.
   - Creates a test directory and a sample test file.

10. **Create Sample TypeScript Files**:
    - Creates a sample TypeScript file (`exampleMyNameSpace.ts`) with a reference to the Xrm namespace.
    - Creates an `index.ts` file to export the sample TypeScript file.

11. **Open Project in VS Code**:
    - Opens the project in Visual Studio Code and the sample TypeScript file.

12. **Display Instructions**:
    - Displays instructions for adding the URL to `launch.json`.
    - Provides commands to start Edge in remote debugging mode.

### Usage

To run the script, use the following command in your terminal:

```sh
[init-project.sh]



