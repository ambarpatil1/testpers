public with sharing class Demo_OpportunityHandler {

    public static void beforeInsert(List<Opportunity> newOpps) {
        for (Opportunity opp : newOpps) {
            if (opp.CloseDate == null) {
                opp.CloseDate = System.today().addDays(30);
            }
            if (String.isBlank(opp.StageName)) {
                opp.StageName = 'Prospecting';
            }
        }
    }

    public static void beforeUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        for (Opportunity newOpp : newOpps) {
            Opportunity oldOpp = oldOppMap.get(newOpp.Id);

            // Example: prevent amount from decreasing
            if (oldOpp.Amount != null && newOpp.Amount != null &&
                newOpp.Amount < oldOpp.Amount) {
                newOpp.Amount = oldOpp.Amount;
            }
        }
    }

    public static void afterInsert(List<Opportunity> newOpps) {
        // Simple example: log to debug
        for (Opportunity opp : newOpps) {
            System.debug('New Opportunity created: ' + opp.Name + ' | Amount: ' + opp.Amount);
        }
    }
}