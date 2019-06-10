<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Opp_Prod_Update_Prd_Family</fullName>
        <description>Opportunity Product - update Product Family with value from product.</description>
        <field>Product_Family__c</field>
        <formula>TEXT ( PricebookEntry.Product2.Family )</formula>
        <name>Opp Prod - Update Prd Family</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Opp Product - Update Product Family</fullName>
        <actions>
            <name>Opp_Prod_Update_Prd_Family</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>On Opportunity Product update Product Family from Product to support revenue splits.</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
