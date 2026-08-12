public class ApexDemo4 {

    public static void runDemo() {
        try {
            Integer num = Integer.valueOf('9999');
            System.debug('Converted number: ' + num);
        } catch (Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
        }
    }
}