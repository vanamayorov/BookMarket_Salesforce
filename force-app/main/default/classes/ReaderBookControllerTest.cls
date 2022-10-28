@isTest
private class ReaderBookControllerTest {
  @TestSetup
  static void setup() {
    Author__c author = new Author__c(
      Name = 'Serhij Zhadan',
      First_Name__c = 'Serhij',
      Last_Name__c = 'Zhadan'
    );
    insert author;

    Book__c book = new Book__c(
      Price__c = 35,
      Book_Title__c = 'Test book',
      Quantity__c = 35,
      Author__c = author.Id
    );
    insert book;

    User user = [
      SELECT Id, FirstName, LastName, UserName
      FROM User
      WHERE Alias = 'tread'
    ][0];

    Reader__c reader = new Reader__c(
      First_Name__c = user.FirstName,
      Last_Name__c = user.LastName,
      Username__c = user.username,
      User__c = user.Id
    );
    insert reader;

    Reader_Book__c readerBooksList = new Reader_Book__c(
      Book__c = book.Id,
      Reader__c = reader.Id,
      Number_Of_Books__c = 1
    );
    insert readerBooksList;
  }

  @isTest
  static void getReaderBooksListTestPositive() {
    Test.startTest();
    User user = [SELECT Id, Name FROM User WHERE alias = 'tread' LIMIT 1][0];
    List<Reader_Book__c> readerBooksList = ReaderBookController.getReaderBooksList(
      user.Id
    );
    System.assertNotEquals(null, readerBooksList);
    System.assert(readerBooksList.size() > 0);
    Test.stopTest();
  }

  @isTest
  static void getReaderBooksListTest_No_ReaderBook_Found() {
    try {
      Test.startTest();
      User user = [SELECT Id, Name FROM User LIMIT 1][0];
      List<Reader_Book__c> readerBooksList = ReaderBookController.getReaderBooksList(
        user.Id
      );
      Test.stopTest();
    } catch (Exception e) {
      System.assertEquals('No reader`s books found.', e.getMessage());
    }
  }
}
