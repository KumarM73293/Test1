/**
* @author Accenture IDC 
* @date 31/03/2016
* @group SLATracker
* @group-content N/A
* @description Trigger on SLATracker object which looks for the after update event
*/
trigger IMH_SLATrackerTrigger on IMH_SLATracker__c (after update,before update) {
    //INVOKING RESPECTIVE HANDLER CLASS METHOD TO UPDATE ALL OTHER PENDING APPROVAL RECORDS  - Before UPDATE
    if(Trigger.isUpdate && Trigger.isBefore){
            IMH_SLATrackerTriggerHandler.handleBeforeUpdate(Trigger.new,Trigger.NewMap,Trigger.oldMap);
        }
    //INVOKING RESPECTIVE HANDLER CLASS METHOD TO UPDATE ALL OTHER PENDING APPROVAL RECORDS  - AFTER UPDATE
     if(Trigger.isUpdate && Trigger.isAfter){
             if(!IMH_SLATrackerTriggerHandler.isExecutedAfter){
                    IMH_SLATrackerTriggerHandler.isExecutedAfter = true;
                    IMH_SLATrackerTriggerHandler.handleAfterUpdate(Trigger.new,Trigger.NewMap,Trigger.oldMap);
                 }
        }
}