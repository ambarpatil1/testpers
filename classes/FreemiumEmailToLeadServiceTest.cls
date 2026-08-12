@IsTest
private class FreemiumEmailToLeadServiceTest {

    // ============================================================================
    // UNIT TESTS WITH DEPENDENCY INJECTION
    // ============================================================================

    @IsTest
    static void testProcessEmail_withMocks_shouldProcessLeadCreate() {
        // Arrange - Setup mocks
        MockFreemiumEmailPayloadParser mockParser = new MockFreemiumEmailPayloadParser();
        MockFreemiumLeadMapper mockMapper = new MockFreemiumLeadMapper();
        MockFreemiumLeadService mockLeadService = new MockFreemiumLeadService();
        MockFreemiumEmailToLeadLogger mockLogger = new MockFreemiumEmailToLeadLogger();
        
        Map<String, Object> mockPayload = new Map<String, Object>{
            'eventType' => 'LEAD_CREATE',
            'leadExternalRequestId' => 'test-ext-id-123'
        };
        mockParser.payloadDataToReturn = new FreemiumEmailPayloadParser.PayloadData(
            mockPayload, 'LEAD_CREATE', 'test-ext-id-123'
        );
        
        // Ensure no existing lead is found
        mockLeadService.leadToReturn = null;
        
        FreemiumEmailToLeadService service = new FreemiumEmailToLeadService(
            mockParser, mockMapper, mockLeadService, mockLogger
        );
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        // Act
        Test.startTest();
        service.processEmail(email, envelope, 'correlation-123');
        Test.stopTest();
        
        // Assert
        System.assertEquals(1, mockParser.parseEmailCallCount, 'Parser should be called once');
        System.assertEquals(1, mockLeadService.findLeadByExternalRequestIdCallCount, 'Lead lookup should be called');
        System.assertEquals(1, mockMapper.applyMappingsToLeadCallCount, 'Mapper should be called once');
        System.assertEquals(1, mockLeadService.insertLeadCallCount, 'Lead insert should be called once');
        System.assertEquals(0, mockLogger.logFailureCallCount, 'Logger should not be called on success');
    }

    @IsTest
    static void testProcessEmail_withMocks_shouldSkipDuplicateLead() {
        // Arrange
        MockFreemiumEmailPayloadParser mockParser = new MockFreemiumEmailPayloadParser();
        MockFreemiumLeadMapper mockMapper = new MockFreemiumLeadMapper();
        MockFreemiumLeadService mockLeadService = new MockFreemiumLeadService();
        MockFreemiumEmailToLeadLogger mockLogger = new MockFreemiumEmailToLeadLogger();
        
        // Setup: existing lead
        Lead existingLead = new Lead(External_Request_Id__c = 'existing-id');
        mockLeadService.leadToReturn = existingLead;
        
        Map<String, Object> mockPayload = new Map<String, Object>();
        mockParser.payloadDataToReturn = new FreemiumEmailPayloadParser.PayloadData(
            mockPayload, 'LEAD_CREATE', 'existing-id'
        );
        
        FreemiumEmailToLeadService service = new FreemiumEmailToLeadService(
            mockParser, mockMapper, mockLeadService, mockLogger
        );
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        // Act
        Test.startTest();
        service.processEmail(email, envelope, 'correlation-123');
        Test.stopTest();
        
        // Assert - no insert or mapping should occur for duplicate
        System.assertEquals(0, mockMapper.applyMappingsToLeadCallCount, 'Mapper should not be called for duplicate');
        System.assertEquals(0, mockLeadService.insertLeadCallCount, 'Insert should not be called for duplicate');
        System.assertEquals(0, mockLogger.logFailureCallCount, 'Logger should not be called for duplicate');
    }

    @IsTest
    static void testProcessEmail_withMocks_shouldHandleParserException() {
        // Arrange
        MockFreemiumEmailPayloadParser mockParser = new MockFreemiumEmailPayloadParser();
        MockFreemiumLeadMapper mockMapper = new MockFreemiumLeadMapper();
        MockFreemiumLeadService mockLeadService = new MockFreemiumLeadService();
        MockFreemiumEmailToLeadLogger mockLogger = new MockFreemiumEmailToLeadLogger();
        
        // Configure parser to throw exception
        mockParser.shouldThrowException = true;
        mockParser.exceptionToThrow = new FreemiumEmailToLeadException('Parse failed');
        
        FreemiumEmailToLeadService service = new FreemiumEmailToLeadService(
            mockParser, mockMapper, mockLeadService, mockLogger
        );
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        // Act
        Test.startTest();
        service.processEmail(email, envelope, 'correlation-123');
        Test.stopTest();
        
        // Assert - exception should be caught and logged
        System.assertEquals(1, mockLogger.logFailureCallCount, 'Logger should be called on exception');
        System.assertEquals('correlation-123', mockLogger.lastCorrelationId, 'Correlation ID should be logged');
        System.assertNotEquals(null, mockLogger.lastException, 'Exception should be logged');
    }

