# Salesforce Apex Classes Guide

This guide covers everything you need to know about working with Apex classes in Salesforce using the Salesforce CLI.

## Table of Contents
1. [What are Apex Classes?](#what-are-apex-classes)
2. [Creating a New Apex Class](#creating-a-new-apex-class)
3. [Deploying Classes](#deploying-classes)
4. [Pulling Changes from Org](#pulling-changes-from-org)
5. [Running Tests](#running-tests)
6. [Viewing Test Results](#viewing-test-results)
7. [Best Practices](#best-practices)
8. [Common Commands Reference](#common-commands-reference)

## What are Apex Classes?

Apex classes are the building blocks of Salesforce applications. They contain:
- **Methods**: Functions that perform specific operations
- **Properties**: Variables that store data
- **Business Logic**: Code that implements your organization's processes

### Class Structure
```apex
public with sharing class MyClass {
    // Properties
    private String myProperty;
    
    // Constructor
    public MyClass() {
        // Initialization code
    }
    
    // Methods
    public void myMethod() {
        // Method implementation
    }
    
    public static Integer myStaticMethod() {
        // Static method implementation
        return 0;
    }
}
```

### Test Classes
Test classes verify that your Apex code works correctly:
```apex
@isTest
private class MyClassTest {
    @isTest 
    static void testMyMethod() {
        // Arrange: Set up test data
        // Act: Execute the method being tested
        // Assert: Verify the results
    }
}
```

## Creating a New Apex Class

### Using Salesforce CLI
```powershell
# Create a new Apex class
sf apex generate class --name MyNewClass --output-dir force-app/main/default/classes

# Create a new Apex class with a test class
sf apex generate class --name MyNewClass --output-dir force-app/main/default/classes --template DefaultApexClass
```

### Manual Creation
You can also create classes manually by creating two files:
1. `MyClass.cls` - Contains the Apex code
2. `MyClass.cls-meta.xml` - Contains metadata information

**Example MyClass.cls:**
```apex
public with sharing class MyClass {
    public static void helloWorld() {
        System.debug('Hello, World!');
    }
}
```

**Example MyClass.cls-meta.xml:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>64.0</apiVersion>
    <status>Active</status>
</ApexClass>
```

## Deploying Classes

### Deploy Specific Classes
```powershell
# Deploy all classes in the classes directory
sf project deploy start --source-dir force-app/main/default/classes

# Deploy a specific class file
sf project deploy start --source-dir force-app/main/default/classes/MyClass.cls

# Deploy with test execution
sf project deploy start --source-dir force-app/main/default/classes --test-level RunLocalTests
```

### Deploy All Changes
```powershell
# Deploy all local changes
sf project deploy start

# Deploy and run all tests
sf project deploy start --test-level RunAllTestsInOrg
```

### Check Deployment Status
```powershell
# Check deployment status using deployment ID
sf project deploy report --deploy-id YOUR_DEPLOYMENT_ID
```

## Pulling Changes from Org

### Retrieve Specific Metadata
```powershell
# Pull all Apex classes from org
sf project retrieve start --metadata ApexClass

# Pull specific class
sf project retrieve start --metadata ApexClass:MyClassName

# Pull all classes and triggers
sf project retrieve start --metadata ApexClass,ApexTrigger
```

### Pull All Changes
```powershell
# Pull all metadata from org (be careful with this!)
sf project retrieve start --source-dir force-app

# Pull using manifest file
sf project retrieve start --manifest manifest/package.xml
```

## Running Tests

### Run All Tests
```powershell
# Run all tests in the org
sf apex run test --test-level RunAllTestsInOrg --synchronous

# Run all local tests (recommended)
sf apex run test --test-level RunLocalTests --synchronous
```

### Run Specific Tests
```powershell
# Run a specific test class
sf apex run test --class-names MyTestClass --synchronous

# Run multiple test classes
sf apex run test --class-names "MyTestClass1,MyTestClass2" --synchronous

# Run specific test methods
sf apex run test --tests MyTestClass.testMethod1 --synchronous
```

### Run Tests with Coverage
```powershell
# Run tests and get code coverage
sf apex run test --class-names MyTestClass --code-coverage --synchronous
```

### Background Test Execution
```powershell
# Run tests in background (for long-running tests)
sf apex run test --class-names MyTestClass

# Then get results using the test run ID
sf apex get test --test-run-id YOUR_TEST_RUN_ID
```

## Viewing Test Results

### Get Latest Test Results
```powershell
# Get test results by test run ID
sf apex get test --test-run-id YOUR_TEST_RUN_ID

# Get detailed test results with coverage
sf apex get test --test-run-id YOUR_TEST_RUN_ID --code-coverage --detailed
```

### Output Formats
```powershell
# Get results in JSON format
sf apex get test --test-run-id YOUR_TEST_RUN_ID --json

# Get results and save to file
sf apex get test --test-run-id YOUR_TEST_RUN_ID > test-results.txt
```

### Understanding Test Results
- **Outcome**: Passed, Failed, or Skipped
- **Pass Rate**: Percentage of tests that passed
- **Coverage**: Code coverage percentage for each class
- **Runtime**: How long each test took to execute

## Best Practices

### Class Development
1. **Use meaningful names** for classes and methods
2. **Follow naming conventions**: PascalCase for classes, camelCase for methods
3. **Include documentation** using comments
4. **Keep classes focused** on a single responsibility
5. **Use appropriate access modifiers** (public, private, global)

### Testing
1. **Write tests first** (Test-Driven Development)
2. **Aim for 75%+ code coverage** (required for production)
3. **Test both positive and negative scenarios**
4. **Use meaningful test data**
5. **Keep tests independent** of each other

### Deployment
1. **Always test locally** before deploying
2. **Use version control** (Git) for your code
3. **Deploy in small increments**
4. **Run tests with every deployment**
5. **Have a rollback plan**

## Common Commands Reference

### Quick Reference Table
| Task | Command |
|------|---------|
| Create class | `sf apex generate class --name ClassName --output-dir force-app/main/default/classes` |
| Deploy classes | `sf project deploy start --source-dir force-app/main/default/classes` |
| Pull classes | `sf project retrieve start --metadata ApexClass` |
| Run all tests | `sf apex run test --test-level RunLocalTests --synchronous` |
| Run specific test | `sf apex run test --class-names TestClassName --synchronous` |
| Get test results | `sf apex get test --test-run-id TEST_RUN_ID` |
| Check org info | `sf org display` |
| List orgs | `sf org list` |

### Useful Flags
- `--synchronous`: Wait for command to complete
- `--json`: Output in JSON format
- `--code-coverage`: Include code coverage information
- `--detailed`: Include detailed information
- `--test-level`: Specify which tests to run (NoTestRun, RunSpecifiedTests, RunLocalTests, RunAllTestsInOrg)

## Examples from This Project

### ExpenseBatchApprover Class
This project contains an example of:
- A business logic class (`ExpenseBatchApprover.cls`)
- A corresponding test class (`ExpenseBatchApproverTest.cls`)
- Using custom objects (`Expense__c`)
- Bulk operations with SOQL and DML

### Running the Example Test
```powershell
# Run the expense batch approver test
sf apex run test --class-names ExpenseBatchApproverTest --synchronous

# Deploy the classes first if needed
sf project deploy start --source-dir force-app/main/default/classes
```

## Troubleshooting

### Common Issues
1. **Field doesn't exist**: Check object field names in Setup
2. **Test failures**: Review test logic and data setup
3. **Deployment failures**: Check for compilation errors
4. **Permission issues**: Ensure proper org permissions

### Getting Help
```powershell
# Get help for any command
sf apex run test --help
sf project deploy start --help

# Check Salesforce CLI version
sf version

# Update Salesforce CLI
npm install -g @salesforce/cli@latest
```

## Additional Resources
- [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/)
- [Trailhead Apex Modules](https://trailhead.salesforce.com/en/content/learn/trails/force_com_dev_beginner)
