trigger JobTrigger on Job__c (after insert) {
    JobTriggerHandler.handleAfterInsert(Trigger.new);
}