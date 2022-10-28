public with sharing class CityController {
  @AuraEnabled(cacheable=true)
  public static List<City__c> getCities() {
    try {
      List<City__c> cities = [SELECT Id, Name FROM City__c];
      if (cities.isEmpty()) {
        throw new CustomException('No cities found');
      }
      return cities;
    } catch (Exception e) {
      throw new CustomException(e.getMessage());
    }
  }
}
