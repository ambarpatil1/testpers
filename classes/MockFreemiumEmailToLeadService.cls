/**
 * @description Mock implementation of IFreemiumEmailToLeadService for testing.
 *              Allows configurable behavior and tracks method invocations.
 */
@IsTest
public class MockFreemiumEmailToLeadService implements IFreemiumEmailToLeadService {
    
    // Configuration flags
    public Boolean shouldThrowException = false;
    public Exception exceptionToThrow;
    public String correlationIdToReturn = 'MOCK-CORRELATION-ID-123';
    public String bodyToReturn = 'mock body content';
    
    // Call tracking
    public Integer processEmailCallCount = 0;
    public Integer safeGetBodyCallCount = 0;
    public Integer generateCorrelationIdCallCount = 0;
    public Messaging.InboundEmail lastEmailProcessed;
    public Messaging.InboundEnvelope lastEnvelopeProcessed;
    public String lastCorrelationId;
    
    /**
     * @description Mock implementation of processEmail.
     */
    public void processEmail(
        Messaging.InboundEmail email,
        Messaging.InboundEnvelope envelope,
        String correlationId
    ) {
        processEmailCallCount++;
        lastEmailProcessed = email;
        lastEnvelopeProcessed = envelope;
        lastCorrelationId = correlationId;
        
        if (shouldThrowException) {
            if (exceptionToThrow != null) {
                throw exceptionToThrow;
            }
            throw new FreemiumEmailToLeadException('Mock exception');
        }
    }
    
    /**
     * @description Mock implementation of safeGetBody.
     */
    public String safeGetBody(Messaging.InboundEmail email) {
        safeGetBodyCallCount++;
        return bodyToReturn;
    }
    
    /**
     * @description Mock implementation of generateCorrelationId.
     */
    public String generateCorrelationId() {
        generateCorrelationIdCallCount++;
        return correlationIdToReturn;
    }
}