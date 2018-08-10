trigger UpdateAccountNameFromContactLastName on Contact (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    set<Id> setAccountIds = new set<Id>() ;
    if(Trigger.isInsert){
        for(Contact oContact : Trigger.New){
            if(oContact.lastName != null) { //although lastName is required field; still checking for null
                setAccountIds.add(oContact.accountId) ;  
            }
        }
        system.debug('after insert-setAccountIds:: ' + setAccountIds) ;
    }
    
    if(Trigger.isUpdate){
        for(Contact oContact : Trigger.New){
            if(oContact.lastName != null && oContact.lastName != Trigger.oldMap.get(oContact.Id).lastName) 
                setAccountIds.add(oContact.accountId) ;
        }
        system.debug('after update-setAccountIds:: ' + setAccountIds) ;
    }
    
    if(Trigger.isDelete){
        for(Contact oContact : Trigger.Old){
            if(oContact.lastName != null) 
                setAccountIds.add(oContact.accountId) ;
        }
        system.debug('after delete-setAccountIds:: ' + setAccountIds) ;
    }
    
    if(Trigger.isUndelete){
        for(Contact oContact : Trigger.new){
            if(oContact.lastName != null) 
                setAccountIds.add(oContact.accountId) ;
        }
        system.debug('after undelete-setAccountIds:: ' + setAccountIds) ;
    }

    if(!setAccountIds.isEmpty()){
        set<String> setContactName = new set<String>() ;
        list<Account> listAccountToUpdate = new list<Account>() ;
        list<Account> listAccount = [Select Id, Name, (Select Id, LastName from Contacts order by createddate) From Account Where Id IN: setAccountIds] ;
        if(listAccount != null && !listAccount.isEmpty()){
            for(Account oAccount : listAccount){
                for(Contact oContact : oAccount.Contacts){
                    if(!setContactName.contains(oContact.lastName)){
                        setContactName.add(oContact.lastName) ; 
                    }
                }
                list<String> listContactName = new list<String>() ;
                listContactName.addAll(setContactName) ;
                oAccount.Name = oAccount.Name.substringBefore(listContactName[0]) ;
                for(String lastName : setContactName){
                    oAccount.Name = oAccount.Name +  ' ' + lastName  ;
                }
                listAccountToUpdate.add(oAccount) ;
            }
        }
        if(!listAccountToUpdate.isEmpty()) update listAccountToUpdate ;
    }
}