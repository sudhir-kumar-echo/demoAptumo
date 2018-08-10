public with sharing class RerenderRendered_controller{
    public Vehicle__c vehicle ;
    public RerenderRendered_controller(ApexPages.StandardController stdController){
        Id recordId = ApexPages.CurrentPage().getParameters().get('Id') ;
        system.debug('recordId : ' + recordId ) ;
        vehicle = [Select Id, Checkbox__c, Text_field__c from Vehicle__c where Id =: recordId] ;
        system.debug('vehicle : ' + vehicle ) ;
    }
    
    public Boolean showTextField {
        get{
            return vehicle.Checkbox__c ;
        }
    }
}