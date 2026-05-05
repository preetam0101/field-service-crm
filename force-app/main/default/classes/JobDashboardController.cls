public with sharing class JobDashboardController {
    
    @AuraEnabled(cacheable=true)
    public static List<Job__c> getJobs() {
        return [
            SELECT Id, Name, Status__c, Priority__c, 
                   Scheduled_Date__c, Client_Name__c
            FROM Job__c
            ORDER BY Scheduled_Date__c ASC
            LIMIT 200
        ];
    }
}