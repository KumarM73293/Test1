/**
* @author Accenture IDC 
* @date 05/26/2015
* @group Answer
* @group-content N/A
* @description Trigger on Answer object which looks for the after insert and after update event
*/
trigger IMH_AnswerTrigger on IMH_Answer__c (after insert, after update) {
    //INVOKING HANDLER CLASS METHOD TO UPDATE TARGET OBJECT BASED ON THE ANSWER FOR THE QUESTION - ON AFTER UPDATE
    if(!IMH_AnswerTriggerHandler.isSkipTrigger){
        if(Trigger.isUpdate && Trigger.isAfter && !IMH_AnswerTriggerHandler.isAfterUpdateExecuted){
            IMH_AnswerTriggerHandler.isAfterUpdateExecuted = true;
            IMH_AnswerTriggerHandler.updateTargetObjects(Trigger.New, Trigger.newMap);
            //IMH_AnswerTriggerHandler.recallAnswerWarningOnAnswerChange(Trigger.new,Trigger.NewMap,Trigger.oldMap);
        }
        //INVOKING HANDLER CLASS METHOD TO UPDATE TARGET OBJECT BASED ON THE ANSWER FOR THE QUESTION - ON AFTER INSERT
        if(Trigger.isInsert && Trigger.isAfter && !IMH_AnswerTriggerHandler.isAfterInsertExecuted){
            IMH_AnswerTriggerHandler.isAfterInsertExecuted = true;
            IMH_AnswerTriggerHandler.updateTargetObjects(Trigger.New, Trigger.newMap);
        } 
       }
}