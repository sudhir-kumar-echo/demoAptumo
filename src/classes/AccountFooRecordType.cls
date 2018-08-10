public class AccountFooRecordType {
    public String id {get; private set;}
    public AccountFooRecordType() {
        //id = Account.sObjectType.getDescribe()
                    //.getRecordTypeInfosByName().get('Foo').getRecordTypeId();
    }
}