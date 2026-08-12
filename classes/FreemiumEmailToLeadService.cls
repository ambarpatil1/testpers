/**
 * @description Orchestrates the processing of inbound emails to create or update Lead records.
 *              Coordinates between Parser, Mapper, and LeadService components.
 */
public with sharing class FreemiumEmailToLeadService implements IFreemiumEmailToLeadService {

    private static final String EVENT_LEAD_CREATE = 'LEAD_CREATE';
    private static final String EVENT_LEAD_STATUS_UPDATE = 'LEAD_STATUS_UPDATE';

    private final IFreemiumEmailPayloadParser parser;
    private final IFreemiumLeadMapper mapper;
    private final IFreemiumLeadService leadService;
    private final IFreemiumEmailToLeadLogger logger;

    /**
     * @description Default constructor for production use.
     *              Instantiates concrete implementations of all dependencies.
     */
    public FreemiumEmailToLeadService() {
        this(
            new FreemiumEmailPayloadParser(),
            new FreemiumLeadMapper(),
            new FreemiumLeadService(),
            new FreemiumEmailToLeadLogger()
        );
    }

    /**
     * @description Constructor with dependency injection for testing.
     * @param parser The email payload parser implementation
     * @param mapper The lead field mapper implementation
     * @param leadService The lead data service implementation
     * @param logger The failure logger implementation
     */
    @TestVisible
    private FreemiumEmailToLeadService(
        IFreemiumEmailPayloadParser parser,
        IFreemiumLeadMapper mapper,
        IFreemiumLeadService leadService,
        IFreemiumEmailToLeadLogger logger
    ) {
        this.parser = parser;
        this.mapper = mapper;
        this.leadService = leadService;
        this.logger = logger;
    }

    /**
     * @description Processes an inbound email to create or update a Lead record.
     * @param email The inbound email containing the JSON payload
     * @param envelope The email envelope with sender information
     * @param correlationId Unique identifier for tracking this processing attempt
     */
    public void processEmail(
        Messaging.InboundEmail email,
        Messaging.InboundEnvelope envelope,
        String correlationId
    ) {
        String rawBody = parser.safeGetBody(email);
        String leadExternalRequestId;
        String eventType;

        try {
            FreemiumEmailPayloadParser.PayloadData payloadData = parser.parseEmail(email);
            leadExternalRequestId = payloadData.leadExternalRequestId;
            eventType = payloadData.eventType;

            if (eventType == EVENT_LEAD_CREATE) {
                processLeadCreate(payloadData);
                return;
            }

            if (eventType == EVENT_LEAD_STATUS_UPDATE) {
                processLeadStatusUpdate(payloadData);
                return;
            }

            throw new FreemiumEmailToLeadException('Unsupported eventType: ' + eventType);
        } catch (Exception ex) {
            if (String.isBlank(leadExternalRequestId)) {
                leadExternalRequestId = parser.tryExtractString(rawBody, 'leadExternalRequestId');
            }
            if (String.isBlank(eventType)) {
                eventType = parser.tryExtractString(rawBody, 'eventType');
            }

            logger.logFailure(
                email,
                envelope,
                correlationId,
                leadExternalRequestId,
                eventType,
                ex,
                rawBody
            );
        }
    }

    /**
     * @description Processes a Lead creation request.
     * @param payloadData The parsed payload data
     * @throws FreemiumEmailToLeadException if Lead creation fails
     */
    private void processLeadCreate(FreemiumEmailPayloadParser.PayloadData payloadData) {
        String leadExternalRequestId = payloadData.leadExternalRequestId;

        Lead existingLead = leadService.findLeadByExternalRequestId(leadExternalRequestId);
        if (existingLead != null) {
            // Duplicate creation attempts are intentionally ignored and not logged.
            return;
        }

        Lead leadRecord = new Lead();
        leadRecord.External_Request_Id__c = leadExternalRequestId;
        mapper.applyMappingsToLead(leadRecord, payloadData.parsedPayload, EVENT_LEAD_CREATE, AccessType.CREATABLE);

        leadService.insertLead(leadRecord);
    }

    /**
     * @description Processes a Lead status update request.
     * @param payloadData The parsed payload data
     * @throws FreemiumEmailToLeadException if Lead update fails or Lead not found
     */
    private void processLeadStatusUpdate(FreemiumEmailPayloadParser.PayloadData payloadData) {
        String leadExternalRequestId = payloadData.leadExternalRequestId;
        Lead leadRecord = leadService.findLeadForStatusUpdate(leadExternalRequestId);

        if (leadRecord == null) {
            throw new FreemiumEmailToLeadException(
                'No Lead found for status update. leadExternalRequestId: ' + leadExternalRequestId
            );
        }

        mapper.applyMappingsToLead(leadRecord, payloadData.parsedPayload, EVENT_LEAD_STATUS_UPDATE, AccessType.UPDATABLE);
        mapper.appendStatusUpdateReason(leadRecord, payloadData.parsedPayload);

        leadService.updateLead(leadRecord);
    }

    /**
     * @description Safely extracts the email body content (delegates to parser).
     * @param email The inbound email
     * @return The email body as a string
     */
    public String safeGetBody(Messaging.InboundEmail email) {
        return parser.safeGetBody(email);
    }

    /**
     * @description Generates a unique correlation ID for tracking email processing.
     * @return A 24-character hexadecimal correlation ID
     */
    public String generateCorrelationId() {
        Blob randomBlob = Crypto.generateAesKey(128);
        return EncodingUtil.convertToHex(randomBlob).left(24);
    }
}