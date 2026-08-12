@isTest
public class SampleTestClass {
    @isTest static void testMethod1() {
        System.assertEquals(1, 1);
    }

    @isTest static void testMethod2() {
        System.assert(true);
    }
}