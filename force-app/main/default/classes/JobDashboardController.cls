/**
 * @description Apex controller for Job Dashboard LWC
 * Provides job data to the jobDashboard component
 * @author Preetam Parmar
 */
public with sharing class JobDashboardController {
    
    /**
     * @description Fetches all Job records ordered by Scheduled Date
     * cacheable=true enables client side caching for better performance
     * @return List of Job__c records
     */
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