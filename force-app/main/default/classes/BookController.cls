public with sharing class BookController {
  @AuraEnabled(cacheable=true)
  public static List<Book__c> getBooksByCity(String cityId) {
    try {
      return [
        SELECT
          Id,
          Book_Title__c,
          Price__c,
          Description__c,
          Quantity__c,
          Author__r.Name,
          Bookstore__r.Name,
          Available_In_Stock__c
        FROM Book__c
        WHERE Bookstore__r.City__c = :cityId
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static void buyBook(String payload) {
    try {
      Map<String, Object> payloadMap = (Map<String, Object>) JSON.deserializeUntyped(
        payload
      );
      String bookId = (String) payloadMap.get('bookId');
      String userId = (String) payloadMap.get('userId');
      Integer bookQty = (Integer) payloadMap.get('bookQty');
      Double price = (Double) payloadMap.get('price');
      String bookstoreId = (String) payloadMap.get('bookstoreId');

      Reader__c reader = ReaderController.createReader(userId);
      InvoiceController.makeInvoice(reader.Id, bookId, bookQty, price);
      BookController.updateBookQty(bookId, bookQty);
      BookstoreController.updateBookstoreNumOfSoldBooks(bookstoreId, bookQty);
      ReaderController.createReaderList(reader.Id, bookId, bookQty);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  private static Book__c updateBookQty(String bookId, Integer bookQty) {
    try {
      Book__c book = [
        SELECT Id, Quantity__c
        FROM Book__c
        WHERE Id = :bookId
      ][0];

      if (book.Quantity__c - bookQty < 0) {
        throw new AuraHandledException('Exceeding num of books, buy less');
      }

      book.Quantity__c -= bookQty;
      update book;
      return book;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
