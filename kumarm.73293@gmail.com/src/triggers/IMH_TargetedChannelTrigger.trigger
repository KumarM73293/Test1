/**
* @author Accenture IDC 
* @date 06/08/2016
* @group Answer
* @group-content N/A
* @description Trigger on Targeted Product object which looks for all possible events
*/
trigger IMH_TargetedChannelTrigger on IMH_CommChannels__c (after update, before delete,after insert,after delete, after undelete) {
  if(IMH_TargetedChannelTriggerHandler.isExecutionControl){
    if(Trigger.isBefore && Trigger.isDelete){
        IMH_TargetedChannelTriggerHandler.processBeforeDelete(Trigger.OldMap);
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            IMH_TargetedChannelTriggerHandler.processAfterInsert(Trigger.new,Trigger.NewMap,Trigger.OldMap);
        }
        if(Trigger.isDelete){
          IMH_TargetedChannelTriggerHandler.processAfterDelete(Trigger.OldMap);
        }
        else if(Trigger.isUndelete){
            IMH_TargetedChannelTriggerHandler.processAfterUndelete(Trigger.new);
        }
    }
    }
}