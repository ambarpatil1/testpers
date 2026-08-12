/**
 * @description Interface for the Freemium Email to Lead Service.
 *              Enables dependency injection and mock implementations for testing.
 */
public interface IFreemiumEmailToLeadService {
    
    /**
     * @description Processes an inbound email to create or update a Lead record.
     * @param email The inbound email containing the JSON payload
     * @param envelope The email envelope with sender information
     * @param correlationId Unique identifier for tracking this processing attempt
     */
    void processEmail(
        Messaging.InboundEmail email,
        Messaging.InboundEnvelope envelope,
        String correlationId
    );
    
    /**
     * @description Safely extracts the email body content.
     * @param email The inbound email
     * @return The email body as a string
     */
    String safeGetBody(Messaging.InboundEmail email);
    
    /**
     * @description Generates a unique correlation ID for tracking email processing.
     * @return A 24-character hexadecimal correlation ID
     */
    String generateCorrelationId();
}