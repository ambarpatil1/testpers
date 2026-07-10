public with sharing class Demo_Util {

    public static String sayHello(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name + '!';
    }

    public static Decimal add(Decimal a, Decimal b) {
        return (a == null ? 0 : a) + (b == null ? 0 : b);
    }

    public static List<String> getActiveUserNames() {
        List<String> names = new List<String>();
        for (User u : [SELECT Name, IsActive FROM User WHERE IsActive = true LIMIT 100]) {
            names.add(u.Name);
        }
        return names;
    }
}