export class MyNameSpace {
  // Define some global variables
  private static readonly myUniqueId: string = "_myUniqueId"; // Define an ID for the notification
  private static readonly currentUserName: string = Xrm.Utility.getGlobalContext().userSettings.userName; // Get current user name
  private static readonly message: string = `${MyNameSpace.currentUserName}: Your JavaScript code in action!`;

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
