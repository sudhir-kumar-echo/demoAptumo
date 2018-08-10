public class ApiNameToLabelName_class{

    public String strObjectAPIName{get; set;}    
    public String strObjectLabel{get; set;}
    
    public ApiNameToLabelName_class(){}
    
    public pagereference getLabelName(){
        system.debug('strObjectAPIName:: ' + strObjectAPIName) ;
        try{
            strObjectAPIName = strObjectAPIName.trim() ;
            List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String>{strObjectAPIName}); // this can accept list of strings, we describe only one object here
            System.debug(describeSobjectsResult);
            String objectLabel = describeSobjectsResult[0].getLabel();
            System.debug('objectLabel:: ' + objectLabel);
            strObjectLabel = objectLabel ;
        }catch(Exception oException){
            system.debug('oException:: ' + oException.getMessage()) ;
            if(oException.getMessage().contains('Invalid sobject'))
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error, 'Invalid sObject')) ;
            strObjectLabel = null ;
            return null ;
        }        
        return null ;
    }
}