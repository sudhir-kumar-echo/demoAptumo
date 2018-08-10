/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/user_app_configs/*')
global class UserAppConfigs {
    global UserAppConfigs() {

    }
    @HttpPost
    global static hoopla.PushWebService.PushStatus doPost(List<hoopla.UserAppConfigs.ConfigHolder> configs) {
        return null;
    }
    @HttpPut
    global static hoopla.PushWebService.PushStatus doPut(List<String> ids) {
        return null;
    }
global class ConfigHolder {
    webService String name {
        get;
        set;
    }
    webService String value {
        get;
        set;
    }
    global ConfigHolder() {

    }
}
}
