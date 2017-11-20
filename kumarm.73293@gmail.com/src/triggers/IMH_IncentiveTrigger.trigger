/**
* @author Accenture IDC 
* @date 03/03/2016
* @group CommCreative
* @group-content N/A
* @description Trigger on Incentive object which looks for the after insert and after update event
*/
trigger IMH_IncentiveTrigger on IMH_Incentive__c (after insert,after update,before delete, after delete,after undelete) {
    //INVOKING RESPECTIVE HANDLER CLASS METHOD TO INSERT ANSWERSET BASED ON CRITERIA OF UPDATED CommCreative OBJECTS - AFTER UPDATE
    if(Trigger.isAfter){
        if(!IMH_IncentiveTriggerHandler.isExecutedAfter){
            IMH_IncentiveTriggerHandler.isExecutedAfter = true;
            
            if(Trigger.isUpdate){
                IMH_IncentiveTriggerHandler.handleAfterUpdate(Trigger.new,Trigger.NewMap,Trigger.oldMap);
            }
            else if(Trigger.isUndelete){
                IMH_IncentiveTriggerHandler.handleAfterUndelete(Trigger.new,Trigger.NewMap,Trigger.oldMap);
            }
            //INVOKING RESPECTIVE HANDLER CLASS METHOD TO INSERT ANSWERSET BASED ON CRITERIA OF UPDATED CommCreative OBJECTS - AFTER INSERT
            else if(Trigger.isInsert){
                IMH_IncentiveTriggerHandler.handleAfterInsert(Trigger.new,Trigger.NewMap,Trigger.oldMap);
            }
            else if(Trigger.isDelete){
                IMH_IncentiveTriggerHandler.handleAfterDelete(Trigger.Old);
            }
        
    	}
    }else{
        if(Trigger.isDelete){
                IMH_IncentiveTriggerHandler.handleBeforeDelete(Trigger.new,Trigger.NewMap,Trigger.oldMap);
        }
    }
}