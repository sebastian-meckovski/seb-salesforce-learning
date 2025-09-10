@RestResource(urlMapping='/expense/updateDescription')
global with sharing class ExpenseRestController {
    @HttpPatch
    global static String updateDescription() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        // Parse the request body (expects JSON: { "id": "...", "description": "..." })
        String body = req.requestBody.toString();
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(body);

        String expenseId = (String)data.get('id');
        String newDescription = (String)data.get('description');
        if (expenseId == null || newDescription == null) {
            res.statusCode = 400;
            return 'Missing id or description in request.';
        }

        // Query and update the Expense__c record
        Expense__c exp = [SELECT Id, Description__c FROM Expense__c WHERE Id = :expenseId LIMIT 1];
        exp.Description__c = newDescription;
        update exp;

        res.statusCode = 200;
        return 'Description updated successfully.';
    }
}