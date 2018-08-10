global with sharing class RemoteJavascript_Account{

    public String accountName {get; set;}
    public static Account account {get ; set;}
    public RemoteJavascript_Account() {}
    
    @RemoteAction
    global static Account getAccount(String accountName){
        account = [select Id, Name, Phone, Type,NumberOfEmployees from Account where Name=: accountName];
        return account;
    }
}