/**
 * @description Parser for extracting and validating JSON payloads from inbound emails
 *              for the Freemium Email to Lead integration.
 */
public with sharing class FreemiumEmailPayloadParser implements IFreemiumEmailPayloadParser {

    private static final String EXPECTED_SOURCE_SYSTEM = 'freemium-java-app';


/**
     * @description Container for parsed payload data with extracted key fields
     */
    public class PayloadData {
        public Map<String, Object> parsedPayload { get; set; }
        public String eventType { get; set; }
        public String leadExternalRequestId { get; set; }
        
        public PayloadData(Map<String, Object> payload, String evtType, String extRequestId) {
            this.parsedPayload = payload;
            this.eventType = evtType;
            this.leadExternalRequestId = extRequestId;
        }
    }

    /**
     * @description Parses and validates an inbound email to extract the JSON payload.
     * @param email The inbound email containing the JSON payload
     * @return PayloadData containing the parsed payload and extracted key fields
     * @throws FreemiumEmailToLeadException if validation or parsing fails
     */
    public PayloadData parseEmail(Messaging.InboundEmail email) {
        validateEmailSize(email);
        
        String rawBody = safeGetBody(email);
        Map<String, Object> payload = parsePayload(rawBody);
        
        validateCommonPayload(payload);
        
        String eventType = getString(payload, 'eventType');
        String leadExternalRequestId = getString(payload, 'leadExternalRequestId');
        
        return new PayloadData(payload, eventType, leadExternalRequestId);
    }

    /**
     * @description Safely extracts the email body content, preferring plain text over HTML.
     * @param email The inbound email
     * @return The email body as a string, or null if unavailable
     */
    public String safeGetBody(Messaging.InboundEmail email) {
        if (email == null) {
            return null;
        }
        if (!String.isBlank(email.plainTextBody)) {
            return email.plainTextBody;
        }
        if (!String.isBlank(email.htmlBody)) {
            return email.htmlBody.stripHtmlTags();
        }
        return null;
    }

    /**
     * @description Attempts to extract a string value from raw body text by path.
     *              Used for error handling when payload parsing fails.
     * @param rawBody The raw email body
     * @param path The dot-notation path to extract (e.g., 'lead.firstName')
     * @return The extracted string value, or null if extraction fails
     */
    public String tryExtractString(String rawBody, String path) {
        try {
            Map<String, Object> payload = parsePayload(rawBody);
            return getString(payload, path);
        } catch (Exception ignoredException) {
            return null;
        }
    }

    /**
     * @description Validates that the email size is within acceptable limits.
     * @param email The inbound email to validate
     * @throws FreemiumEmailToLeadException if email is null or body is truncated
     */
    private void validateEmailSize(Messaging.InboundEmail email) {
        if (email == null) {
            throw new FreemiumEmailToLeadException('Inbound email is null.');
        }
        if (email.plainTextBodyIsTruncated == true) {
            throw new FreemiumEmailToLeadException('Plain text body was truncated.');
        }
        if (email.htmlBodyIsTruncated == true) {
            throw new FreemiumEmailToLeadException('HTML body was truncated.');
        }
    }

    /**
     * @description Parses the raw email body to extract the JSON payload.
     * @param body The raw email body text
     * @return Map representation of the JSON payload
     * @throws FreemiumEmailToLeadException if body is empty or JSON is invalid
     */
    private Map<String, Object> parsePayload(String body) {
        if (String.isBlank(body)) {
            throw new FreemiumEmailToLeadException('Email body is empty.');
        }

        String jsonPayload = extractJsonPayload(body);
        try {
            Object parsed = JSON.deserializeUntyped(jsonPayload);
            return (Map<String, Object>) parsed;
        } catch (JSONException ex) {
            throw new FreemiumEmailToLeadException('Invalid JSON payload: ' + ex.getMessage());
        }
    }

    /**
     * @description Extracts JSON content from email body, supporting JSON_START/JSON_END markers.
     * @param body The raw email body
     * @return The extracted JSON string
     * @throws FreemiumEmailToLeadException if body is empty or JSON payload is missing
     */
    private String extractJsonPayload(String body) {
        String cleanedBody = body == null ? null : body.trim();
        if (String.isBlank(cleanedBody)) {
            throw new FreemiumEmailToLeadException('Email body is empty.');
        }

        Integer startIndex = cleanedBody.indexOf('JSON_START');
        Integer endIndex = cleanedBody.indexOf('JSON_END');

        if (startIndex >= 0 && endIndex > startIndex) {
            startIndex += 'JSON_START'.length();
            cleanedBody = cleanedBody.substring(startIndex, endIndex);
        }

        if (String.isBlank(cleanedBody)) {
            throw new FreemiumEmailToLeadException('JSON payload is empty.');
        }

        return cleanedBody.trim();
    }

    /**
     * @description Validates common payload structure and required fields.
     * @param payload The parsed JSON payload
     * @throws FreemiumEmailToLeadException if validation fails
     */
    private void validateCommonPayload(Map<String, Object> payload) {
        if (payload == null) {
            throw new FreemiumEmailToLeadException('Payload is missing.');
        }

        String sourceSystem = getString(payload, 'sourceSystem');
        String leadExternalRequestId = getString(payload, 'leadExternalRequestId');
        String eventType = getString(payload, 'eventType');

        if (sourceSystem != EXPECTED_SOURCE_SYSTEM) {
            throw new FreemiumEmailToLeadException('Unsupported sourceSystem: ' + sourceSystem);
        }
        if (!isValidUuid(leadExternalRequestId)) {
            throw new FreemiumEmailToLeadException('leadExternalRequestId must be a valid 36-character UUID.');
        }
        if (String.isBlank(eventType)) {
            throw new FreemiumEmailToLeadException('eventType is required.');
        }
    }

    /**
     * @description Extracts a string value from the payload by dot-notation path.
     * @param payload The parsed JSON payload
     * @param path The dot-notation path (e.g., 'lead.firstName')
     * @return The string value, or null if not found
     */
    public String getString(Map<String, Object> payload, String path) {
        Object value = getValueByPath(payload, path);
        return value == null ? null : String.valueOf(value).trim();
    }

    /**
     * @description Navigates through nested maps using dot-notation path.
     * @param payload The parsed JSON payload
     * @param path The dot-notation path (e.g., 'lead.firstName')
     * @return The value at the path, or null if not found
     */
    private Object getValueByPath(Map<String, Object> payload, String path) {
        if (payload == null || String.isBlank(path)) {
            return null;
        }

        Object current = payload;
        for (String part : path.split('\\.')) {
            try {
                Map<String, Object> currentMap = (Map<String, Object>) current;
                current = currentMap.get(part);
            } catch (Exception ex) {
                return null;
            }
        }
        return current;
    }

    /**
     * @description Validates that a string is a properly formatted UUID.
     * @param value The string to validate
     * @return True if value is a valid UUID, false otherwise
     */
    private Boolean isValidUuid(String value) {
        if (String.isBlank(value)) {
            return false;
        }

        Pattern uuidPattern = Pattern.compile(
            '^[a-f0-9]{8}-[a-f0-9]{4}-[1-5][a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}$'
        );
        return uuidPattern.matcher(value.trim().toLowerCase()).matches();
    }
}