public with sharing class ReaderBookController {
  @AuraEnabled
  public static List<Reader_Book__c> getReaderBooksList(String userId) {
    try {
      return [
        SELECT Book__r.Book_Title__c, Number_Of_Books__c, Book__r.Author__r.Name
        FROM Reader_Book__c
        WHERE Reader__c IN (SELECT Id FROM Reader__c WHERE User__c = :userId)
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
