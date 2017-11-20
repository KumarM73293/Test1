/**
* @author Accenture IDC 
* @date 03/22/2016
* @group Attachment
* @group-content N/A
* @description Trigger on AnswerSet object which looks for the after insert and after update event
*/
trigger IMH_AttachmentTrigger on Attachment (after insert, after delete, after undelete, before delete, before update) {
    //HANDLER METHOD CALLED TO UPDATE THE FINAL CREATIVE RECORD IF ATTACHMENT IS STAMPED TO THAT.
    if((Trigger.isInsert && Trigger.isAfter) || (Trigger.isUndelete && Trigger.isAfter)){
    	IMH_AttachmentTriggerHandler.updateFinalCreative(Trigger.New);
    }
    if(Trigger.isDelete && Trigger.isAfter) {
        IMH_AttachmentTriggerHandler.updateCreativeAndCommunicationOnDelete(Trigger.Old);
    }
    if(Trigger.isDelete && Trigger.isBefore) {
        IMH_AttachmentTriggerHandler.checkCommunicationStageonDelete(Trigger.oldMap);
    }
    if(Trigger.isUpdate && Trigger.isBefore) {
        IMH_AttachmentTriggerHandler.preventUpdateByReviewer(Trigger.New);
    }
}