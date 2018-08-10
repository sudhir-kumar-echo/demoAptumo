public with sharing class ExpenseController {
	@AuraEnabled
    public static list<Expense__c> getExpenses(){
        return [SELECT Id, name, Amount__c, Client__c, Reimbursed__c, CreatedDate, Date__c FROM Expense__c];
    }
}