public with sharing class InvoiceController {
  public static Invoice__c makeInvoice(
    String readerId,
    String bookId,
    Integer bookQty,
    Double price
  ) {
    try {
      Invoice__c invoice = new Invoice__c(
        Books_Quantity__c = bookQty,
        Book__c = bookId,
        Reader__c = readerId,
        Total_Amount__c = price * bookQty
      );

      insert invoice;
      return invoice;
    } catch (Exception e) {
      throw new CustomException(e.getMessage());
    }
  }
}
