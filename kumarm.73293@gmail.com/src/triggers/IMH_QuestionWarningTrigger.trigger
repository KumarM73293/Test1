/**
* @author Accenture IDC 
* @date 05/26/2015
* @group QuestionWarning
* @group-content N/A
* @description Trigger on QuestionWarning object which looks for the before insert and before update event
*/
trigger IMH_QuestionWarningTrigger on IMH_QuestionWarning__c (before insert,before update) {
    
    //INVOKING RESPECTIVE HANDLER CLASS METHOD TO CHECK THE UNIQUESNESS OF A RECORD
    if(!IMH_QuestionWarningTriggerHandler.isExecutedBefore){
        IMH_QuestionWarningTriggerHandler.isExecutedBefore = true;
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                IMH_QuestionWarningTriggerHandler.handleBeforeInsert(Trigger.New);
            }
            else{
                IMH_QuestionWarningTriggerHandler.handleBeforeUpdate(Trigger.New,Trigger.OldMap);
            }
        }
    }
}