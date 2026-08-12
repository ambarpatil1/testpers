<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Test_EmailAlert</fullName>
        <description>Test_EmailAlert</description>
        <protected>false</protected>
        <recipients>
            <recipient>michal.furmanek1@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CommunityLockoutEmailTemplate</template>
    </alerts>
    <outboundMessages>
        <fullName>Test_Outbound</fullName>
        <apiVersion>62.0</apiVersion>
        <endpointUrl>https://www.google.com/</endpointUrl>
        <fields>AccountNumber</fields>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>arm-qa@autorabit.com.keystone</integrationUser>
        <name>Test_Outbound</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
</Workflow>