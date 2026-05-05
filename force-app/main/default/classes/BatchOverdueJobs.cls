public class BatchOverdueJobs implements Database.Batchable<sObject>, Database.Stateful {
    
    // Track count of overdue jobs across all batches
    private Integer overdueCount = 0;
    private String adminEmail = 'parmarpreetam143@gmail.com';
    
    // Step 1 - START: Query all jobs to process
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Status__c, Scheduled_Date__c 
            FROM Job__c 
            WHERE Scheduled_Date__c < TODAY
            AND Status__c != 'Completed'
        ]);
    }
    
    // Step 2 - EXECUTE: Process each chunk of records
    public void execute(Database.BatchableContext bc, List<Job__c> jobs) {
        
        List<Job__c> jobsToUpdate = new List<Job__c>();
        
        for(Job__c job : jobs) {
            job.Status__c = 'Overdue';
            jobsToUpdate.add(job);
        }
        
        if(!jobsToUpdate.isEmpty()) {
            update jobsToUpdate;
            overdueCount += jobsToUpdate.size();
        }
    }
    
    // Step 3 - FINISH: Send summary email
    public void finish(Database.BatchableContext bc) {
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{ adminEmail });
        email.setSubject('Daily Overdue Jobs Report');
        email.setPlainTextBody(
            'Daily batch job completed.\n\n' +
            'Total jobs marked as Overdue: ' + overdueCount + '\n\n' +
            'Please review the Field Service CRM dashboard for details.'
        );
        
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
    }
}