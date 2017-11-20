/**
* @author Accenture IDC 
* @date 05/26/2015
* @group Answer
* @group-content N/A
* @description Trigger Handler on Incentive that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/
public without sharing class IMH_IncentiveTriggerHandler {
    public static Boolean isExecutedAfter = false;
    private static final String COMMUNICATION_FIELD = 'Communication__c';
    private static final String INCENTIVE_STATUS_CANCELLED = 'Cancelled';
    private static final String SEMICOLON_SPACE ='; ' ;
    private static final String REEVALUATE_FIELD_SET_NAME ='IMH_Re_Evaluate_Questionnaire_Fields';
   
   /*****************************************************************************
    * @description: Mehod called on after update of trigger event
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
    public static void handleAfterUpdate(List<sObject> ltriggernew
                                         , Map<Id,sObject> mtriggernew
                                         , Map<Id,sObject> mtriggerold){
        Set<Id> communicationIds = new Set<Id>();                                             
        Boolean isAnswerUpdateRequired = false;
        Map<sObject,Boolean> IncUpdateRequiredMap = new Map<sObject,Boolean>();
        List <Schema.FieldSetMember> reqApproversTriggerField = new List<Schema.FieldSetMember>();
        reqApproversTriggerField = IMH_GeneralApplicationUility.readFieldSet(REEVALUATE_FIELD_SET_NAME,IMH_UtilityConstants.INCENTIVE_OBJECT_API);
        for(sObject sObj :ltriggernew){
            communicationIds.add(String.valueOf(sObj.get(COMMUNICATION_FIELD)));
            for(Schema.FieldSetMember field : reqApproversTriggerField) {
                if(mtriggernew.get(sObj.Id).get(field.getFieldPath()) != mtriggerold.get(sobj.Id).get(field.getFieldPath())) {
                    isAnswerUpdateRequired = true;
                    IncUpdateRequiredMap.put(sObj,true);
                    break;
                }
            }    
        }
        if(isAnswerUpdateRequired) {
            IMH_ReEvaluateQuestionnaireHandler.reEvaluate(IMH_UtilityConstants.INCENTIVE_OBJECT_API, IncUpdateRequiredMap);                                        
        }
        IMH_GeneralApplicationUility.updateAnswerStatus(ltriggernew,mtriggernew,communicationIds,IMH_UtilityConstants.CONCEPT,IMH_UtilityConstants.INCENTIVE_OBJECT_API);                          
    }
    
   /*****************************************************************************
    * @description: Mehod called on after insert of trigger event
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
    public static void handleAfterInsert(List<sObject>ltriggernew
                                         , Map<Id,sObject> mtriggernew
                                         , Map<Id,sObject> mtriggerold){
        Set<Id> communicationIds = new Set<Id>();    
        Map<sObject,Boolean> IncUpdateRequiredMap = new Map<sObject,Boolean>();
        for(sObject sObj :ltriggernew){
            communicationIds.add(String.valueOf(sObj.get(COMMUNICATION_FIELD)));
            IncUpdateRequiredMap.put(sObj,true);
        }       
        IMH_ReEvaluateQuestionnaireHandler.reEvaluate(IMH_UtilityConstants.INCENTIVE_OBJECT_API, IncUpdateRequiredMap);                                        
        IMH_GeneralApplicationUility.updateAnswerStatus(ltriggernew,mtriggernew,communicationIds,IMH_UtilityConstants.CONCEPT,IMH_UtilityConstants.INCENTIVE_OBJECT_API);                                                                         

    }
    
    /*
    * @description: Mehod called on after delete of trigger event
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
    public static void handleAfterDelete(List<sObject> ltriggerOld){
        Set<Id> communicationIds = new Set<Id>();                                               
        Map<sObject,Boolean> IncUpdateRequiredMap = new Map<sObject,Boolean>();
        System.debug('RR__TriggerOld>>>>>: '+ltriggerOld);
        for(sObject sObj :ltriggerOld){
            communicationIds.add(String.valueOf(sObj.get(COMMUNICATION_FIELD)));
            IncUpdateRequiredMap.put(sObj,true);
        }          
        System.debug('11111__TIncUpdateRequiredMap>>>>>: '+IncUpdateRequiredMap);
        IMH_ReEvaluateQuestionnaireHandler.reEvaluate(IMH_UtilityConstants.INCENTIVE_OBJECT_API, IncUpdateRequiredMap);                                        
        IMH_GeneralApplicationUility.updateAnswerStatus(ltriggerOld,null,communicationIds,IMH_UtilityConstants.CONCEPT,IMH_UtilityConstants.INCENTIVE_OBJECT_API);                                                                         
    }
    
    /*****************************************************************************
    * @description: Mehod called on after Undelete of trigger event
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
    public static void handleAfterUndelete(List<sObject>ltriggernew
                                         , Map<Id,sObject> mtriggernew
                                         , Map<Id,sObject> mtriggerold){
        Set<Id> communicationIds = new Set<Id>(); 
        Map<sObject,Boolean> IncUpdateRequiredMap = new Map<sObject,Boolean>();
        for(sObject sObj :ltriggernew){
            communicationIds.add(String.valueOf(sObj.get(COMMUNICATION_FIELD)));
            IncUpdateRequiredMap.put(sObj,true);
        }
        System.debug('11111__TIncUpdateRequiredMap>>>>>: '+IncUpdateRequiredMap);
        IMH_ReEvaluateQuestionnaireHandler.reEvaluate(IMH_UtilityConstants.INCENTIVE_OBJECT_API, IncUpdateRequiredMap);                                        
        IMH_GeneralApplicationUility.updateAnswerStatus(ltriggernew,mtriggernew,communicationIds,IMH_UtilityConstants.CONCEPT,IMH_UtilityConstants.INCENTIVE_OBJECT_API);                                                                         
    }   
    
    /*****************************************************************************
    * @description: Mehod called on after Undelete of trigger event
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
    public static void handleBeforeDelete(List<sObject>ltriggernew
                                         , Map<Id,sObject> mtriggernew
                                         , Map<Id,sObject> mtriggerold){
            IMH_GeneralApplicationUility.preventDeletion(mtriggerold,Label.IMH_PreventDeletionOfIncentive,IMH_UtilityConstants.INCENTIVE_OBJECT_API);
    }
    
}