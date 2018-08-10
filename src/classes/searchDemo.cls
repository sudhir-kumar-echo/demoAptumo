public class searchDemo{
    public list<SObject> listAccount {get; set;}
    public list<SObject> listLead {get; set;}
    
    public searchDemo(){}
    
    public void findSearch(){
    
        list<list<SObject>>  listSObjectSearch = [FIND '*Test*' IN Name Fields RETURNING lead (name, phone), Account(Name)] ;
        system.debug('listSObjectSearch :: ' + listSObjectSearch ) ;
 
        for(list<SObject> listSObject : listSObjectSearch){
            if(listSObject instanceof list<Lead>){
                for(SObject oLead : listSObject){
                    listLead.add(oLead) ;
                }
            }
            system.debug('listLead:: ' + listLead) ;
            if(listSObject instanceof list<Account>){
                for(SObject oAccount : listSObject){
                    listAccount.add(oAccount) ;
                }
            }
            system.debug('listAccount:: ' + listAccount) ;
        }
    }

}