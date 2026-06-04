public class CaseWithImageUploader {

    // Method to upload image and create Cases with embedded image in RTA
    public static void uploadImageAndInsertCase(String namePrefix, Integer startFrom, Integer endAt, Id contentVersionId) {
        
        // Step 1: Get the ContentDocumentId from the provided ContentVersion ID
        // Query ContentVersion using the provided contentVersionId to retrieve the associated ContentDocumentId
        ContentVersion contentVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionId LIMIT 1];
        
        // If no ContentVersion is found, throw an exception
        if (contentVersion == null) {
            // Throw a runtime exception with a custom error message
            throw new AuraHandledException('ContentVersion ID is invalid or does not exist.');
        }
        
        // Extract the ContentDocumentId from the ContentVersion
        Id contentDocId = contentVersion.ContentDocumentId;
        
        // Step 2: Generate the image URL using the ContentVersion ID
        // The URL format for downloading a file stored in Salesforce using ContentVersion ID
        String imageUrl = '/sfc/servlet.shepherd/version/download/' + contentVersionId;

        // Step 3: Create a list to hold the Cases that will be inserted
        List<Case> casesToInsert = new List<Case>();

        // Generate the HTML <img> tag to embed the image in the Rich Text Area field
        String imageTag = '<img src="' + imageUrl + '" style="max-width:300px;" />';

        // Loop to create Cases from startFrom to endAt (inclusive)
        for (Integer i = startFrom; i <= endAt; i++) {
            // Create a new Case record
            Case c = new Case();
            
            // Set the Case subject using the namePrefix and the loop index
            c.Subject = namePrefix + ' ' + i;
            
            // Set the Rich Text Area field (replace 'Your_Custom_Rich_Text_Field__c' with the actual API name of your RTA field)
            // Embed the image tag in the RTA field content
            c.RichTextArea__c = 'Embedded image below:<br/>' + imageTag;
            
            // Add the Case to the list for insertion
            casesToInsert.add(c);
        }

        // Insert the list of Cases into Salesforce
        insert casesToInsert;

        // Step 4: Link the uploaded image (via ContentDocument) to the newly created Cases
        // Create a list of ContentDocumentLink records to establish a relationship between the uploaded file and the Cases
        List<ContentDocumentLink> links = new List<ContentDocumentLink>();
        
        // For each Case created, create a ContentDocumentLink to associate the ContentDocument with the Case
        for (Case c : casesToInsert) {
            links.add(new ContentDocumentLink(
                ContentDocumentId = contentDocId,  // Use the ContentDocumentId retrieved earlier
                LinkedEntityId = c.Id,  // Link the ContentDocument to the newly created Case
                ShareType = 'V',  // Set the share type as 'V' for Viewer (can be changed as per requirement)
                Visibility = 'AllUsers'  // Set the visibility of the attachment (can be 'AllUsers' or 'InternalUsers')
            ));
        }
        
        // Insert the ContentDocumentLink records to establish the link between the files and Cases
        insert links;
    }
}