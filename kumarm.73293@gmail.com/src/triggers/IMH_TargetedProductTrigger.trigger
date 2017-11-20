/**
* @author Accenture IDC 
* @date 06/08/2016
* @group Answer
* @group-content N/A
* @description Trigger on Targeted Product object which looks for all possible events
*/
trigger IMH_TargetedProductTrigger on IMH_CommProducts__c (after update, before delete,after insert,after delete, after undelete) {
    if(IMH_TargetedProductTriggerHandler.isExecutionControl){
  //INVOKING RESPECTIVE HANDLER CLASS METHOD TO INSERT ANSWERSET BASED ON CRITERIA OF UPDATED CommCreative OBJECTS - AFTER UPDATE
    if(Trigger.isAfter){
            if(Trigger.isUndelete){
                IMH_TargetedProductTriggerHandler.handleAfterUndelete(Trigger.new,Trigger.NewMap,Trigger.oldMap);
            }
            //INVOKING RESPECTIVE HANDLER CLASS METHOD TO INSERT ANSWERSET BASED ON CRITERIA OF UPDATED CommCreative OBJECTS - AFTER INSERT
            else if(Trigger.isInsert){
                IMH_TargetedProductTriggerHandler.handleAfterInsert(Trigger.new,Trigger.NewMap,Trigger.oldMap);
            }
            else if(Trigger.isDelete){
                IMH_TargetedProductTriggerHandler.handleAfterDelete(new List<IMH_CommProducts__c>(),new Map<Id,IMH_CommProducts__c>(), Trigger.OldMap);
            }
        
        }
    else{
        if(Trigger.isDelete){
                IMH_TargetedProductTriggerHandler.handleBeforeDelete(Trigger.new,Trigger.NewMap,Trigger.oldMap);
        }
    }
  }
}