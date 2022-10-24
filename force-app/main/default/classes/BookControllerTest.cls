@isTest
private class BookControllerTest {
  @testSetup
  static void setup() {
    City__c city = new City__c(Name = 'Kyiv');
    insert city;

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

    Bookstore__c bookstore = new Bookstore__c(
      Name = 'Kharkiv bookstore',
      City__c = city.Id
    );

    insert bookstore;
  }

  @isTest
  static void getBooksByCityTest() {
    City__c city = [SELECT Id, Name FROM City__c WHERE Name = 'Kyiv'];
    List<Book__c> books = BookController.getBooksByCity(city.Id);
    System.assert(books != null);
  }

  @isTest
  static void buyBookTest() {
    Book__c book = [
      SELECT Id, Book_Title__c
      FROM Book__c
      WHERE Book_Title__c = 'Test book'
    ][0];

    User user = [SELECT Id, Name FROM User WHERE LastName = 'Reader'][0];

    Bookstore__c bookstore = [
      SELECT Id, Name
      FROM Bookstore__c
      WHERE Name = 'Kharkiv bookstore'
    ][0];

    Map<String, Object> jsonPayload = new Map<String, Object>();
    jsonPayload.put('bookId', book.Id);
    jsonPayload.put('userId', user.Id);
    jsonPayload.put('bookQty', 1);
    jsonPayload.put('price', 152);
    jsonPayload.put('bookstoreId', bookstore.Id);
    String payloadString = JSON.serialize(jsonPayload);

    BookController.buyBook(payloadString);
  }

  @isTest
  static void updateBookQtyTestPositive() {
    Book__c book = [
      SELECT Id, Book_Title__c
      FROM Book__c
      WHERE Book_Title__c = 'Test book'
    ][0];

    Book__c bookFromDB = BookController.updateBookQty(book.Id, 5);
    System.assertEquals(30, bookFromDB.Quantity__c);
  }

  @isTest
  static void updateBookQtyTestNegative() {
    Book__c book = [
      SELECT Id, Quantity__c
      FROM Book__c
      WHERE Book_Title__c = 'Test book'
    ][0];

    try {
      Book__c bookFromDB = BookController.updateBookQty(book.Id, 36);
    } catch (CustomException e) {
      System.assertEquals(
        'Exceeding number of books. You cant buy more than available in stock.',
        e.getMessage()
      );
    }
  }
}
