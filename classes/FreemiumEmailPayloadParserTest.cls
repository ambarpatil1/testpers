/**
 * @description Test class for FreemiumEmailPayloadParser
 */
@IsTest
private class FreemiumEmailPayloadParserTest {

    /**
     * @description Test successful parsing of valid email
     */
    @IsTest
    static void testParseEmailWithValidPayload() {
        // Arrange
        String leadExternalRequestId = '6f3c9c55-4d4e-4f4a-bd38-88c8f6f14f20';
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody =
            'JSON_START\n' +
            '{' +
            '"sourceSystem":"freemium-java-app",' +
            '"leadExternalRequestId":"' + leadExternalRequestId + '",' +
            '"eventType":"LEAD_CREATE",' +
            '"lead":{"firstName":"John","lastName":"Doe"}' +
            '}' +
            '\nJSON_END';

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        FreemiumEmailPayloadParser.PayloadData result = parser.parseEmail(email);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, result, 'PayloadData should not be null');
        System.assertEquals('LEAD_CREATE', result.eventType, 'Event type should match');
        System.assertEquals(leadExternalRequestId, result.leadExternalRequestId, 'Lead external request ID should match');
        System.assertNotEquals(null, result.parsedPayload, 'Parsed payload should not be null');
    }

    /**
     * @description Test parsing with HTML body when plain text is not available
     */
    @IsTest
    static void testParseEmailWithHtmlBody() {
        // Arrange
        String leadExternalRequestId = 'aaaaaaaa-1111-4111-8111-bbbbbbbbbbbb';
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.htmlBody =
            '<html><body>JSON_START\n' +
            '{' +
            '"sourceSystem":"freemium-java-app",' +
            '"leadExternalRequestId":"' + leadExternalRequestId + '",' +
            '"eventType":"LEAD_STATUS_UPDATE"' +
            '}' +
            '\nJSON_END</body></html>';

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        FreemiumEmailPayloadParser.PayloadData result = parser.parseEmail(email);
        Test.stopTest();

        // Assert
        System.assertEquals('LEAD_STATUS_UPDATE', result.eventType);
        System.assertEquals(leadExternalRequestId, result.leadExternalRequestId);
    }

    /**
     * @description Test parsing without JSON markers
     */
    @IsTest
    static void testParseEmailWithoutMarkers() {
        // Arrange
        String leadExternalRequestId = 'bbbbbbbb-2222-4222-8222-cccccccccccc';
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody =
            '{' +
            '"sourceSystem":"freemium-java-app",' +
            '"leadExternalRequestId":"' + leadExternalRequestId + '",' +
            '"eventType":"LEAD_CREATE"' +
            '}';

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        FreemiumEmailPayloadParser.PayloadData result = parser.parseEmail(email);
        Test.stopTest();

        // Assert
        System.assertEquals('LEAD_CREATE', result.eventType);
        System.assertEquals(leadExternalRequestId, result.leadExternalRequestId);
    }

    /**
     * @description Test parsing failure with null email
     */
    @IsTest
    static void testParseEmailWithNullEmail() {
        // Arrange
        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        try {
            parser.parseEmail(null);
            System.assert(false, 'Should throw exception for null email');
        } catch (FreemiumEmailToLeadException ex) {
            System.assert(ex.getMessage().contains('null'), 'Exception message should mention null');
        }
        Test.stopTest();
    }

    /**
     * @description Test parsing failure with empty body
     */
    @IsTest
    static void testParseEmailWithEmptyBody() {
        // Arrange
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody = '';

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        try {
            parser.parseEmail(email);
            System.assert(false, 'Should throw exception for empty body');
        } catch (FreemiumEmailToLeadException ex) {
            System.assert(ex.getMessage().contains('empty'), 'Exception message should mention empty');
        }
        Test.stopTest();
    }

    /**
     * @description Test parsing failure with truncated plain text body
     */
    @IsTest
    static void testParseEmailWithTruncatedPlainText() {
        // Arrange
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody = '{"test":"data"}';
        email.plainTextBodyIsTruncated = true;

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        try {
            parser.parseEmail(email);
            System.assert(false, 'Should throw exception for truncated body');
        } catch (FreemiumEmailToLeadException ex) {
            System.assert(ex.getMessage().contains('truncated'), 'Exception message should mention truncated');
        }
        Test.stopTest();
    }

    /**
     * @description Test parsing failure with truncated HTML body
     */
    @IsTest
    static void testParseEmailWithTruncatedHtmlBody() {
        // Arrange
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.htmlBody = '<html>{"test":"data"}</html>';
        email.htmlBodyIsTruncated = true;

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        try {
            parser.parseEmail(email);
            System.assert(false, 'Should throw exception for truncated HTML body');
        } catch (FreemiumEmailToLeadException ex) {
            System.assert(ex.getMessage().contains('truncated'), 'Exception message should mention truncated');
        }
        Test.stopTest();
    }

    /**
     * @description Test parsing failure with invalid JSON
     */
    @IsTest
    static void testParseEmailWithInvalidJson() {
        // Arrange
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody = '{ "invalid": json }';

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        try {
            parser.parseEmail(email);
            System.assert(false, 'Should throw exception for invalid JSON');
        } catch (FreemiumEmailToLeadException ex) {
            System.assert(ex.getMessage().contains('Invalid JSON'), 'Exception message should mention invalid JSON');
        }
        Test.stopTest();
    }

    /**
     * @description Test parsing failure with unsupported source system
     */
    @IsTest
    static void testParseEmailWithInvalidSourceSystem() {
        // Arrange
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody =
            '{' +
            '"sourceSystem":"unknown-system",' +
            '"leadExternalRequestId":"aaaaaaaa-1111-4111-8111-aaaaaaaaaaaa",' +
            '"eventType":"LEAD_CREATE"' +
            '}';

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        try {
            parser.parseEmail(email);
            System.assert(false, 'Should throw exception for invalid source system');
        } catch (FreemiumEmailToLeadException ex) {
            System.assert(ex.getMessage().contains('sourceSystem'), 'Exception message should mention sourceSystem');
        }
        Test.stopTest();
    }

    /**
     * @description Test parsing failure with invalid UUID format
     */
    @IsTest
    static void testParseEmailWithInvalidUuid() {
        // Arrange
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody =
            '{' +
            '"sourceSystem":"freemium-java-app",' +
            '"leadExternalRequestId":"invalid-uuid",' +
            '"eventType":"LEAD_CREATE"' +
            '}';

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        try {
            parser.parseEmail(email);
            System.assert(false, 'Should throw exception for invalid UUID');
        } catch (FreemiumEmailToLeadException ex) {
            System.assert(ex.getMessage().contains('UUID'), 'Exception message should mention UUID');
        }
        Test.stopTest();
    }

    /**
     * @description Test parsing failure with missing event type
     */
    @IsTest
    static void testParseEmailWithMissingEventType() {
        // Arrange
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody =
            '{' +
            '"sourceSystem":"freemium-java-app",' +
            '"leadExternalRequestId":"aaaaaaaa-1111-4111-8111-aaaaaaaaaaaa"' +
            '}';

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        try {
            parser.parseEmail(email);
            System.assert(false, 'Should throw exception for missing event type');
        } catch (FreemiumEmailToLeadException ex) {
            System.assert(ex.getMessage().contains('eventType'), 'Exception message should mention eventType');
        }
        Test.stopTest();
    }

    /**
     * @description Test extracting nested values using dot notation
     */
    @IsTest
    static void testGetStringWithNestedPath() {
        // Arrange
        String leadExternalRequestId = 'cccccccc-3333-4333-8333-dddddddddddd';
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody =
            '{' +
            '"sourceSystem":"freemium-java-app",' +
            '"leadExternalRequestId":"' + leadExternalRequestId + '",' +
            '"eventType":"LEAD_CREATE",' +
            '"lead":{"firstName":"Jane","lastName":"Doe"}' +
            '}';

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        FreemiumEmailPayloadParser.PayloadData result = parser.parseEmail(email);
        String firstName = parser.getString(result.parsedPayload, 'lead.firstName');
        String lastName = parser.getString(result.parsedPayload, 'lead.lastName');
        Test.stopTest();

        // Assert
        System.assertEquals('Jane', firstName, 'First name should be extracted');
        System.assertEquals('Doe', lastName, 'Last name should be extracted');
    }

    /**
     * @description Test tryExtractString with valid payload
     */
    @IsTest
    static void testTryExtractStringWithValidPayload() {
        // Arrange
        String rawBody =
            '{' +
            '"sourceSystem":"freemium-java-app",' +
            '"leadExternalRequestId":"dddddddd-4444-4444-8444-eeeeeeeeeeee",' +
            '"eventType":"LEAD_CREATE"' +
            '}';

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        String eventType = parser.tryExtractString(rawBody, 'eventType');
        Test.stopTest();

        // Assert
        System.assertEquals('LEAD_CREATE', eventType);
    }

    /**
     * @description Test tryExtractString with invalid payload returns null
     */
    @IsTest
    static void testTryExtractStringWithInvalidPayload() {
        // Arrange
        String rawBody = 'invalid json {';

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        String result = parser.tryExtractString(rawBody, 'eventType');
        Test.stopTest();

        // Assert
        System.assertEquals(null, result, 'Should return null for invalid payload');
    }

    /**
     * @description Test safeGetBody with plain text
     */
    @IsTest
    static void testSafeGetBodyWithPlainText() {
        // Arrange
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody = 'Plain text content';
        email.htmlBody = '<html>HTML content</html>';

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        String body = parser.safeGetBody(email);
        Test.stopTest();

        // Assert
        System.assertEquals('Plain text content', body, 'Should prefer plain text over HTML');
    }

    /**
     * @description Test safeGetBody with only HTML
     */
    @IsTest
    static void testSafeGetBodyWithOnlyHtml() {
        // Arrange
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.htmlBody = '<html><body>HTML content</body></html>';

        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        String body = parser.safeGetBody(email);
        Test.stopTest();

        // Assert
        System.assertEquals('HTML content', body, 'Should strip HTML tags');
    }

    /**
     * @description Test safeGetBody with null email
     */
    @IsTest
    static void testSafeGetBodyWithNullEmail() {
        // Arrange
        FreemiumEmailPayloadParser parser = new FreemiumEmailPayloadParser();

        Test.startTest();
        String body = parser.safeGetBody(null);
        Test.stopTest();

        // Assert
        System.assertEquals(null, body, 'Should return null for null email');
    }
}