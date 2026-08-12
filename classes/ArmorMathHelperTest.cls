@IsTest
private class ArmorMathHelperTest {

    @IsTest
    static void testSquare() {
        Test.startTest();
        Integer result = ArmorMathHelper.square(5);
        Test.stopTest();

        System.assertEquals(25, result);
    }

    @IsTest
    static void testCube() {
        Test.startTest();
        Integer result = ArmorMathHelper.cube(4);
        Test.stopTest();

        System.assertEquals(64, result);
    }

    @IsTest
    static void testAverage() {
        List<Integer> numbers = new List<Integer>{10, 20, 30, 40};

        Test.startTest();
        Decimal result = ArmorMathHelper.average(numbers);
        Test.stopTest();

        System.assertEquals(25, result);
    }

    @IsTest
    static void testAverageEmptyList() {
        List<Integer> numbers = new List<Integer>();

        Test.startTest();
        Decimal result = ArmorMathHelper.average(numbers);
        Test.stopTest();

        System.assertEquals(0, result);
    }

    @IsTest
    static void testIsEven() {
        Test.startTest();
        Boolean evenResult = ArmorMathHelper.isEven(8);
        Boolean oddResult = ArmorMathHelper.isEven(9);
        Test.stopTest();

        System.assertEquals(true, evenResult);
        System.assertEquals(false, oddResult);
    }
}