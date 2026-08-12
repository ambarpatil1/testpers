/**
 * @description Interface for the Freemium Lead Service.
 *              Enables dependency injection and mock implementations for testing.
 */
public interface IFreemiumLeadService {
    
    /**
     * @description Finds a Lead by its External Request ID.
     * @param leadExternalRequestId The external request ID to search for
     * @return The Lead record if found, null otherwise
     */
    Lead findLeadByExternalRequestId(String leadExternalRequestId);
    
    /**
     * @description Finds a Lead for status update operations (includes additional fields).
     * @param leadExternalRequestId The external request ID to search for
     * @return The Lead record with Status and Description if found, null otherwise
     */
    Lead findLeadForStatusUpdate(String leadExternalRequestId);
    
    /**
     * @description Inserts a Lead record with proper security enforcement.
     * @param leadRecord The Lead to insert
     */
    void insertLead(Lead leadRecord);
    
    /**
     * @description Updates a Lead record with proper security enforcement.
     * @param leadRecord The Lead to update
     */
    void updateLead(Lead leadRecord);
}