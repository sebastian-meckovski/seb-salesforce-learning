trigger BookUpdateTrigger on Book__c (after update) {
    
    // List to hold the platform events to be published
    List<Book_Update__e> bookUpdateEvents = new List<Book_Update__e>();
    
    // Iterate through the updated Book records
    for (Book__c book : Trigger.new) {
        
        // Get the old version of the record for comparison
        Book__c oldBook = Trigger.oldMap.get(book.Id);
        
        // Check if any relevant fields have actually changed
        Boolean hasSignificantChange = false;
        
        if (book.Title__c != oldBook.Title__c ||
            book.Author__c != oldBook.Author__c ||
            book.Rating__c != oldBook.Rating__c ||
            book.Review__c != oldBook.Review__c) {
            hasSignificantChange = true;
        }
        
        // Only publish event if there was a significant change
        if (hasSignificantChange) {
            
            Book_Update__e bookEvent = new Book_Update__e();
            
            // Since the platform event doesn't have custom fields defined yet,
            // we'll prepare the event object. You can add custom fields to the
            // Book_Update__e object and populate them here.
            
            // Example of what you could add if custom fields existed:
            // bookEvent.Book_Id__c = book.Id;
            // bookEvent.Book_Title__c = book.Title__c;
            // bookEvent.Book_Author__c = book.Author__c;
            // bookEvent.Previous_Rating__c = oldBook.Rating__c;
            // bookEvent.New_Rating__c = book.Rating__c;
            // bookEvent.Update_Type__c = 'Rating Change';
            
            bookUpdateEvents.add(bookEvent);
        }
    }
    
    // Publish the platform events
    if (!bookUpdateEvents.isEmpty()) {
        List<Database.SaveResult> results = EventBus.publish(bookUpdateEvents);
        
        // Handle any publishing errors
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                for (Database.Error error : result.getErrors()) {
                    System.debug('Error publishing Book_Update__e event: ' + error.getMessage());
                    // In production, you might want to log this to a custom object
                    // or send an alert
                }
            }
        }
    }
}