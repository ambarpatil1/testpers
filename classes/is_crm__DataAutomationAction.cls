/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DataAutomationAction {
    @InvocableMethod(label='Automate Data Sent for Personalization' description='Send Contact/Lead Data from Salesforce to Personalization.')
    global static List<is_crm.DataAutomationAction.Result> bulkInvoke(List<is_crm.DataAutomationAction.RawInput> rawInputs) {
        return null;
    }
global class RawInput {
    @InvocableVariable(label='User Attributes' description='Stringified JSON User attributes.' required=true)
    global String attributes;
    @InvocableVariable(label='Dataset' description='The dataset to save the events in, within the Personalization platform.' required=true)
    global String dataset;
    @InvocableVariable(label='Increase Batch Size' description='Increase Batch Size' required=false)
    global Boolean increaseBatchSize;
    @InvocableVariable(label='Interaction Name' description='Interaction Name' required=false)
    global String interactionName;
    @InvocableVariable(label='Profile Object Configuration' description='Stringified JSON List of Profile Object Configurations' required=false)
    global String profileObjectConfigs;
}
global class Result {
    @InvocableVariable(label='Error Code' description='The error code for the failure.  Omitted if success is true.' required=false)
    global String errorCode;
    @InvocableVariable(label='Error Description' description='The error description for the failure.  Omitted if success is true.' required=false)
    global String errorDescription;
    @InvocableVariable(label='Success' description='True if the request was successfully actioned.  False otherwise.' required=false)
    global Boolean success;
}
}
