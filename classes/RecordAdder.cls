public with sharing class RecordAdder {
    public RecordAdder() {

    }

    public static void addRecords(Integer N)
    {
        List<Intern__c> records = new List<Intern__c>();
        Integer i = 1; //counter
        while(i <= N)
        {
           
            Intern__c intern = new Intern__c();
            intern.Name = 'Intern ' + i;
            
            records.add(intern);
            i++;
        }
        System.debug('The interns to be added are :' + records);
        insert records;
    }
}