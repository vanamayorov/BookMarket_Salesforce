public without sharing class BookstoreController {
  public static Bookstore__c updateBookstoreNumOfSoldBooks(
    String bookstoreId,
    Integer bookQty
  ) {
    try {
      Bookstore__c bookstore = new Bookstore__c();
      List<Bookstore__c> bookstoreList = [
        SELECT Id, Num_Sold_Books__c
        FROM Bookstore__c
        WHERE Id = :bookstoreId
      ];

      if (!bookstoreList.isEmpty()) {
        bookstore = bookstoreList[0];
        bookstore.Num_Sold_Books__c += bookQty;
        update bookstore;
      }

      return bookstore;
    } catch (Exception e) {
      throw new CustomException(e.getMessage());
    }
  }
}
