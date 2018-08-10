public with sharing class ContactController {
	
    @AuraEnabled
    public static list<Contact> getContacts() {
        list<Contact> contacts = [SELECT Id, Name, MailingStreet, Phone, Email, LeadSource From CONTACT] ;
        //Add isAccessible check
        return contacts ;
    }
}