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
        Expense__c e2 = new Expense__c(
            Name='Expense 2', 
            Currency__c=25000, 
            Status__c='Submitted',
            Category__c='Travel',
            Date__c=Date.today(),
            Description__c='Test expense 2'
        );
        insert new List<Expense__c>{e1, e2};
        
        // Act
        Test.startTest();
        Integer updatedCount = ExpenseBatchApprover.approveExpensesUnder20000();
        Test.stopTest();
        
        // Assert
        List<Expense__c> expenses = [SELECT Currency__c, Status__c FROM Expense__c WHERE Id IN :new List<Id>{e1.Id, e2.Id}];
        System.assertEquals(1, updatedCount, 'Should update 1 expense');
        
        // Check each expense individually
        for (Expense__c e : expenses) {
            if (e.Currency__c < 20000) {
                System.assertEquals('Rejected', e.Status__c, 'Status should be Rejected for expense under 20000');
            } else {
                System.assertEquals('Submitted', e.Status__c, 'Status should remain Submitted for expense over 20000');
            }
        }
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