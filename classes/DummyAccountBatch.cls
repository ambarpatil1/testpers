global class DummyAccountBatch implements Database.Batchable<SObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name
            FROM Account
            ORDER BY Name
        ]);
    }

    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        for (Account acc : (List<Account>) scope) {
            System.debug('DummyAccountBatch Account: Id=' + acc.Id + ', Name=' + acc.Name);
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('DummyAccountBatch finished.');
    }
}