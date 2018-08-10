<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Account_Name_update</fullName>
        <field>One_Account__c</field>
        <formula>Account.Name</formula>
        <name>Account Name update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>one account can have only one contact</fullName>
        <actions>
            <name>Account_Name_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>one account can have only one contact</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
