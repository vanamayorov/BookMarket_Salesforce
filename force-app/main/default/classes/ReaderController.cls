public with sharing class ReaderController {
  public static Reader__c createReader(String userId) {
    try {
      User user = [
        SELECT Id, Name, Email, Username, FirstName, LastName
        FROM User
        WHERE Id = :userId
      ][0];

      List<Reader__c> readerInDb = [
        SELECT Id
        FROM Reader__c
        WHERE User__c = :user.Id
      ];

      if (readerInDb.isEmpty()) {
        Reader__c newReader = new Reader__c(
          Reader_Email__c = user.Email,
          Username__c = user.Username,
          First_Name__c = user.FirstName,
          Last_Name__c = user.LastName,
          User__c = user.Id
        );
        insert newReader;
        return newReader;
      }
      return readerInDb[0];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  public static Reader_Book__c createReaderList(
    String readerId,
    String bookId,
    Integer bookQty
  ) {
    try {
      Reader_Book__c readerList = new Reader_Book__c();

      List<Reader_Book__c> readerBookList = [
        SELECT Reader__c, Book__c, Number_Of_Books__c
        FROM Reader_Book__c
        WHERE Reader__c = :readerId AND Book__c = :bookId
      ];

      if (readerBookList.isEmpty()) {
        readerList.Reader__c=readerId;
        readerList.Book__c=bookId;
        readerList.Number_Of_Books__c=bookQty;
        insert readerList;
      } else {
        readerList = readerBookList[0];
        readerList.Number_Of_Books__c += bookQty;
        update readerList;
      }

      return readerList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
