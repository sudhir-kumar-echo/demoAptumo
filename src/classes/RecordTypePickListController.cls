public with sharing class RecordTypePickListController 
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
    
    public RecordTypePickListController(ApexPages.StandardController std){
        sCurrentStageValue = '' ;
        sCurrentStageNr = 0 ;
        opp=(Opportunity) std.getRecord();
        sCurrentStageValue = opp.StageName ;
        loadOnce=true;
    }

    public PageReference reload(){
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

        return null;
    }

    public void segregatePicklistValues(){
        for(Integer i = 0; i < pickListVals.size(); i++){
            mapStageNr2StageValue.put(i+1, pickListVals[i]) ;
            mapStageValue2StageNr.put(pickListVals[i], i+1) ;
        }
        system.debug('Sudhir mapStageNr2StageValue:: ' + mapStageNr2StageValue) ;
        system.debug('Sudhir mapStageValue2StageNr:: ' + mapStageValue2StageNr) ;
        
        if(mapStageValue2StageNr.containsKey(sCurrentStageValue)){
        
            sCurrentStageNr = mapStageValue2StageNr.get(sCurrentStageValue) ;
            system.debug('Sudhir sCurrentStageNr:: ' + sCurrentStageNr) ;
            
            for(Integer i = 1; i <= mapStageNr2StageValue.keySet().size(); i++){
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