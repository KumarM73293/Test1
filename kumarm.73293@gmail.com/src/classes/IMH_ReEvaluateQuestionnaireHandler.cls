/**
* @author Accenture IDC 
* @date 01/14/2016
* @group Escalation
* @group-content N/A
* @description Code for Questionnaire Re-Evaluation
*/
public without sharing class IMH_ReEvaluateQuestionnaireHandler {
    
    private static final String BENEFITSTEAMS = 'Benefits Team';
    public static Boolean reEvaluateQuestionnaire = false;
    /*****************************************************************************
    * @description: Method to update Answers so as to update the required Approvers Field.
    * @param: Object Name, Map of records & boolean that indicates whether records need re-evaluation
    * @return: none
    */
    public static void reEvaluate(String objectName, 
                                  Map<sObject,Boolean> sObjIsUpdateRequiredMap){
        
        List<IMH_Answer__c> answersToUpdate = new List<IMH_Answer__c>();
        Set<Id> commIds = new Set<Id>();
        if(objectName.equalsIgnoreCase(IMH_UtilityConstants.INCENTIVE_OBJECT_API)){
            for(IMH_Incentive__c inc : [SELECT Id, Communication__c FROM IMH_Incentive__c
                                        WHERE id =: sObjIsUpdateRequiredMap.keyset()]){
                commIds.add(inc.Communication__c);
            }
        }
        for(IMH_AnswerSet__c ansSet: [SELECT Id, 
                                          (SELECT Id,Question__c,Answer__c FROM Answers__r) 
                                          FROM IMH_AnswerSet__c
                                          WHERE (Communication__c =:sObjIsUpdateRequiredMap.keySet() OR 
                                                    Communication__c =:commIds) ]){
                if(!ansSet.Answers__r.isEmpty()){
                    answersToUpdate.addAll(ansSet.Answers__r);
                }                                                        
        }
        if(!answersToUpdate.isEmpty()){
                reEvaluateQuestionnaire = true;
                Database.update(answersToUpdate,true);
        }
        
    }
}