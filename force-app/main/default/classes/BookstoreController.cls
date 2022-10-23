public with sharing class BookstoreController {
  public static void updateBookstoreNumOfSoldBooks(
    String bookstoreId,
    Integer bookQty
  ) {
    try {
      List<Bookstore__c> bookstoreList = [
        SELECT Id, Num_Sold_Books__c
        FROM Bookstore__c
        WHERE Id = :bookstoreId
      ];

      if (!bookstoreList.isEmpty()) {
        Bookstore__c bookstore = bookstoreList[0];
        bookstore.Num_Sold_Books__c += bookQty;
        update bookstore;
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
