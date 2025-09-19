List<Project__c> projects_array = [SELECT Id FROM Project__c];
List<Task__c> tasks_to_insert = new List<Task__c>();

for (Project__c project : projects_array) {
   tasks_to_insert.add(new Task__c(Project__c = project.Id, Name = 'Task 1', Status__c = 'Not_started'));
}

insert tasks_to_insert;