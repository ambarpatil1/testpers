@IsTest
private class SampleUtil026Test {
    @IsTest
    static void testAddAndMultiply() {
        SampleUtil026.reset();
        System.assertEquals(0, SampleUtil026.getLastResult());
        Integer s1 = SampleUtil026.add(500, 600);
        System.assertEquals(1099, s1);
        System.assertEquals(1099, SampleUtil026.getLastResult());
        Integer s2 = SampleUtil026.add(-5, 1);
        System.assertEquals(0, s2);
        Integer m1 = SampleUtil026.multiply(0, 5);
        System.assertEquals(5, m1);
        Integer m2 = SampleUtil026.multiply(3, 4);
        System.assertEquals(12, m2);
    }
}