module.exports = {
  preset: "ts-jest",
  testEnvironment: "node",
  transform: {
    "^.+\\.[tj]sx?$": "ts-jest", // Transform both .ts/.tsx and .js/.jsx files using ts-jest
  },
  moduleFileExtensions: ["ts", "tsx", "js", "jsx"], // Recognize both TypeScript and JavaScript files
};
