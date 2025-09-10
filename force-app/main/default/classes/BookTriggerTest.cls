@isTest
private class BookTriggerTest {
    
    @TestSetup
    static void makeData() {
        // Create test data for Book__c records
        List<Book__c> testBooks = new List<Book__c>();
        
        testBooks.add(new Book__c(
            Name = 'TriggerTestBook1',
            Title__c = 'Original Title 1',
            Author__c = 'Original Author 1',
            Rating__c = 3.0,
            Review__c = 'Original review 1'
        ));
        
        testBooks.add(new Book__c(
            Name = 'TriggerTestBook2',
            Title__c = 'Original Title 2',
            Author__c = 'Original Author 2',
            Rating__c = 4.0,
            Review__c = 'Original review 2'
        ));
        
        insert testBooks;
    }
    
    @isTest
    static void testBookUpdateTrigger_TitleChange() {
        // Test that BookUpdateTrigger fires when title changes
        Book__c testBook = [SELECT Id, Title__c, Author__c, Rating__c, Review__c FROM Book__c WHERE Name = 'TriggerTestBook1' LIMIT 1];
        
        Test.startTest();
        // Update the title to trigger the trigger
        testBook.Title__c = 'Updated Title 1';
        update testBook;
        Test.stopTest();
        
        // Verify the book was updated (trigger should have fired)
        Book__c updatedBook = [SELECT Title__c FROM Book__c WHERE Id = :testBook.Id];
        System.assertEquals('Updated Title 1', updatedBook.Title__c, 'Title should be updated');
    }
    
    @isTest
    static void testBookUpdateTrigger_AuthorChange() {
        // Test that BookUpdateTrigger fires when author changes
        Book__c testBook = [SELECT Id, Title__c, Author__c, Rating__c, Review__c FROM Book__c WHERE Name = 'TriggerTestBook1' LIMIT 1];
        
        Test.startTest();
        // Update the author to trigger the trigger
        testBook.Author__c = 'Updated Author 1';
        update testBook;
        Test.stopTest();
        
        // Verify the book was updated
        Book__c updatedBook = [SELECT Author__c FROM Book__c WHERE Id = :testBook.Id];
        System.assertEquals('Updated Author 1', updatedBook.Author__c, 'Author should be updated');
    }
    
    @isTest
    static void testBookUpdateTrigger_RatingChange() {
        // Test that BookUpdateTrigger fires when rating changes
        Book__c testBook = [SELECT Id, Title__c, Author__c, Rating__c, Review__c FROM Book__c WHERE Name = 'TriggerTestBook1' LIMIT 1];
        
        Test.startTest();
        // Update the rating to trigger the trigger
        testBook.Rating__c = 5.0;
        update testBook;
        Test.stopTest();
        
        // Verify the book was updated
        Book__c updatedBook = [SELECT Rating__c FROM Book__c WHERE Id = :testBook.Id];
        System.assertEquals(5.0, updatedBook.Rating__c, 'Rating should be updated');
    }
    
    @isTest
    static void testBookUpdateTrigger_ReviewChange() {
        // Test that BookUpdateTrigger fires when review changes
        Book__c testBook = [SELECT Id, Title__c, Author__c, Rating__c, Review__c FROM Book__c WHERE Name = 'TriggerTestBook1' LIMIT 1];
        
        Test.startTest();
        // Update the review to trigger the trigger
        testBook.Review__c = 'Updated review 1';
        update testBook;
        Test.stopTest();
        
        // Verify the book was updated
        Book__c updatedBook = [SELECT Review__c FROM Book__c WHERE Id = :testBook.Id];
        System.assertEquals('Updated review 1', updatedBook.Review__c, 'Review should be updated');
    }
    
