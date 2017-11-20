/**
* @author Accenture IDC 
* @date 12/11/2015
* @group AnswerSet
* @group-content N/A
* @description Trigger Handler on AnswerSet that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/ 
public without sharing class IMH_AnswerSetTriggerHandler {
    public static Boolean isExecutedAfter = false;
    public static Boolean isskipTrigger = false;
    private static final String SYSOPENANSWERSET_API = 'SYSOpenAnswerSets__c';
    private static final String SYSOPENANSWERSETCONCEPT_API =  'SYSOpenAnswerSetsForConcept__c';
    private static final String SYSOPENANSWERSETCREATIVE_API =  'SYSOpenAnswerSetsForCreative__c';
    private static final String SYSOPENANSWERSETPREEXEC_API =  'SYSOpenAnswerSetsForPreExecution__c';
    private static final String SYSOPENANSWERSETREEXEC_API =  'SYSOpenAnswerSetsForReadyForExecution__c';
    /*****************************************************************************
    * @description: Mehod called on after update of trigger event
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
    public static void handleAfterUpdate(List<IMH_AnswerSet__c> ltriggernew
                                         , Map<Id,IMH_AnswerSet__c> mtriggernew
                                         , Map<Id,IMH_AnswerSet__c> mtriggerold){
        IMH_AnswerSetTriggerHandler.calculateOpenAnswerSet(ltriggernew, mtriggernew, mtriggerold);
    }
    
   /*****************************************************************************
    * @description: Mehod called on after insert of trigger event
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
     public static void handleAfterInsert(List<IMH_AnswerSet__c>ltriggernew
                                          , Map<Id,IMH_AnswerSet__c> mtriggernew
                                          , Map<Id,IMH_AnswerSet__c> mtriggerold){
        IMH_AnswerSetTriggerHandler.calculateOpenAnswerSet(ltriggernew, mtriggernew, new Map<Id,IMH_AnswerSet__c>());
    }
     /*****************************************************************************
    * @description: Mehod called to calculate the total numbver of Open Answer Set on or without Update of Incentives
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
    private static void calculateOpenAnswerSet(List<IMH_AnswerSet__c>ltriggernew
                                          , Map<Id,IMH_AnswerSet__c> mtriggernew
                                          , Map<Id,IMH_AnswerSet__c> mtriggerold){
        Set<Id> sObjectIds = new Set<Id>();
        Map<String,String> ansSetIdByTargetId = new Map<String,String>();
        Map<String,String> stageByAPIName = new Map<String,String>();
        stageByAPIName.put(IMH_UtilityConstants.CONCEPT,SYSOPENANSWERSETCONCEPT_API);
        stageByAPIName.put(IMH_UtilityConstants.CREATIVE,SYSOPENANSWERSETCREATIVE_API);
        stageByAPIName.put(IMH_UtilityConstants.PRE_EXECUTION,SYSOPENANSWERSETPREEXEC_API);
        stageByAPIName.put(IMH_UtilityConstants.READY_FOR_EXECUTION,SYSOPENANSWERSETREEXEC_API);                                                        
        stageByAPIName.put('Creative-Compliance','SYSOpenAnswerSetsForCompliance__c');                                                          
                                            
        for(IMH_AnswerSet__c ansSet : ltriggernew){
            
            if(mtriggerold.isEmpty() || ansSet.Status__c != mtriggerold.get(ansSet.Id).Status__c){
                if(ansSet.Benefits__c!=null) {
                    ansSetIdByTargetId.put(ansSet.Id,ansSet.Benefits__c);
                }
                else {
                    ansSetIdByTargetId.put(ansSet.Id,ansSet.Communication__c);
                }
            } 
        }
        Map<Id,List<IMH_AnswerSet__c>> mListOfOpenAnswerByTargetId = new Map<Id,List<IMH_AnswerSet__c>>();
        List<IMH_AnswerSet__c> tempAnsList = new List<IMH_AnswerSet__c>();
        String targetId = IMH_UtilityConstants.EMPTY_STRING;                                              
        for(IMH_AnswerSet__c ansSet : [SELECT Id,Benefits__c,Communication__c,Status__c,SYS_CommunicaitonQuestionSetType__c FROM IMH_AnswerSet__c 
                                                    WHERE Benefits__c IN :ansSetIdByTargetId.values()
                                                    OR Communication__c IN :ansSetIdByTargetId.values()]) {
            if(ansSet.Benefits__c!=null) {
                targetId = ansSet.Benefits__c;
            }
            else {
                targetId = ansSet.Communication__c;
            }
            tempAnsList= new List<IMH_AnswerSet__c>();  
            //system.debug('--->>>>>>ansSet--->>>'+ansSet);                                           
            if(!IMH_UtilityConstants.ANS_SET_COMPLETED.equalsIgnoreCase(ansSet.Status__c)) {
                //system.debug('--->>>>>>ansSet--->>>'+ targetId);       
                if(!mListOfOpenAnswerByTargetId.containsKey(targetId)){
                    mListOfOpenAnswerByTargetId.put(targetId, new List<IMH_Answerset__c>{ansSet});
                }
                else {
                    tempAnsList = mListOfOpenAnswerByTargetId.get(targetId);
                    tempAnsList.add(ansSet);
                    mListOfOpenAnswerByTargetId.put(targetId,tempAnsList);
                }
            }
        }
        Schema.SObjectType token = null;
        sObject sObjRecord = null;                                      
        List<sObject> lsObjectToUpdate = new List<sObject>();
        Map<Id,sObject> mSObjectById = new Map<Id,sObject>();                                              
        Map<String,Integer> mapNoOfStageOpenAns = new  Map<String,Integer>();  
        Set<String> iteratableIds = new Set<String>();
        iteratableIds.addAll(ansSetIdByTargetId.values());                                              
        for(Id sObjId : iteratableIds){
            token = Id.valueOf(sObjId).getSObjectType();
            sObjRecord = token.newSObject(sObjId);
            //system.debug('-->>> sObject Id '+ sObjId);
            if(token == IMH_Communication__c.sObjectType){
                sObjRecord.put(SYSOPENANSWERSETCONCEPT_API,0);
                sObjRecord.put(SYSOPENANSWERSETCREATIVE_API,0);
                sObjRecord.put(SYSOPENANSWERSETPREEXEC_API,0);
                sObjRecord.put(SYSOPENANSWERSETREEXEC_API,0);
                sObjRecord.put('SYSOpenAnswerSetsForCompliance__c',0);
                System.debug('REST00000');
                if(mListOfOpenAnswerByTargetId.containsKey(sObjId)){
                    for(IMH_AnswerSet__c openAnsSet : mListOfOpenAnswerByTargetId.get(sObjId)){
                        if(mapNoOfStageOpenAns.containsKey(stageByAPIName.get(openAnsSet.SYS_CommunicaitonQuestionSetType__c))){
                        mapNoOfStageOpenAns.put(stageByAPIName.get(openAnsSet.SYS_CommunicaitonQuestionSetType__c)
                                                , mapNoOfStageOpenAns.get(stageByAPIName.get(openAnsSet.SYS_CommunicaitonQuestionSetType__c))+1);
                        }else{
                          mapNoOfStageOpenAns.put(stageByAPIName.get(openAnsSet.SYS_CommunicaitonQuestionSetType__c),1);
 
                        }
                        sObjRecord.put(stageByAPIName.get(openAnsSet.SYS_CommunicaitonQuestionSetType__c)
                                        ,mapNoOfStageOpenAns.get(stageByAPIName.get(openAnsSet.SYS_CommunicaitonQuestionSetType__c)));
                    }
                }
                
            }else{
                sObjRecord.put(SYSOPENANSWERSET_API,mListOfOpenAnswerByTargetId.containsKey(sObjId)? mListOfOpenAnswerByTargetId.get(sObjId).size():0);
            }
            lsObjectToUpdate.add(sObjRecord);        
        }
        Database.update (lsObjectToUpdate,false);
    }
}