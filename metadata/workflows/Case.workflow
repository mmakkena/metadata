<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert</fullName>
        <description>Email Alert - Support Ticket Received</description>
        <protected>false</protected>
        <recipients>
            <recipient>jhorty@hardingpoint.com.main</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GRAX_Support/Support_Ticket_Received</template>
    </alerts>
    <alerts>
        <fullName>Level_2_Email_Notification_After_Business_Hours</fullName>
        <description>Level 2 Email Notification - After Business Hours</description>
        <protected>false</protected>
        <recipients>
            <recipient>L2_GRAX_Support_After_Hours</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>response@grax.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GRAX_Support/Level_2_Support_Request_Internal</template>
    </alerts>
    <alerts>
        <fullName>Level_2_Email_Notification_During_Business_Hours</fullName>
        <description>Level 2 Email Notification - During Business Hours</description>
        <protected>false</protected>
        <recipients>
            <recipient>L2_GRAX_Support</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>response@grax.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GRAX_Support/Level_2_Support_Request_Internal</template>
    </alerts>
    <fieldUpdates>
        <fullName>Case_Assign_to_Level_1_Support</fullName>
        <field>OwnerId</field>
        <lookupValue>Level_1_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case - Assign to Level 1 Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Set_Escalated_True</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>Case Set Escalated True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Set_Provisioned_Date</fullName>
        <description>Set Provisioned Date field on Case to current date.</description>
        <field>Provisioned_Date__c</field>
        <formula>Today()</formula>
        <name>Case - Set Provisioned Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Set_Status_to_Escalated</fullName>
        <field>Status</field>
        <literalValue>Escalated</literalValue>
        <name>Case - Set Status to Escalated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Owner_to_Level_2_Support</fullName>
        <field>OwnerId</field>
        <lookupValue>Level_2_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Case Owner to Level 2 Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_to_GRAX_Support</fullName>
        <field>RecordTypeId</field>
        <lookupValue>GRAX_Support</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT to GRAX Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Case - Email when support ticket created</fullName>
        <actions>
            <name>Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GRAX Support</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Escalate to Level 2</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Critical Production Issue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalated</value>
        </criteriaItems>
        <description>Escalate case to Level 2 support based on escalation criteria.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Case_Owner_to_Level_2_Support</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case - Level 2 Assigned - After Business Hours</fullName>
        <actions>
            <name>Level_2_Email_Notification_After_Business_Hours</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Workflow to send Level 2 notifications after business hours.</description>
        <formula>AND(  Owner:Queue.DeveloperName = &apos;Level_2_Support&apos;,  ISPICKVAL( Status, &apos;Escalated&apos;),  (CASE( MOD( DateValue(LastModifiedDate) - DATE(1900, 1, 7), 7),  0, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.SundayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.SundayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;) ,  1, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.MondayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.MondayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;) ,  2, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.TuesdayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.TuesdayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;) ,  3, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.WednesdayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.WednesdayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;) ,  4, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.ThursdayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.ThursdayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;) ,  5, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.FridayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.FridayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;) ,  6, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.SaturdayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.SaturdayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;) ,  &quot;F&quot;) = &quot;F&quot;)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Level_2_Email_Notification_After_Business_Hours</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Level_2_Email_Notification_After_Business_Hours</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Level_2_Email_Notification_During_Business_Hours</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Level_2_Email_Notification_After_Business_Hours</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Level_2_Email_Notification_After_Business_Hours</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case - Level 2 Assigned - During Business Hours</fullName>
        <actions>
            <name>Level_2_Email_Notification_During_Business_Hours</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Workflow to send Level 2 notifications during business hours.</description>
        <formula>AND( Owner:Queue.DeveloperName = &apos;Level_2_Support&apos;, ISPICKVAL( Status, &apos;Escalated&apos;),  (CASE( MOD(  DateValue(LastModifiedDate)  - DATE(1900, 1, 7), 7),  0, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.SundayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.SundayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;)  ,  1, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.MondayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.MondayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;) ,  2, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.TuesdayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.TuesdayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;) ,  3, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.WednesdayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.WednesdayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;) ,  4, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.ThursdayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.ThursdayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;) ,  5, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.FridayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.FridayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;) ,  6, IF (AND ( TIMEVALUE(LastModifiedDate)&gt;= BusinessHours.SaturdayStartTime, TIMEVALUE(LastModifiedDate)&lt;= BusinessHours.SaturdayEndTime) = TRUE, &quot;T&quot;,&quot;F&quot;) , &quot;F&quot;) = &quot;T&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Level_2_Email_Notification_After_Business_Hours</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Level_2_Email_Notification_During_Business_Hours</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Level_2_Email_Notification_During_Business_Hours</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Level_2_Email_Notification_During_Business_Hours</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Level_2_Email_Notification_During_Business_Hours</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Level_2_Email_Notification_During_Business_Hours</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case - Set Escalated Flag True</fullName>
        <actions>
            <name>Case_Set_Escalated_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalated</value>
        </criteriaItems>
        <description>On Case set Escalated Flag to True when status set to Escalated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case - Set Provisioned Date</fullName>
        <actions>
            <name>Case_Set_Provisioned_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Provisioned__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Provisioned_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GRAX Implementation</value>
        </criteriaItems>
        <description>If Provisioned = True and Provisioned Date is Null then set to current date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case - Set Status to Escalated</fullName>
        <actions>
            <name>Case_Set_Status_to_Escalated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>On Case Create if Owner &lt;&gt; User and Priority = Critical Production Issue the set status to Escalated.</description>
        <formula>AND( ISPICKVAL(Priority, &apos;Critical Production Issue&apos;), BEGINS( OwnerId , &quot;00G&quot;), Web_Created__c = TRUE )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Web Created Support</fullName>
        <actions>
            <name>Case_Assign_to_Level_1_Support</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_RT_to_GRAX_Support</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Web_Created__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>On Case creation from web assign case to Level 1 support.  Also assign Record Type to GRAX Support.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
