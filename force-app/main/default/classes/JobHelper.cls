public class JobHelper {

    // Method to create a new Job record
    public static Job__c createJob(String jobName, String status, String priority) {
        Job__c newJob = new Job__c();
        newJob.Name      = jobName;
        newJob.Status__c  = status;
        newJob.Priority__c = priority;
        insert newJob;
        return newJob;
    }

    // Method to get all Jobs by Status
    public static List<Job__c> getJobsByStatus(String status) {
        return [SELECT Id, Name, Status__c, Priority__c 
                FROM Job__c 
                WHERE Status__c = :status];
    }

    // Method to update Job Priority
    public static void updatePriority(Id jobId, String newPriority) {
        Job__c job = [SELECT Id, Priority__c FROM Job__c WHERE Id = :jobId LIMIT 1];
        job.Priority__c = newPriority;
        update job;
    }

    // Method to delete a Job by Id
    public static void deleteJob(Id jobId) {
        Job__c job = [SELECT Id FROM Job__c WHERE Id = :jobId LIMIT 1];
        delete job;
    }
}