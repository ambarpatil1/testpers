@IsTest
private class Demo_ContactNormalizeBatch_Test {
    @IsTest
    static void testBatch() {
        insert new Contact(FirstName='  Jane  ', LastName='  Doe  ');
        Test.startTest();
        Id jobId = Database.executeBatch(new Demo_ContactNormalizeBatch(), 50);
        Test.stopTest();
        Contact c = [SELECT FirstName, LastName FROM Contact LIMIT 1];
        System.assertEquals('Jane', c.FirstName);
        System.assertEquals('Doe',  c.LastName);
    }
}