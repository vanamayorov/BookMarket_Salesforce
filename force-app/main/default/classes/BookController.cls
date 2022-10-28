public with sharing class BookController {
  @AuraEnabled(cacheable=true)
  public static List<Book__c> getBooksByCity(String cityId) {
    try {
      List<Book__c> booksList = [
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

      if (booksList.isEmpty()) {
        throw new CustomException('No books found.');
      }

      return booksList;
    } catch (Exception e) {
      throw new CustomException(e.getMessage());
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

      BookController.updateBookQty(bookId, bookQty);
      Reader__c reader = ReaderController.createReader(userId);
      InvoiceController.makeInvoice(
        reader.Id,
        bookId,
        bookQty,
        price,
        bookstoreId
      );
      ReaderController.createReaderList(reader.Id, bookId, bookQty);
      BookstoreController.updateBookstoreNumOfSoldBooks(bookstoreId, bookQty);
    } catch (Exception e) {
      throw new CustomException(e.getMessage());
    }
  }

  public static Book__c updateBookQty(String bookId, Integer bookQty) {
    try {
      Book__c book = [
        SELECT Id, Quantity__c
        FROM Book__c
        WHERE Id = :bookId
      ][0];

      if (book.Quantity__c - bookQty < 0) {
        throw new CustomException(
          'Exceeding number of books. You cant buy more than available in stock.'
        );
      }

      book.Quantity__c -= bookQty;
      update book;
      return book;
    } catch (Exception e) {
      throw new CustomException(e.getMessage());
    }
  }
}
