@IsTest
private class Demo_Util_Test {

    @IsTest
    static void testSayHello() {
        System.assertEquals('Hello, World!', Demo_Util.sayHello(null));
        System.assertEquals('Hello, Harshit!', Demo_Util.sayHello('Harshit'));
    }

    @IsTest
    static void testAdd() {
        System.assertEquals(5, Demo_Util.add(2, 3));
        System.assertEquals(3, Demo_Util.add(null, 3));
        System.assertEquals(0, Demo_Util.add(null, null));
    }

    @IsTest
    static void testGetActiveUserNames() {
        List<String> names = Demo_Util.getActiveUserNames();
        System.assertNotEquals(0, names.size(), 'There should be at least one active user');
    }
}