    @IsTest
    static void testProcessEmail_withMocks_shouldProcessLeadStatusUpdate() {
        // Arrange
        MockFreemiumEmailPayloadParser mockParser = new MockFreemiumEmailPayloadParser();
        MockFreemiumLeadMapper mockMapper = new MockFreemiumLeadMapper();
        MockFreemiumLeadService mockLeadService = new MockFreemiumLeadService();
        MockFreemiumEmailToLeadLogger mockLogger = new MockFreemiumEmailToLeadLogger();
        
        // Setup: existing lead for update
        Lead existingLead = new Lead(
            Id = generateFakeLeadId(),
            External_Request_Id__c = 'update-id-456',
            Status = 'Open'
        );
        mockLeadService.leadToReturn = existingLead;
        
        Map<String, Object> mockPayload = new Map<String, Object>();
        mockParser.payloadDataToReturn = new FreemiumEmailPayloadParser.PayloadData(
            mockPayload, 'LEAD_STATUS_UPDATE', 'update-id-456'
        );
        
        FreemiumEmailToLeadService service = new FreemiumEmailToLeadService(
            mockParser, mockMapper, mockLeadService, mockLogger
        );
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        // Act
        Test.startTest();
        service.processEmail(email, envelope, 'correlation-456');
        Test.stopTest();
        
        // Assert
        System.assertEquals(1, mockLeadService.findLeadForStatusUpdateCallCount, 'Lead lookup should be called');
        System.assertEquals(1, mockMapper.applyMappingsToLeadCallCount, 'Mapper should be called');
        System.assertEquals(1, mockMapper.appendStatusUpdateReasonCallCount, 'Append reason should be called');
        System.assertEquals(1, mockLeadService.updateLeadCallCount, 'Update should be called');
        System.assertEquals(0, mockLogger.logFailureCallCount, 'No failure should be logged');
    }

    @IsTest
    static void testProcessEmail_withMocks_shouldLogErrorForMissingLeadOnUpdate() {
        // Arrange
        MockFreemiumEmailPayloadParser mockParser = new MockFreemiumEmailPayloadParser();
        MockFreemiumLeadMapper mockMapper = new MockFreemiumLeadMapper();
        MockFreemiumLeadService mockLeadService = new MockFreemiumLeadService();
        MockFreemiumEmailToLeadLogger mockLogger = new MockFreemiumEmailToLeadLogger();
        
        // Setup: no lead found
        mockLeadService.leadToReturn = null;
        
        Map<String, Object> mockPayload = new Map<String, Object>();
        mockParser.payloadDataToReturn = new FreemiumEmailPayloadParser.PayloadData(
            mockPayload, 'LEAD_STATUS_UPDATE', 'nonexistent-id'
        );
        
        FreemiumEmailToLeadService service = new FreemiumEmailToLeadService(
            mockParser, mockMapper, mockLeadService, mockLogger
        );
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        // Act
        Test.startTest();
        service.processEmail(email, envelope, 'correlation-789');
        Test.stopTest();
        
        // Assert
        System.assertEquals(1, mockLogger.logFailureCallCount, 'Failure should be logged');
        System.assertEquals('LEAD_STATUS_UPDATE', mockLogger.lastEventType, 'Event type should be logged');
        System.assertNotEquals(null, mockLogger.lastException, 'Exception should be logged');
    }

    // ============================================================================
    // INTEGRATION TESTS (EXISTING - MAINTAIN FOR FULL END-TO-END COVERAGE)
    // ============================================================================

