public with sharing class SPMCheckExampleAccountTriggerHandler {
    public static void updateAddressSPM(List<Account> newAccounts) {
        for (Account acc: newAccounts) {
            acc.BillingCity = 'Prague';
//gdgdgf
//example
//second notification
        }
    }
}