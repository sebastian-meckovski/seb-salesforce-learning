@isTest
private class BookControllerTest {
    
    @TestSetup
    static void makeData() {
        // Create test data for Book__c records
        List<Book__c> testBooks = new List<Book__c>();
        
        testBooks.add(new Book__c(
            Name = 'Book1',
            Title__c = 'The Great Gatsby',
            Author__c = 'F. Scott Fitzgerald',
            Rating__c = 4.5,
            Review__c = 'A classic American novel'
        ));
        
        testBooks.add(new Book__c(
            Name = 'Book2',
            Title__c = '1984',
            Author__c = 'George Orwell',
            Rating__c = 4.8,
            Review__c = 'A dystopian masterpiece'
        ));
        
        testBooks.add(new Book__c(
            Name = 'Book3',
            Title__c = 'To Kill a Mockingbird',
            Author__c = 'Harper Lee',
            Rating__c = 4.7,
            Review__c = 'A powerful story about justice'
        ));
        
        insert testBooks;
    }
    
    @isTest
    static void testGetBooks_WithData() {
        // Test the getBooks method with existing data
        Test.startTest();
        List<Book__c> result = BookController.getBooks();
        Test.stopTest();
        
        // Assert that we get the expected number of books
        System.assertEquals(3, result.size(), 'Should return 3 books');
        
        // Verify the fields are populated correctly
        for (Book__c book : result) {
            System.assertNotEquals(null, book.Id, 'Book Id should not be null');
            System.assertNotEquals(null, book.Name, 'Book Name should not be null');
            System.assertNotEquals(null, book.Title__c, 'Book Title should not be null');
            System.assertNotEquals(null, book.Author__c, 'Book Author should not be null');
            System.assertNotEquals(null, book.Rating__c, 'Book Rating should not be null');
            System.assertNotEquals(null, book.Review__c, 'Book Review should not be null');
        }
        
        // Verify specific book data
        Book__c gatsby = null;
        for (Book__c book : result) {
            if (book.Title__c == 'The Great Gatsby') {
                gatsby = book;
                break;
            }
        }
        System.assertNotEquals(null, gatsby, 'Should find The Great Gatsby');
        System.assertEquals('F. Scott Fitzgerald', gatsby.Author__c, 'Author should match');
        System.assertEquals(4.5, gatsby.Rating__c, 'Rating should match');
    }
    
    @isTest
    static void testGetBooks_NoData() {
        // Delete all test data to test empty result
        delete [SELECT Id FROM Book__c];
        
        Test.startTest();
        List<Book__c> result = BookController.getBooks();
        Test.stopTest();
        
        // Assert that we get an empty list
        System.assertEquals(0, result.size(), 'Should return empty list when no books exist');
        System.assertNotEquals(null, result, 'Result should not be null, should be empty list');
    }
    
    @isTest
    static void testGetBooks_CacheableAnnotation() {
        // Test that the method works correctly (cacheable methods should work normally in tests)
        Test.startTest();
        List<Book__c> firstCall = BookController.getBooks();
        List<Book__c> secondCall = BookController.getBooks();
        Test.stopTest();
        
        // Both calls should return the same data
        System.assertEquals(firstCall.size(), secondCall.size(), 'Both calls should return same number of records');
        System.assertEquals(3, firstCall.size(), 'Should return 3 books on first call');
        System.assertEquals(3, secondCall.size(), 'Should return 3 books on second call');
    }
    
    @isTest
    static void testGetBooks_FieldAccess() {
        // Test that all required fields are accessible and returned
        Test.startTest();
        List<Book__c> result = BookController.getBooks();
        Test.stopTest();
        
        System.assert(result.size() > 0, 'Should have test data');
        
        Book__c testBook = result[0];
        
        // Test that we can access all the fields mentioned in the SOQL query
        try {
            String id = testBook.Id;
            String name = testBook.Name;
            String title = testBook.Title__c;
            String author = testBook.Author__c;
            Decimal rating = testBook.Rating__c;
            String review = testBook.Review__c;
            
            // If we get here without exceptions, field access is working
            System.assert(true, 'All fields are accessible');
        } catch (Exception e) {
            System.assert(false, 'Field access failed: ' + e.getMessage());
        }
    }
}
