trigger DeleteChildrenFromOppty on Opportunity (before insert, before update, after insert, after update) {
	
    if(Trigger.isAfter && Trigger.isUpdate){
        set<Id> setOpportunityIds = new set<Id>() ;
        for(Opportunity opp : Trigger.new){
            if((!opp.isWon && opp.isClosed) && !(!Trigger.oldMap.get(opp.Id).isWon && Trigger.oldMap.get(opp.Id).isClosed)){
                setOpportunityIds.add(opp.Id) ;
            }
        }
        if(!setOpportunityIds.isEmpty())
            delete([SELECT Id from Vehicle__c WHERE Opportunity__c IN: setOpportunityIds]) ;
    }
}