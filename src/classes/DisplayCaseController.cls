public with sharing class DisplayCaseController {
	
    @AuraEnabled
    public static Case getCaseFromId(Id idCase){
        list<Case> listCase = new list<Case>() ;
        if(idCase == null) {
            return [SELECT Id, Subject, Description, Status FROM Case LIMIT 1] ;
        } else{
            listCase = [SELECT Id, Subject, Description, Status FROM Case WHERE Id =: idCase] ;
        }
        
        if(!listCase.isEmpty()){
            return listCase[0] ;
        } else {
            return [SELECT Id, Subject, Description, Status FROM Case LIMIT 1] ;
        }
    }
}