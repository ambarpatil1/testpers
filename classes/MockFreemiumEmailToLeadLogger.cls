/**
 * @description Mock implementation of IFreemiumEmailToLeadLogger for testing.
 *              Tracks logging calls without performing actual database operations.
 */
@IsTest
public class MockFreemiumEmailToLeadLogger implements IFreemiumEmailToLeadLogger {
    
    // Call tracking
    public Integer logFailureCallCount = 0;
    public Messaging.InboundEmail lastEmail;
    public Messaging.InboundEnvelope lastEnvelope;
    public String lastCorrelationId;
    public String lastLeadExternalRequestId;
    public String lastEventType;
    public Exception lastException;
    public String lastRawBody;
    
    /**
     * @description Mock implementation of logFailure that only tracks the call.
     */
    public void logFailure(
        Messaging.InboundEmail email,
        Messaging.InboundEnvelope envelope,
        String correlationId,
        String leadExternalRequestId,
        String eventType,
        Exception ex,
        String rawBody
    ) {
        logFailureCallCount++;
        lastEmail = email;
        lastEnvelope = envelope;
        lastCorrelationId = correlationId;
        lastLeadExternalRequestId = leadExternalRequestId;
        lastEventType = eventType;
        lastException = ex;
        lastRawBody = rawBody;
    }
}