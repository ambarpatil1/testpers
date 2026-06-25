public with sharing class AccountService {

    /**
     * Returns active accounts.
     * Can be called from LWC/Aura.
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> getActiveAccounts() {
        try {
            return [
                SELECT Id,
                       Name,
                       Industry,
                       Phone,
                       Website,
                       AnnualRevenue
                FROM Account
                WHERE IsDeleted = false
                ORDER BY Name
                WITH USER_MODE
                LIMIT 200
            ];
        } catch (Exception ex) {
            throw new AuraHandledException(
                'Unable to retrieve accounts. ' + ex.getMessage()
            );
        }
    }

    /**
     * Creates a new Account.
     */
    @AuraEnabled
    public static Id createAccount(Account accountRecord) {

        if (accountRecord == null) {
            throw new AuraHandledException('Account data cannot be empty.');
        }

        try {
            insert accountRecord;
            return accountRecord.Id;

        } catch (DmlException ex) {
            throw new AuraHandledException(
                'Failed to create Account. ' + ex.getDmlMessage(0)
            );
        }
    }

    /**
     * Bulk update Accounts.
     */
    @AuraEnabled
    public static void updateAccounts(List<Account> accounts) {

        if (accounts == null || accounts.isEmpty()) {
            return;
        }

        try {
            update accounts;

        } catch (DmlException ex) {
            throw new AuraHandledException(
                'Account update failed. ' + ex.getDmlMessage(0)
            );
        }
    }

    /**
     * Bulk delete Accounts.
     */
    @AuraEnabled
    public static void deleteAccounts(List<Id> accountIds) {

        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }

        List<Account> accounts = [
            SELECT Id
            FROM Account
            WHERE Id IN :accountIds
            WITH USER_MODE
        ];

        delete accounts;
    }
}
