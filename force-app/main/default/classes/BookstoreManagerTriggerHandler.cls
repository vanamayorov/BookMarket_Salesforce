public class BookstoreManagerTriggerHandler {
  public static void makeCityPublic(
    List<Bookstore_Manager__c> bookstoreManagers
  ) {
    List<City__Share> cityShareList = new List<City__Share>();
    for (Bookstore_Manager__c bMan : bookstoreManagers) {
      City__Share cityShare = new City__Share();
      cityShare.ParentId = bMan.City__c;
      cityShare.UserOrGroupId = bMan.User__c;
      cityShare.AccessLevel = 'Read';
      cityShareList.add(cityShare);
    }
    insert cityShareList;
  }
}
