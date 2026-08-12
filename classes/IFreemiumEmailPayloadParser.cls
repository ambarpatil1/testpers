/**
 * @description Interface for the Freemium Email Payload Parser.
 *              Enables dependency injection and mock implementations for testing.
 */
public interface IFreemiumEmailPayloadParser {
    
    /**
     * @description Parses and validates an inbound email to extract the JSON payload.
     * @param email The inbound email containing the JSON payload
     * @return PayloadData containing the parsed payload and extracted key fields
     */
    FreemiumEmailPayloadParser.PayloadData parseEmail(Messaging.InboundEmail email);
    
    /**
     * @description Safely extracts the email body content, preferring plain text over HTML.
     * @param email The inbound email
     * @return The email body as a string, or null if unavailable
     */
    String safeGetBody(Messaging.InboundEmail email);
    
    /**
     * @description Attempts to extract a string value from raw JSON body without full parsing.
     * @param rawBody The raw JSON string
     * @param key The key to extract
     * @return The extracted value or null if not found
     */
    String tryExtractString(String rawBody, String key);
}