@isTest
private class CityControllerTest {
  static final List<String> citiesNames = new List<String>{ 'Kyiv', 'Kharkiv' };

  static private void insertCities() {
    List<City__c> cities = new List<City__c>();
    for (Integer i = 0; i < citiesNames.size(); i++) {
      cities.add(new City__c(Name = citiesNames[i]));
    }
    insert cities;
  }

  @isTest
  static void getCitiesTestPositive() {
    CityControllerTest.insertCities();
    Test.startTest();
    List<City__c> cities = CityController.getCities();
    System.assert(cities != null);
    System.assert(cities.size() == citiesNames.size());
    for (Integer i = 0; i < citiesNames.size(); i++) {
      System.assertEquals(citiesNames[i], cities[i].Name);
    }
    Test.stopTest();
  }

  @isTest
  static void getCitiesTest_No_Cities_Found() {
    try {
      Test.startTest();
      List<City__c> cities = CityController.getCities();
      Test.stopTest();
    } catch (Exception e) {
      System.assertEquals('No cities found', e.getMessage());
    }
  }
}
