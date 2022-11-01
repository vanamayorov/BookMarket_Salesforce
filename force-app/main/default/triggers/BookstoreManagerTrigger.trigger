trigger BookstoreManagerTrigger on Bookstore_Manager__c(
  after insert,
  after update
) {
  if (Trigger.isAfter) {
    BookstoreManagerTriggerHandler.makeCityPublic(Trigger.new);
  }
}
