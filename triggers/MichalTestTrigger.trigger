trigger MichalTestTrigger on MichalTest__c (before insert, before update) {
    MichalTestTriggerHandler.beforeSave(Trigger.new);
}