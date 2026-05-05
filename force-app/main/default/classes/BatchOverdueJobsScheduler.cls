public class BatchOverdueJobsScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        BatchOverdueJobs batch = new BatchOverdueJobs();
        Database.executeBatch(batch, 200);

        /*Run this in execute anonymouus Window --
     String cronExp = '0 0 8 * * ?';
     System.schedule(
     'Daily Overdue Jobs Batch',
     cronExp,
     new BatchOverdueJobsScheduler()
     );

*/
    }
}