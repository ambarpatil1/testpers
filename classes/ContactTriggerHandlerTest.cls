@IsTest
public class ContactTriggerHandlerTest {
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