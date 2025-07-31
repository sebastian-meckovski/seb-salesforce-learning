@isTest
private class ExpenseBatchApproverTest {
    @isTest static void testApproveExpensesUnder20000() {
        // Arrange: create test expenses with required fields
        Expense__c e1 = new Expense__c(
            Name='Expense 1', 
            Currency__c=15000, 
            Status__c='Submitted',
            Category__c='Travel',
            Date__c=Date.today(),
            Description__c='Test expense 1'
        );
        insert e1;
        
        // Debug: Check what we actually inserted
        Expense__c inserted = [SELECT Id, Currency__c, Status__c FROM Expense__c WHERE Id = :e1.Id];
        System.debug('Inserted expense: Currency=' + inserted.Currency__c + ', Status=' + inserted.Status__c);
        
        // Debug: Check what the query finds
        List<Expense__c> foundExpenses = [SELECT Id, Currency__c, Status__c FROM Expense__c WHERE Currency__c < 20000 AND Status__c != 'Rejected'];
        System.debug('Found ' + foundExpenses.size() + ' expenses matching criteria');
        
        // Act
        Test.startTest();
        Integer updatedCount = ExpenseBatchApprover.approveExpensesUnder20000();
        Test.stopTest();
        
        // Assert
        System.assertEquals(1, updatedCount, 'Should update 1 expense');
        
        // Verify the update
        Expense__c updated = [SELECT Status__c FROM Expense__c WHERE Id = :e1.Id];
        System.assertEquals('Rejected', updated.Status__c, 'Status should be Rejected');
    }
    
    @isTest static void testApproveExpensesUnder20000_NoRecordsToUpdate() {
        // Test case where no records meet criteria (all already rejected)
        Expense__c e1 = new Expense__c(
            Name='Expense 1', 
            Currency__c=15000, 
            Status__c='Rejected',
            Category__c='Travel',
            Date__c=Date.today(),
            Description__c='Test expense 1'
        );
        insert e1;
        
        Test.startTest();
        Integer updatedCount = ExpenseBatchApprover.approveExpensesUnder20000();
        Test.stopTest();
        
        System.assertEquals(0, updatedCount, 'Should update 0 expenses when all are already rejected');
    }
    
    @isTest static void testApproveExpensesUnder20000_AllOverThreshold() {
        // Test case where all expenses are over 20000
        Expense__c e1 = new Expense__c(
            Name='Expense 1', 
            Currency__c=25000, 
            Status__c='Submitted',
            Category__c='Travel',
            Date__c=Date.today(),
            Description__c='Test expense 1'
        );
        insert e1;
        
        Test.startTest();
        Integer updatedCount = ExpenseBatchApprover.approveExpensesUnder20000();
        Test.stopTest();
        
        System.assertEquals(0, updatedCount, 'Should update 0 expenses when all are over threshold');
    }
}