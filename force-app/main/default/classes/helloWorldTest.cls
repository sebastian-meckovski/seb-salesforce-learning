@isTest
private class helloWorldTest {
    @isTest static void testConstructor() {
        // Test the constructor
        Test.startTest();
        helloWorld hw = new helloWorld();
        Test.stopTest();
        
        // Assert that the object was created successfully
        System.assertNotEquals(null, hw, 'helloWorld object should be created');
    }
    
    @isTest static void testMultipleInstances() {
        // Test creating multiple instances
        Test.startTest();
        helloWorld hw1 = new helloWorld();
        helloWorld hw2 = new helloWorld();
        Test.stopTest();
        
        // Assert that both objects were created successfully
        System.assertNotEquals(null, hw1, 'First helloWorld object should be created');
        System.assertNotEquals(null, hw2, 'Second helloWorld object should be created');
    }
}