<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Closed_Lost_EA</fullName>
        <ccEmails>sudhir.kumar@centurylink.com</ccEmails>
        <description>Closed Lost_EA</description>
        <protected>false</protected>
        <recipients>
            <recipient>sudhir.kumar@gmail.com.mydev</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Closed_Lost_ET</template>
    </alerts>
    <rules>
        <fullName>Closed Lost_WR</fullName>
        <actions>
            <name>Closed_Lost_EA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>test1111</fullName>
        <active>false</active>
        <formula>ISPICKVAL(StageName, &apos;Prospecting&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>test111166</fullName>
        <active>false</active>
        <formula>ISPICKVAL(StageName, &apos;Prospecting&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
