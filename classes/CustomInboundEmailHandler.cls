public with sharing class CustomInboundEmailHandler implements Messaging.InboundEmailHandler {
    
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        
        // Instantiate the result object to return to the Email Service
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        try {
            // 1. Extract details from the incoming email
            String senderName = email.fromName;
            String senderAddress = email.fromAddress;
            String emailSubject = email.subject;
            String emailBody = email.plainTextBody; // You can also use email.htmlBody
            
            // 2. Custom Business Logic: Find or create a Contact based on the sender's email
            List<Contact> existingContacts = [SELECT Id, Name FROM Contact WHERE Email = :senderAddress LIMIT 1];
            Contact currentContact;
            
            if (existingContacts.isEmpty()) {
                // Create a new contact if one isn't found
                currentContact = new Contact(
                    LastName = String.isNotBlank(senderName) ? senderName : 'Unknown Sender',
                    Email = senderAddress
                );
                insert currentContact;
            } else {
                currentContact = existingContacts[0];
            }
            
            // 3. Log the incoming email as a Task tied to the Contact
            Task emailTask = new Task(
                Subject = (emailSubject != null) ? 'Email Received: ' + emailSubject : 'Email Received: No Subject',
                Description = emailBody,
                WhoId = currentContact.Id,
                Status = 'Completed',
                ActivityDate = Date.today(),
                Priority = 'Normal'
            );
            insert emailTask;
            
            // 4. Mark the inbound email transaction as completely successful
            result.success = true;
            
        } catch (Exception e) {
            // If an exception occurs, catch it and tell Salesforce the process failed
            System.debug('Error processing inbound email: ' + e.getMessage());
            result.success = false;
            result.message = 'Failed to process the inbound email. Error: ' + e.getMessage();
        }
        
        return result;
    }
}