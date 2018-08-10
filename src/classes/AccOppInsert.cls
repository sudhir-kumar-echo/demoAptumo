global class AccOppInsert
{
  
  global class AccountInfo 
  {
     webservice String accName;
     webservice String newRold;
     webservice List<OppInfo> oppInfo; 
  }
  
  global class OppInfo 
  {
     webservice String oppName; 
   //webservice ID accId;
     webservice String accName;
  }
  
  global class OutputResponse 
  {
     webservice String respExtId;
     webservice Id respSfdcId;
     webservice String respMessage;
  }
  
  webService static List<OutputResponse> insertAccOpp(List<AccountInfo> accInfo) 
  {
    List<Account> accList = new List<Account>();
    Set<String> allAccSet = new Set<String>();
    Set<String> allOppSet = new Set<String>();
    List<Id> successAccList = new List<Id>();
    List<Id> successOppList = new List<Id>();
    Set<String> failureAccSet = new Set<String>();
  //Set<String> successAccSet = new Set<String>();
    List<String> responseList = new List<String>();
    Set<String> accountNameInserted = new Set<String>();
    Set<String> oppNameInserted = new Set<String>();
    Map<String,List<OppInfo>> mapOpp = new Map<String,List<OppInfo>>();
    Map<String,Id> accSuccessMap = new Map<String,Id>();
    List<Opportunity> oppFinalList = new List<Opportunity>();
    
    List<AccOppInsert.OutputResponse> respList = new List<AccOppInsert.OutputResponse>();
    
  for(Integer i=0;i<accInfo.size();i++)
  {
        
    if(accInfo[i].newRold.length()>2)
    {
                for(OppInfo o : accInfo[i].oppInfo)
                {
                Opportunity oppObj = new Opportunity();
                //contains all OPP's which came from SAP PI
                system.debug(' Only Oppppppppppppppppppppppppppp ');
                
                allOppSet.add(o.oppName);
                
                oppObj.Name = o.oppName;
                oppObj.accountId =  Id.valueOf(accInfo[i].newRold);
                oppObj.StageName = 'Qualification';
                oppObj.closedate = date.parse('10/6/2014');
                //list to process database.insert
                oppFinalList.add(oppObj);
                system.debug('Opp List ' + oppFinalList);
                }
                
    }
    else
    {
     system.debug('Before Acc Wrapper' + accInfo[i].accName);
     
     //Taking all Accounts which we got from SAP PI
     allAccSet.add(accInfo[i].accName);
     Account acc = new Account();
     acc.Name = accInfo[i].accName;
     //This list used during Database.insert
     accList.add(acc);
     //key as account and value as list of opp's for that acc
     system.debug('Opp Size ' + accInfo[i].oppInfo.size());
     
     mapOpp.put(acc.Name , accInfo[i].oppInfo);
    }
  }
    
    Database.SaveResult[] srList = Database.insert(accList, false);

     for (Database.SaveResult sr : srList) 
     {
       if (sr.isSuccess()) 
       {
        System.debug('Successfully inserted account. Account ID: ' + sr.getId());
        //Captures all sucessfully inserted accounts
        successAccList.add(sr.getId());
       }
     }
     
     List<Account> accQuery = [select id,name from Account where id in : successAccList];
     
     for(Account accQueried : accQuery)
     {
        //Captures all account names which inserted successfully
        accountNameInserted.add(accQueried.Name);
        //key as successfully inserted account and value as it's ID
        accSuccessMap.put(accQueried.Name,accQueried.id);
        responseList.add(accQueried.Name + '^^^'+accQueried.id);
        
        AccOppInsert.OutputResponse resp1 = new AccOppInsert.OutputResponse();
        resp1.respExtId = accQueried.Name;
        resp1.respSfdcId = accQueried.id;
        respList.add(resp1);
     }
     
     system.debug('11111111111111111111 ' + allAccSet);
     for(String s : allAccSet)
     {
        if(!(accountNameInserted.contains(s)))
        {
            //set of failed acc names
            failureAccSet.add(s);
            responseList.add(s + '^^^AccFailure');
            
            AccOppInsert.OutputResponse resp2 = new AccOppInsert.OutputResponse();
            resp2.respExtId = s;
            resp2.respMessage = 'AccFailure';
            respList.add(resp2);
            
        }
     }
     
     //**********************
     system.debug('22222222222222222 ' + failureAccSet);
     for(String s :failureAccSet)
     {
        if(mapOpp.containsKey(s))
        {
            for( AccOppInsert.OppInfo opp : mapOpp.get(s))
            {
                responseList.add(opp.oppName+'^^^OppFailedBcozAccFailed');
                
                AccOppInsert.OutputResponse resp3 = new AccOppInsert.OutputResponse();
                resp3.respExtId = opp.oppName;
                resp3.respMessage = 'OppFailedBcozAccFailed';
                respList.add(resp3);
                
            }
           //mapOpp.remove(s);
        }
    }
    
     system.debug('333333333333333333 ' + successAccList  + '     ' + accountNameInserted);
    for(String s :accountNameInserted)
     {
        if(mapOpp.containsKey(s))
        {
            for( AccOppInsert.OppInfo opp : mapOpp.get(s))
            {
                Opportunity oppObj = new Opportunity();
                //contains all OPP's which came from SAP PI
                system.debug(' Opp Nameeeeeeeeeee ' + opp.oppName);
                if(opp.oppName != '' && opp.oppName != null)
                {
                allOppSet.add(opp.oppName);
                
                oppObj.Name = opp.oppName;
                oppObj.accountId =  accSuccessMap.get(opp.accName);
                oppObj.StageName = 'Qualification';
                oppObj.closedate = date.parse('10/6/2014');
                //list to process database.insert
                oppFinalList.add(oppObj);
                system.debug('Opp List ' + oppFinalList);
                }
                else
                {
                    system.debug(' ************ Only Acc No Opp ');
                }
            }
          
        }
    }
    
    //@@@@@@@@@@@@@@@@@
    
    Database.SaveResult[] srOppList = Database.insert(oppFinalList, false);

     for (Database.SaveResult sr : srOppList) 
     {
       if (sr.isSuccess()) 
       {
        System.debug('Successfully inserted OPP ID: ' + sr.getId());
        //Successfully inserted OPP ID's
        successOppList.add(sr.getId());
       }
       else
       {
        for(Database.Error err : sr.getErrors()) 
            {
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Fields that affected this error: ' + err.getFields());
            }
       }
     }
     
     
     List<Opportunity> oppQuery = [select id,name from Opportunity where id in : successOppList];
     
     for(Opportunity oppQueried : oppQuery)
     {
        //Successfully inserted OPP names
        oppNameInserted.add(oppQueried.Name);
        responseList.add(oppQueried.Name + '^^^'+oppQueried.id);
        
        AccOppInsert.OutputResponse resp4 = new AccOppInsert.OutputResponse();
        resp4.respExtId = oppQueried.Name;
        resp4.respSfdcId = oppQueried.id;
        respList.add(resp4);
        
     }
     
    if(allOppset.size() > 0)
    {
     for(String s : allOppSet)
     {
        if(!(oppNameInserted.contains(s)))
        {
            responseList.add(s + '^^^OppFailure');
            
            AccOppInsert.OutputResponse resp5 = new AccOppInsert.OutputResponse();
            resp5.respExtId = s;
            resp5.respMessage = 'OppFailure';
            respList.add(resp5);
        }
     }
    }
     
     //**********************
    
     //return responseList;  
       return respList;
  }
  
}