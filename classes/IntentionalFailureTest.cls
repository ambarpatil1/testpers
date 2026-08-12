@isTest
private class IntentionalFailureTest {

    @isTest
    static void forceAssertionFailure() {
        // This will always fail the test
        System.assert(false, 'This is an intentional test failure to validate deployment blocks.');
    }

    @isTest
    static void forceEqualsFailure() {
        // 1 does not equal 2, so this will fail
        System.assertEquals(1, 2, 'Intentional mismatch for testing purposes.');
    }
}