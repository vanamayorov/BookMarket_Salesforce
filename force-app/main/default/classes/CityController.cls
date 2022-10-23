public with sharing class CityController {
  @AuraEnabled(cacheable=true)
  public static List<City__c> getCities() {
    return [SELECT Id, Name FROM City__c];
  }
}
