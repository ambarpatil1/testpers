/**
 * @description Handles inbound emails for Freemium Lead processing integration.
 *              Implements Salesforce Inbound Email Handler to process emails from
 *              the freemium Java application and create/update Lead records.
 */
public with sharing class FreemiumEmailToLeadHandler implements Messaging.InboundEmailHandler {

    private final IFreemiumEmailToLeadService emailToLeadService;
    private final IFreemiumEmailToLeadLogger logger;

    /**
     * @description Default constructor for production use.
     *              Instantiates concrete implementations of all dependencies.
     */
    public FreemiumEmailToLeadHandler() {
        this(
            new FreemiumEmailToLeadService(),
            new FreemiumEmailToLeadLogger()
        );
    }

    /**
     * @description Constructor with dependency injection for testing.
     * @param emailToLeadService The email to lead service implementation
     * @param logger The failure logger implementation
     */
    @TestVisible
    private FreemiumEmailToLeadHandler(
        IFreemiumEmailToLeadService emailToLeadService,
        IFreemiumEmailToLeadLogger logger
    ) {
        this.emailToLeadService = emailToLeadService;
        this.logger = logger;
    }

    /**
     * @description Handles inbound email processing for Lead creation and updates.
     *              Generates a correlation ID, processes the email, and logs any failures.
     *              Always returns success to prevent email retry loops.
     * @param email The inbound email containing the JSON payload
     * @param envelope The envelope containing sender information
     * @return InboundEmailResult with success=true and correlation ID in message
     */
    public Messaging.InboundEmailResult handleInboundEmail(
        Messaging.InboundEmail email,
        Messaging.InboundEnvelope envelope
    ) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        String correlationId = emailToLeadService.generateCorrelationId();

        try {
            emailToLeadService.processEmail(email, envelope, correlationId);
            result.success = true;
            result.message = 'Inbound email processed. Correlation Id: ' + correlationId;
        } catch (Exception ex) {
            String rawBody = emailToLeadService.safeGetBody(email);

            logger.logFailure(
                email,
                envelope,
                correlationId,
                null,
                null,
                ex,
                rawBody
            );

            // Return true to avoid mail retry loops. The failure is logged in Salesforce.
            result.success = true;
            result.message = 'Inbound email processed with error. Correlation Id: ' + correlationId;
        }

        return result;
    }
}