trigger Account_SingletonPattern on Account (before insert, before update) {
    for(Account acc : Trigger.New) {
        AccountFooRecordType rt = new AccountFooRecordType() ;
    }
}