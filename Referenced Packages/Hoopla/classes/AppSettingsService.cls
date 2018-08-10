/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AppSettingsService {
    global AppSettingsService() {

    }
    webService static void generateValidLicense() {

    }
    webService static hoopla.AppSettingsService.ApiMetrics getApiUsageLimits() {
        return null;
    }
    webService static List<hoopla__App_Config__c> getAppConfig() {
        return null;
    }
    webService static void invalidateLicense() {

    }
    webService static void upsertServiceToken(String serviceToken) {

    }
global class ApiMetrics {
    webService Boolean chatterEnabled {
        get;
        set;
    }
    webService List<hoopla.AppSettingsService.CountdownTimePeriod> countdownTimePeriods {
        get;
        set;
    }
    webService String currencyIsoCode {
        get;
        set;
    }
    webService Integer decimalPlaces {
        get;
        set;
    }
    webService BusinessHours hours {
        get;
        set;
    }
    webService Boolean isMultiCurrency {
        get;
        set;
    }
    webService List<hoopla.AppSettingsService.LicenseType> licenseTypes {
        get;
        set;
    }
    webService String orgType {
        get;
        set;
    }
    global ApiMetrics() {

    }
}
global class CountdownTimePeriod {
    webService String label {
        get;
        set;
    }
    webService String name {
        get;
        set;
    }
    global CountdownTimePeriod() {

    }
}
global class LicenseType {
    webService String licenseName {
        get;
        set;
    }
    webService Integer userCount {
        get;
        set;
    }
    global LicenseType() {

    }
}
}
