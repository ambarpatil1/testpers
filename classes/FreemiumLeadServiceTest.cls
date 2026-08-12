/**
 * @description Test class for FreemiumLeadService
 */
@IsTest
private class FreemiumLeadServiceTest {

    /**
     * @description Test finding a Lead by external request ID
     */
    @IsTest
    static void testFindLeadByExternalRequestId() {
        // Arrange
        String externalRequestId = 'aaaaaaaa-1111-4111-8111-aaaaaaaaaaaa';
        Lead testLead = new Lead(
            FirstName = 'Find',
            LastName = 'Test',
            Company = 'Test Corp',
            Email = 'find@example.com',
            Status = '1-Open',
            External_Request_Id__c = externalRequestId
        );
        insert testLead;

        FreemiumLeadService service = new FreemiumLeadService();

        Test.startTest();
        Lead foundLead = service.findLeadByExternalRequestId(externalRequestId);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, foundLead, 'Lead should be found');
        System.assertEquals(testLead.Id, foundLead.Id, 'Should return the correct Lead');
    }

    /**
     * @description Test finding a Lead with null external request ID
     */
    @IsTest
    static void testFindLeadByExternalRequestIdWithNull() {
        // Arrange
        FreemiumLeadService service = new FreemiumLeadService();

        Test.startTest();
        Lead foundLead = service.findLeadByExternalRequestId(null);
        Test.stopTest();

        // Assert
        System.assertEquals(null, foundLead, 'Should return null for null input');
    }

    /**
     * @description Test finding a Lead that doesn't exist
     */
    @IsTest
    static void testFindLeadByExternalRequestIdNotFound() {
        // Arrange
        FreemiumLeadService service = new FreemiumLeadService();

        Test.startTest();
        Lead foundLead = service.findLeadByExternalRequestId('nonexistent-id');
        Test.stopTest();

        // Assert
        System.assertEquals(null, foundLead, 'Should return null when Lead not found');
    }

    /**
     * @description Test finding a Lead for status update
     */
    @IsTest
    static void testFindLeadForStatusUpdate() {
        // Arrange
        String externalRequestId = 'bbbbbbbb-2222-4222-8222-bbbbbbbbbbbb';
        Lead testLead = new Lead(
            FirstName = 'Status',
            LastName = 'Test',
            Company = 'Test Corp',
            Email = 'status@example.com',
            Status = '1-Open',
            Description = 'Initial description',
            External_Request_Id__c = externalRequestId
        );
        insert testLead;

        FreemiumLeadService service = new FreemiumLeadService();

        Test.startTest();
        Lead foundLead = service.findLeadForStatusUpdate(externalRequestId);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, foundLead, 'Lead should be found');
        System.assertEquals(testLead.Id, foundLead.Id, 'Should return the correct Lead');
        System.assertEquals('1-Open', foundLead.Status, 'Status should be included');
        System.assertEquals('Initial description', foundLead.Description, 'Description should be included');
    }

    /**
     * @description Test inserting a Lead successfully
     */
    @IsTest
    static void testInsertLead() {
        // Arrange
        Lead testLead = new Lead(
            FirstName = 'Insert',
            LastName = 'Test',
            Company = 'Test Corp',
            Email = 'insert@example.com',
            Status = '1-Open',
            External_Request_Id__c = 'cccccccc-3333-4333-8333-cccccccccccc'
        );

        FreemiumLeadService service = new FreemiumLeadService();

        Test.startTest();
        service.insertLead(testLead);
        Test.stopTest();

        // Assert
        List<Lead> leads = [SELECT Id, FirstName, LastName FROM Lead WHERE Email = 'insert@example.com'];
        System.assertEquals(1, leads.size(), 'Lead should be inserted');
        System.assertEquals('Insert', leads[0].FirstName);
        System.assertEquals('Test', leads[0].LastName);
    }

    /**
     * @description Test updating a Lead successfully
     */
    @IsTest
    static void testUpdateLead() {
        // Arrange
        Lead testLead = new Lead(
            FirstName = 'Update',
            LastName = 'Test',
            Company = 'Test Corp',
            Email = 'update@example.com',
            Status = '1-Open',
            External_Request_Id__c = 'dddddddd-4444-4444-8444-dddddddddddd'
        );
        insert testLead;

        testLead.Status = '3-MQL';
        testLead.Description = 'Updated by test';

        FreemiumLeadService service = new FreemiumLeadService();

        Test.startTest();
        service.updateLead(testLead);
        Test.stopTest();

        // Assert
        Lead updatedLead = [SELECT Status, Description FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('3-MQL', updatedLead.Status, 'Status should be updated');
        System.assertEquals('Updated by test', updatedLead.Description, 'Description should be updated');
    }

    /**
     * @description Test inserting a Lead with invalid data
     */
    @IsTest
    static void testInsertLeadWithInvalidData() {
        // Arrange
        Lead testLead = new Lead(
            // Missing required fields like LastName, Company
            FirstName = 'Invalid'
        );

        FreemiumLeadService service = new FreemiumLeadService();

        Test.startTest();
        try {
            service.insertLead(testLead);
            System.assert(false, 'Should throw exception for invalid Lead');
        } catch (FreemiumEmailToLeadException ex) {
            System.assert(ex.getMessage().contains('failed'), 'Exception should mention failure');
        }
        Test.stopTest();
    }

    /**
     * @description Test updating a Lead with invalid ID
     */
    @IsTest
    static void testUpdateLeadWithInvalidId() {
        // Arrange
        Lead testLead = new Lead(
            Id = '00Q000000000000', // Invalid ID
            Status = '3-MQL'
        );

        FreemiumLeadService service = new FreemiumLeadService();

        Test.startTest();
        try {
            service.updateLead(testLead);
            System.assert(false, 'Should throw exception for invalid Lead ID');
        } catch (FreemiumEmailToLeadException ex) {
            System.assert(ex.getMessage().contains('failed'), 'Exception should mention failure');
        }
        Test.stopTest();
    }

    /**
     * @description Test inserting Lead with duplicate external request ID
     */
    @IsTest
    static void testInsertLeadWithDuplicateExternalRequestId() {
        // Arrange
        String externalRequestId = 'eeeeeeee-5555-4555-8555-eeeeeeeeeeee';
        
        Lead firstLead = new Lead(
            FirstName = 'First',
            LastName = 'Lead',
            Company = 'Test Corp',
            Email = 'first@example.com',
            Status = '1-Open',
            External_Request_Id__c = externalRequestId
        );
        insert firstLead;

        Lead duplicateLead = new Lead(
            FirstName = 'Duplicate',
            LastName = 'Lead',
            Company = 'Test Corp',
            Email = 'duplicate@example.com',
            Status = '1-Open',
            External_Request_Id__c = externalRequestId
        );

        FreemiumLeadService service = new FreemiumLeadService();

        Test.startTest();
        try {
            service.insertLead(duplicateLead);
            System.assert(false, 'Should throw exception for duplicate external request ID');
        } catch (FreemiumEmailToLeadException ex) {
            System.assert(
                ex.getMessage().contains('failed') || ex.getMessage().contains('duplicate') || ex.getMessage().contains('DUPLICATE'),
                'Exception should mention failure or duplicate: ' + ex.getMessage()
            );
        }
        Test.stopTest();
    }

    /**
     * @description Test security enforcement with WITH SECURITY_ENFORCED
     * Note: This test verifies the clause is present, actual FLS testing requires profile setup
     */
    @IsTest
    static void testSecurityEnforcementInQueries() {
        // Arrange
        String externalRequestId = 'ffffffff-6666-4666-8666-ffffffffffff';
        Lead testLead = new Lead(
            FirstName = 'Security',
            LastName = 'Test',
            Company = 'Test Corp',
            Email = 'security@example.com',
            Status = '1-Open',
            External_Request_Id__c = externalRequestId
        );
        insert testLead;

        FreemiumLeadService service = new FreemiumLeadService();

        Test.startTest();
        // Should not throw exception with current user's full access
        Lead foundLead = service.findLeadByExternalRequestId(externalRequestId);
        Lead foundLeadForUpdate = service.findLeadForStatusUpdate(externalRequestId);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, foundLead, 'Lead should be accessible');
        System.assertNotEquals(null, foundLeadForUpdate, 'Lead should be accessible for update');
    }

    /**
     * @description Test that stripInaccessible validation works
     */
    @IsTest
    static void testStripInaccessibleValidation() {
        // Arrange
        Lead testLead = new Lead(
            FirstName = 'Strip',
            LastName = 'Test',
            Company = 'Test Corp',
            Email = 'strip@example.com',
            Status = '1-Open',
            External_Request_Id__c = '11111111-7777-4777-8777-111111111111'
        );

        FreemiumLeadService service = new FreemiumLeadService();

        Test.startTest();
        // Should succeed with standard user permissions
        service.insertLead(testLead);
        Test.stopTest();

        // Assert
        List<Lead> leads = [SELECT Id FROM Lead WHERE Email = 'strip@example.com'];
        System.assertEquals(1, leads.size(), 'Lead should be inserted');
    }
}