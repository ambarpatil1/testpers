// ✅ Priority 4: Class name in uppercase (bad naming)
public class BAD_CLASS_NAME {

    // ✅ Priority 4: Method name is all uppercase (bad naming)
    public static void DO_SOMETHING_WRONG() {

        // ✅ Priority 1: SOQL inside loop
        for (Account acc : [SELECT Id FROM Account LIMIT 5]) {
            Contact[] cons = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
        }

        // ✅ Priority 3: Empty if block
        if (true) {
        }

        // ✅ Priority 3: Hardcoded ID
        Account acc2 = [SELECT Id FROM Account WHERE Id = '001D000000IqhSL'];

        // ✅ Priority 4: Short variable name
        String x = 'Too short';

        // ✅ Priority 4: Unused variable
        Integer unusedVar = 100;

        // ✅ Priority 4: Missing class-level documentation
        // (if documentation rules are enabled)
    }
}