@isTest
private class ManagersNotificationControllerTest {
  public static String CRON_EXP = '0 0 0 15 11 ? 2022';

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
  static void testScheduledJob() {
    Test.startTest();
    String jobId = System.schedule(
      'ScheduledApexTest',
      CRON_EXP,
      new ManagersNotificationController()
    );
    List<Bookstore_Manager__c> bookstoreManagers = [
      SELECT
        First_Name__c,
        Last_Name__c,
        Bookstore_Manager_Email__c,
        Bookstore__r.Name,
        Bookstore__r.Num_Sold_Books__c
      FROM Bookstore_Manager__c
      WHERE Bookstore_Manager_Email__c = 'test@gmail.com'
      LIMIT 1
    ];
    Messaging.SendEmailResult[] results = ManagersEmailMessanger.sendEmails(
      bookstoreManagers
    );
    System.assertNotEquals(null, results);
    Test.stopTest();
  }
}
