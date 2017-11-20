/**
* @author Accenture IDC 
* @date 12/11/2015
* @group Benefit
* @group-content N/A
* @description Trigger on Benefit object which looks for the after insert and after update event
*/
trigger IMH_BenefitTrigger on IMH_Benefits__c (after insert,after update) {
    //INVOKING RESPECTIVE HANDLER CLASS METHOD TO INSERT ANSWERSET BASED ON CRITERIA OF UPDATED BENEFIT OBJECTS - AFTER UPDATE
    if(!IMH_BenefitTriggerHandler.isExecutedAfter){
        IMH_BenefitTriggerHandler.isExecutedAfter = true;
        if(Trigger.isUpdate && Trigger.isAfter){
            IMH_BenefitTriggerHandler.handleAfterUpdate(Trigger.new,Trigger.NewMap,Trigger.oldMap);
        }
        if(Trigger.isInsert && Trigger.isAfter){
                IMH_BenefitTriggerHandler.handleAfterInsert(Trigger.new,Trigger.NewMap,Trigger.oldMap);
        }
    }
}