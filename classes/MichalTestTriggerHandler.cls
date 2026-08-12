public with sharing class MichalTestTriggerHandler {
//test
    public static void beforeSave(List<MichalTest__c> newRecords) {
        for (MichalTest__c record : newRecords) {
            if (record.MichalTestCheckbox__c == true) {
                record.MichalPicklistTest__c = 'TestPicklist1';
            }
        }
    }
}