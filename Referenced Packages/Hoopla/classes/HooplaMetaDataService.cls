/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class HooplaMetaDataService {
    global HooplaMetaDataService() {

    }
    webService static hoopla.HooplaMetaDataService.ObjectMetadata retrieveObjectInfo(String objectName) {
        return null;
    }
global class FieldMetadata {
    webService Boolean canDisplay {
        get;
        set;
    }
    webService Boolean canGroup {
        get;
        set;
    }
    webService String displayType {
        get;
        set;
    }
    webService Boolean isDateFieldOption {
        get;
        set;
    }
    webService Boolean isUserReferenceField {
        get;
        set;
    }
    webService String label {
        get;
        set;
    }
    webService String name {
        get;
        set;
    }
    webService List<hoopla.HooplaMetaDataService.PicklistValue> pickListValues {
        get;
        set;
    }
    webService String referenceTo {
        get;
        set;
    }
    global FieldMetadata() {

    }
}
global class ObjectMetadata {
    webService List<String> errorInfo {
        get;
        set;
    }
    webService List<hoopla.HooplaMetaDataService.FieldMetadata> fields {
        get;
        set;
    }
    webService Boolean hasErrors {
        get;
        set;
    }
    webService Boolean hasOwnerId {
        get;
        set;
    }
    webService Boolean isCustomObject {
        get;
        set;
    }
    webService String label {
        get;
        set;
    }
    webService String name {
        get;
        set;
    }
    webService String nameField {
        get;
        set;
    }
    global ObjectMetadata() {

    }
}
global class PicklistValue {
    @WebService
    webService String label;
    @WebService
    webService String value;
    global PicklistValue() {

    }
}
}
