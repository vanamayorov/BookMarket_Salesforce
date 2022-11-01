@isTest
private class ManagersEmailMessangerTest {
  @TestSetup
  static void setup() {
    City__c city = new City__c(Name = 'Kyiv');
    insert city;

    Bookstore__c bookstore = new Bookstore__c(
      Name = 'Kyiv bookstore',
      City__c = city.Id,
      Num_Sold_Books__c = 35
    );
    insert bookstore;

    Bookstore_Manager__c bookstoreManager = new Bookstore_Manager__c(
      City__c = city.Id,
      Bookstore_Manager_Email__c = 'test@gmail.com',
      First_Name__c = 'Name',
      Last_Name__c = 'Surname',
      Bookstore__c = bookstore.Id
    );
    insert bookstoreManager;
  }

  @isTest
  static void sendEmailsTest() {
    Test.startTest();
    List<Bookstore_Manager__c> bookstoreManagers = [
      SELECT
        Id,
        Bookstore_Manager_Email__c,
        First_Name__c,
        Last_Name__c,
        Bookstore__r.Num_Sold_Books__c
      FROM Bookstore_Manager__c
      WHERE Bookstore_Manager_Email__c = 'test@gmail.com'
      LIMIT 1
    ];

    Messaging.SendEmailResult[] results = ManagersEmailMessanger.sendEmails(
      bookstoreManagers
    );
    System.assertNotEquals(null, results);
    System.assert(results.size() > 0);
    Test.stopTest();
  }
}
