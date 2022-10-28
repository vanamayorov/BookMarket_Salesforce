public with sharing class ReaderBookController {
  @AuraEnabled
  public static List<Reader_Book__c> getReaderBooksList(String userId) {
    try {
      List<Reader_Book__c> readerBooksList = [
        SELECT Book__r.Book_Title__c, Number_Of_Books__c, Book__r.Author__r.Name
        FROM Reader_Book__c
        WHERE Reader__c IN (SELECT Id FROM Reader__c WHERE User__c = :userId)
      ];

      if (readerBooksList.isEmpty()) {
        throw new CustomException('No reader`s books found.');
      }

      return readerBooksList;
    } catch (Exception e) {
      throw new CustomException(e.getMessage());
    }
  }
}
