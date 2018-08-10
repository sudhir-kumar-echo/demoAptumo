public class DynamicPageBlockTable_Controller {
	public List<Account> getAccountList()
    {
        String fieldList = '';
        for(Schema.FieldSetMember fsm : SObjectType.Account.FieldSets.MyFieldset.getFields())
            fieldList += fieldList.length()>0 ? ','+fsm.getFieldPath() : fsm.getFieldPath();
        return (List<Account>) Database.query('select ' + fieldList + ' from Account');
    }
    
    public Component.Apex.PageBlockTable getMyPageBlockTable()
    {
        Component.Apex.PageBlockTable table = new Component.Apex.PageBlockTable(var='acc');
        table.expressions.value='{!AccountList}';
        for(Schema.FieldSetMember fsm : SObjectType.Account.FieldSets.MyFieldset.getFields())
        {
            Component.Apex.OutputField outputField = new Component.Apex.OutputField();
            outputField.expressions.value = '{!acc.' + fsm.getFieldPath() + '}';
            Component.Apex.Column column = new Component.Apex.Column(headerValue=fsm.getLabel());
            column.childComponents.add(outputField);
            table.childComponents.add(column);
        }
        return table;
    }
}