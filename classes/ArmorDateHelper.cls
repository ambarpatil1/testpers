public with sharing class ArmorDateHelper {

    public static Date getCurrentDate() {
        return Date.today();
    }

    public static Date getNextWeek() {
        return Date.today().addDays(7);
    }

    public static Date getPreviousMonth() {
        return Date.today().addMonths(-1);
    }

    public static Integer daysBetween(Date startDate, Date endDate) {
        return startDate.daysBetween(endDate);
    }

    public static Datetime getCurrentDateTime() {
        return System.now();
    }
}