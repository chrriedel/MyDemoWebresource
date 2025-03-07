# create variables for the project
# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ask for project name
echo "Enter a project foldername:"
read projectFolderName

# ask for nameSpace prefix
echo "Enter your nameSpace prefix:"
read nameSpace

# ask for outputfileName prefix
echo "Enter your outputFile name (including file extension (.js)):"
read outputFileName

# ask if typescript should be added, if not config will be created fo javascript
echo "Do you want to add typescript to the project?"
echo "If you choose no, the project will be setup for javascript."
echo "Enter 'y' for true, or 'n' for false: "
read varTypeScript

# Set the variable varTypeScript based on the user input
if [ "$varTypeScript" != "y" ] && [ "$varTypeScript" != "n" ]; then
  echo "Invalid input. Please enter 'y' or 'n'."
  exit 1
fi

# Prompt the user for eslint
echo "Do you want to add eslint to the project?"
echo "Enter 'y' for true, or 'n' for false: "
read varEsLint

# Set the variable varesLint based on the user input
if [ "$varEsLint" != "y" ] && [ "$varEsLint" != "n" ]; then
  echo "Invalid input. Please enter 'y' or 'n'."
  exit 1
fi

# Prompt the user for prettier
echo "Do you want to add prettier to the project?"
echo "Enter 'y' for true, or 'n' for false: "
read varPrettier

# Set the variable varPrettier based on the user input
if [ "$varPrettier" != "y" ] && [ "$varPrettier" = "n" ]; then
  echo "Invalid input. Please enter 'y' or 'n'."
  exit 1
fi

# Prompt the user for vscode exstension
echo "Do you want to add unit testing to your project?"
echo "Enter 'y' for true, or 'n' for false: "
read varJest

# Set the variable varJest based on the user input
if [ "$varJest" != "y" ] && [ "$varJest" = "n" ]; then
  echo "Invalid input. Please enter 'y' or 'n'."
  exit 1
fi

# Install prerequisites
# Check if Homebrew is installed
echo "Installing homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Installing it now..."
  # Install Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

echo "Installing node js"
# check if node js is installed if not install using brew
if ! command -v node >/dev/null 2>&1; then
  echo "Node.js is not installed. Installing it now using Homebrew..."
  brew install node
else
  echo "Node.js is already installed. Skipping installation!"
fi

# Install recommended VS Code extensions using the VS Code command line (optional; requires VS Code CLI)
echo "Installing VSCode Extensions for Power Platform Tools and npm-intellisense..."
#code --install-extension ms-powerplatform.vscode-powerplatform
code --install-extension microsoft-IsvExpTools.powerplatform-vscode --force
code --install-extension christian-kohler.npm-intellisense --force
code --install-extension ms-edgedevtools.vscode-edge-devtools --force

# creating folder structure
# Create a project directory and navigate into it
if [ -d "$projectFolderName" ]; then
  echo "Directory $projectFolderName already exists. Switching to the directory."
  cd $projectFolderName
else
  mkdir $projectFolderName && cd $projectFolderName
fi

# Create .gitingore file
cat >.gitignore <<EOL
node_modules
dist
.vscode
EOL

# Create the source directory
mkdir src
mkdir src/Forms

# Create the .vscode directory
mkdir .vscode

# Initialize a Node.js project
npm init -y

# Install the required Type definitions for Power Platform
npm install --save-dev @types/xrm
npm install --save-dev @types/node

# Check if typescript should be added to the project
if [ "$varTypeScript" = "y" ]; then
  echo "Setting up TypeScript for the project"
  # Install typescript to the project
  npm install typescript --save-dev
  npx tsc -init
  # Create a basic TypeScript configuration file
  cat >tsconfig.json <<EOL
{
   "compilerOptions": {
    "target": "ES6",
    "module": "ES2015",
    "lib": [
			"dom",
      "es2015"
		],     
    "strict": true,
    "typeRoots": ["./node_modules/@types"],
    "sourceMap": true,
    "rootDir": "src",
    "moduleResolution": "node",
    "outDir": "dist",
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true
  }
}
EOL
  varIndexFile="index.ts"
else
  echo "Setting up JavaScript for the project"
  varIndexFile="index.js"
fi

# Create launch json
cat >.vscode/launch.json <<EOL
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
     {
            "name": "Attach to Model-Driven App in Edge ",
            "port": 9222,
            "request": "attach",
            "type": "msedge",
            "webRoot": "\${workspaceFolder}",
            "timeout": 30000,
            "url": "<Model-Driven App URL inkl. App ID>*",
        }
    ]
}
EOL

