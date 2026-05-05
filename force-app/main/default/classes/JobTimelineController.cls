public with sharing class JobTimelineController {
    
    @AuraEnabled(cacheable=true)
    public static Job__c getJobById(String jobId) {
        return [
            SELECT Id, Name, Status__c, Priority__c,
                   Scheduled_Date__c, Client_Name__c
            FROM Job__c
            WHERE Id = :jobId
            LIMIT 1
        ];
    }
}