/**
* @author Accenture IDC 
* @date 05/26/2015
* @group Answer
* @group-content N/A
* @description Trigger Handler on Answer that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/
public without sharing class IMH_AnswerTriggerHandler{
    public  static boolean isSkipTrigger = false;
    private static final String RECALLED = 'Recalled due to change in Answer';
    private static final String BLANK_SPACE = '';
    private static final String COMMA_QUERY_STR = ', ';
    private static final String FROM_QUERY_STR = ' from ';
    private static final String SELECT_QUERY_STR = 'select ';
    private static final String WHERE_CLAUSE_QUERY_STR = ' WHERE Id IN : recordIds';  
    private static final String ANSWER_STATUS = 'Status__c';
    private static final String NOT_REQUIRED = 'Not Required';
    private static final String REMOVED = 'Removed';
    public static Boolean isAfterUpdateExecuted = false;
    public static Boolean isAfterInsertExecuted = false;
    public static Map<String,Map<String,Set<String>>> mValuesUpdatedByFieldByTargetId = new Map<String,Map<String,Set<String>>>(); 
    /**
    * @description  - Updates the campaign/Offer object based on the question action and response to the questions
    * @param  - List<IMH_Answer__c>, Map<Id,IMH_Answer__c>
    * @return  - Void
    */ 
    public static void updateTargetObjects(List<IMH_Answer__c> lTriggerNew,
                                            Map<Id,IMH_Answer__c> mTriggerNewMap){
        mValuesUpdatedByFieldByTargetId = new Map<String,Map<String,Set<String>>>();                                 
        String targetObjectRecordId = BLANK_SPACE;
        //CONSTRUCT THE MAP WITH LABEL NAMES AND API NAMES - LATER I CAN BE REPLACE WITH CUSTOM SETTINGS
        Map<String,String> mAPINameByLabalName = new Map<String,String>();
        mAPINameByLabalName.PUT(IMH_UtilityConstants.COMMUNICATION_LABELNAME,IMH_UtilityConstants.COMMUNICATION_OBJECT_API);
        mAPINameByLabalName.PUT(IMH_UtilityConstants.BENEFITS_ENTRY_LABEL,IMH_UtilityConstants.BENEFIT_API);
        sObject objToUpdate;
        Map<Id,sObject> mSObjectById = new Map<Id,sObject>();
        Map<String, Schema.SObjectType> mSobjectTypeByName = new  Map<String, Schema.SObjectType>();
        Map<String,Map<String, Schema.SObjectField>> fieldMapByObjectName = new Map<String,Map<String, Schema.SObjectField>>();                                                
        mSobjectTypeByName = Schema.getGlobalDescribe();
        fieldMapByObjectName.put(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,IMH_GeneralApplicationUility.constructFieldMap(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,mSobjectTypeByName));
        fieldMapByObjectName.put(IMH_UtilityConstants.BENEFIT_API,IMH_GeneralApplicationUility.constructFieldMap(IMH_UtilityConstants.BENEFIT_API,mSobjectTypeByName));
        Map<Id,IMH_Answer__c> mAnswerByQuestionId = new Map<Id,IMH_Answer__c>();
        Set<Id> sObjectIds = new Set<Id>();
        Map<Id,sObject> mapSobjectsById = new Map<Id,sObject>();
        String  multiSelectValueUpdated = BLANK_SPACE;
        Set<String> valuesUpdated = new Set<String>();
        Map<String,Set<String>> innerMap = new Map<String,Set<String>>();
        Boolean replaceMultiPicklistVaue = false;   
        Map<String,Map<String,Set<String>>> mValuesNOTUpdatedByFieldByTargetId = new Map<String,Map<String,Set<String>>>(); 
        Set<String> valuesNotToUpdate = new Set<String>();
        Map<String,Set<String>> innerMap2 = new Map<String,Set<String>>();
        Set<String> tempSetToCompare = new Set<String>();                                                 
        // QUERY ANSWER OBJECT TO GET THE REFERENCE FIELD AS WELL AND ITERATE THROUGH ANSWER 
        // TO CREATE A MAP OF QUESTION ID AND ANSWER OBJECT    
        for(IMH_Answer__c tempAns : [SELECT Id
                                            , Answer__c
                                            , Question__c
                                            , AnswerSet__r.Benefits__c 
                                            , AnswerSet__r.Communication__c 
                                         FROM IMH_Answer__c WHERE Id IN :mTriggerNewMap.keySet() AND Question__c!=NULL
                                         LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
            sObjectIds.add(tempAns.AnswerSet__r.Communication__c);
            sObjectIds.add(tempAns.AnswerSet__r.Benefits__c);                                              
            mAnswerByQuestionId.put(tempAns.Question__c, tempAns);
        }
        /*
        if(!mapSobjectsById.isEmpty()){
            for(Integer i=0 ;i<mapSobjectsById.values().size();i++){
                sObjectIds.add(Id.valueOf(String.valueOf(mapSobjectsById.values().get(i).get(IMH_UtilityConstants.CAMPAIGN_REF_FIELD))));   
            }
        }
        */
        IMH_GeneralApplicationUility.getSOBjectRecords(IMH_UtilityConstants.BENEFIT_API, sObjectIds, mapSobjectsById,fieldMapByObjectName);
        IMH_GeneralApplicationUility.getSOBjectRecords(IMH_UtilityConstants.COMMUNICATION_OBJECT_API, sObjectIds, mapSobjectsById,fieldMapByObjectName);
        Set<String> tempSetStr = new Set<String>(); 
        String tempStr = '';                                                        
        // ITERATE THROUGH THE QUESTION ACTION AND UPDATE THE TARGET OBJECT.
        Boolean  validQuestionAction  = true;
        for(IMH_QuestionAction__c tempAction : [SELECT Id
                                                    , MultiEntryCriteria__c 
                                                    , Field__c
                                                    , Object__c
                                                    , (SELECT Id,Object__c,Field__c,Equals__c FROM EntryCriterias__r
                                                           LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows()))
                                                    , ValueUpdate__c
                                                    , Question__c
                                                FROM IMH_QuestionAction__c 
                                                WHERE Question__c IN : mAnswerByQuestionId.keySet()
                                                LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
                multiSelectValueUpdated  = BLANK_SPACE;
                replaceMultiPicklistVaue = true;                                                 
                //FETCH THE TARGETID FROM ANSWER SET                                                        
                if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(mAPINameByLabalName.get(tempAction.Object__c))){
                    targetObjectRecordId = mAnswerByQuestionId.get(
                                                            tempAction.Question__c).AnswerSet__r.Communication__c;
                }
                else {
                    targetObjectRecordId = mAnswerByQuestionId.get(
                                                            tempAction.Question__c).AnswerSet__r.Benefits__c;
                }
                // GET OBJECT TO UPDATE - CHECK IF IT IS NEW OR UPDATE ALREADY IN LOOP 
                if(!mSObjectById.containsKey(targetObjectRecordId)){
                        objToUpdate = mapSobjectsById.get(targetObjectRecordId);
                    } else {
                        objToUpdate = mSObjectById.get(targetObjectRecordId);
                }
                validQuestionAction  = true;
                validQuestionAction = IMH_GeneralApplicationUility.checkEntryCriteria(tempAction
                                                                                    , mapSobjectsById
                                                                                    , mAPINameByLabalName.get(tempAction.Object__c)
                                                                                    , objToUpdate
                                                                                    , fieldMapByObjectName
                                                                                    , validQuestionAction);
                if(validQuestionAction){
                    tempSetToCompare.clear();
                    tempSetToCompare.addAll(tempAction.MultiEntryCriteria__c.toLowerCase().split(';'));
                    //CHECK WHETHER THE ENTRY CRITERIA AND ANSWER ARE SAME  
                    
                    if(mAnswerByQuestionId.get(tempAction.Question__c).Answer__c !=NULL 
                        && tempSetToCompare.contains(mAnswerByQuestionId.get(tempAction.Question__c).Answer__c.toLowerCase())){
                        // UPDATE THE TARGET OBJECT WITH VALUE AND RESPECTIVE FIELD IN SOBJECT.
                        String valueToUpdate = IMH_UtilityConstants.EMPTY_STRING;
                        // CHECK IF THE FIELD TYPE IS MULTI PICKLIST - IF  - UPDATE WITH EXISTING VALUES
                        if(fieldMapByObjectName.get(mAPINameByLabalName.get(tempAction.Object__c)).get(tempAction.Field__c).getDescribe().getType() == Schema.DisplayType.MultiPicklist
                          && objToUpdate.get(tempAction.Field__c)!=null){
                              if(!String.valueOf(objToUpdate.get(tempAction.Field__c)).contains(tempAction.ValueUpdate__c)){
                                  valueToUpdate = objToUpdate.get(tempAction.Field__c) + IMH_UtilityConstants.SEMI_COLON + tempAction.ValueUpdate__c ;
                                  objToUpdate.put(tempAction.Field__c, valueToUpdate);
                              }
                        }else{
                            //ELSE  - UPDATE NEW VALUES
                            objToUpdate.put(tempAction.Field__c, tempAction.ValueUpdate__c);
                        }
                        multiSelectValueUpdated = fieldMapByObjectName.get(mAPINameByLabalName.get(tempAction.Object__c)).get(tempAction.Field__c).getDescribe().getType()
                                                                                                        == Schema.DisplayType.MultiPicklist?tempAction.ValueUpdate__c:BLANK_SPACE;                                                         
                    }else{
                        if(mValuesUpdatedByFieldByTargetId.containsKey(objToUpdate.Id) 
                            && mValuesUpdatedByFieldByTargetId.get(objToUpdate.Id).containsKey(tempAction.Field__c)
                            && mValuesUpdatedByFieldByTargetId.get(objToUpdate.Id).get(tempAction.Field__c).contains(tempAction.ValueUpdate__c)){
                            replaceMultiPicklistVaue = false;
                        }
                        // IF ANSWER CRITERIA DOESN'T SATISFY NULLIFY THE VALUE POPULATED ALREADY
                        if(objToUpdate.get(tempAction.Field__c)!=null
                            && String.valueOf(objToUpdate.get(tempAction.Field__c)).contains(tempAction.ValueUpdate__c)){
                            if(fieldMapByObjectName.get(mAPINameByLabalName.get(tempAction.Object__c)).get(tempAction.Field__c).getDescribe().getType() == Schema.DisplayType.MultiPicklist){
                                if(replaceMultiPicklistVaue){
                                    tempSetStr.clear();
                                    tempSetStr.addAll(String.ValueOf(objToUpdate.get(tempAction.Field__c)).split(';'));
                                    tempSetStr.remove(tempAction.ValueUpdate__c);
                                    tempStr = '';
                                    for(String str : tempSetStr){
                                        tempStr += str + ';';
                                    }
                                    objToUpdate.put(tempAction.Field__c,tempStr);
                                }   
                            }else{
                                objToUpdate.put(tempAction.Field__c, null);
                            }
                        }
                }
                valuesUpdated = new Set<String>();
                innerMap = new Map<String,Set<String>>();                                     
                if(String.isNotBlank(multiSelectValueUpdated)){
                        if(mValuesUpdatedByFieldByTargetId.containsKey(objToUpdate.Id)){
                            innerMap = mValuesUpdatedByFieldByTargetId.get(objToUpdate.Id);
                            if(mValuesUpdatedByFieldByTargetId.get(objToUpdate.Id).containsKey(tempAction.Field__c)){
                               valuesUpdated = mValuesUpdatedByFieldByTargetId.get(objToUpdate.Id).get(tempAction.Field__c);
                            }
                        }
                        valuesUpdated.add(multiSelectValueUpdated);
                        innerMap.put(tempAction.Field__c, valuesUpdated);
                        mValuesUpdatedByFieldByTargetId.put(objToUpdate.Id, innerMap);
                }                                    
                }
                else if(IMH_ReEvaluateQuestionnaireHandler.reEvaluateQuestionnaire){
                   
                    if(mValuesNOTUpdatedByFieldByTargetId.containsKey(objToUpdate.Id)){
                        innerMap2 = mValuesNOTUpdatedByFieldByTargetId.get(objToUpdate.Id);
                        if(mValuesNOTUpdatedByFieldByTargetId.get(objToUpdate.Id).containsKey(tempAction.Field__c)){
                            valuesNotToUpdate = mValuesNOTUpdatedByFieldByTargetId.get(objToUpdate.Id).get(tempAction.Field__c);
                        }
                    }
                    valuesNotToUpdate.add(tempAction.ValueUpdate__c);
                    innerMap2.put(tempAction.Field__c, valuesNotToUpdate);
                            mValuesNOTUpdatedByFieldByTargetId.put(objToUpdate.Id, innerMap2);
                     
                }
                mSObjectById.put(targetObjectRecordId, objToUpdate);                                     
       }
        //NESTED LOOP CANNOT BE AVOIDED SINCE THIS SHOULD BE BULKIFIED. 
        //ALSO CONSIDERING THE FIRST ITERATION THE COMPLEXITY IS NOT MUCH SINCE ONLY AN ELEMENT IS EXPECTED TO BE ON mValuesUpdatedByFieldByTargetId                                                
        for(Id sObjId : mValuesNOTUpdatedByFieldByTargetId.keySet()){
            for(String field : mValuesNOTUpdatedByFieldByTargetId.get(sObjId).keySet()){
                for(String valuesNotValid : mValuesNOTUpdatedByFieldByTargetId.get(sObjId).get(field)){
                    if(mValuesUpdatedByFieldByTargetId.get(sObjId)==NULL 
                       || mValuesUpdatedByFieldByTargetId.get(sObjId).get(field)==NULL
                        || !mValuesUpdatedByFieldByTargetId.get(sObjId).get(field).contains(valuesNotValid)){
                        if(mSObjectById.get(sObjId).get(field) != NULL) {
                            tempSetStr.clear();
                            tempSetStr.addAll(String.ValueOf(mSObjectById.get(sObjId).get(field)).split(';'));
                            tempSetStr.remove(valuesNotValid);
                            tempStr = '';
                            for(String str : tempSetStr){
                                tempStr += str + ';';
                            }
                            mSObjectById.get(sObjId).put(field,tempStr);
                        }    
                    }
                }
            }
        }                                        
        // UPDATE THE LIST OF SOBJECTS - OFFER/CAMAPIGN                                         
        if(!mSObjectById.values().isEmpty()){
            Database.update(mSObjectById.values(),false);
        }
    }
}