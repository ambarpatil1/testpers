public with sharing class POC_InvocableAction {

    public class Request {
        @InvocableVariable(label='First Name' required=true)
        public String firstName;

        @InvocableVariable(label='Last Name' required=true)
        public String lastName;

        @InvocableVariable(label='Email')
        public String email;

        @InvocableVariable(label='Department')
        public String department;

        @InvocableVariable(label='Comments')
        public String comments;
    }

    public class Result {
        @InvocableVariable(label='Message')
        public String message;

        @InvocableVariable(label='Success')
        public Boolean success;
    }

    @InvocableMethod(label='POC Create Message' description='POC invocable action for Flow testing')
    public static List<Result> run(List<Request> requests) {
        List<Result> results = new List<Result>();

        for (Request req : requests) {
            Result res = new Result();
            res.success = true;
            res.message =
                    'POC executed for ' +
                            req.firstName + ' ' + req.lastName +
                            (String.isNotBlank(req.department) ? ' | Dept: ' + req.department : '') +
                            (String.isNotBlank(req.email) ? ' | Email: ' + req.email : '');
            results.add(res);
        }

        return results;
    }
}