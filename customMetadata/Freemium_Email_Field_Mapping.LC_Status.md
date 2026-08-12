<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Lead Create Status</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Allowed_Values__c</field>
        <value xsi:type="xsd:string">1-Open,3-MQL,4-SAL,5-SQL,6-Recycled,7-Disqualified</value>
    </values>
    <values>
        <field>Default_Value__c</field>
        <value xsi:type="xsd:string">3-MQL</value>
    </values>
    <values>
        <field>Event_Type__c</field>
        <value xsi:type="xsd:string">LEAD_CREATE</value>
    </values>
    <values>
        <field>Payload_Path__c</field>
        <value xsi:type="xsd:string">lead.leadStatus</value>
    </values>
    <values>
        <field>Required__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Target_Field__c</field>
        <value xsi:type="xsd:string">Status</value>
    </values>
    <values>
        <field>Target_Object__c</field>
        <value xsi:type="xsd:string">Lead</value>
    </values>
</CustomMetadata>
