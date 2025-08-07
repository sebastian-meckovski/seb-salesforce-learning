public with sharing class BookController {
    @AuraEnabled(cacheable=true)
    public static List<Book__c> getBooks() {
        return [SELECT Id, Name, Title__c, Author__c, Rating__c, Review__c FROM Book__c];
    }
    
    @AuraEnabled
    public static Book__c createBook(String title, String author, Integer rating, String review) {
        Book__c newBook = new Book__c(
            Title__c = title,
            Author__c = author,
            Rating__c = rating,
            Review__c = review
        );
        insert newBook;
        return newBook;
    }
    
    @AuraEnabled
    public static Book__c updateBookRating(Id bookId, Decimal newRating) {
        Book__c book = [SELECT Id, Rating__c FROM Book__c WHERE Id = :bookId LIMIT 1];
        book.Rating__c = newRating;
        update book;
        return book;
    }
}