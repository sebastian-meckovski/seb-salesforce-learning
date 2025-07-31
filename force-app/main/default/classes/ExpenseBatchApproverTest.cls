@isTest
private class ExpenseBatchApproverTest {
    @isTest static void testApproveExpensesUnder20000() {
        // Arrange: create test expenses
        Expense__c e1 = new Expense__c(Name='Expense 1', Currency__c=15000, Status__c='Pending');
        Expense__c e2 = new Expense__c(Name='Expense 2', Currency__c=25000, Status__c='Pending');
        insert new List<Expense__c>{e1, e2};
        
        // Act
        Integer updatedCount = ExpenseBatchApprover.approveExpensesUnder20000();
        
        // Assert
        List<Expense__c> expenses = [SELECT Currency__c, Status__c FROM Expense__c WHERE Id IN :new List<Id>{e1.Id, e2.Id}];
        System.assertEquals(1, updatedCount, 'Should update 1 expense');
        for (Expense__c e : expenses) {
            if (e.Currency__c < 20000) {
                System.assertEquals('Rejected', e.Status__c, 'Status should be Rejected');
            } else {
                System.assertEquals('Pending', e.Status__c, 'Status should remain Pending');
            }
        }
    }
}