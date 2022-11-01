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

  public static void makeCityPrivate(
    List<Bookstore_Manager__c> bookstoreManagers
  ) {
    Set<Id> bMaIds = new Set<Id>();

    for (Bookstore_Manager__c bMa : bookstoreManagers) {
      bMaIds.add(bMa.User__c);
    }

    List<City__Share> cityShareList = [
      SELECT Id, UserOrGroupId
      FROM City__Share
      WHERE UserOrGroupId IN :bMaIds
    ];

    delete cityShareList;
  }
}
