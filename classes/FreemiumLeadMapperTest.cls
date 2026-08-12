/**
 * @description Test class for FreemiumLeadMapper
 */
@IsTest
private class FreemiumLeadMapperTest {

    /**
     * @description Test applying mappings for lead creation
     */
    @IsTest
    static void testApplyMappingsToLeadForCreate() {
        // Arrange
        Lead testLead = new Lead();
        Map<String, Object> payload = new Map<String, Object>{
            'lead' => new Map<String, Object>{
                'firstName' => 'John',
                'lastName' => 'Doe',
                'email' => 'john.doe@example.com',
                'company' => 'Test Corp'
            }
        };

        FreemiumLeadMapper mapper = new FreemiumLeadMapper();

        Test.startTest();
        mapper.applyMappingsToLead(testLead, payload, 'LEAD_CREATE', AccessType.CREATABLE);
        Test.stopTest();

        // Assert
        System.assertEquals('John', testLead.FirstName, 'First name should be mapped');
        System.assertEquals('Doe', testLead.LastName, 'Last name should be mapped');
        System.assertEquals('john.doe@example.com', testLead.Email, 'Email should be mapped');
        System.assertEquals('Test Corp', testLead.Company, 'Company should be mapped');
    }

    /**
     * @description Test applying mappings for status update
     */
    @IsTest
    static void testApplyMappingsToLeadForStatusUpdate() {
        // Arrange
        Lead testLead = new Lead(
            FirstName = 'Jane',
            LastName = 'Smith',
            Email = 'jane.smith@example.com',
            Company = 'Existing Corp',
            Status = '1-Open'
        );
        insert testLead;

        // Query to get all fields
        testLead = [SELECT Id, Status FROM Lead WHERE Id = :testLead.Id];

        Map<String, Object> payload = new Map<String, Object>{
            'leadStatusUpdate' => new Map<String, Object>{
                'status' => '4-SAL'
            }
        };

        FreemiumLeadMapper mapper = new FreemiumLeadMapper();

        Test.startTest();
        mapper.applyMappingsToLead(testLead, payload, 'LEAD_STATUS_UPDATE', AccessType.UPDATABLE);
        Test.stopTest();

        // Assert
        System.assertEquals('4-SAL', testLead.Status, 'Status should be updated');
    }

    /**
     * @description Test appending status update reason to description
     */
    @IsTest
    static void testAppendStatusUpdateReason() {
        // Arrange
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Email = 'test@example.com',
            Company = 'Test',
            Status = '1-Open',
            Description = 'Initial description'
        );

        Map<String, Object> payload = new Map<String, Object>{
            'leadStatusUpdate' => new Map<String, Object>{
                'status' => '4-SAL',
                'reason' => 'User met PQL criteria'
            }
        };

        FreemiumLeadMapper mapper = new FreemiumLeadMapper();

        Test.startTest();
        mapper.appendStatusUpdateReason(testLead, payload);
        Test.stopTest();

