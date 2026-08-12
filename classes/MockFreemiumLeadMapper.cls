/**
 * @description Mock implementation of IFreemiumLeadMapper for testing.
 *              Tracks method invocations without performing actual mappings.
 */
@IsTest
public class MockFreemiumLeadMapper implements IFreemiumLeadMapper {
    
    // Configuration
    public Boolean shouldThrowException = false;
    public Exception exceptionToThrow;
    
    // Call tracking
    public Integer applyMappingsToLeadCallCount = 0;
    public Integer appendStatusUpdateReasonCallCount = 0;
    public SObject lastTargetRecord;
    public Map<String, Object> lastPayload;
    public String lastEventType;
    public System.AccessType lastAccessType;
    public Lead lastLeadRecord;
    
    /**
     * @description Mock implementation of applyMappingsToLead.
     */
    public void applyMappingsToLead(
        SObject targetRecord,
        Map<String, Object> payload,
        String eventType,
        System.AccessType accessType
    ) {
        applyMappingsToLeadCallCount++;
        lastTargetRecord = targetRecord;
        lastPayload = payload;
        lastEventType = eventType;
        lastAccessType = accessType;
        
        if (shouldThrowException) {
            if (exceptionToThrow != null) {
                throw exceptionToThrow;
            }
            throw new FreemiumEmailToLeadException('Mock mapping exception');
        }
    }
    
    /**
     * @description Mock implementation of appendStatusUpdateReason.
     */
    public void appendStatusUpdateReason(Lead leadRecord, Map<String, Object> payload) {
        appendStatusUpdateReasonCallCount++;
        lastLeadRecord = leadRecord;
        lastPayload = payload;
    }
}