# Add webpack to the project
echo "adding webpack..."
npm install webpack webpack-cli webpack-merge ts-loader --save-dev

#create webpack config files
#create common config
echo "creating config files..."
cat >webpack.common.js <<EOL
const path = require("path");

module.exports = {
  entry: "./src/$varIndexFile",
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: "ts-loader",
        exclude: /node_modules/,
      },
    ],
  },
  resolve: {
    extensions: [".tsx", ".ts", ".js"],
  },
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "$outputFileName",
    // Set this to your namespace e.g. nC_ClientLibrary
    library: ["$nameSpace"],
    libraryTarget: "var",
  },
};
EOL
# create dev config
cat >webpack.dev.js <<EOL
const { merge } = require("webpack-merge");
const common = require("./webpack.common.js");
module.exports = merge(common, {
  mode: "development",
  devtool: "eval-source-map",
});
EOL
# Create prod config
cat >webpack.prod.js <<EOL
const { merge } = require("webpack-merge");
const common = require("./webpack.common.js");
module.exports = merge(common, {
  mode: "production",
});
EOL

# replace scripts in package.json for webpack
sed -i '' '/"scripts": {/,/},/c\
  "scripts": {\
    "test": "echo \\"Error: no test specified\\" && exit 1",\
    "build": "webpack --config webpack.dev.js",\
    "start": "webpack --config webpack.dev.js --watch",\
    "dist": "webpack --config webpack.prod.js"\
  },
' package.json

# Check if eslint should be setup
if [ "$varesLint" = "y" ]; then
  echo "Setting up eslint for the project"

  if [ "$varTypeScript" = "y" ]; then

    cat >eslint.config.mjs <<EOL
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
EOL

  else
    cat >eslint.config.mjs <<EOL
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
       ecmaVersion: 5, // Specify ECMAScript version
       sourceType: "module",
        ecmaFeatures: {
          jsx: true, // Enable JSX
        },
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
EOL
  fi
  #install eslint node modules
  npm install --save-dev eslint @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-plugin-react eslint-config-prettier eslint-plugin-prettier

  # Add lint scripts to the scripts section in package.json
  sed -i '' '/"scripts": {/a\
    "lint": "eslint src",\
    "lint:fix": "npm run lint -- --fix",
' package.json

  #install vscode extension for eslint
  code --install-extension dbaeumer.vscode-eslint --force
else
  echo "Setting up eslint skipped!"
fi

# setup prettier prefered config
if [ "$varPrettier" = "y" ]; then

  echo "Setting up Prettier config"
  cat >.prettierrc.json <<EOL
{
    "semi": true,
    "trailingComma": "all",
    "singleQuote": false,
    "printWidth": 120,
    "tabWidth": 2,
    "endOfLine":"auto"
  }
EOL
  # install prettier node modules
  npm install --save-dev --save-exact prettier

  # install vscode extension for prettier
  code --install-extension esbenp.prettier-vscode --force

else
  echo "Setting up prettier skipped!"
fi

# add jest
if [ "$varJest" = "y" ]; then
  # install jest
  npm install jest ts-jest xrm-mock @types/jest --save-dev

  cat >jest.config.js <<EOL
module.exports = {
  preset: "ts-jest",
  testEnvironment: "node",
  transform: {
    "^.+\\.[tj]sx?$": "ts-jest", // Transform both .ts/.tsx and .js/.jsx files using ts-jest
  },
  moduleFileExtensions: ["ts", "tsx", "js", "jsx"], // Recognize both TypeScript and JavaScript files
};
EOL

  # add test to package.json
  sed -i '' '/"test":/s/".*"/"test": "jest"/' package.json

  # add launch config to debug unit tests

  # Add Jest configuration to launch.json
  cd .vscode
  sed -i '' '/"configurations": \[/a\
\        {\
\            "type": "node",\
\            "name": "vscode-jest-tests",\
\            "request": "launch",\
\            "program": "${workspaceFolder}/node_modules/jest/bin/jest",\
\            "args": [\
\                "--runInBand",\
\                "--code-coverage=false",\
\                "--runTestsByPath",\
\                "--testPathPattern=${fileBasename}"\
\            ],\
\            "cwd": "${workspaceFolder}",\
\            "console": "integratedTerminal",\
\            "internalConsoleOptions": "neverOpen",\
\            "disableOptimisticBPs": true,\
\            "smartStep": true,\
\            "skipFiles": [\
\                "node_modules/**/*.js",\
\                "<node_internals>/**/*.js",\
\                "async_hooks.js",\
\                "inspector_async_hook.js"\
\            ]\
\        },  
' launch.json
  cd ..

  # add test directory
  mkdir src/Forms/__tests__

  if [ "$varTypeScript" = "y" ]; then
    cat >src/Forms/__tests__/unit.exampleMyNameSpace.test.ts <<EOL
