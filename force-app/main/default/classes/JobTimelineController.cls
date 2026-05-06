/**
 * @description Apex controller for Job Timeline LWC
 * Fetches single Job record for timeline display
 * @author Preetam Parmar
 */
public with sharing class JobTimelineController {
    
    /**
     * @description Fetches a single Job record by Id
     * @param jobId Id of the Job record to retrieve
     * @return Single Job__c record
     */
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