@isTest
private class CityControllerTest {
  @isTest
  static void getCitiesTest() {
    List<City__c> cities = CityController.getCities();
    System.assert(cities != null);
  }
}