import { MyNameSpace } from "../exampleMyNameSpace";
import { XrmMockGenerator } from "xrm-mock";

describe("formOnLoad", () => {
  beforeEach(() => {
    // Initialize the mock Xrm environment
    XrmMockGenerator.initialise();
    XrmMockGenerator.context.userSettings.userName = "TestUser";
  });
  // Your test goes here!!!
  it("should check if true is true", () => {
    expect(true).toBe(true);
  });
});

EOL

  else
    cat >src/Forms/__tests__/unit.exampleMyNameSpace.test.js <<EOL
//import { formOnLoad } from "../exampleMyNameSpace";
//import { XrmMockGenerator } from "xrm-mock";

describe("formOnLoad", () => {
  /*beforeEach(() => {
    // Initialize the mock Xrm environment
    XrmMockGenerator.initialise();
    XrmMockGenerator.context.userSettings.userName = "TestUser";
  });*/
  // Your test goes here!!!
  it("should check if true is true", () => {
    expect(true).toBe(true);
  });
});

EOL
  fi
else
  echo "skipped adding unit tests"
fi

# Create a sample TypeScript file with a reference to the Xrm namespace
if [ "$varTypeScript" = "y" ]; then
  cat >src/Forms/exampleMyNameSpace.ts <<EOL
export class MyNameSpace {
  // Define some global variables
  private static readonly myUniqueId: string = "_myUniqueId"; // Define an ID for the notification
  private static readonly currentUserName: string = Xrm.Utility.getGlobalContext().userSettings.userName; // Get current user name
  private static readonly message: string = \`\${MyNameSpace.currentUserName}: Your JavaScript code in action!\`;

  /**
   * Function to run in the form OnLoad event
   * @param executionContext - The execution context passed from Dynamics 365
   */
  public static formOnLoad(executionContext: Xrm.Events.EventContext): void {
    const formContext: Xrm.FormContext = executionContext.getFormContext();

    // Display the form level notification as an INFO
    formContext.ui.setFormNotification(this.message, "INFO", this.myUniqueId);

    // Wait for 5 seconds before clearing the notification
    window.setTimeout(() => {
      formContext.ui.clearFormNotification(this.myUniqueId);
    }, 5000);
  }
}
EOL

  cat >src/index.ts <<EOL
export * from "./Forms/exampleMyNameSpace";
EOL

  # Open the project in Visual Studio Code
  code . ./src/Forms/exampleMyNameSpace.ts

else
  cat >src/Forms/exampleMyNameSpace.js <<EOL
var MyNameSpace = (function () {
  // Define some global variables
  var myUniqueId = "_myUniqueId"; // Define an ID for the notification
  var currentUserName = Xrm.Utility.getGlobalContext().userSettings.userName; // Get current user name
  var message = currentUserName + ": Your JavaScript code in action!";

  return {
    /**
     * Function to run in the form OnLoad event
     * @param {Xrm.Events.EventContext} executionContext - The execution context passed from Dynamics 365
     */
    formOnLoad: function (executionContext) {
      var formContext = executionContext.getFormContext();

      // Display the form level notification as an INFO
      formContext.ui.setFormNotification(message, "INFO", myUniqueId);

      // Wait for 5 seconds before clearing the notification
      window.setTimeout(function () {
        formContext.ui.clearFormNotification(myUniqueId);
      }, 5000);
    },
  };
})();
EOL

  cat >src/index.js <<EOL
export * from "./Forms/exampleMyNameSpace.js";
EOL

  # Open the project in Visual Studio Code
  code . ./src/Forms/exampleMyNameSpace.js
fi

# Modified echo statements with color
echo -e "${YELLOW}Make sure to add your URL to the launch.json file${NC}"

echo -e "${GREEN}Please close all Edge instances and use the following command:${NC}"
echo -e "${GREEN}/Applications/Microsoft\ Edge.app/Contents/MacOS/Microsoft\ Edge --remote-debugging-port=9222${NC}"
echo -e "${GREEN}to start Edge in remote debugging mode${NC}"
