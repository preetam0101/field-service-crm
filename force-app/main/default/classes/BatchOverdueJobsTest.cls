@isTest
public class BatchOverdueJobsTest {
    
    @TestSetup
    static void setupTestData() {
        
        // Create overdue jobs (past date, not completed)
        List<Job__c> overdueJobs = new List<Job__c>();
        for(Integer i = 0; i < 5; i++) {
            overdueJobs.add(new Job__c(
                Name = 'Overdue Job ' + i,
                Status__c = 'New',
                Priority__c = 'High',
                Scheduled_Date__c = Date.today().addDays(-5),
                Client_Name__c = 'Test Client ' + i
            ));
        }
        insert overdueJobs;
        
        // Create completed jobs (should NOT be updated)
        List<Job__c> completedJobs = new List<Job__c>();
        for(Integer i = 0; i < 3; i++) {
            completedJobs.add(new Job__c(
                Name = 'Completed Job ' + i,
                Status__c = 'Completed',
                Priority__c = 'Low',
                Scheduled_Date__c = Date.today().addDays(-3),
                Client_Name__c = 'Completed Client ' + i
            ));
        }
        insert completedJobs;
    }
    
    // Test 1 - Batch marks overdue jobs correctly
    @isTest
    static void testBatchMarksOverdueJobs() {
        
        Test.startTest();
        BatchOverdueJobs batch = new BatchOverdueJobs();
        Database.executeBatch(batch, 200);
        Test.stopTest();
        
        // Verify overdue jobs were updated
        List<Job__c> overdueJobs = [
            SELECT Id, Status__c 
            FROM Job__c 
            WHERE Name LIKE 'Overdue Job%'
        ];
        
        for(Job__c job : overdueJobs) {
            System.assertEquals('Overdue', job.Status__c,
                'Job status should be updated to Overdue');
        }
    }
    
    // Test 2 - Completed jobs are NOT updated
    @isTest
    static void testCompletedJobsNotUpdated() {
        
        Test.startTest();
        BatchOverdueJobs batch = new BatchOverdueJobs();
        Database.executeBatch(batch, 200);
        Test.stopTest();
        
        // Verify completed jobs still have Completed status
        List<Job__c> completedJobs = [
            SELECT Id, Status__c 
            FROM Job__c 
            WHERE Name LIKE 'Completed Job%'
        ];
        
        for(Job__c job : completedJobs) {
            System.assertEquals('Completed', job.Status__c,
                'Completed jobs should not be updated');
        }
    }
    
    // Test 3 - Scheduler test
    @isTest
    static void testScheduler() {
        
        Test.startTest();
        String cronExp = '0 0 8 * * ?';
        System.schedule(
            'Test Overdue Jobs Batch',
            cronExp,
            new BatchOverdueJobsScheduler()
        );
        Test.stopTest();
        
        // Verify scheduled job exists
        List<CronTrigger> scheduledJobs = [
            SELECT Id, CronJobDetail.Name 
            FROM CronTrigger 
            WHERE CronJobDetail.Name = 'Test Overdue Jobs Batch'
        ];
        
        System.assertEquals(1, scheduledJobs.size(),
            'Scheduled job should exist');
    }
}