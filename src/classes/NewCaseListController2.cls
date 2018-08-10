public with sharing class NewCaseListController2{
    public NewCaseListController2(){}
    public list<Case> NewCases {
        
        get{
            if(NewCases == null)
                NewCases = new list<Case>() ;
            else
                NewCases = [SELECT Id, CaseNumber,  Status FROM Case
                            WHERE
                            Status = 'New'] ;
                system.debug('NewCases::' + NewCases) ;
            return NewCases ;
        }
        set ;
    }
}