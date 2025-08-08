trigger BookEventTrigger on Book_Update__e (after insert) {
    System.debug('Platform Event trigger fired for ' + Trigger.new.size() + ' event(s)');
    
    for (Book_Update__e event : Trigger.new) {
        System.debug('Processing Book Update Event: ' + event.EventUuid);
        System.debug('Event details: ' + event);
        
        // You can add your event processing logic here
        // For example, logging to a custom object, calling external services, etc.
        
        // Example: Create audit log entries
        // This would require creating a Book_Event_Log__c custom object
        /*
        Book_Event_Log__c log = new Book_Event_Log__c(
            Event_UUID__c = event.EventUuid,
            Created_Date__c = event.CreatedDate,
            Event_Details__c = String.valueOf(event)
        );
        insert log;
        */
    }
}