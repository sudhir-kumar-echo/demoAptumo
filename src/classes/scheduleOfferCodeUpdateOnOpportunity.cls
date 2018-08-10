global class scheduleOfferCodeUpdateOnOpportunity implements Schedulable{

    global void execute(SchedulableContext SC){
        UpdateOfferCodeOnOppty oUpdateOfferCodeOnOppty = new UpdateOfferCodeOnOppty();
        Database.executeBatch(oUpdateOfferCodeOnOppty);
    }
    
}