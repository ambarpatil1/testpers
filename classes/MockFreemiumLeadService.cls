/**
 * @description Mock implementation of IFreemiumLeadService for testing.
 *              Provides in-memory lead storage without database operations.
 */
@IsTest
public class MockFreemiumLeadService implements IFreemiumLeadService {
    
    // Configuration
    public Boolean shouldThrowExceptionOnInsert = false;
    public Boolean shouldThrowExceptionOnUpdate = false;
    public Exception exceptionToThrow;
    public Lead leadToReturn;
    
    // In-memory storage
    public Map<String, Lead> leadsByExternalRequestId = new Map<String, Lead>();
    
    // Call tracking
    public Integer findLeadByExternalRequestIdCallCount = 0;
    public Integer findLeadForStatusUpdateCallCount = 0;
    public Integer insertLeadCallCount = 0;
    public Integer updateLeadCallCount = 0;
    public String lastExternalRequestIdQueried;
    public Lead lastLeadInserted;
    public Lead lastLeadUpdated;
    
    /**
     * @description Mock implementation of findLeadByExternalRequestId.
     */
    public Lead findLeadByExternalRequestId(String leadExternalRequestId) {
        findLeadByExternalRequestIdCallCount++;
        lastExternalRequestIdQueried = leadExternalRequestId;
        
        if (leadToReturn != null) {
            return leadToReturn;
        }
        
        return leadsByExternalRequestId.get(leadExternalRequestId);
    }
    
    /**
     * @description Mock implementation of findLeadForStatusUpdate.
     */
    public Lead findLeadForStatusUpdate(String leadExternalRequestId) {
        findLeadForStatusUpdateCallCount++;
        lastExternalRequestIdQueried = leadExternalRequestId;
        
        if (leadToReturn != null) {
            return leadToReturn;
        }
        
        return leadsByExternalRequestId.get(leadExternalRequestId);
    }
    
    /**
     * @description Mock implementation of insertLead.
     */
    public void insertLead(Lead leadRecord) {
        insertLeadCallCount++;
        lastLeadInserted = leadRecord;
        
        if (shouldThrowExceptionOnInsert) {
            if (exceptionToThrow != null) {
                throw exceptionToThrow;
            }
            throw new FreemiumEmailToLeadException('Mock insert exception');
        }
        
        // Simulate successful insert
        leadRecord.Id = generateFakeId();
        String extId = (String)leadRecord.get('External_Request_Id__c');
        if (String.isNotBlank(extId)) {
            leadsByExternalRequestId.put(extId, leadRecord);
        }
    }
    
    /**
     * @description Mock implementation of updateLead.
     */
    public void updateLead(Lead leadRecord) {
        updateLeadCallCount++;
        lastLeadUpdated = leadRecord;
        
        if (shouldThrowExceptionOnUpdate) {
            if (exceptionToThrow != null) {
                throw exceptionToThrow;
            }
            throw new FreemiumEmailToLeadException('Mock update exception');
        }
        
        // Update in-memory storage
        String extId = (String)leadRecord.get('External_Request_Id__c');
        if (String.isNotBlank(extId)) {
            leadsByExternalRequestId.put(extId, leadRecord);
        }
    }
    
    /**
     * @description Generates a fake Lead ID for testing.
     */
    private Id generateFakeId() {
        // Generate a valid 18-character Salesforce ID for Lead object
        // Lead object has prefix '00Q'
        String prefix = '00Q';
        String randomChars = '0000000000000';
        
        // Generate a simple sequential ID for testing
        Integer randomNum = Math.abs(Crypto.getRandomInteger());
        String numStr = String.valueOf(randomNum);
        if (numStr.length() > 12) {
            numStr = numStr.substring(0, 12);
        }
        randomChars = numStr.leftPad(12, '0');
        
        String id15 = prefix + randomChars;
        
        // Calculate checksum characters for 18-char ID
        String checksumChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ012345';
        String checksum = '';
        
        for (Integer i = 0; i < 3; i++) {
            Integer flags = 0;
            for (Integer j = 0; j < 5; j++) {
                String c = id15.substring(i * 5 + j, i * 5 + j + 1);
                if (c.toUpperCase() == c && c >= 'A' && c <= 'Z') {
                    flags += 1 << j;
                }
            }
            checksum += checksumChars.substring(flags, flags + 1);
        }
        
        return Id.valueOf(id15 + checksum);
    }
}