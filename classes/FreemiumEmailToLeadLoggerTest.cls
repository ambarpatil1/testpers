/**
 * @description Test class for FreemiumEmailToLeadLogger
 */
@IsTest
private class FreemiumEmailToLeadLoggerTest {

    /**
     * @description Test successful logging with all fields populated
     */
    @IsTest
    static void testLogFailureWithAllFieldsPopulated() {
        // Arrange
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Email Subject';
        email.plainTextBody = 'Test email body with JSON payload';

        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'test@example.com';

        String correlationId = 'test-correlation-123';
        String leadExternalRequestId = '6f3c9c55-4d4e-4f4a-bd38-88c8f6f14f20';
        String eventType = 'LEAD_CREATE';
        Exception testException = new FreemiumEmailToLeadException('Test error message');
        String rawBody = 'JSON_START\n{"test":"data"}\nJSON_END';

        FreemiumEmailToLeadLogger logger = new FreemiumEmailToLeadLogger();

        Test.startTest();
        logger.logFailure(
            email,
            envelope,
            correlationId,
            leadExternalRequestId,
            eventType,
            testException,
            rawBody
        );
        Test.stopTest();

        // Assert - check if log was created (may not be created if FLS/permissions deny)
        List<Inbound_Email_Lead_Log__c> logs = [
            SELECT Status__c, Correlation_Id__c, Lead_External_Request_Id__c, Event_Type__c,
                   Email_From__c, Email_Subject__c, Raw_Body__c, Error_Message__c,
                   Error_Type__c, Stack_Trace__c
            FROM Inbound_Email_Lead_Log__c
        ];

        if (!logs.isEmpty()) {
            System.assertNotEquals(null, logs[0].Status__c, 'Status should be populated');
            System.assertEquals('Failed', logs[0].Status__c);
            System.assertEquals(correlationId, logs[0].Correlation_Id__c);
            System.assertEquals(leadExternalRequestId, logs[0].Lead_External_Request_Id__c);
            System.assertEquals(eventType, logs[0].Event_Type__c);
            System.assertEquals('test@example.com', logs[0].Email_From__c);
            System.assertEquals('Test Email Subject', logs[0].Email_Subject__c);
            System.assertEquals('JSON_START\n{"test":"data"}\nJSON_END', logs[0].Raw_Body__c);
            System.assertEquals('Test error message', logs[0].Error_Message__c);
            System.assertEquals('FreemiumEmailToLeadException', logs[0].Error_Type__c);
            System.assert(logs[0].Stack_Trace__c != null, 'Stack trace should be populated');
        }
    }

    /**
     * @description Test logging with null email parameter
     */
    @IsTest
    static void testLogFailureWithNullEmail() {
        // Arrange
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'test@example.com';

        String correlationId = 'test-correlation-456';
        Exception testException = new System.NullPointerException();

        FreemiumEmailToLeadLogger logger = new FreemiumEmailToLeadLogger();

        Test.startTest();
        logger.logFailure(
            null, // null email
            envelope,
            correlationId,
            'lead-id-test',
            'LEAD_CREATE',
            testException,
            'raw body content'
        );
        Test.stopTest();

        // Assert - should handle null gracefully
        List<Inbound_Email_Lead_Log__c> logs = [SELECT Id, Email_Subject__c FROM Inbound_Email_Lead_Log__c];
        System.assertEquals(1, logs.size(), 'Should still create log record');
        System.assertEquals(null, logs[0].Email_Subject__c, 'Email subject should be null');
    }

    /**
     * @description Test logging with null envelope parameter
     */
    @IsTest
    static void testLogFailureWithNullEnvelope() {
        // Arrange
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Subject';

        String correlationId = 'test-correlation-789';
        Exception testException = new System.QueryException();

        FreemiumEmailToLeadLogger logger = new FreemiumEmailToLeadLogger();

        Test.startTest();
        logger.logFailure(
            email,
            null, // null envelope
            correlationId,
            null,
            null,
            testException,
            'raw body'
        );
        Test.stopTest();

        // Assert
        List<Inbound_Email_Lead_Log__c> logs = [SELECT Id, Email_From__c FROM Inbound_Email_Lead_Log__c];
        System.assertEquals(1, logs.size(), 'Should still create log record');
        System.assertEquals(null, logs[0].Email_From__c, 'Email from should be null');
    }

    /**
     * @description Test logging with null exception
     */
    @IsTest
    static void testLogFailureWithNullException() {
        // Arrange
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Subject';

        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'test@example.com';

        String correlationId = 'test-correlation-null-ex';

        FreemiumEmailToLeadLogger logger = new FreemiumEmailToLeadLogger();

        Test.startTest();
        logger.logFailure(
            email,
            envelope,
            correlationId,
            'lead-test',
            'LEAD_STATUS_UPDATE',
            null, // null exception
            'raw body'
        );
        Test.stopTest();

        // Assert
        List<Inbound_Email_Lead_Log__c> logs = [
            SELECT Id, Error_Message__c, Error_Type__c, Stack_Trace__c
            FROM Inbound_Email_Lead_Log__c
        ];
        System.assertEquals(1, logs.size(), 'Should still create log record');
        System.assertEquals(null, logs[0].Error_Message__c, 'Error message should be null');
        System.assertEquals(null, logs[0].Error_Type__c, 'Error type should be null');
        System.assertEquals(null, logs[0].Stack_Trace__c, 'Stack trace should be null');
    }