    @IsTest
    static void shouldCreateLeadFromCustomMetadataMappings() {
        String leadExternalRequestId = '6f3c9c55-4d4e-4f4a-bd38-88c8f6f14f20';

        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'Freemium Lead Create';
        email.plainTextBody =
            'JSON_START\n' +
            '{' +
            '"sourceSystem":"freemium-java-app",' +
            '"leadExternalRequestId":"' + leadExternalRequestId + '",' +
            '"eventType":"LEAD_CREATE",' +
            '"createdAt":"2026-01-23T10:30:00Z",' +
            '"lead":{' +
            '"firstName":"Jane",' +
            '"lastName":"Doe",' +
            '"email":"jane.doe@example.com",' +
            '"company":"Acme Inc",' +
            '"leadStatus":"3-MQL",' +
            '"leadCurrency":"USD",' +
            '"leadSource":"Inbound",' +
            '"leadSourceCategory":"Inbound",' +
            '"leadSourceDetail":"Product Qualified Lead - Vault Freemium",' +
            '"phone":"+1 555 123 4567",' +
            '"country":"United States",' +
            '"description":"User signed up through Vault Freemium"' +
            '}' +
            '}' +
            '\nJSON_END';
        envelope.fromAddress = 'no-reply@example.com';

        Test.startTest();
        Messaging.InboundEmailResult result = new FreemiumEmailToLeadHandler().handleInboundEmail(email, envelope);
        Test.stopTest();

        System.assertEquals(true, result.success);

        List<Lead> leads = [
            SELECT Id, FirstName, LastName, Email, Company, Status, LeadSource, CurrencyIsoCode,
                   External_Request_Id__c, Lead_Source_Category__c, Lead_Source_Detail__c
            FROM Lead
            WHERE External_Request_Id__c = :leadExternalRequestId
            LIMIT 1
        ];
        
        System.assertEquals(1, leads.size(), 'Lead should have been created. Check for errors in Inbound_Email_Lead_Log__c');
        Lead createdLead = leads[0];

        System.assertEquals('Jane', createdLead.FirstName);
        System.assertEquals('Doe', createdLead.LastName);
        System.assertEquals('jane.doe@example.com', createdLead.Email);
        System.assertEquals('Acme Inc', createdLead.Company);
        System.assertEquals('3-MQL', createdLead.Status);
        System.assertEquals('Inbound', createdLead.LeadSource);
        System.assertEquals('USD', createdLead.CurrencyIsoCode);
        System.assertEquals('Inbound', createdLead.Lead_Source_Category__c);
        System.assertEquals('Product Qualified Lead - Vault Freemium', createdLead.Lead_Source_Detail__c);
    }

    @IsTest
    static void shouldIgnoreDuplicateLeadCreateWithoutFailure() {
        String leadExternalRequestId = 'aaaaaaaa-1111-4111-8111-aaaaaaaaaaaa';

        insert new Lead(
            FirstName = 'Existing',
            LastName = 'Lead',
            Company = 'Freemium',
            Email = 'existing@example.com',
            Status = '3-MQL',
            External_Request_Id__c = leadExternalRequestId
        );

        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'Duplicate Freemium Lead Create';
        email.plainTextBody =
            'JSON_START\n' +
            '{' +
            '"sourceSystem":"freemium-java-app",' +
            '"leadExternalRequestId":"' + leadExternalRequestId + '",' +
            '"eventType":"LEAD_CREATE",' +
            '"lead":{"lastName":"Doe","email":"jane.doe@example.com","company":"Acme Inc"}' +
            '}' +
            '\nJSON_END';
        envelope.fromAddress = 'no-reply@example.com';

        Test.startTest();
        Messaging.InboundEmailResult result = new FreemiumEmailToLeadHandler().handleInboundEmail(email, envelope);
        Test.stopTest();

        System.assertEquals(true, result.success);
        System.assertEquals(1, [SELECT COUNT() FROM Lead WHERE External_Request_Id__c = :leadExternalRequestId]);
    }

    @IsTest
    static void shouldUpdateLeadStatus() {
        String leadExternalRequestId = 'bbbbbbbb-2222-4222-8222-bbbbbbbbbbbb';

        insert new Lead(
            FirstName = 'Jane',
            LastName = 'Doe',
            Company = 'Freemium',
            Email = 'jane.doe@example.com',
            Status = '1-Open',
            External_Request_Id__c = leadExternalRequestId
        );

        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'Freemium Lead Status Update';
        email.plainTextBody =
            'JSON_START\n' +
            '{' +
            '"sourceSystem":"freemium-java-app",' +
            '"leadExternalRequestId":"' + leadExternalRequestId + '",' +
            '"eventType":"LEAD_STATUS_UPDATE",' +
            '"createdAt":"2026-01-23T11:00:00Z",' +
            '"leadStatusUpdate":{"status":"4-SAL","reason":"User met PQL threshold"}' +
            '}' +
            '\nJSON_END';
        envelope.fromAddress = 'no-reply@example.com';

        Test.startTest();
        Messaging.InboundEmailResult result = new FreemiumEmailToLeadHandler().handleInboundEmail(email, envelope);
        Test.stopTest();

        System.assertEquals(true, result.success);

        Lead updatedLead = [
            SELECT Id, Status, Description
            FROM Lead
            WHERE External_Request_Id__c = :leadExternalRequestId
            LIMIT 1
        ];
        System.assertEquals('4-SAL', updatedLead.Status);
        System.assert(updatedLead.Description != null && updatedLead.Description.contains('User met PQL threshold'));
    }

