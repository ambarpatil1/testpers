@IsTest
private class AccountContactHelperTest {
    @IsTest
    static void testAccountAndContactHelpers() {
        Integer utilityResult = SharedTestUtility.safeAdd(11, 9);

        Account acc = AccountHelper.buildAccount('Built Account');

        Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.Email = 'test@example.com';

        System.assertEquals(20, utilityResult);
        System.assertEquals(true, AccountHelper.hasName(acc));
        System.assertEquals(true, ContactHelper.hasEmail(con));
    }
}