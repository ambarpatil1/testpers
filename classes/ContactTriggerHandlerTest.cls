@IsTest
public class ContactTriggerHandlerTest {
    // E2E-015 test modification - 2026-05-25 - Arjun
    @IsTest
    static void test() {
        Account acc = new Account(
            Name = 'Test Acc'
        );
        insert acc;

        insert new Contact(
            LastName = 'Test',
            AccountId = acc.Id
        );
    }
}