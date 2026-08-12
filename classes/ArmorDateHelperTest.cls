@IsTest
private class ArmorDateHelperTest {

    @IsTest
    static void testGetCurrentDate() {
        Test.startTest();
        Date currentDate = ArmorDateHelper.getCurrentDate();
        Test.stopTest();

        System.assertEquals(Date.today(), currentDate);
    }

    @IsTest
    static void testGetNextWeek() {
        Test.startTest();
        Date nextWeek = ArmorDateHelper.getNextWeek();
        Test.stopTest();

        System.assertEquals(Date.today().addDays(7), nextWeek);
    }

    @IsTest
    static void testGetPreviousMonth() {
        Test.startTest();
        Date previousMonth = ArmorDateHelper.getPreviousMonth();
        Test.stopTest();

        System.assertEquals(Date.today().addMonths(-1), previousMonth);
    }

    @IsTest
    static void testDaysBetween() {
        Date startDate = Date.today();
        Date endDate = startDate.addDays(15);

        Test.startTest();
        Integer days = ArmorDateHelper.daysBetween(startDate, endDate);
        Test.stopTest();

        System.assertEquals(15, days);
    }

    @IsTest
    static void testGetCurrentDateTime() {
        Test.startTest();
        Datetime currentDateTime = ArmorDateHelper.getCurrentDateTime();
        Test.stopTest();

        System.assertNotEquals(null, currentDateTime);
        System.assert(currentDateTime <= System.now());
    }
}