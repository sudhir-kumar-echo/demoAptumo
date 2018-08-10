public with sharing class ProgressBarVisualforce_cls
{
    //Attributes for parsing picklist values
    public List<String> pickListVals {get; set;}  //list to hold picklist values on a given record type
    public String valsText {get; set;}
    public Boolean loadOnce {get; set;}
    private Opportunity opp;
    
    //attributes for segregating picklist values
    public String sCurrentStageValue {get; set;}
    public list<String> listCompletedStages {get; set;}
    public list<String> listNotCompletedStages {get; set;}
    
    public map<Integer, String> mapStageNr2StageValue ;
    public map<String, Integer> mapStageValue2StageNr ;
    public Integer sCurrentStageNr ;
    
    public ProgressBarVisualforce_cls(ApexPages.StandardController std){
        sCurrentStageValue = '' ;
        sCurrentStageNr = 0 ;
        mapStageNr2StageValue = new map<Integer, String>() ;
        mapStageValue2StageNr = new map<String, Integer>() ;
        listCompletedStages = new list<String>() ;
        listNotCompletedStages = new list<String>() ;
        opp=(Opportunity) std.getRecord();
        system.debug('opp:: ' + opp) ;
        
        String sOpportunityId = ApexPages.currentPage().getParameters().get('Id') ;
        system.debug('Sudhir sOpportunityId:: ' + sOpportunityId) ;
        
        Opportunity oOpportunity = [SELECT Id, Name, toLabel(StageName) FROM Opportunity where Id =: sOpportunityId] ;
        
        sCurrentStageValue = oOpportunity.StageName ;
        system.debug('opp.StageName:: ' + opp.StageName) ;
       
        loadOnce=true;
        //reload();
    }

    public void reload(){
        pickListVals=new List<String>();
        Boolean skip=true;
        for (String val : valsText.split(':')){
            if (skip){
                skip=false;
            }else {
                pickListVals.add(val);
            }
        }
        loadOnce=false;
        //
        
        for(Integer i = 0; i < pickListVals.size(); i++){
            mapStageNr2StageValue.put(i+1, pickListVals[i]) ;
            mapStageValue2StageNr.put(pickListVals[i], i+1) ;
        }
        system.debug('Sudhir mapStageNr2StageValue:: ' + mapStageNr2StageValue) ;
        system.debug('Sudhir mapStageValue2StageNr:: ' + mapStageValue2StageNr) ;
        
        if(mapStageValue2StageNr.containsKey(sCurrentStageValue)){
        
            sCurrentStageNr = mapStageValue2StageNr.get(sCurrentStageValue) ;
            system.debug('Sudhir sCurrentStageNr:: ' + sCurrentStageNr) ;
            
            for(Integer i : mapStageNr2StageValue.keySet()){
                if(i < sCurrentStageNr){
                    listCompletedStages.add(mapStageNr2StageValue.get(i)) ;
                } else if(i > sCurrentStageNr){
                    listNotCompletedStages.add(mapStageNr2StageValue.get(i)) ;
                }
            }
            
            system.debug('Sudhir listCompletedStages:: ' + listCompletedStages) ;
            system.debug('Sudhir listNotCompletedStages:: ' + listNotCompletedStages) ;
        }
    }


}