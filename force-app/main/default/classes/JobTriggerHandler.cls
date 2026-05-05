public class JobTriggerHandler {
    
    public static void handleAfterInsert(List<Job__c> newJobs) {
        
        // Step 1 - Find first available Technician
        List<Technician__c> availableTechs = [
            SELECT Id, Name 
            FROM Technician__c 
            WHERE Is_Available__c = true 
            LIMIT 1
        ];
        
        // Step 2 - If no technician found, stop here
        if(availableTechs.isEmpty()) {
            return;
        }
        
        // Step 3 - Get the technician
        Technician__c tech = availableTechs[0];
        
        // Step 4 - Create Job Assignments for all new jobs
        List<Job_Assignnment__c> assignments = new List<Job_Assignnment__c>();
        
        for(Job__c job : newJobs) {
            Job_Assignnment__c assignment = new Job_Assignnment__c(
                Job__c = job.Id,
                Technician__c = tech.Id,
                Assigned_Date__c = Date.today()
            );
            assignments.add(assignment);
        }
        
        // Step 5 - Insert all assignments at once
        insert assignments;
    }
}