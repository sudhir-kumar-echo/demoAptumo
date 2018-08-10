public with sharing class OpportunityPaginationController{
    
    // Opportunity in context from the page
    public String contextOpportunity { get; set; }
    
    // Instantiate StandardSetController
    private ApexPages.StandardSetController setCon;
    
    // Opportunity IDs selected by the user
    private Set<Id> setSelectedOpportunity ;
   
   public OpportunityPaginationController(){
       // Initialize variables
       setSelectedOpportunity = new Set<Id>();
       //Gather Data set in setCon
       this.setCon = new ApexPages.StandardSetController([Select Id, Name, StageName from Opportunity]);
       this.setCon.setPageNumber(1);
       this.setCon.setPageSize(5);
   }
   
   //Handle selected Opportunities
   
   public void handleSelectedOpportunity(){
   system.debug('****' + contextOpportunity);
       this.setSelectedOpportunity.add(this.contextOpportunity);
   }
   
   //Handle de-selected Opportunities
   public void handleDeselectedOpportunity(){
       this.setSelectedOpportunity.remove(this.contextOpportunity);
   }
   
   // Return count of Selected Opportunities
   public Integer getSelectedCount(){
       system.debug('SKJ this.selectedContactIds.size()::'+ this.setSelectedOpportunity.size());
       return this.setSelectedOpportunity.size();
   }
   
   //Go to the next page
   public void goNext(){
       if(this.setCon.getHasNext())
           this.setCon.next();
   }
   
   //Go to the previous page
   public void goPrevious(){
       if(this.setCon.getHasPrevious())
           this.setCon.previous();
   }
   
   //Return current page selected Opportunity
   public List<OpportunityRowItem> getOpportunities(){
       List<OpportunityRowItem> listOpportunityRowItem = new List<OpportunityRowItem> ();
       for(sObject s : this.setCon.getRecords()){
           Opportunity opp = (Opportunity) s;
           
           OpportunityRowItem oOpportunityRowItem = new OpportunityRowItem(opp, false);
           
           if(this.setSelectedOpportunity.contains(opp.Id)){
               oOpportunityRowItem.IsSelected = true;
           }else {
               oOpportunityRowItem.IsSelected = false;
           }
           listOpportunityRowItem.add(oOpportunityRowItem);
       }
       
       return listOpportunityRowItem;
   }
   
   //Return whether previous page exists
   public Boolean getHasPrevious(){
       return this.setCon.getHasPrevious();
   }
   
   //Return whether next page exists
   public Boolean getHasNext(){
       return this.setCon.getHasNext();
   }
   
   //Return page number
   public Integer getPageNumber(){
       return this.setCon.getPageNumber();
   }
   
   //Return total pages
   public Integer getTotalPages(){
       Decimal totalSize = this.setCon.getResultSize();
       Decimal pageSize = this.setCon.getPageSize();
       
       Decimal pages = totalSize/pageSize;
       
       return (Integer)pages.round(System.RoundingMode.CEILING);
   }
   
   //Helper class that represent a row
   public with sharing class OpportunityRowItem{
       public Opportunity oOpportunity { get; set; }
       public Boolean IsSelected { get; set; }
       
       public OpportunityRowItem(Opportunity o, Boolean b){
           this.oOpportunity = o;
           this.IsSelected = b;
       }
   }


}