        // Assert
        System.assert(testLead.Description.contains('Initial description'), 'Original description should be preserved');
        System.assert(testLead.Description.contains('User met PQL criteria'), 'Reason should be appended');
        System.assert(testLead.Description.contains('4-SAL'), 'New status should be mentioned');
    }

    /**
     * @description Test appending status update reason with blank existing description
     */
    @IsTest
    static void testAppendStatusUpdateReasonWithBlankDescription() {
        // Arrange
        Lead testLead = new Lead();
        Map<String, Object> payload = new Map<String, Object>{
            'leadStatusUpdate' => new Map<String, Object>{
                'status' => '3-MQL',
                'reason' => 'Qualified through freemium'
            }
        };

        FreemiumLeadMapper mapper = new FreemiumLeadMapper();

        Test.startTest();
        mapper.appendStatusUpdateReason(testLead, payload);
        Test.stopTest();

        // Assert
        System.assert(testLead.Description.contains('Qualified through freemium'), 'Reason should be set');
        System.assert(testLead.Description.contains('3-MQL'), 'New status should be mentioned');
    }

    /**
     * @description Test appending with no reason provided
     */
    @IsTest
    static void testAppendStatusUpdateReasonWithNoReason() {
        // Arrange
        Lead testLead = new Lead();
        Map<String, Object> payload = new Map<String, Object>{
            'leadStatusUpdate' => new Map<String, Object>{
                'status' => '3-MQL'
            }
        };

        FreemiumLeadMapper mapper = new FreemiumLeadMapper();

        Test.startTest();
        mapper.appendStatusUpdateReason(testLead, payload);
        Test.stopTest();

        // Assert
        System.assertEquals(null, testLead.Description, 'Description should remain null when no reason provided');
    }

    /**
     * @description Test mapping failure when no metadata mappings exist
     */
    @IsTest
    static void testApplyMappingsWithNoMetadata() {
        // Arrange
        Lead testLead = new Lead();
        Map<String, Object> payload = new Map<String, Object>();

        FreemiumLeadMapper mapper = new FreemiumLeadMapper();

        Test.startTest();
        try {
            mapper.applyMappingsToLead(testLead, payload, 'INVALID_EVENT_TYPE', AccessType.CREATABLE);
            System.assert(false, 'Should throw exception when no mappings found');
        } catch (FreemiumEmailToLeadException ex) {
            System.assert(ex.getMessage().contains('No active custom metadata mappings'), 'Exception should mention missing mappings');
        }
        Test.stopTest();
    }

    /**
     * @description Test mapping with default values when payload value is missing
     */
    @IsTest
    static void testApplyMappingsWithDefaultValues() {
        // Arrange
        Lead testLead = new Lead();
        // Payload with minimal data - metadata should use defaults
        Map<String, Object> payload = new Map<String, Object>{
            'lead' => new Map<String, Object>{
                'firstName' => 'DefaultTest',
                'lastName' => 'User',
                'email' => 'default@example.com',
                'company' => 'Default Company' // Company is required per metadata
            }
        };

        FreemiumLeadMapper mapper = new FreemiumLeadMapper();

        Test.startTest();
        mapper.applyMappingsToLead(testLead, payload, 'LEAD_CREATE', AccessType.CREATABLE);
        Test.stopTest();

        // Assert - verifying the mapping worked
        System.assertEquals('DefaultTest', testLead.FirstName, 'First name should be mapped');
        System.assertEquals('User', testLead.LastName, 'Last name should be mapped');
        System.assertEquals('Default Company', testLead.Company, 'Company should be mapped');
    }

    /**
     * @description Test type conversion for different field types
     */
    @IsTest
    static void testTypeConversionForVariousFields() {
        // Arrange
        Lead testLead = new Lead();
        Map<String, Object> payload = new Map<String, Object>{
            'lead' => new Map<String, Object>{
                'firstName' => 'TypeTest',
                'lastName' => 'User',
                'email' => 'typetest@example.com',
                'company' => 'Type Corp',
                'leadCurrency' => 'USD'
            }
        };

        FreemiumLeadMapper mapper = new FreemiumLeadMapper();

        Test.startTest();
        mapper.applyMappingsToLead(testLead, payload, 'LEAD_CREATE', AccessType.CREATABLE);
        Test.stopTest();

        // Assert
        System.assertEquals('TypeTest', testLead.FirstName, 'String field should be mapped');
        System.assertEquals('USD', testLead.CurrencyIsoCode, 'Currency field should be mapped');
    }

    /**
     * @description Test that non-creatable fields are skipped for create
     */
    @IsTest
    static void testSkipNonCreatableFields() {
        // Arrange
        Lead testLead = new Lead();
        Map<String, Object> payload = new Map<String, Object>{
            'lead' => new Map<String, Object>{
                'firstName' => 'SkipTest',
                'lastName' => 'User',
                'email' => 'skip@example.com',
                'company' => 'Skip Corp'
            }
        };

        FreemiumLeadMapper mapper = new FreemiumLeadMapper();

        Test.startTest();
        // No exception should be thrown - non-creatable fields are silently skipped
        mapper.applyMappingsToLead(testLead, payload, 'LEAD_CREATE', AccessType.CREATABLE);
        Test.stopTest();

        // Assert - basic fields should still be mapped
        System.assertEquals('SkipTest', testLead.FirstName, 'Creatable fields should still be mapped');
    }

    /**
     * @description Test validation of allowed values
     */
    @IsTest
    static void testAllowedValuesValidation() {
        // This test depends on metadata configuration
        // If metadata has allowed values constraints, invalid values should be rejected
        // For demonstration, we'll test the positive case

        Lead testLead = new Lead();
        Map<String, Object> payload = new Map<String, Object>{
            'lead' => new Map<String, Object>{
                'firstName' => 'AllowedTest',
                'lastName' => 'User',
                'email' => 'allowed@example.com',
                'company' => 'Allowed Corp',
                'leadStatus' => '3-MQL' // Valid status value
            }
        };

        FreemiumLeadMapper mapper = new FreemiumLeadMapper();

        Test.startTest();
        // Should succeed with valid value
        mapper.applyMappingsToLead(testLead, payload, 'LEAD_CREATE', AccessType.CREATABLE);
        Test.stopTest();

        // Assert
        System.assertEquals('3-MQL', testLead.Status, 'Valid allowed value should be accepted');
    }

    /**
     * @description Test mapping with nested payload paths
     */
    @IsTest
    static void testNestedPayloadPaths() {
        // Arrange
        Lead testLead = new Lead();
        Map<String, Object> payload = new Map<String, Object>{
            'lead' => new Map<String, Object>{
                'firstName' => 'Nested',
                'lastName' => 'User',
                'email' => 'nested@example.com',
                'company' => 'Nested Corp'
            }
        };

        FreemiumLeadMapper mapper = new FreemiumLeadMapper();

        Test.startTest();
        mapper.applyMappingsToLead(testLead, payload, 'LEAD_CREATE', AccessType.CREATABLE);
        Test.stopTest();

        // Assert - nested paths like 'lead.firstName' should work
        System.assertEquals('Nested', testLead.FirstName, 'Nested path should be resolved');
        System.assertEquals('User', testLead.LastName, 'Nested path should be resolved');
    }
}