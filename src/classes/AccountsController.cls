public class AccountsController {
	@AuraEnabled
    public static list<Account> getAccounts(){
        return [SELECT Id, Name, Industry, Type, NumberOfEmployees, TickerSymbol, Phone FROM Account ORDER BY createdDate DESC];
    }
}