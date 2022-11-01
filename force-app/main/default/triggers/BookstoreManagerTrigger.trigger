trigger BookstoreManagerTrigger on Bookstore_Manager__c(
  after insert,
  after update,
  before delete
) {
  if (Trigger.isBefore) {
    if (Trigger.isDelete) {
      BookstoreManagerTriggerHandler.makeCityPrivate(Trigger.old);
    }
  }
  if (Trigger.isAfter) {
    BookstoreManagerTriggerHandler.makeCityPublic(Trigger.new);
  }
}
