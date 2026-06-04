public with sharing class AccountTriggerHandler {
    public static void updateAddress(List<Account> newAccounts) {
        // E2E-015 test modification - 2026-05-25 - Arjun
        for (Account acc: newAccounts) {
            acc.BillingCity = 'Prague';
        }
    }
}