trigger RollUpContactCountOnAccount on Contact (after insert, after update, after delete) {
    
    set<Id> setAccountIds = new set<Id>() ;
    list<Account> listAccount = new list<Account>() ;
    list<Account> listAccountToUpdate = new list<Account>() ;
    list<AggregateResult> listContactAggregateResult = new list<AggregateResult>() ;
    
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Contact oContact : Trigger.New){
            setAccountIds.add(oContact.AccountId) ;
        }
    }
    
    
    if(Trigger.isDelete){
        for(Contact oContact : Trigger.old){
            setAccountIds.add(oContact.AccountId) ;
        }
    }
    
    system.debug('Sudhir setAccountIds:: ' + setAccountIds) ;
    
    if(!setAccountIds.isEmpty()){
        listAccount = [SELECT Id, Name, Contact_Count__c from Account WHERE Id IN: setAccountIds] ;
        
        listContactAggregateResult = [SELECT AccountId, Count(Id) FROM Contact WHERE AccountId IN: setAccountIds GROUP BY AccountId] ;
    }
    
    system.debug('Sudhir listAccount:: ' + listAccount) ;
    system.debug('Sudhir listContactAggregateResult:: ' + listContactAggregateResult) ;
    
    if(!listContactAggregateResult.isEmpty()){
        for(AggregateResult oContactAggregateResult : listContactAggregateResult){
            for(Account oAccount : listAccount){
                if(oContactAggregateResult.get('AccountId') == oAccount.Id){
                    oAccount.Contact_Count__c = String.valueOf(oContactAggregateResult.get('expr0')) ;
                }
                listAccountToUpdate.add(oAccount) ;
            }
        }
    }
    system.debug('Sudhir listAccountToUpdate:: ' + listAccountToUpdate) ;
    
    if(!listAccountToUpdate.isEmpty()){
        update listAccountToUpdate ; 
    }
    
}