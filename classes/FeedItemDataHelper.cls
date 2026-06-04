public class FeedItemDataHelper {
    // Public method to allow direct execution in anonymous Apex
    public static void generateFeedItems() {
        // Create a sample case for case-related feed items
        Case caseRecord = new Case(
            Subject = 'Test Case',
            Status = 'New'
        );
        insert caseRecord;

        // Sample user for feed items
        User sampleUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];

        // ActivityEvent
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'ActivityEvent',
            Body = 'This is a test ActivityEvent'
        );

        // AdvancedTextPost
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'AdvancedTextPost',
            Body = 'This is an Advanced Text Post'
        );

        // ApprovalPost
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'ApprovalPost',
            Body = 'This is an Approval Post'
        );

        // CanvasPost
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'CanvasPost',
            Body = 'This is a Canvas Post'
        );

        // CollaborationGroupUnarchived
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'CollaborationGroupUnarchived',
            Body = 'Collaboration Group Unarchived'
        );

        // DashboardComponentAlert
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'DashboardComponentAlert',
            Body = 'Dashboard Component Alert'
        );

        // DashboardComponentSnapshot
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'DashboardComponentSnapshot',
            Body = 'Dashboard Component Snapshot'
        );

        // ProfileSkillPost
        insert new FeedItem(
            ParentId = sampleUser.Id,
            Type = 'ProfileSkillPost',
            Body = 'Profile Skill Post'
        );

        // ReplyPost
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'ReplyPost',
            Body = 'Reply Post Example'
        );

        // RypplePost
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'RypplePost',
            Body = 'Rypple Post'
        );

        // Since UserStatus cannot be directly inserted, we skip it
        // UserStatus: This is typically created by users in the UI

        // AttachArticleEvent
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'AttachArticleEvent',
            Body = 'Article Attached Event'
        );

        // CaseCommentPost
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'CaseCommentPost',
            Body = 'Case Comment Post'
        );

        // ChangeStatusPost
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'ChangeStatusPost',
            Body = 'Change Status Post'
        );

        // ChatTranscriptPost
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'ChatTranscriptPost',
            Body = 'Chat Transcript Post'
        );

        // FacebookPost
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'FacebookPost',
            Body = 'Facebook Post Example'
        );

        // MilestoneEvent
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'MilestoneEvent',
            Body = 'Milestone Event'
        );

        // SocialPost
        insert new FeedItem(
            ParentId = caseRecord.Id,
            Type = 'SocialPost',
            Body = 'This is a Social Post'
        );
    }
}