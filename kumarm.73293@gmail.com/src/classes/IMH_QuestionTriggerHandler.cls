/**
* @author Accenture IDC 
* @date 08/27/2015
* @group Question
* @group-content N/A
* @description Trigger Handler on Offer that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/
public without sharing class IMH_QuestionTriggerHandler {
	public static Boolean isExecutedBefore = false;
    /*****************************************************************************
    * @description: Mehod called on before update of trigger event
    * @param: Trigger.New,Trigger.OldMap
    * @return: void
    */
    public static void handleBeforeUpdate(List<sObject> ltriggernew
                                         , Map<Id,sObject> mtriggerold){
        IMH_GeneralApplicationUility.checkUniquenessOfRecord(ltriggernew,mtriggerold);
		Map<Id,IMH_Question__c> mDeactivatedQuestions = new Map<Id,IMH_Question__c>();                                         
		for(IMH_Question__c quest : (List<IMH_Question__c>) ltriggernew){
            if(!quest.Active__c 
               	&& quest.Active__c!= Boolean.valueOf(mtriggerold.get(quest.Id).get('Active__c'))){
                mDeactivatedQuestions.put(quest.Id,quest);
            }
        }                                             
        IMH_QuestionTriggerHandler.deleteUnansweredQuestionnaire(mDeactivatedQuestions);
    }
    
    /*****************************************************************************
    * @description: Mehod called on before update of trigger event
    * @param: Trigger.New
    * @return: void
    */
    public static void handleBeforeInsert(List<sObject> ltriggernew){
        IMH_GeneralApplicationUility.checkUniquenessOfRecord(ltriggernew,new Map<Id,sObject>());
    }
    
    /*****************************************************************************
    * @description: Mehod called on before update of trigger event
    * @param: Trigger.New
    * @return: void
    */
    public static void handleBeforeDelete(Map<Id,IMH_Question__c>mtriggerold){
       // IMH_GeneralApplicationUility.checkUniquenessOfRecord(ltriggernew,new Map<Id,sObject>());
         IMH_QuestionTriggerHandler.deleteUnansweredQuestionnaire(mtriggerold);
    }
    
     /*****************************************************************************
    * @description: Mehod called on before update of trigger event
    * @param: Trigger.New
    * @return: void
    */
    public static void deleteUnansweredQuestionnaire(Map<Id,IMH_Question__c> mtriggerold){
        Database.DeleteResult[] drList = Database.delete([SELECT Id,
                                      Question__c
                               FROM IMH_Answer__c
                               WHERE Status__c != 'Completed'
                               AND Question__c IN:mtriggerold.keyset()], true);
	}
}