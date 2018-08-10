global with sharing class AccountJavascriptRemoter {
    
    public String sAccountName { get; set; }
    public static Account account { get ; set ; }
    
    public AccountJavascriptRemoter () {} 
    
    @RemoteAction
    global static Account getAccount(String sAccountName) {
        system.debug('AccountJavascriptRemoter.getAccount.sAccountName:: ' + sAccountName) ;
        account = [Select Id, Name, Phone, Type, NumberOfEmployees from Account Where Name =: sAccountName] ;
        system.debug('AccountJavascriptRemoter.account :: ' + account ) ;
        return account ;
    }
}