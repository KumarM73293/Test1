/**
* @author Accenture IDC 
* @date 12/11/2015
* @group AnswerSet
* @group-content N/A
* @description Trigger on AnswerSet object which looks for the after insert and after update event
*/
trigger IMH_AnswerSetTrigger on IMH_AnswerSet__c (after insert,after update) {
    //INVOKING RESPECTIVE HANDLER CLASS METHOD TO UPDATE OPEN ANSWERSETS ON TARGET OBJECTS - AFTER UPDATE
    if(!IMH_AnswerSetTriggerHandler.isskipTrigger){
        IMH_AnswerSetTriggerHandler.isExecutedAfter = true;
         //IMH_AnswerSetTriggerHandler.isskipTrigger = true;
        if(Trigger.isUpdate && Trigger.isAfter){
            IMH_AnswerSetTriggerHandler.handleAfterUpdate(Trigger.new,Trigger.NewMap,Trigger.oldMap);
        }
        if(Trigger.isInsert && Trigger.isAfter){
                IMH_AnswerSetTriggerHandler.handleAfterInsert(Trigger.new,Trigger.NewMap,Trigger.oldMap);
        }
    }
}