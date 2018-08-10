/**********************************************************************************
Name    : ObjectFieldMetadataController
Date    : August 8, 2017
Usage   : This class intends to get the field name, field label, type and length of the fields in an object. 
          It provides an option to export the information into a PDF, Excel or MS-Doc.
          - To Do: for MS-Doc later

History :

    Created - Sudhir Kumar 
    Purpose - Get the field name, field label, type and length of the fields in an object. 

**********************************************************************************/

public with sharing class ObjectFieldMetadataController {
    
    public String objectName {get; set;}
    public String exportOption {get; set;}
    public String contentType {get; set;}
    public Boolean showSection {get; set;}

    public list<FieldMetadataWrapper> listFieldsMetadataWrapper {get; set;}
    
    public ObjectFieldMetadataController() {
        showSection = false ;
        if(objectName == null){
            objectName = ApexPages.CurrentPage().getParameters().get('objectName') ;
            contentType = ApexPages.CurrentPage().getParameters().get('contentType') ;
            getFieldsMetaDataInfo() ;
        }
    }

    public pagereference openPdf(){
        PageReference pr ;
        if(exportOption == 'pdf') {
            pr = new PageReference('/apex/ObjectFieldMetadataAsPdf');
            pr.getParameters().put('exportOption', 'pdf');
        }
        else if(exportOption == 'excel') {
            pr = new PageReference('/apex/ObjectFieldMetadataAsDocExcel');
            pr.getParameters().put('contentType', 'application/vnd.ms-excel#ObjectFieldsMetadata.xls');
        }else if(exportOption == 'msDoc') {
            pr = new PageReference('/apex/ObjectFieldMetadataAsDocExcel');
            pr.getParameters().put('contentType', 'application/vnd.ms-word#ObjectFieldsMetadata.docx');
        }
        pr.getParameters().put('objectName', objectName);
        pr.setRedirect(true); 
        return pr;
    }
    public PageReference getFieldsMetaDataInfo() {
        list<FieldDefinition> fieldsMetadata = [Select Label, DeveloperName, DataType, Length, MasterLabel, QualifiedApiName , IsIndexed, ControllingFieldDefinitionId
                                                             From 
                                                             FieldDefinition 
                                                             where 
                                                             EntityDefinition.QualifiedApiName  =: objectName ] ;                                                      
         
         listFieldsMetadataWrapper = new list<FieldMetadataWrapper>() ;
         for(FieldDefinition fd : fieldsMetadata) {
             FieldMetadataWrapper fdWrap = new FieldMetadataWrapper(fd) ;
             listFieldsMetadataWrapper.add(fdWrap) ;
         }
         if(fieldsMetadata.isEmpty()) showSection = true ;
         return null ;
    }
    
    public class FieldMetadataWrapper {
        public FieldDefinition fd {get; set;}
        public FieldMetadataWrapper(FieldDefinition fd){
            this.fd = fd ;
        }
    }
}