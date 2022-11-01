public with sharing class ManagersNotificationController implements Schedulable {
  public void execute(SchedulableContext ctx) {
    List<Bookstore_Manager__c> bookstoreManagers = [
      SELECT
        First_Name__c,
        Last_Name__c,
        Bookstore_Manager_Email__c,
        Bookstore__r.Name,
        Bookstore__r.Num_Sold_Books__c
      FROM Bookstore_Manager__c
    ];

    ManagersEmailMessanger.sendEmails(bookstoreManagers);
  }
}
