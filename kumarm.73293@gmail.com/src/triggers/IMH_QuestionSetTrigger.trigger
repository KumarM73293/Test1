/**
* @author Accenture IDC 
* @date 05/26/2015
* @group QuestionSet
* @group-content N/A
* @description Trigger on QuestionSet object which looks for the before insert and before update event
*/
trigger IMH_QuestionSetTrigger on IMH_QuestionSet__c (before insert,before update) {
    
    //INVOKING RESPECTIVE HANDLER CLASS METHOD TO CHECK THE UNIQUESNESS OF A RECORD
    if(!IMH_QuestionSetTriggerHandler.isExecutedBefore){
        IMH_QuestionSetTriggerHandler.isExecutedBefore = true;
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                IMH_QuestionSetTriggerHandler.handleBeforeInsert(Trigger.New);
            }
            else{
                IMH_QuestionSetTriggerHandler.handleBeforeUpdate(Trigger.New,Trigger.OldMap);
            }
        }
    }
}