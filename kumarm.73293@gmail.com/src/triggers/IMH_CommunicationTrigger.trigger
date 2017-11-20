/**
* @author Accenture IDC 
* @date 05/26/2015
* @group Answer
* @group-content N/A
* @description Trigger on Communication object which looks for the after insert and after update event
*/
trigger IMH_CommunicationTrigger on IMH_Communication__c (after insert,after update,before insert) {
   //INVOKING RESPECTIVE HANDLER CLASS METHOD TO Update the fields Before Insert For Cloning- BEFORE INSERT 
    if(Trigger.isInsert && Trigger.isBefore){
         IMH_CommunicationTriggerHandler.handleBeforeInsert(Trigger.new,Trigger.NewMap);
    }
    if(!IMH_CommunicationTriggerHandler.isExecutedAfter){
        //IMH_CommunicationTriggerHandler.isExecutedAfter = true;
        if(Trigger.isUpdate && Trigger.isAfter){
            IMH_CommunicationTriggerHandler.handleAfterUpdate(Trigger.new,Trigger.NewMap,Trigger.oldMap);
            IMH_CommunicationTriggerHandler.updateRequiredApprover(Trigger.new,Trigger.NewMap,Trigger.oldMap);      
        }
        if(Trigger.isInsert && Trigger.isAfter){
                IMH_CommunicationTriggerHandler.handleAfterInsert(Trigger.new,Trigger.NewMap,Trigger.oldMap);
            }
    }
}