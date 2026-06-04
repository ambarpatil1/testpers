@isTest
public class FeedItemGeneratorTest {
    
    @isTest
    static void testFeedItemGeneration() {
        // Set up test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Generate feed items
        Test.startTest();
        FeedItemGenerator.generateFeedItems(testAccount.Id);
        Test.stopTest();

        // Verify feed items created
        List<FeedItem> feedItems = [SELECT Id, Body, ParentId, Type FROM FeedItem WHERE ParentId = :testAccount.Id];
        System.assertEquals(23, feedItems.size(), 'Expected 23 feed items to be generated.');

        // Add further assertions as needed to validate individual feed items
        for (FeedItem item : feedItems) {
            System.assertNotEquals(null, item.Body, 'Feed item body should not be null.');
            System.assertNotEquals(null, item.Type, 'Feed item type should not be null.');
        }
    }
}