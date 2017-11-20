/**
* @author Accenture IDC 
* @date 03/03/2016
* @group CommCreative
* @group-content N/A
* @description Trigger on Creative object which looks for the after insert and after update event
*/
trigger IMH_CommCreativeTrigger on IMH_CommCreative__c (after insert,after update) {
	//INVOKING RESPECTIVE HANDLER CLASS METHOD TO INSERT ANSWERSET BASED ON CRITERIA OF UPDATED CommCreative OBJECTS - AFTER UPDATE
    if(Trigger.isUpdate && Trigger.isAfter){
        IMH_CommCreativeTriggerHandler.handleAfterUpdate(Trigger.new,Trigger.NewMap,Trigger.oldMap);
    }
    //INVOKING RESPECTIVE HANDLER CLASS METHOD TO INSERT ANSWERSET BASED ON CRITERIA OF UPDATED CommCreative OBJECTS - AFTER INSERT
    if(Trigger.isInsert && Trigger.isAfter){
       IMH_CommCreativeTriggerHandler.handleAfterInsert(Trigger.new,Trigger.NewMap,Trigger.oldMap);
    }
}