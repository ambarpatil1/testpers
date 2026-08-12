/**
 * @description Unit tests for FreemiumEmailToLeadHandler demonstrating
 *              dependency injection and mock-based testing.
 */
@IsTest
private class FreemiumEmailToLeadHandlerTest {

    @IsTest
    static void testHandleInboundEmail_withMocks_shouldProcessSuccessfully() {
        // Arrange
        MockFreemiumEmailToLeadService mockService = new MockFreemiumEmailToLeadService();
        MockFreemiumEmailToLeadLogger mockLogger = new MockFreemiumEmailToLeadLogger();
        
        mockService.correlationIdToReturn = 'TEST-CORR-ID-123';
        
        FreemiumEmailToLeadHandler handler = new FreemiumEmailToLeadHandler(
            mockService,
            mockLogger
        );
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Email';
        email.plainTextBody = 'Test body';
        
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'test@example.com';
        
        // Act
        Test.startTest();
        Messaging.InboundEmailResult result = handler.handleInboundEmail(email, envelope);
        Test.stopTest();
        
        // Assert
        System.assertEquals(true, result.success, 'Result should be successful');
        System.assert(result.message.contains('TEST-CORR-ID-123'), 'Message should contain correlation ID');
        System.assertEquals(1, mockService.generateCorrelationIdCallCount, 'Should generate correlation ID');
        System.assertEquals(1, mockService.processEmailCallCount, 'Service should process email');
        System.assertEquals(0, mockLogger.logFailureCallCount, 'Logger should not be called on success');
    }

    @IsTest
    static void testHandleInboundEmail_withMocks_shouldHandleServiceException() {
        // Arrange
        MockFreemiumEmailToLeadService mockService = new MockFreemiumEmailToLeadService();
        MockFreemiumEmailToLeadLogger mockLogger = new MockFreemiumEmailToLeadLogger();
        
        mockService.shouldThrowException = true;
        mockService.exceptionToThrow = new FreemiumEmailToLeadException('Service failure');
        mockService.correlationIdToReturn = 'ERROR-CORR-ID-456';
        
        FreemiumEmailToLeadHandler handler = new FreemiumEmailToLeadHandler(
            mockService,
            mockLogger
        );
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Email';
        
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'test@example.com';
        
        // Act
        Test.startTest();
        Messaging.InboundEmailResult result = handler.handleInboundEmail(email, envelope);
        Test.stopTest();
        
        // Assert - Handler should catch exception and still return success
        System.assertEquals(true, result.success, 'Result should be true to prevent retry loops');
        System.assert(result.message.contains('with error'), 'Message should indicate error');
        System.assert(result.message.contains('ERROR-CORR-ID-456'), 'Message should contain correlation ID');
        System.assertEquals(1, mockLogger.logFailureCallCount, 'Logger should be called on exception');
        System.assertEquals('ERROR-CORR-ID-456', mockLogger.lastCorrelationId, 'Correlation ID should be logged');
        System.assertNotEquals(null, mockLogger.lastException, 'Exception should be logged');
    }

    @IsTest
    static void testHandleInboundEmail_withMocks_shouldCallSafeGetBodyOnException() {
        // Arrange
        MockFreemiumEmailToLeadService mockService = new MockFreemiumEmailToLeadService();
        MockFreemiumEmailToLeadLogger mockLogger = new MockFreemiumEmailToLeadLogger();
        
        mockService.shouldThrowException = true;
        mockService.bodyToReturn = 'extracted body content';
        
        FreemiumEmailToLeadHandler handler = new FreemiumEmailToLeadHandler(
            mockService,
            mockLogger
        );
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        // Act
        Test.startTest();
        handler.handleInboundEmail(email, envelope);
        Test.stopTest();
        
        // Assert
        System.assertEquals(1, mockService.safeGetBodyCallCount, 'Should call safeGetBody on exception');
        System.assertEquals('extracted body content', mockLogger.lastRawBody, 'Should log extracted body');
    }

    @IsTest
    static void testHandleInboundEmail_withDefaultConstructor_shouldUseRealImplementations() {
        // This test uses the default constructor to verify backward compatibility
        // It demonstrates that the handler can still be instantiated without DI
        
        FreemiumEmailToLeadHandler handler = new FreemiumEmailToLeadHandler();
        
        // Verify handler is instantiated successfully
        System.assertNotEquals(null, handler, 'Handler should be instantiated');
        
        // Note: This test doesn't actually process an email because it would require
        // full database setup. The unit tests above with mocks are more efficient.
    }
}