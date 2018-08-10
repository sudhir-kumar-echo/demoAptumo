@isTest
public class SLDS_ProgressBarComponentController_Test {
    public static testmethod void testSLDS_ProgressBarComponentController(){
        
        SLDS_ProgressBarComponentController oSLDS_ProgressBarComponentController = new SLDS_ProgressBarComponentController() ;
        Account oAccount = new Account(Name = 'Test Sudhir Account');
        //oAccount.Organization_Number__c = '123456-1234' ;
        insert oAccount ;
        
        Opportunity oOpportunity = new Opportunity(Name = 'Test Sudhir Oppty') ;
        oOpportunity.AccountId = oAccount.Id ;
        oOpportunity.StageName = 'Prospecting' ;
        oOpportunity.CloseDate = Date.valueOf('2016-03-14') ;
        insert oOpportunity ;
        
        String sMainData = 'Opportunity,StageName,' + String.valueOf(oOpportunity.Id) ;
        oSLDS_ProgressBarComponentController.setData(sMainData) ;
        oSLDS_ProgressBarComponentController.getData() ;
    }
}