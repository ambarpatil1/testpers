@IsTest
private class MichalTestTriggerHandlerTest {

    @IsTest
    static void testPicklistUpdatedWhenCheckboxTrueOnInsert() {
        MichalTest__c testRecord = new MichalTest__c(
            MichalTestCheckbox__c = true
        );

        Test.startTest();
        insert testRecord;
        Test.stopTest();

        MichalTest__c insertedRecord = [
            SELECT MichalTestCheckbox__c, MichalPicklistTest__c
            FROM MichalTest__c
            WHERE Id = :testRecord.Id
        ];

        System.assertEquals(true, insertedRecord.MichalTestCheckbox__c);
        System.assertEquals(
            'TestPicklist1',
            insertedRecord.MichalPicklistTest__c,
            'Picklist should be updated when checkbox is true.'
        );
    }

    @IsTest
    static void testPicklistUpdatedWhenCheckboxChangedToTrueOnUpdate() {
        MichalTest__c testRecord = new MichalTest__c(
            MichalTestCheckbox__c = false
        );
        insert testRecord;

        testRecord.MichalTestCheckbox__c = true;

        Test.startTest();
        update testRecord;
        Test.stopTest();

        MichalTest__c updatedRecord = [
            SELECT MichalTestCheckbox__c, MichalPicklistTest__c
            FROM MichalTest__c
            WHERE Id = :testRecord.Id
        ];

        System.assertEquals(true, updatedRecord.MichalTestCheckbox__c);
        System.assertEquals(
            'TestPicklist1',
            updatedRecord.MichalPicklistTest__c,
            'Picklist should be updated when checkbox is set to true.'
        );
    }

    @IsTest
    static void testPicklistNotUpdatedWhenCheckboxFalse() {
        MichalTest__c testRecord = new MichalTest__c(
            MichalTestCheckbox__c = false
        );

        Test.startTest();
        insert testRecord;
        Test.stopTest();

        MichalTest__c insertedRecord = [
            SELECT MichalTestCheckbox__c, MichalPicklistTest__c
            FROM MichalTest__c
            WHERE Id = :testRecord.Id
        ];

        System.assertEquals(false, insertedRecord.MichalTestCheckbox__c);
        System.assertEquals(
            null,
            insertedRecord.MichalPicklistTest__c,
            'Picklist should not be updated when checkbox is false.'
        );
    }
}