public class SLDS_ProgressBarComponentController {

    public string data;
    public sObject genericObject{get;set;}
    public String fieldName{get;set;}
    
    /*
       param : String
       ReturnType : void
       description: The assignTo variable in the the component are not available in the constructor as per the salesforce execution flow
                    For this reason all the data is sent as part of one attribute 'data' which will be comma seperated.
                     
    */
    public void setData (string d) {
        List<String> mainData = d.split(',');
        fieldName = mainData[1];
        String objectName = mainData[0];
        String recordId = mainData[2];
        //Cast the sObject to the specific object.
        Type t = Type.forName(objectName);
        genericObject = (sObject)t.newInstance();
        //Query the object with the field so that the picklist value only shows the values which it should as that depends on the recordType etc.
        genericObject = Database.query('SELECT '+fieldName+' FROM '+objectName+' WHERE Id = \''+recordId+'\'');

    }
    
    //Get the data.
    public string getData() {
        return data;
    }
    
    //Empty Constructor
    public SLDS_ProgressBarComponentController () {
        
    }
}