/**********************************************************************************
Name    : ObjectFieldMetadataController_Test  for ObjectFieldMetadataController
Date    : August 8, 2017
Usage   : It intends to get the field name, field label, type and length of the fields in an object. 
          It provides an option to export the information into a PDF, Excel or MS-Doc.
          - To Do: for MS-Doc later

History :

    Created - Sudhir Kumar 
    Purpose - Get the field name, field label, type and length of the fields in an object. 

**********************************************************************************/

@isTest

public class ObjectFieldMetadataController_Test {

    static testMethod void testObjectFieldMetadataController(){
        ObjectFieldMetadataController con = new ObjectFieldMetadataController() ;
        con.objectName = 'Account' ;
        con.getFieldsMetaDataInfo() ;
        con.exportOption = 'pdf' ;
        con.openPdf() ;
        con.exportOption = 'excel' ;
        con.openPdf() ;
        con.exportOption = 'msDoc' ;
        con.openPdf() ;
    }
}