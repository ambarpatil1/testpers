public class DynamicRecordCreator {

    // Method to create Accounts and Contacts based on user input
    public static void createAccountsAndContacts(Integer accountCount, Integer contactsPerAccount) {
        
        // List to hold accounts for batch insert
        List<Account> accounts = new List<Account>();
        // Create the specified number of Accounts
        for (Integer i = 1; i <= accountCount; i++) {
            Account account = new Account(
                Name = 'Alpha Industries ' + i,
               // Account_Type__c = 'Customer - Direct', // Adjust custom fields if necessary
                Industry = 'Manufacturing'
                //Account_Tier__c = 'Premium' // Adjust custom fields if necessary 
                );
            accounts.add(account);
        }
        
        // Insert Accounts
        insert accounts;
        System.debug(accountCount + ' Account records created.');

        // List to hold contacts for batch insert
        List<Contact> contacts = new List<Contact>();

        // For each account created, create the specified number of Contacts
        for (Account acc : accounts) {
            for (Integer j = 1; j <= contactsPerAccount; j++) {
                Contact contact = new Contact(
                    FirstName = 'Contact ' + j,
                    LastName = 'LastName ' + j,
                    Title = 'Position ' + j,
                    Email = 'contact' + j + '@alphaindustries.com',
                    AccountId = acc.Id
                );
                contacts.add(contact);
            }
        }
        
        // Insert Contacts
        insert contacts;
        System.debug((accountCount * contactsPerAccount) + ' Contact records created.');
    }
}