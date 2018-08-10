public with sharing class sampleExtension { 

public Account oAccount;
 
 //public account acc = new account();

public sampleExtension(ApexPages.StandardController controller) {
oAccount = (Account) controller.getRecord() ;

}

public PageReference savenow() {
Account acc = new Account();

acc.Name = oAccount.Name;

acc.Type= oAccount.Type;
 //acc.Region__c= Region;
 //system.debug('name' + acc.name + 'Type' + acc.Type + 'Region' + acc.Region__c );
 insert acc;

//System.debug('nickName: '+Type);

return null;
 }

}