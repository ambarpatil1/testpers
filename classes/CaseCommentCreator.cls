public class CaseCommentCreator {
    public static void createCasesAndComments() {
        List<Case> casesToInsert = new List<Case>();
        List<CaseComment> commentsToInsert = new List<CaseComment>();

        // Create 10 cases
        for (Integer i = 100; i < 201; i++) {
            Case newCase = new Case();
            newCase.Subject = 'Test Case ' + (i + 1);
            newCase.Status = 'New'; // Set the status as needed
            newCase.Priority = 'Medium'; // Set the priority as needed
            casesToInsert.add(newCase);
        }

        // Insert cases
        insert casesToInsert;

        // Create 5 comments for each case
        for (Case c : casesToInsert) {
            for (Integer j = 100; j < 108; j++) {
                CaseComment newComment = new CaseComment();
                newComment.ParentId = c.Id; // Link the comment to the case
                newComment.CommentBody = 'This is comment ' + (j + 1) + ' for case ' + c.Subject;
                commentsToInsert.add(newComment);
            }
        }

        // Insert case comments
        insert commentsToInsert;
    }
}