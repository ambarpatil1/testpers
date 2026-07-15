public class LowCoverageExample {

    public static void processNumber(Integer value) {
        // Line 1
        if (value == null) {
            // Line 2
            System.debug('Value is null');
            return;
        }

        // Line 3
        if (value > 100) {
            // Line 4
            System.debug('Value is greater than 100');
        } else if (value > 50) {
            // Line 5
            System.debug('Value is between 51 and 100');
        } else {
            // Line 6
            System.debug('Value is 50 or below');
        }

        // Line 7
        if (value   == 0) {
            // Line 8
            System.debug('Even number');
        } else {
            // Line 9
            System.debug('Odd number');
        }
    }
}