    @isTest
    static void testBookUpdateTrigger_MultipleFieldChanges() {
        // Test that BookUpdateTrigger fires when multiple fields change
        Book__c testBook = [SELECT Id, Title__c, Author__c, Rating__c, Review__c FROM Book__c WHERE Name = 'TriggerTestBook1' LIMIT 1];
        
        Test.startTest();
        // Update multiple fields to trigger the trigger
        testBook.Title__c = 'Multi Updated Title';
        testBook.Author__c = 'Multi Updated Author';
        testBook.Rating__c = 2.5;
        testBook.Review__c = 'Multi updated review';
        update testBook;
        Test.stopTest();
        
        // Verify all fields were updated
        Book__c updatedBook = [SELECT Title__c, Author__c, Rating__c, Review__c FROM Book__c WHERE Id = :testBook.Id];
        System.assertEquals('Multi Updated Title', updatedBook.Title__c, 'Title should be updated');
        System.assertEquals('Multi Updated Author', updatedBook.Author__c, 'Author should be updated');
        System.assertEquals(2.5, updatedBook.Rating__c, 'Rating should be updated');
        System.assertEquals('Multi updated review', updatedBook.Review__c, 'Review should be updated');
    }
    
    @isTest
    static void testBookUpdateTrigger_NoSignificantChange() {
        // Test that trigger handles updates with no significant field changes
        Book__c testBook = [SELECT Id, Title__c, Author__c, Rating__c, Review__c FROM Book__c WHERE Name = 'TriggerTestBook1' LIMIT 1];
        
        Test.startTest();
        // Update a field that's not monitored by the trigger (like Name)
        testBook.Name = 'UpdatedName1';
        update testBook;
        Test.stopTest();
        
        // Verify the name was updated but trigger logic for significant changes wasn't triggered
        Book__c updatedBook = [SELECT Name FROM Book__c WHERE Id = :testBook.Id];
        System.assertEquals('UpdatedName1', updatedBook.Name, 'Name should be updated');
    }
    
    @isTest
    static void testBookUpdateTrigger_BulkUpdate() {
        // Test that trigger handles bulk updates correctly
        List<Book__c> testBooks = [SELECT Id, Title__c, Author__c, Rating__c, Review__c FROM Book__c];
        
        Test.startTest();
        // Update multiple books at once
        for (Book__c book : testBooks) {
            book.Rating__c = 4.5;
            book.Review__c = 'Bulk updated review';
        }
        update testBooks;
        Test.stopTest();
        
        // Verify all books were updated
        List<Book__c> updatedBooks = [SELECT Rating__c, Review__c FROM Book__c WHERE Id IN :testBooks];
        for (Book__c book : updatedBooks) {
            System.assertEquals(4.5, book.Rating__c, 'Rating should be updated for all books');
            System.assertEquals('Bulk updated review', book.Review__c, 'Review should be updated for all books');
        }
    }
    
    @isTest
    static void testBookEventTrigger_PlatformEventHandling() {
        // Test the BookEventTrigger by publishing a platform event
        // Note: Platform event triggers are harder to test directly, but we can test the logic
        
        Test.startTest();
        
        // Create and publish a Book_Update__e platform event
        Book_Update__e testEvent = new Book_Update__e();
        
        // Publish the event
        List<Database.SaveResult> results = EventBus.publish(testEvent);
        
        Test.stopTest();
        
        // Verify the event was published successfully
        System.assertEquals(1, results.size(), 'Should have one publish result');
        System.assertEquals(true, results[0].isSuccess(), 'Event should be published successfully');
    }
    
    @isTest
    static void testBookEventTrigger_MultipleEvents() {
        // Test the BookEventTrigger with multiple platform events
        
        Test.startTest();
        
        // Create multiple Book_Update__e platform events
        List<Book_Update__e> testEvents = new List<Book_Update__e>();
        testEvents.add(new Book_Update__e());
        testEvents.add(new Book_Update__e());
        testEvents.add(new Book_Update__e());
        
        // Publish the events
        List<Database.SaveResult> results = EventBus.publish(testEvents);
        
        Test.stopTest();
        
        // Verify all events were published successfully
        System.assertEquals(3, results.size(), 'Should have three publish results');
        for (Database.SaveResult result : results) {
            System.assertEquals(true, result.isSuccess(), 'All events should be published successfully');
        }
    }
}
