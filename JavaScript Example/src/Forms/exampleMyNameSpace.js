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
