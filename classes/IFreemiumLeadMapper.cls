/**
 * @description Interface for the Freemium Lead Mapper.
 *              Enables dependency injection and mock implementations for testing.
 */
public interface IFreemiumLeadMapper {
    
    /**
     * @description Applies field mappings to a Lead record based on custom metadata configuration.
     * @param targetRecord The Lead record to populate
     * @param payload The parsed JSON payload containing field values
     * @param eventType The event type (LEAD_CREATE or LEAD_STATUS_UPDATE)
     * @param accessType The access type to check (CREATABLE or UPDATABLE)
     */
    void applyMappingsToLead(
        SObject targetRecord,
        Map<String, Object> payload,
        String eventType,
        System.AccessType accessType
    );
    
    /**
     * @description Appends a status update reason to the Lead's Description field.
     * @param leadRecord The Lead record to update
     * @param payload The parsed JSON payload containing the status update details
     */
    void appendStatusUpdateReason(Lead leadRecord, Map<String, Object> payload);
}