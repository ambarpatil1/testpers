@IsTest
private class POC_InvocableActionTest {

    @IsTest
    static void testRun_SingleRequest() {
        POC_InvocableAction.Request req = new POC_InvocableAction.Request();
        req.firstName = 'David';
        req.lastName = 'Fernandez';
        req.email = 'david.fernandez@autorabit.com';
        req.department = 'Engineering';
        req.comments = 'POC test run';

        List<POC_InvocableAction.Request> requests = new List<POC_InvocableAction.Request>{ req };

        Test.startTest();
        List<POC_InvocableAction.Result> results = POC_InvocableAction.run(requests);
        Test.stopTest();

        System.assertNotEquals(null, results, 'Results should not be null');
        System.assertEquals(1, results.size(), 'One result should be returned');

        POC_InvocableAction.Result res = results[0];
        System.assertEquals(true, res.success, 'Success should be true');
        System.assertNotEquals(null, res.message, 'Message should not be null');
        System.assert(res.message.contains('David Fernandez'), 'Message should include full name');
        System.assert(res.message.contains('Dept: Engineering'), 'Message should include department');
        System.assert(res.message.contains('Email: david.fernandez@autorabit.com'), 'Message should include email');
    }

    @IsTest
    static void testRun_MultipleRequests() {
        POC_InvocableAction.Request req1 = new POC_InvocableAction.Request();
        req1.firstName = 'John';
        req1.lastName = 'Doe';
        req1.email = 'john.doe@example.com';
        req1.department = 'Sales';

        POC_InvocableAction.Request req2 = new POC_InvocableAction.Request();
        req2.firstName = 'Jane';
        req2.lastName = 'Smith';
        req2.email = 'jane.smith@example.com';
        req2.department = 'Support';

        List<POC_InvocableAction.Request> requests =
                new List<POC_InvocableAction.Request>{ req1, req2 };

        Test.startTest();
        List<POC_InvocableAction.Result> results = POC_InvocableAction.run(requests);
        Test.stopTest();

        System.assertEquals(2, results.size(), 'Two results should be returned');
        System.assertEquals(true, results[0].success, 'First result should be successful');
        System.assertEquals(true, results[1].success, 'Second result should be successful');
        System.assert(results[0].message.contains('John Doe'), 'First message should include first record name');
        System.assert(results[1].message.contains('Jane Smith'), 'Second message should include second record name');
    }

    @IsTest
    static void testRun_OptionalFieldsBlank() {
        POC_InvocableAction.Request req = new POC_InvocableAction.Request();
        req.firstName = 'Only';
        req.lastName = 'Required';
        req.email = null;
        req.department = '';
        req.comments = null;

        List<POC_InvocableAction.Request> requests = new List<POC_InvocableAction.Request>{ req };

        Test.startTest();
        List<POC_InvocableAction.Result> results = POC_InvocableAction.run(requests);
        Test.stopTest();

        System.assertEquals(1, results.size(), 'One result should be returned');
        System.assertEquals(true, results[0].success, 'Result should be successful');
        System.assert(results[0].message.contains('Only Required'), 'Message should include required fields');
        System.assert(!results[0].message.contains('Dept:'), 'Message should not include blank department');
        System.assert(!results[0].message.contains('Email:'), 'Message should not include blank email');
    }
}