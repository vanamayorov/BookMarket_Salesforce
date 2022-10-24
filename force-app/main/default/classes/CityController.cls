public with sharing class CityController {
  @AuraEnabled(cacheable=true)
  public static List<City__c> getCities() {
    try {
      return [SELECT Id, Name FROM City__c];
    } catch (Exception e) {
      throw new CustomException(e.getMessage());
    }
  }
}
