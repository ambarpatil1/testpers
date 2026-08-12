trigger AccountTrigger on Account (before insert, before update) {
    
    for (Account acc : Trigger.new) {
        
        // Simple logic: If Name is blank, set default
        if (String.isBlank(acc.Name)) {
            acc.Name = 'Default Account';
        }
        
        // Example: Add description on update
        if (Trigger.isUpdate) {
            acc.Description = 'Updated via Trigger';
        }
    }
}