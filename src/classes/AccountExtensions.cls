public with sharing class AccountExtensions {
    
    public Account oAccount ;
    
    public AccountExtensions(ApexPages.StandardController stdController){
        oAccount = [SELECT Id, Owner.Name FROM Account WHERE Id =: ApexPages.CurrentPage().getParameters().get('Id')] ;
    }
    public String accountOwner {
        get{
            if(accountOwner == null){
                accountOwner = oAccount.Owner.Name ;
            }
            return accountOwner ;
        }
        private set ;
    }
}