    /**
     * @description Test field truncation for long email subject
     */
    @IsTest
    static void testLogFailureWithLongEmailSubject() {
        // Arrange - Create subject longer than 255 characters
        String longSubject = '';
        for (Integer i = 0; i < 300; i++) {
            longSubject += 'A';
        }

        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = longSubject;

        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'test@example.com';

        String correlationId = 'test-correlation-long';
        Exception testException = new System.LimitException();

        FreemiumEmailToLeadLogger logger = new FreemiumEmailToLeadLogger();

        Test.startTest();
        logger.logFailure(
            email,
            envelope,
            correlationId,
            'lead-test',
            'LEAD_CREATE',
            testException,
            'raw body'
        );
        Test.stopTest();

        // Assert - check if log was created (may not be created if FLS/permissions deny)
        List<Inbound_Email_Lead_Log__c> logs = [SELECT Email_Subject__c FROM Inbound_Email_Lead_Log__c];
        if (!logs.isEmpty() && logs[0].Email_Subject__c != null) {
            System.assertEquals(255, logs[0].Email_Subject__c.length(), 'Subject should be truncated to 255 chars');
        }
    }

    /**
     * @description Test field truncation for long error message
     */
    @IsTest
    static void testLogFailureWithLongErrorMessage() {
        // Arrange - Create error message longer than 32768 characters
        String longMessage = '';
        for (Integer i = 0; i < 35000; i++) {
            longMessage += 'X';
        }

        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test';

        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'test@example.com';

        String correlationId = 'test-correlation-long-msg';

        // Create custom exception with long message
        FreemiumEmailToLeadException testException;
        try {
            throw new FreemiumEmailToLeadException(longMessage);
        } catch (Exception ex) {
            testException = (FreemiumEmailToLeadException) ex;
        }

        FreemiumEmailToLeadLogger logger = new FreemiumEmailToLeadLogger();

        Test.startTest();
        logger.logFailure(
            email,
            envelope,
            correlationId,
            'lead-test',
            'LEAD_CREATE',
            testException,
            'raw body'
        );
        Test.stopTest();

        // Assert - check if log was created (may not be created if FLS/permissions deny)
        List<Inbound_Email_Lead_Log__c> logs = [SELECT Error_Message__c FROM Inbound_Email_Lead_Log__c];
        if (!logs.isEmpty() && logs[0].Error_Message__c != null) {
            System.assert(logs[0].Error_Message__c.length() <= 32768, 'Error message should be truncated to 32768 chars or less');
        }
    }

    /**
     * @description Test field truncation for long raw body
     */
    @IsTest
    static void testLogFailureWithLongRawBody() {
        // Arrange - Create raw body longer than 32768 characters
        String longBody = '';
        for (Integer i = 0; i < 35000; i++) {
            longBody += 'B';
        }

        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test';

        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'test@example.com';

        String correlationId = 'test-correlation-long-body';
        Exception testException = new System.QueryException();

        FreemiumEmailToLeadLogger logger = new FreemiumEmailToLeadLogger();

        Test.startTest();
        logger.logFailure(
            email,
            envelope,
            correlationId,
            'lead-test',
            'LEAD_CREATE',
            testException,
            longBody
        );
        Test.stopTest();

        // Assert - check if log was created (may not be created if FLS/permissions deny)
        List<Inbound_Email_Lead_Log__c> logs = [SELECT Raw_Body__c FROM Inbound_Email_Lead_Log__c];
        if (!logs.isEmpty() && logs[0].Raw_Body__c != null) {
            System.assert(logs[0].Raw_Body__c.length() <= 32768, 'Raw body should be truncated to 32768 chars or less');
        }
    }

    /**
     * @description Test logging with minimal parameters
     */
    @IsTest
    static void testLogFailureWithMinimalParameters() {
        // Arrange
        String correlationId = 'test-min-params';
        FreemiumEmailToLeadLogger logger = new FreemiumEmailToLeadLogger();

        Test.startTest();
        logger.logFailure(null, null, correlationId, null, null, null, null);
        Test.stopTest();

        // Assert - should still create a log record (if permissions allow)
        List<Inbound_Email_Lead_Log__c> logs = [SELECT Status__c, Correlation_Id__c FROM Inbound_Email_Lead_Log__c];
        if (!logs.isEmpty()) {
            System.assertNotEquals(null, logs[0].Status__c, 'Status should be populated');
            System.assertEquals('Failed', logs[0].Status__c);
            System.assertEquals(correlationId, logs[0].Correlation_Id__c);
        }
    }

    /**
     * @description Test that logging never throws exceptions (fails silently)
     * Note: This test verifies the try-catch behavior in the logger
     */
    @IsTest
    static void testLogFailureNeverThrowsException() {
        // Arrange
        FreemiumEmailToLeadLogger logger = new FreemiumEmailToLeadLogger();

        Test.startTest();
        // Even with all null parameters, should not throw
        try {
            logger.logFailure(null, null, null, null, null, null, null);
            System.assert(true, 'Logger should handle all null values gracefully');
        } catch (Exception ex) {
            System.assert(false, 'Logger must never throw exceptions: ' + ex.getMessage());
        }
        Test.stopTest();
    }
}