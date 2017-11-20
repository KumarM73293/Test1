/**
* @author Accenture IDC 
* @date 05/26/2015
* @group Answer
* @group-content N/A
* @description Trigger on Campaign object which looks for the before insert and before update event
*/
trigger IMH_QuestionTrigger on IMH_Question__c (before insert,before update,before delete) {
    
    //INVOKING RESPECTIVE HANDLER CLASS METHOD TO CHECK THE UNIQUESNESS OF A RECORD
    if(!IMH_QuestionTriggerHandler.isExecutedBefore){
        IMH_QuestionTriggerHandler.isExecutedBefore = true;
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                IMH_QuestionTriggerHandler.handleBeforeInsert(Trigger.New);
            }
            else if(Trigger.isUpdate){
                 IMH_QuestionTriggerHandler.handleBeforeUpdate(Trigger.New,Trigger.OldMap);
            }
            else if(Trigger.isDelete){
                System.debug('***Quest 1 ');
                 IMH_QuestionTriggerHandler.handleBeforeDelete(Trigger.OldMap);
            }
        }
    }
}