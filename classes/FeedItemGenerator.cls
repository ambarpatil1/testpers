public class FeedItemGenerator {

    public static void generateFeedItems(Id recordId) {
        createActivityEvent(recordId);
        postAdvancedTextUpdate(recordId);
        createAnnouncement(recordId);
        generateApprovalPost(recordId);
        createBasicTemplateFeedItem(recordId);
        createCanvasPost(recordId);
        
        // Create a Collaboration Group and associated feed items
        CollaborationGroup newGroup = new CollaborationGroup(Name = 'Test Collaboration Group');
        insert newGroup;
        createCollaborationGroupFeedItems(newGroup.Id);
        
        createRecordEvent(recordId);
        createDashboardComponentAlert(recordId);
        createDashboardComponentSnapshot(recordId);
        postProfileSkill(recordId);
        createQuestionPost(recordId);
        createReplyPost(recordId);
        createRypplePost(recordId);
        createTrackedChange(recordId);
        postUserStatus(recordId);
        attachArticleEvent(recordId);
        createCallLogPost(recordId);
        createCaseCommentPost(recordId);
        createChangeStatusPost(recordId);
        createChatTranscriptPost(recordId);
        createEmailMessageEvent(recordId);
        createFacebookPost(recordId);
        createMilestoneEvent(recordId);
        createSocialPost(recordId);
    }

    static void createActivityEvent(Id recordId) {
        // Create ActivityEvent feed item
        FeedItem event = new FeedItem(
            ParentId = recordId,
            Body = 'Activity Event: Test Activity Event',
            Type = 'TextPost'  // Generic feed item type
        );
        insert event;
    }

    static void postAdvancedTextUpdate(Id recordId) {
        // Create AdvancedTextPost feed item
        FeedItem post = new FeedItem(
            ParentId = recordId,
            Body = 'This is an advanced text update.',
            Type = 'TextPost'  // Generic feed item type
        );
        insert post;
    }

    static void createAnnouncement(Id recordId) {
        // Create a FeedItem instead
        FeedItem announcement = new FeedItem(
            ParentId = recordId,
            Body = 'Important announcement for the team.',
            Type = 'TextPost'  // Change this to the appropriate type if needed
        );
        insert announcement;
    }

    static void generateApprovalPost(Id recordId) {
        // Create ApprovalPost feed item
        FeedItem approval = new FeedItem(
            ParentId = recordId,
            Body = 'Approval request submitted.',
            Type = 'TextPost'  // Generic feed item type
        );
        insert approval;
    }

    static void createBasicTemplateFeedItem(Id recordId) {
        // Create BasicTemplateFeedItem feed item
        FeedItem templateItem = new FeedItem(
            ParentId = recordId,
            Body = 'Using a basic template for this feed item.',
            Type = 'TextPost'  // Generic feed item type
        );
        insert templateItem;
    }

    static void createCanvasPost(Id recordId) {
        // Create CanvasPost feed item
        FeedItem canvasPost = new FeedItem(
            ParentId = recordId,
            Body = 'Canvas Post created.',
            Type = 'TextPost'  // Generic feed item type
        );
        insert canvasPost;
    }

    static void createCollaborationGroupFeedItems(Id groupId) {
        // Create CollaborationGroupCreated and CollaborationGroupUnarchived feed items
        FeedItem groupCreated = new FeedItem(
            ParentId = groupId,
            Body = 'New collaboration group created.',
            Type = 'TextPost'
        );
        insert groupCreated;

        FeedItem groupUnarchived = new FeedItem(
            ParentId = groupId,
            Body = 'Collaboration group has been unarchived.',
            Type = 'TextPost'
        );
        insert groupUnarchived;
    }

    static void createRecordEvent(Id recordId) {
        // Create CreatedRecordEvent feed item
        FeedItem recordEvent = new FeedItem(
            ParentId = recordId,
            Body = 'A new record has been created.',
            Type = 'TextPost'
        );
        insert recordEvent;
    }

    static void createDashboardComponentAlert(Id recordId) {
        // Create DashboardComponentAlert feed item
        FeedItem alert = new FeedItem(
            ParentId = recordId,
            Body = 'Alert triggered for the dashboard component.',
            Type = 'TextPost'
        );
        insert alert;
    }

    static void createDashboardComponentSnapshot(Id recordId) {
        // Create DashboardComponentSnapshot feed item
        FeedItem snapshot = new FeedItem(
            ParentId = recordId,
            Body = 'Snapshot of the dashboard component created.',
            Type = 'TextPost'
        );
        insert snapshot;
    }

    static void postProfileSkill(Id recordId) {
        // Create ProfileSkillPost feed item
        FeedItem skillPost = new FeedItem(
            ParentId = recordId,
            Body = 'New skill added to the profile.',
            Type = 'TextPost'
        );
        insert skillPost;
    }

    static void createQuestionPost(Id recordId) {
        // Create QuestionPost feed item
        FeedItem questionPost = new FeedItem(
            ParentId = recordId,
            Body = 'What is the best way to achieve this?',
            Type = 'TextPost'
        );
        insert questionPost;
    }

    static void createReplyPost(Id recordId) {
        // Create ReplyPost feed item
        FeedItem replyPost = new FeedItem(
            ParentId = recordId,
            Body = 'Here is a response to your query.',
            Type = 'TextPost'
        );
        insert replyPost;
    }

    static void createRypplePost(Id recordId) {
        // Create RypplePost feed item
        FeedItem rypplePost = new FeedItem(
            ParentId = recordId,
            Body = 'Feedback post generated.',
            Type = 'TextPost'
        );
        insert rypplePost;
    }

    static void createTrackedChange(Id recordId) {
        // Create TrackedChange feed item
        FeedItem trackedChange = new FeedItem(
            ParentId = recordId,
            Body = 'Tracked change made to the record.',
            Type = 'TextPost'
        );
        insert trackedChange;
    }

    static void postUserStatus(Id recordId) {
        // Create UserStatus feed item
        FeedItem userStatus = new FeedItem(
            ParentId = recordId,
            Body = 'User status updated.',
            Type = 'TextPost'
        );
        insert userStatus;
    }

    static void attachArticleEvent(Id recordId) {
        // Create AttachArticleEvent feed item
        FeedItem attachEvent = new FeedItem(
            ParentId = recordId,
            Body = 'Article attached to the record.',
            Type = 'TextPost'
        );
        insert attachEvent;
    }

    static void createCallLogPost(Id recordId) {
        // Create CallLogPost feed item
        FeedItem callLog = new FeedItem(
            ParentId = recordId,
            Body = 'Call log recorded.',
            Type = 'TextPost'
        );
        insert callLog;
    }

    static void createCaseCommentPost(Id recordId) {
        // Create CaseCommentPost feed item
        FeedItem caseComment = new FeedItem(
            ParentId = recordId,
            Body = 'Comment added to the case.',
            Type = 'TextPost'
        );
        insert caseComment;
    }

    static void createChangeStatusPost(Id recordId) {
        // Create ChangeStatusPost feed item
        FeedItem changeStatus = new FeedItem(
            ParentId = recordId,
            Body = 'Status of the record changed.',
            Type = 'TextPost'
        );
        insert changeStatus;
    }

    static void createChatTranscriptPost(Id recordId) {
        // Create ChatTranscriptPost feed item
        FeedItem chatTranscript = new FeedItem(
            ParentId = recordId,
            Body = 'Chat transcript saved.',
            Type = 'TextPost'
        );
        insert chatTranscript;
    }

    static void createEmailMessageEvent(Id recordId) {
        // Create EmailMessageEvent feed item
        FeedItem emailEvent = new FeedItem(
            ParentId = recordId,
            Body = 'Email message sent or received.',
            Type = 'TextPost'
        );
        insert emailEvent;
    }

    static void createFacebookPost(Id recordId) {
        // Create FacebookPost feed item
        FeedItem facebookPost = new FeedItem(
            ParentId = recordId,
            Body = 'Facebook post created.',
            Type = 'TextPost'
        );
        insert facebookPost;
    }

    static void createMilestoneEvent(Id recordId) {
        // Create MilestoneEvent feed item
        FeedItem milestone = new FeedItem(
            ParentId = recordId,
            Body = 'Milestone achieved.',
            Type = 'TextPost'
        );
        insert milestone;
    }

    static void createSocialPost(Id recordId) {
        // Create SocialPost feed item
        FeedItem socialPost = new FeedItem(
            ParentId = recordId,
            Body = 'General social media post.',
            Type = 'TextPost'
        );
        insert socialPost;
    }
}