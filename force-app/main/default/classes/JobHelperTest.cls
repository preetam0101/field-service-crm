@isTest
public class JobHelperTest {

    @isTest
    static void testCreateJob() {
        Job__c job = JobHelper.createJob('Test Job', 'New', 'High');
        System.assertNotEquals(null, job.Id, 'Job should be created');
    }

    @isTest
    static void testGetJobsByStatus() {
        JobHelper.createJob('Test Job', 'New', 'High');
        List<Job__c> jobs = JobHelper.getJobsByStatus('New');
        System.assert(jobs.size() > 0, 'Should return at least one job');
    }

    @isTest
    static void testUpdatePriority() {
        Job__c job = JobHelper.createJob('Test Job', 'New', 'High');
        JobHelper.updatePriority(job.Id, 'Low');
        Job__c updated = [SELECT Priority__c FROM Job__c WHERE Id = :job.Id];
        System.assertEquals('Low', updated.Priority__c, 'Priority should be Low');
    }

    @isTest
    static void testDeleteJob() {
        Job__c job = JobHelper.createJob('Test Job', 'New', 'High');
        JobHelper.deleteJob(job.Id);
        List<Job__c> jobs = [SELECT Id FROM Job__c WHERE Id = :job.Id];
        System.assertEquals(0, jobs.size(), 'Job should be deleted');
    }
}