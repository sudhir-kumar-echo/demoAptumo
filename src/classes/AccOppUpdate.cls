global class AccOppUpdate
{
  global class AccountInfo 
  {
     webservice String accName;
     webservice String accId;
     webservice List<OppInfo> oppInfo;
  }
  
  global class OppInfo 
  {
     webservice String oppName;
     webservice String accId;
     webservice String oppId;
  }
  
  global class OutputResponse 
  {
     webservice Id respSfdcId;
     webservice String respMessage;
  }
  
  webService static List<OutputResponse> updateAccOpp(List<AccountInfo> accInfo) 
  {
    system.debug('Entereddddddddddddddddddddddd ' + accInfo);
    List<AccOppUpdate.OutputResponse> respList = new List<AccOppUpdate.OutputResponse>();
    
    List<Account> updateAcc = new List<Account>();
    List<Opportunity> updateOpp = new List<Opportunity>();
    Set<Id> allAccountIds = new Set<Id>();
    Set<Id> allOppIds = new Set<Id>();
    Set<Id> successfulAccountIds = new Set<Id>();
  //Set<Id> failedAccountIds = new Set<Id>();
    Set<Id> successfulOppIds = new Set<Id>();
  //Set<Id> failedOppIds = new Set<Id>();
    
    
    
    for(Integer i=0;i<accInfo.size();i++)
    {
        if(accInfo[i].accName == '' || accInfo[i].accName == null)
        {
            system.debug('Only Opp Update No Acc Update');
        }
        else
        { 
            Id aId = Id.valueof(accInfo[i].accId);
            Account updAcc = new Account(id=aId);
            allAccountIds.add(accInfo[i].accId);
            updAcc.Name = accInfo[i].accName;
            updateAcc.add(updAcc);
            
        }
        
        
            for(OppInfo oInfo : accInfo[i].oppInfo)
            {
                if(oInfo.oppId.length()>2)
                {
                Opportunity opp = new Opportunity(id=oInfo.oppId);
                allOppIds.add(oInfo.oppId);
                opp.Name = oInfo.oppName;
                updateOpp.add(opp);
                }
                else
                {
                    system.debug('No Opp To Update');
                }
            }
        
    }
    
    //--------------------
    Database.SaveResult[] srList = Database.update(updateAcc, false);

     
     for (Database.SaveResult sr : srList) 
     {
       if (sr.isSuccess()) 
       {
            successfulAccountIds.add(sr.getId());   
            AccOppUpdate.OutputResponse resp = new AccOppUpdate.OutputResponse();
            resp.respSfdcId = sr.getId();
            resp.respMessage = 'Acc Update Success';
            respList.add(resp);
       }
     }
     
     for(Id i : allAccountIds)
     {
       if(!successfulAccountIds.contains(i))
       {
            //failedAccountIds.add(i);
            AccOppUpdate.OutputResponse resp1 = new AccOppUpdate.OutputResponse();
            resp1.respSfdcId = i;
            resp1.respMessage = 'Acc Update Failed';
            respList.add(resp1);
       }
     }
    
    //--------------------
    Database.SaveResult[] srListOpp = Database.update(updateOpp, false);

     
     for (Database.SaveResult sr : srListOpp) 
     {
       if (sr.isSuccess()) 
       {
            successfulOppIds.add(sr.getId());   
            AccOppUpdate.OutputResponse resp2 = new AccOppUpdate.OutputResponse();
            resp2.respSfdcId = sr.getId();
            resp2.respMessage = 'Opp Update Success';
            respList.add(resp2);
       }
     }
     
     for(Id i : allOppIds)
     {
       if(!successfulOppIds.contains(i))
       {
            //failedOppIds.add(i);
            AccOppUpdate.OutputResponse resp3 = new AccOppUpdate.OutputResponse();
            resp3.respSfdcId = i;
            resp3.respMessage = 'Opp Update Failed';
            respList.add(resp3);
       }
     }
    
    //--------------------
    
    
    return respList;
  }
}