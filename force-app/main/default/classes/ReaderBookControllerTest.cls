@isTest
private class ReaderBookControllerTest {
  @isTest
  static void getReaderBooksListTest() {
    User user = [SELECT Id, Name FROM User WHERE LastName = 'Reader'][0];

    List<Reader_Book__c> readerBooksList = ReaderBookController.getReaderBooksList(
      user.Id
    );
  }
}
