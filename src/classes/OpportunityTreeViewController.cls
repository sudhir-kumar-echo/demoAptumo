public class OpportunityTreeViewController{
     
    public Map<String, Map<String, List<Opportunity>>> mapOpportunities{get;set;}
     
    // Get opportunity records - Calling it a page action attribute.
    public void fetchOpportunites(){
         
        mapOpportunities = new Map<String, Map<String, List<Opportunity>>>();
         
        for(Opportunity oppRecord : [Select o.Type, o.StageName, o.OwnerId, o.Name, o.IsWon, o.IsClosed, o.Id, o.Description, 
                                      o.CreatedDate, o.CreatedById, o.CloseDate, o.Amount, o.AccountId, o.Account.Name 
                                      From Opportunity o
                                      WHERE StageName in:getOpportunityStages() order by o.CloseDate Desc]){
                                       
            String closeDate = oppRecord.CloseDate.format();
            if(mapOpportunities.get(closeDate) != null){
                if(mapOpportunities.get(closeDate).get(oppRecord.StageName) != null)
                    mapOpportunities.get(closeDate).get(oppRecord.StageName).add(oppRecord);
                else
                    mapOpportunities.get(closeDate).put(oppRecord.StageName, new List<Opportunity>{oppRecord});
            }
            else{
                mapOpportunities.put(closeDate, new Map<String, List<Opportunity>>{oppRecord.StageName => new List<Opportunity>{oppRecord}});
            }                                                                            
        }                                                   
    }
     
    // Get List of Stage names of Opportunity.
    private static List<String> getOpportunityStages(){
        List<String> stages = new List<String>();
        // Get DescribeFieldResult for Opportunity StageName picklist.
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
             
        for( Schema.PicklistEntry f : ple){
              stages.add(f.getLabel()); // Add Stage Name to list.
        }       
        return stages; // Return all Stages.
    }
}