@isTest
private class ExpenseRestControllerTest {
    @isTest
    static void testUpdateDescription_Success() {
        // Arrange: create an Expense__c record
        Expense__c exp = new Expense__c(
            Name = 'Exp 1',
            Currency__c = 100,
            Status__c = 'Submitted',
            Category__c = 'Travel',
            Date__c = Date.today(),
            Description__c = 'Old desc'
        );
        insert exp;

        // Prepare REST request/response
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PATCH';
        req.requestURI = '/services/apexrest/expense/updateDescription';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf('{"id":"' + exp.Id + '","description":"New desc"}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String result = ExpenseRestController.updateDescription();
        Test.stopTest();

        // Assert response and DB change
        System.assertEquals(200, RestContext.response.statusCode, 'Should return 200');
        System.assertEquals('Description updated successfully.', result, 'Return message should match');
        Expense__c reloaded = [SELECT Description__c FROM Expense__c WHERE Id = :exp.Id];
        System.assertEquals('New desc', reloaded.Description__c, 'Description should be updated');
    }

    @isTest
    static void testUpdateDescription_MissingFields() {
        // Prepare REST request with missing fields
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PATCH';
        req.requestURI = '/services/apexrest/expense/updateDescription';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf('{"id":null,"description":null}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String result = ExpenseRestController.updateDescription();
        Test.stopTest();

        System.assertEquals(400, RestContext.response.statusCode, 'Should return 400 for missing inputs');
        System.assertEquals('Missing id or description in request.', result, 'Error message should match');
    }
}