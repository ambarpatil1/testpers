@IsTest
private class HelloWorldTest {
//tessst
    @IsTest
    static void testHello() {

        HelloWorld helloWorld = new HelloWorld();

        Test.startTest();
        String result = helloWorld.hello();
        Test.stopTest();

        System.assertEquals('Hello World!', result);
    }
}