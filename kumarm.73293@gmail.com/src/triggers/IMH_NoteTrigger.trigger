/**
* @author Accenture IDC 
* @date 05/20/2016
* @group Note
* @group-content N/A
* @description Trigger on Note to restrict reviewers to edit or delete a note
*/
trigger IMH_NoteTrigger on Note (before update, before delete) {
    if(Trigger.isDelete && Trigger.isBefore){
        IMH_NoteTriggerHandler.preventDelete(Trigger.oldMap);
    }
    if(Trigger.isUpdate && Trigger.isBefore){
        IMH_NoteTriggerHandler.preventUpdate(Trigger.New);
    }
}