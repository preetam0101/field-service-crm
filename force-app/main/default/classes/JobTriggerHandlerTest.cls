@isTest
public class JobTriggerHandlerTest {
    
    // Step 1 - Setup test data
    @TestSetup
    static void setupTestData() {
        
        // Create a test Technician
        Technician__c tech = new Technician__c(
            Name = 'Test Technician',
            Is_Available__c = true,
            Email__c = 'testtech@test.com',
            Phone__c = '1234567890'
        );
        insert tech;
    }
    
    // Test 1 - Happy path: Job created, technician available
    @isTest
    static void testJobAssignmentCreated() {
        
        // Create a test Job
        Job__c job = new Job__c(
            Name = 'Test Job',
            Status__c = 'New',
            Priority__c = 'High',
            Scheduled_Date__c = Date.today().addDays(5),
            Client_Name__c = 'Test Client'
        );
        
        // Start test
        Test.startTest();
        insert job;
        Test.stopTest();
        
        // Verify Job Assignment was created
        List<Job_Assignnment__c> assignments = [
            SELECT Id, Job__c, Technician__c 
            FROM Job_Assignnment__c 
            WHERE Job__c = :job.Id
        ];
        
        // Assert
        System.assertEquals(1, assignments.size(), 
            'One Job Assignment should have been created');
        System.assertNotEquals(null, assignments[0].Technician__c, 
            'Technician should be assigned');
    }
    
    // Test 2 - No technician available
    @isTest
    static void testNoTechnicianAvailable() {
        
        // Make technician unavailable
        Technician__c tech = [
            SELECT Id 
            FROM Technician__c 
            LIMIT 1
        ];
        tech.Is_Available__c = false;
        update tech;
        
        // Create a test Job
        Job__c job = new Job__c(
            Name = 'Test Job No Tech',
            Status__c = 'New',
            Priority__c = 'Low',
            Scheduled_Date__c = Date.today().addDays(3),
            Client_Name__c = 'Test Client 2'
        );
        
        // Start test
        Test.startTest();
        insert job;
        Test.stopTest();
        
        // Verify NO Job Assignment was created
        List<Job_Assignnment__c> assignments = [
            SELECT Id 
            FROM Job_Assignnment__c 
            WHERE Job__c = :job.Id
        ];
        
        // Assert
        System.assertEquals(0, assignments.size(), 
            'No Job Assignment should be created when no technician is available');
    }
    
    // Test 3 - Bulk test: multiple jobs created at once
    @isTest
    static void testBulkJobCreation() {
        
        // Create 10 jobs at once
        List<Job__c> jobs = new List<Job__c>();
        for(Integer i = 0; i < 10; i++) {
            jobs.add(new Job__c(
                Name = 'Bulk Test Job ' + i,
                Status__c = 'New',
                Priority__c = 'Medium',
                Scheduled_Date__c = Date.today().addDays(i),
                Client_Name__c = 'Bulk Client ' + i
            ));
        }
        
        // Start test
        Test.startTest();
        insert jobs;
        Test.stopTest();
        
        // Verify 10 Job Assignments were created
        List<Job_Assignnment__c> assignments = [
            SELECT Id 
            FROM Job_Assignnment__c
        ];
        
        // Assert
        System.assertEquals(10, assignments.size(), 
            '10 Job Assignments should have been created for 10 jobs');
    }
}