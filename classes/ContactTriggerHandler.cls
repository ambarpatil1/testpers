public with sharing class ContactTriggerHandler {
    public static void updateParentAccounts(List<Contact> newContacts) {
        update new Account(
            Id = newContacts[0].AccountId
        );
    }
}