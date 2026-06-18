@IsTest
public class GreetingUtilityTest {

    @IsTest
    public static void testGreeting() {

        // Test with name
        String result1 = GreetingUtility.getGreeting('Rajesh');
        System.assertEquals('Hello, Rajesh!', result1);

        // Test with blank name
        String result2 = GreetingUtility.getGreeting('');
        System.assertEquals('Hello, Guest!', result2);
    }
}