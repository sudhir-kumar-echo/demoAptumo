//Purpose to show multiple dynamic fields along with id in a pageBlock table
public class ObjectFieldRecordsController
{
//Map to fields to display
public Map<String,String> mapFieldToShow{set;get;}
//List containing field to show on page-block table
public List<String>listFieldToShow{set;get;}
//Map having all  object present in this organization
Map<String,Schema.SObjectType>gd=Schema.getGlobalDescribe();
//List to be set on selected list and have all object present in the organization
public List<SelectOption> listOfObject {get; set;}
//Varible use to store selected value from selectedList of object
public String objectName {get;set;}
//Variable of type SObject which can hold any type of object and is used to hold object obtained from value of ojbect’s selected list
Schema.SObjectType sobj=gd.get(objectName);
//Map to hold fields ofselected object
Map<String, Schema.SObjectField> fieldsMap;
//Variable to hold selected value from selected list of fields
public List<String> stringfieldName{set;get;}
//List to hold field related to selected object fetcehes from database by soql query
public List<SObject> listOfFieldRecord{get;set;}
//Integer variables to contain information for Pagination section
public Integer pageNumber{get;set;}
Integer pageSize=10;
public Integer totalPage{set;get;}
Integer offset{get;set;}
//Constructor to initilize class variables shown on page after class loaded
public ObjectFieldRecordsController()
{
mapFieldToShow = new Map<String,String>();
listFieldToShow = new List<String>();
stringfieldName=new List<String>();
offset=0;
pageNumber=0;
totalPage =0;
listOfObject = new List<SelectOption>();
List<Schema.SObjectType> gd1 =gd.Values();
listOfObject.add(new SelectOption('','–None–'));
//This for loop adds object name to the object’s selected list
for(Schema.SObjectType f : gd1)
listOfObject.add(new SelectOption(f.getDescribe().getLocalName(),f.getDescribe().getLabel()));
listOfObject.sort();
}
//Select-Option type list to return fields of selected object
public List<SelectOption>getFieldName()
{
List<SelectOption>fieldList=new List<SelectOption>();
// fieldList.add(new selectOption(”,’–Select Field—’));
if(objectName != null && objectName !='')
{
sobj = gd.get(objectName);
//Variable to hold all properties of sobj like-fields.label createable etc
Schema.DescribeSObjectResult all = sobj.getDescribe();
fieldsMap = new Map<String, Schema.SObjectField>();
//Adding fields to the fieldsMap
fieldsMap =  all.fields.getMap();
// This for loop add the field api name as a key and field label as value into field list
for(Schema.SObjectField fieldName:fieldsMap.Values())
{
if(fieldName.getDescribe().getName()!='id')
fieldList.add(new SelectOption(fieldname.getDescribe().getName(),fieldName.getDescribe().getLabel()));
}
fieldList.sort();
}
return fieldList;
}
//Function call during onchange of selectedList of object type and fetch id field of records from selected object
public void function()
{
stringFieldName = new List<String>();
if(objectName != '' && objectName != null)
{
sobj =gd.get(objectName);
query();
List<SObject> tempList =Database.query('Select id from '+sobj+' Limit 50000');
//Variable to count the number of records presents for the selected object
Integer count = tempList.size();
if((Math.mod(count,pageSize)) == 0)
totalPage = count/pageSize;
else
totalPage = count/pageSize + 1;
pageNumber = 0;
}
}
//Method to contain state of next button and get call during onclick event of next button
public PageReference next()
{
pageNumber++;
query();
return null;
}
//Method to contain state of previous button and get call during onclick event of previous button
public  PageReference previous()
{
pageNumber--;
query();
return null;
}
//Variable having information when to disable the next button
public Boolean getDisableNext()
{
if (pageNumber <totalPage-1) return true; else return false;
}
//Variable having information when to disable the previous button
public Boolean getDisablePrevious()
{
if (pageNumber > 0) return true; else return false;
}
//This method fetch id from database according to pageNumber and pageSize to display them into PageBlockTable
public void query()
{
offset = pageNumber * pageSize;
Schema.DescribeSObjectResult all=sobj.getDescribe();
if(all.isAccessible() &&   all.isQueryable())
{
if(stringfieldName.size()==0 ||stringfieldName==null)
{
listFieldToShow=new List<String>();
mapFieldToShow=new Map<String,String>();
try
{
listOfFieldRecord = Database.query('Select Id from '+sobj+ ' LIMIT 10 ' +' OFFSET '+ offset);
mapFieldToShow.put('id','id');
listFieldToShow.add('id');
}
catch(Exception e)
{
ApexPages.addMessages(e);
}
}
else
{
listFieldToShow=new List<String>();
mapFieldToShow=new Map<String,String>();
String stringFieldName1='';
try
{
mapFieldToShow.put('id','id');
listFieldToShow.add('id');
for(String s:stringFieldName)
{
stringFieldName1+=','+s;
mapFieldToShow.put(s,s);
listFieldToShow.add(s);
}
listOfFieldRecord = Database.query('Select Id'+stringfieldName1+' from '+sobj+ ' LIMIT 10 ' +' OFFSET '+ offset);
}
catch(Exception e)
{
ApexPages.addMessages(e);
}
}
}
else
listOfFieldRecord=null;
}
}