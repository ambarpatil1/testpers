@isTest
public class AccountTriggerTest {

    @isTest
    static void testInsertAccount1() {
        Account acc = new Account();
        insert acc;
        //adding a comment//
        Account result = [SELECT Name FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Default Account', result.Name);
    }
    @isTest
    static void testUpdateAccount() {
        
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        //new line added//
        acc.Name = 'Updated Name';
        update acc;
        Account result = [SELECT Description FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Updated via Trigger', result.Description);
    }
}