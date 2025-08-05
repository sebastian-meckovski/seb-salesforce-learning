public with sharing class BookController {
    @AuraEnabled(cacheable=true)
    public static List<Book__c> getBooks() {
        return [SELECT Id, Name, Title__c, Author__c, Rating__c, Review__c FROM Book__c];
    }
}