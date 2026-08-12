public with sharing class ArmorAccountManager {

    public static List<Account> getAccounts() {
        return [SELECT Id, Name FROM Account LIMIT 100];
    }

    public static Integer getAccountCount() {
        return [SELECT COUNT() FROM Account];
    }

    public static Account createAccount(String name) {
        Account acc = new Account(Name = name);
        insert acc;
        return acc;
    }

    public static void updateAccount(Account acc) {
        update acc;
    }

    public static void deleteAccount(Id accountId) {
        delete [SELECT Id FROM Account WHERE Id = :accountId];
    }
}