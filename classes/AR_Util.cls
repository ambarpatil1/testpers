// File: AR_Util.cls
public with sharing class AR_Util {
    public static String hello(String name) {
        return String.isBlank(name) ? 'Hello, World!' : 'Hello, ' + name + '!';
    }

    public static Decimal safeAdd(Decimal a, Decimal b) {
        return (a == null ? 0 : a) + (b == null ? 0 : b);
    }

    public static Integer activeUserCount() {
        return [SELECT COUNT() FROM User WHERE IsActive = true];
    }
}