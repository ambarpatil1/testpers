public class AccDB {
    
    public static void newacc() {
        list<Account> li = new list<Account>();
        
        Account acc = new Account();
        acc.Name = 'vq1';
        acc.Rating = 'Hot';
        acc.Phone  = '9849898192'  ;
        li.add(acc);
        
        Account acc1 = new Account();
        acc1.Name = 'vq2';
        acc1.Rating = 'cold';
        acc1.Phone  = '9839829892'  ;
        li.add(acc1);
        
        Account acc2 = new Account();
        acc2.Name = 'vq3';
        acc2.Rating = 'warm';
        acc2.Phone  = '9839893892';
        li.add(acc2);
        
        insert li;
        //system.debug(li);
        
    }
    
    public static void dbcheck(){
        list<account> todayaccount = new list<account>();
        todayaccount = [SELECT id, name, rating FROM account WHERE createddate = today];
        system.debug(todayaccount);
        delete todayaccount;
        
    }
   
}