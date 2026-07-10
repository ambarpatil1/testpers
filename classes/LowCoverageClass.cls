public class LowCoverageClass {

    public static String categorizeAccount(Decimal revenue, Boolean isActive) {

        if (revenue == null) {
            return 'No Revenue';
        }

        String category = '';

        if (revenue > 1000000) {
            category = 'Enterprise';
        } else if (revenue > 500000) {
            category = 'Mid Market';
        } else if (revenue > 100000) {
            category = 'Small Business';
        } else {
            category = 'Startup';
        }

        if (isActive) {
            category += ' - Active';
        } else {
            category += ' - Inactive';
        }

        // Extra unused logic to reduce coverage
        if (revenue < 0) {
            category = 'Invalid Revenue';
        }

        return category;
    }
}