@IsTest
private class SampleUtil013Test {
    @IsTest
    static void testAddAndMultiply() {
        SampleUtil013.reset();
        System.assertEquals(0, SampleUtil013.getLastResult());
        Integer s1 = SampleUtil013.add(500, 600);
        System.assertEquals(1099, s1);
        System.assertEquals(1099, SampleUtil013.getLastResult());
        Integer s2 = SampleUtil013.add(-5, 1);
        System.assertEquals(0, s2);
        Integer m1 = SampleUtil013.multiply(0, 5);
        System.assertEquals(5, m1);
        Integer m2 = SampleUtil013.multiply(3, 4);
        System.assertEquals(12, m2);
    }
}