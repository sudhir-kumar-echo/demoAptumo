public with sharing class MetadataCRUDforceCtrl {
    
    public MetadataCRUDforceCtrl() {
    }
    public static String selectedObject {get; set;}
    
    public static List<SelectOption> sobjectList {
        get {
            if(sobjectList == null) {
                sobjectList = new list<SelectOption>() ;
                map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe() ;
                //system.debug('gd:: ' + gd);
                sobjectList.add(new SelectOption('None', '--None--')) ;
                for(Schema.SObjectType obj : gd.values()) {
                    Schema.DescribeSObjectResult objResult = obj.getDescribe() ;
                    //system.debug('SObject:: ' + objResult) ;
                    //system.debug('SObject API Name:: ' + objResult.getName()) ;
                    //system.debug('SObject Label:: ' + objResult.getLabel()) ;
                    
                    sobjectList.add(new SelectOption(objResult.getName(), objResult.getLabel())) ;
                }
            }
        system.debug('sobjectList :: ' + sobjectList) ;
        return sobjectList ;
        }
        set ;
    }
    
    public static String selectedProfile {get; set;}
    
    public static List<SelectOption> profileList {
        get {
            if(profileList  == null) {
               profileList = new list<SelectOption>() ;
               profileList.add(new SelectOption('None', '--None--')) ;
               for(Profile prf : [SELECT Id, Name FROM Profile]) {
                   
                   profileList.add(new SelectOption(prf.Id, prf.Name)) ;
                }
            }
        system.debug('profileList:: ' + profileList) ;
        return profileList;
        }
        set ;
    }
    
}