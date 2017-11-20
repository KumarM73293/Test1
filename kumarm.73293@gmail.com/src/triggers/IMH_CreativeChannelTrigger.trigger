/**
* @author Accenture IDC 
* @date 01/12/2016
* @group Answer
* @group-content N/A
* @description Trigger on Targeted Channel object which looks for the before delete and after update event
*               Basically triggers prevents deletion of records based on status during approval process and 
*               reject creative and targeted products if all targeted channels are rejected.
*/
trigger IMH_CreativeChannelTrigger on IMH_CreativeChannel__c (after update, before delete,after insert,after delete, after undelete) {
    if( Trigger.isAfter){
        if(Trigger.isDelete){
            IMH_ChannelProductRejectHandler.updateRequiredApproversOnCreative(Trigger.Old,new Set<Id>()); 
        }
        else if(Trigger.isUnDelete){
            IMH_ChannelProductRejectHandler.updateRequiredApproversOnCreative(Trigger.New,new Set<Id>()); 
        }
        else if(Trigger.isInsert){
            IMH_ChannelProductRejectHandler.updateRequiredApproversOnCreative(Trigger.New,new Set<Id>()); 
         }
    }
    else {
        if(Trigger.isDelete){
            IMH_ChannelsProductsPreventDelete.checkRecordStatus(Trigger.Old);
        }
    }
}