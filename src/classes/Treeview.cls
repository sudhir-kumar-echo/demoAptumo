public class Treeview

{
    public list<Childrecords> Assigning1{get;set;}
    public integer i;
    public string AccountName{get;set;}
    public class Childrecords
    {
        public list<contact> contactsrecords{get;set;}
        public Account Accountrecords{get;set;}
        public Childrecords(Account acc,list<contact> con)
        {
            Accountrecords= acc;
            contactsrecords = con;
        }
    
    }
    public list<Childrecords> getmethoddemo()
    {
        Assigning1 = new list<Childrecords>();
        list<Account> acc1 = new list<Account>();
        AccountName = '%'+AccountName+'%';
        string AccountName1 = AccountName ;
        if(AccountName1 !='%null%' )
        {
            acc1 = [select id,Name,Rating,Phone from Account where Name LIKE:AccountName1 limit 50];
        }
        else
        {
            acc1 = [select id,Name,Rating,Phone from Account limit 50];
        }
        for(integer i=0;i<acc1.size();i++)
        {
            list<Contact> Con2 = [Select id,LastName,Phone,AccountID,Email from contact where AccountID=:acc1[i].ID];
            Assigning1.add(new Childrecords(acc1[i],Con2));
        }  
        return Assigning1;  
    }
}