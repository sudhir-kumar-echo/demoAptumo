global class UpdateOfferCodeOnOppty implements Database.Batchable<sObject> {
    public List<Campaign> listCampaign = new List<Campaign>();
    Set<Id> setOpportunityId = new Set<Id>();
    Set<Id> setFailedCampaign = new Set<Id>();
    
    //Constructor
    global UpdateOfferCodeOnOppty(){
        listCampaign = [select Id, Offer_code__c from Campaign where Has_Offer_Code__c = true];
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([select Id, Offer_code__c, CampaignId from Opportunity where CampaignId IN: listCampaign]);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        map<Id, String> mapCampaignOfferCode = new map<Id, String>();
        list<Opportunity> listOpportunity = new list<Opportunity>();
        for(Campaign oCampaign: listCampaign){
            if(!mapCampaignOfferCode.containsKey(oCampaign.Id)){
                mapCampaignOfferCode.put(oCampaign.Id, oCampaign.offer_code__c);
            }
        }
        
        for(sObject s: scope){
            Opportunity oOpportunity = (Opportunity)s;
            oOpportunity.offer_code__c = mapCampaignOfferCode.get(oOpportunity.CampaignId);
            listOpportunity.add(oOpportunity);
        }
      
        List<Database.SaveResult> listSaveResult = Database.update(listOpportunity);
        
        for(Integer i = 0; i < listSaveResult.size() ; i++){
            if(!listSaveResult[i].isSuccess()){
                setFailedCampaign.add(listOpportunity[i].CampaignId);
            }
        }
        
        for(Campaign oCampaign: listCampaign){
            if(!setFailedCampaign.contains(oCampaign.Id)){
                oCampaign.Has_Offer_Code__c = false;
            }
        }
        Database.update(listCampaign);
       
    }
    
    global void finish(Database.BatchableContext ctx){
    
        AsyncApexJob oAsyncApexJob = [ SELECT Id, ApexClassId,
                                       JobItemsProcessed, 
                                       TotalJobItems,
                                       NumberOfErrors,
                                       ExtendedStatus,
                                       CreatedBy.Email
                                       FROM AsyncApexJob
                                       WHERE id =: ctx.getJobId()];
        String sMessageFormat = 'Your batch job for Opportunity Offer Code update has finished.It Executed {0}  batches.Of which, {1}  processed without any exceptions and {2}  batched threw unhandled exceptions. Error: {3}';
                             
                             
        List<String> messageValues = new String[]{
                                                  String.valueOf(oAsyncApexJob.TotalJobItems),
                                                  String.valueOf(oAsyncApexJob.JobItemsProcessed),
                                                  String.valueOf(oAsyncApexJob.NumberOfErrors),
                                                  String.valueOf(oAsyncApexJob.ExtendedStatus)        
                                    } ;
        
        String sEmailMessage = String.format(sMessageFormat, messageValues );                           
                               
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] sToAddress = new String[]{'sudhir.kumarjaiswal@thomsonreuters.com'};
        mail.setToAddresses(sToAddress);
        mail.setReplyTo('noreply@salesforce.com');                       
        mail.setSenderDisplayName('Batch Job Summary');
        mail.setSubject('Batch Job Summary: Update Campaign Offer Code on Opportunity');
        mail.setPlainTextBody(sEmailMessage);
        mail.setHtmlBody(sEmailMessage);
        
        if(oAsyncApexJob.NumberOfErrors > 0 ){
            Messaging.sendEmail( new Messaging.SingleEmailMessage[]{mail});
        }
                              
    }
    
}