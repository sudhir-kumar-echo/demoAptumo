trigger AddErrorTrigger on Expense__c (before insert, before update) {
	
    for(Expense__c exp : Trigger.New){
        system.debug('::Before AddError');
        exp.Amount__c.addError('You got an error here') ;
        system.debug('::After AddError');
        exp.Amount__c = 100 ;
    }
}