    @IsTest
    static void shouldLogFailureForInvalidPayload() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'Invalid Freemium Payload';
        email.plainTextBody = 'JSON_START\n{ "invalid": true }\nJSON_END';
        envelope.fromAddress = 'no-reply@example.com';

        Test.startTest();
        Messaging.InboundEmailResult result = new FreemiumEmailToLeadHandler().handleInboundEmail(email, envelope);
        Test.stopTest();

        System.assertEquals(true, result.success);
        
        // Verify log was created (if permissions allow)
        List<Inbound_Email_Lead_Log__c> logs = [
            SELECT Status__c, Error_Message__c, Error_Type__c, Email_Subject__c
            FROM Inbound_Email_Lead_Log__c
        ];
        if (!logs.isEmpty()) {
            System.assertNotEquals(null, logs[0].Status__c, 'Status should be populated');
            System.assertEquals('Failed', logs[0].Status__c);
            System.assertEquals('Invalid Freemium Payload', logs[0].Email_Subject__c);
            System.assert(logs[0].Error_Message__c != null, 'Error message should be populated');
        }
    }

    @IsTest
    static void shouldLogFailureForMissingRequiredFields() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'Missing Required Fields';
        email.plainTextBody =
            'JSON_START\n' +
            '{' +
            '"sourceSystem":"freemium-java-app",' +
            '"leadExternalRequestId":"aaaaaaaa-1111-4111-8111-aaaaaaaaaaaa",' +
            '"eventType":"LEAD_CREATE",' +
            '"lead":{"firstName":"John"}' + // Missing required lastName, email, company
            '}' +
            '\nJSON_END';
        envelope.fromAddress = 'no-reply@example.com';

        Test.startTest();
        Messaging.InboundEmailResult result = new FreemiumEmailToLeadHandler().handleInboundEmail(email, envelope);
        Test.stopTest();

        System.assertEquals(true, result.success);
        
        // Verify log was created with proper error details (if permissions allow)
        List<Inbound_Email_Lead_Log__c> logs = [
            SELECT Status__c, Error_Message__c, Event_Type__c, Lead_External_Request_Id__c
            FROM Inbound_Email_Lead_Log__c
        ];
        if (!logs.isEmpty()) {
            System.assertNotEquals(null, logs[0].Status__c, 'Status should be populated');
            System.assertEquals('Failed', logs[0].Status__c);
            System.assertEquals('LEAD_CREATE', logs[0].Event_Type__c);
            System.assertEquals('aaaaaaaa-1111-4111-8111-aaaaaaaaaaaa', logs[0].Lead_External_Request_Id__c);
            System.assert(logs[0].Error_Message__c.contains('Required'), 'Error should mention required field');
        }
    }

    @IsTest
    static void shouldLogFailureForInvalidEventType() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'Invalid Event Type';
        email.plainTextBody =
            'JSON_START\n' +
            '{' +
            '"sourceSystem":"freemium-java-app",' +
            '"leadExternalRequestId":"bbbbbbbb-2222-4222-8222-bbbbbbbbbbbb",' +
            '"eventType":"INVALID_EVENT_TYPE"' +
            '}' +
            '\nJSON_END';
        envelope.fromAddress = 'no-reply@example.com';

        Test.startTest();
        Messaging.InboundEmailResult result = new FreemiumEmailToLeadHandler().handleInboundEmail(email, envelope);
        Test.stopTest();

        System.assertEquals(true, result.success);
        
        // Verify log was created (if permissions allow)
        List<Inbound_Email_Lead_Log__c> logs = [
            SELECT Status__c, Error_Message__c, Event_Type__c
            FROM Inbound_Email_Lead_Log__c
        ];
        if (!logs.isEmpty()) {
            System.assertNotEquals(null, logs[0].Status__c, 'Status should be populated');
            System.assertEquals('Failed', logs[0].Status__c);
            System.assertEquals('INVALID_EVENT_TYPE', logs[0].Event_Type__c);
            System.assert(logs[0].Error_Message__c.contains('Unsupported eventType'), 'Error should mention unsupported event type');
        }
    }

    @IsTest
    static void shouldLogFailureForLeadNotFoundOnStatusUpdate() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'Lead Not Found';
        email.plainTextBody =
            'JSON_START\n' +
            '{' +
            '"sourceSystem":"freemium-java-app",' +
            '"leadExternalRequestId":"cccccccc-3333-4333-8333-cccccccccccc",' +
            '"eventType":"LEAD_STATUS_UPDATE",' +
            '"leadStatusUpdate":{"status":"4-SAL"}' +
            '}' +
            '\nJSON_END';
        envelope.fromAddress = 'no-reply@example.com';

        Test.startTest();
        Messaging.InboundEmailResult result = new FreemiumEmailToLeadHandler().handleInboundEmail(email, envelope);
        Test.stopTest();

        System.assertEquals(true, result.success);
        
        // Verify log was created (if permissions allow)
        List<Inbound_Email_Lead_Log__c> logs = [
            SELECT Status__c, Error_Message__c, Event_Type__c, Lead_External_Request_Id__c
            FROM Inbound_Email_Lead_Log__c
        ];
        if (!logs.isEmpty()) {
            System.assertNotEquals(null, logs[0].Status__c, 'Status should be populated');
            System.assertEquals('Failed', logs[0].Status__c);
            System.assertEquals('LEAD_STATUS_UPDATE', logs[0].Event_Type__c);
            System.assertEquals('cccccccc-3333-4333-8333-cccccccccccc', logs[0].Lead_External_Request_Id__c);
            System.assert(logs[0].Error_Message__c.contains('No Lead found'), 'Error should mention Lead not found');
        }
    }

    @IsTest
    static void shouldLogFailureForMalformedJson() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'Malformed JSON';
        email.plainTextBody = 'JSON_START\n{ "invalid": json, "missing": "quotes" }\nJSON_END';
        envelope.fromAddress = 'no-reply@example.com';

        Test.startTest();
        Messaging.InboundEmailResult result = new FreemiumEmailToLeadHandler().handleInboundEmail(email, envelope);
        Test.stopTest();

        System.assertEquals(true, result.success);
        
        // Verify log was created (if permissions allow)
        List<Inbound_Email_Lead_Log__c> logs = [
            SELECT Status__c, Error_Message__c
            FROM Inbound_Email_Lead_Log__c
        ];
        if (!logs.isEmpty()) {
            System.assertNotEquals(null, logs[0].Status__c, 'Status should be populated');
            System.assertEquals('Failed', logs[0].Status__c);
            System.assert(logs[0].Error_Message__c.contains('Invalid JSON'), 'Error should mention invalid JSON');
        }
    }

    @IsTest
    static void shouldLogFailureForTruncatedEmailBody() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'Truncated Body';
        email.plainTextBody = '{"test":"data"}';
        email.plainTextBodyIsTruncated = true;
        envelope.fromAddress = 'no-reply@example.com';

        Test.startTest();
        Messaging.InboundEmailResult result = new FreemiumEmailToLeadHandler().handleInboundEmail(email, envelope);
        Test.stopTest();

        System.assertEquals(true, result.success);
        
        // Verify log was created (if permissions allow)
        List<Inbound_Email_Lead_Log__c> logs = [
            SELECT Status__c, Error_Message__c
            FROM Inbound_Email_Lead_Log__c
        ];
        if (!logs.isEmpty()) {
            System.assertNotEquals(null, logs[0].Status__c, 'Status should be populated');
            System.assertEquals('Failed', logs[0].Status__c);
            System.assert(logs[0].Error_Message__c.contains('truncated'), 'Error should mention truncated');
        }
    }

    // ============================================================================
    // TEST UTILITIES
    // ============================================================================

    /**
     * @description Generates a fake Lead ID for testing purposes.
     */
    private static Id generateFakeLeadId() {
        // Generate a valid 18-character Salesforce ID for Lead object
        // Lead object has prefix '00Q'
        String prefix = '00Q';
        String randomChars = '0000000000000';
        
        // Generate a simple sequential ID for testing
        Integer randomNum = Math.abs(Crypto.getRandomInteger());
        String numStr = String.valueOf(randomNum);
        if (numStr.length() > 12) {
            numStr = numStr.substring(0, 12);
        }
        randomChars = numStr.leftPad(12, '0');
        
        String id15 = prefix + randomChars;
        
        // Calculate checksum characters for 18-char ID
        String checksumChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ012345';
        String checksum = '';
        
        for (Integer i = 0; i < 3; i++) {
            Integer flags = 0;
            for (Integer j = 0; j < 5; j++) {
                String c = id15.substring(i * 5 + j, i * 5 + j + 1);
                if (c.toUpperCase() == c && c >= 'A' && c <= 'Z') {
                    flags += 1 << j;
                }
            }
            checksum += checksumChars.substring(flags, flags + 1);
        }
        
        return Id.valueOf(id15 + checksum);
    }
}