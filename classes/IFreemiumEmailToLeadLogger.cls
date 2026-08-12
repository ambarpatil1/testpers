/**
 * @description Interface for the Freemium Email to Lead Logger.
 *              Enables dependency injection and mock implementations for testing.
 */
public interface IFreemiumEmailToLeadLogger {
    
    /**
     * @description Logs a failure during email processing to the Inbound_Email_Lead_Log__c object.
     * @param email The inbound email that was being processed (can be null)
     * @param envelope The inbound email envelope containing sender info (can be null)
     * @param correlationId Unique identifier for this email processing attempt
     * @param leadExternalRequestId External request ID from the payload (if available)
     * @param eventType The event type from the payload (e.g., LEAD_CREATE, LEAD_STATUS_UPDATE)
     * @param ex The exception that occurred during processing
     * @param rawBody The raw email body content
     */
    void logFailure(
        Messaging.InboundEmail email,
        Messaging.InboundEnvelope envelope,
        String correlationId,
        String leadExternalRequestId,
        String eventType,
        Exception ex,
        String rawBody
    );
}