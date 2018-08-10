// This Apex controller contains a serverEcho action that prepends a string to the value passed in.

public with sharing class SimpleServerSideController {
	//Use @AuraEnabled to enable client- and server-side access to the method
	@AuraEnabled
    public static String serverEcho(String firstName){
        return ('Hello from server, ' + firstName) ;
    }
}