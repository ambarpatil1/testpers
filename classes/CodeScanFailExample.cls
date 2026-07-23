public class CodeScanFailExample {

       private static final String API_KEY = 'abcd1234-SECRET-KEY';

    public static void execute(String accountName, String email) {
           String query = 'SELECT Id, Name FROM Account WHERE Name = \'' + accountName + '\'';
        List<Account> accounts = Database.query(query);

               for (Account acc : accounts) {
            acc.Description = 'Updated for ' + email;
            update acc; // DML inside loop
        }

        Contact con = new Contact(LastName = 'TestContact', Email = email);
        insert con;

        try {
            Integer x = 1 / 0;
        } catch (Exception e) {
            // Ignoring exception
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.insecureexample.com');
        req.setMethod('GET');
        new Http().send(req);
    }
}