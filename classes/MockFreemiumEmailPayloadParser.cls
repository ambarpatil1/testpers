/**
 * @description Mock implementation of IFreemiumEmailPayloadParser for testing.
 *              Allows configurable behavior for parsing operations.
 */
@IsTest
public class MockFreemiumEmailPayloadParser implements IFreemiumEmailPayloadParser {
    
    // Configuration
    public Boolean shouldThrowException = false;
    public Exception exceptionToThrow;
    public FreemiumEmailPayloadParser.PayloadData payloadDataToReturn;
    public String bodyToReturn = 'mock body';
    public String extractedStringToReturn = 'mock-value';
    
    // Call tracking
    public Integer parseEmailCallCount = 0;
    public Integer safeGetBodyCallCount = 0;
    public Integer tryExtractStringCallCount = 0;
    public Messaging.InboundEmail lastEmailParsed;
    public String lastRawBodyForExtract;
    public String lastKeyForExtract;
    
    /**
     * @description Mock implementation of parseEmail.
     */
    public FreemiumEmailPayloadParser.PayloadData parseEmail(Messaging.InboundEmail email) {
        parseEmailCallCount++;
        lastEmailParsed = email;
        
        if (shouldThrowException) {
            if (exceptionToThrow != null) {
                throw exceptionToThrow;
            }
            throw new FreemiumEmailToLeadException('Mock parse exception');
        }
        
        if (payloadDataToReturn != null) {
            return payloadDataToReturn;
        }
        
        // Default mock data
        Map<String, Object> mockPayload = new Map<String, Object>{
            'eventType' => 'LEAD_CREATE',
            'leadExternalRequestId' => 'MOCK-EXT-ID-123'
        };
        return new FreemiumEmailPayloadParser.PayloadData(mockPayload, 'LEAD_CREATE', 'MOCK-EXT-ID-123');
    }
    
    /**
     * @description Mock implementation of safeGetBody.
     */
    public String safeGetBody(Messaging.InboundEmail email) {
        safeGetBodyCallCount++;
        return bodyToReturn;
    }
    
    /**
     * @description Mock implementation of tryExtractString.
     */
    public String tryExtractString(String rawBody, String key) {
        tryExtractStringCallCount++;
        lastRawBodyForExtract = rawBody;
        lastKeyForExtract = key;
        return extractedStringToReturn;
    }
}