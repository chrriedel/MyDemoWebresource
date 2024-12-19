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
