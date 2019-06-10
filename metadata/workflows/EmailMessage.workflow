<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Case_Set_Priority_to_Production_Critical</fullName>
        <field>Priority</field>
        <literalValue>Critical Production Issue</literalValue>
        <name>Case Set Priority to Production Critical</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_Escalated</fullName>
        <field>Status</field>
        <literalValue>Escalated</literalValue>
        <name>Set Status Escalated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Email Message - Urgent Case</fullName>
        <actions>
            <name>Case_Set_Priority_to_Production_Critical</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_Escalated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Subject</field>
            <operation>contains</operation>
            <value>URGENT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>notEqual</operation>
            <value>Critical Production Issue</value>
        </criteriaItems>
        <description>When subject of email contains Urgent then set Case status to Escalated and Priority to Production Critical issue.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
