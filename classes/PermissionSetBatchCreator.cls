public class PermissionSetBatchCreator {
    public static void createPermissionSets(Integer numberOfSets) {
        if (numberOfSets <= 0) {
            System.debug('Number of Permission Sets to create must be greater than 0.');
            return;
        }

        List<PermissionSet> permissionSetsToInsert = new List<PermissionSet>();
        for (Integer i = 1; i <= numberOfSets; i++) {
            String labelName = 'ARMPerfTest' + i;
            String apiName = 'ARMPerfTest' + i;

            PermissionSet permSet = new PermissionSet();
            permSet.Label = labelName;
            permSet.Name = apiName;

            permissionSetsToInsert.add(permSet);
        }

        try {
            insert permissionSetsToInsert;
            System.debug('Permission Sets created successfully: ' + permissionSetsToInsert.size());
        } catch (Exception e) {
            System.debug('Failed to create Permission Sets. Error: ' + e.getMessage());
        }
    }
}