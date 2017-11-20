/**
* @author Accenture IDC 
* @date 05/26/2015
* @group ResponseValue
* @group-content N/A
* @description Trigger on ResponseValue object which looks for the before insert and before update event
*/
trigger IMH_ResponseValueTrigger on IMH_ResponseValue__c (before insert,before update) {
    
    //INVOKING RESPECTIVE HANDLER CLASS METHOD TO CHECK THE UNIQUESNESS OF A RECORD
    if(!IMH_ResponseValueTriggerHandler.isExecutedBefore){
        IMH_ResponseValueTriggerHandler.isExecutedBefore = true;
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                IMH_ResponseValueTriggerHandler.handleBeforeInsert(Trigger.New);
            }
            else{
                IMH_ResponseValueTriggerHandler.handleBeforeUpdate(Trigger.New,Trigger.OldMap);
            }
        }
    }
}