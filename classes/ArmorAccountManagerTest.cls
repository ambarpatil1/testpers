@IsTest
private class ArmorAccountManagerTest {

    @IsTest
    static void testGetAccounts() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Test.startTest();
        List<Account> accounts = ArmorAccountManager.getAccounts();
        Test.stopTest();

        System.assert(accounts.size() > 0);
    }

    @IsTest
    static void testGetAccountCount() {
        insert new Account(Name = 'Account One');
        insert new Account(Name = 'Account Two');

        Test.startTest();
        Integer count = ArmorAccountManager.getAccountCount();
        Test.stopTest();

        System.assert(count >= 2);
    }

    @IsTest
    static void testCreateAccount() {
        Test.startTest();
        Account acc = ArmorAccountManager.createAccount('Created Account');
        Test.stopTest();

        System.assertNotEquals(null, acc.Id);
        System.assertEquals('Created Account', acc.Name);
    }

    @IsTest
    static void testUpdateAccount() {
        Account acc = new Account(Name = 'Old Name');
        insert acc;

        acc.Name = 'Updated Name';

        Test.startTest();
        ArmorAccountManager.updateAccount(acc);
        Test.stopTest();

        Account updated = [SELECT Name FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Updated Name', updated.Name);
    }

    @IsTest
    static void testDeleteAccount() {
        Account acc = new Account(Name = 'Delete Me');
        insert acc;

        Test.startTest();
        ArmorAccountManager.deleteAccount(acc.Id);
        Test.stopTest();

        Integer count = [SELECT COUNT() FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, count);
    }
}