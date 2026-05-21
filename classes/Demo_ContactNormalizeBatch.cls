public with sharing class Demo_ContactNormalizeBatch implements Database.Batchable<SObject>, Database.Stateful {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, FirstName, LastName FROM Contact WHERE FirstName != null OR LastName != null');
    }
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Contact> updates = new List<Contact>();
        for (Contact c : (List<Contact>)scope) {
            Boolean changed = false;
            if (c.FirstName != null) { c.FirstName = c.FirstName.trim(); changed = true; }
            if (c.LastName  != null) { c.LastName  = c.LastName.trim();  changed = true; }
            if (changed) updates.add(c);
        }
        if (!updates.isEmpty()) update updates;
    }
    public void finish(Database.BatchableContext bc) {
        System.debug('Demo_ContactNormalizeBatch finished');
    }
}