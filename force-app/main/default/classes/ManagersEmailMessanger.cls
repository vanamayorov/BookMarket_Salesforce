public with sharing class ManagersEmailMessanger {
  public static List<Messaging.SendEmailResult> sendEmails(
    List<Bookstore_Manager__c> bookstoreManagers
  ) {
    List<Messaging.SingleEmailMessage> listOfEmails = new List<Messaging.SingleEmailMessage>();

    for (Bookstore_Manager__c manager : bookstoreManagers) {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(
        new List<String>{ manager.Bookstore_Manager_Email__c }
      );
      mail.setSubject('Daily num of sold books notification');
      mail.setPlainTextBody(
        'Dear ' +
        manager.First_Name__c +
        ' ' +
        manager.Last_Name__c +
        ' Num of sold books: ' +
        manager.Bookstore__r.Num_Sold_Books__c
      );
      listOfEmails.add(mail);
    }

    List<Messaging.SendEmailResult> results = Messaging.sendEmail(listOfEmails);
    return results;
  }
}
