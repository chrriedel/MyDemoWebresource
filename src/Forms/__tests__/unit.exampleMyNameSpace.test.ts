import { formOnLoad } from "../exampleMyNameSpace";
import { XrmMockGenerator } from "xrm-mock";

describe("formOnLoad", () => {
  beforeEach(() => {
    // Initialize the mock Xrm environment
    XrmMockGenerator.initialise();
    XrmMockGenerator.context.userSettings.userName = "TestUser";
  });
  // Your test goes here!!!
});
