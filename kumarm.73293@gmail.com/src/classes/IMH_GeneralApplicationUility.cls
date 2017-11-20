/**
* @author Accenture IDC 
* @date 05/26/2015
* @group GeneralApplication Utility
* @group-content N/A
* @description:iMH Release 1 (Sprint 1) General Application Utility which contains the common methods called.
*/
public without sharing class IMH_GeneralApplicationUility {
    private static Final String NOT_STARTED = 'Not Started';
    private static Final String INCENTIVE_STATUS_API = 'IncentiveStatus__c';
    private static Final String CREATIVE_STATUS_API = 'CreativeStatus__c';
    private static final String STAGE_API_NAME ='ProcessStage__c';
    private static final String REINSTATE_CHECK = 'SYSReinitiateCheck__c';
    private static Final String COMMUNICATION = 'Communication';
    private static Final String REVIEWSTAGE_API = 'Stage__c'; // ProcessStage + Review Stage
    private static Final String BENEFITSTAGE_API = 'BenefitStage__c';
    private static Final String OWNERID = 'OwnerId';
    private static Final String SYSREINTIATERECALL = 'SYSReinitiateRecallCheck__c';
    private static Final String SYSREINITATEREJECT  = 'SYSReinitiateRejectCheck__c';
    private static Final String ENTRYCRITERIA_REL = 'EntryCriterias__r';
    private static Final String INCENTIVES_REL = 'Incentives__r';
    private static Final String CREATIVE_REL = 'Creative__r';
    private static Final String PREAPPROVED_REL = 'PreApprovedBenefits__r';
    private static Final String CREATIVE = 'Creative';
    private static final String ANSWER_RELSHIP = 'Answer_Sets__r';
    private static final String QUESTIONSET_API_NAME = 'QuestionSet__c';
    private static final String REMOVED = 'Removed';
    private static final String RECALLED = 'Recalled';
    private static final String BATCH_FAIL = 'Failed';
    private static final String REVIEWANDAPPROVAL = 'Review & Approval';
    private static final String RECORD_TYPE = 'RecordType';
    private static final String DEVELOPER_NAME = 'DeveloperName';
    private static final String CENTRAL_communication = 'Central_Communication'; 
    private static final String APPROVED_STEP = 'Approved';
    private static final String REJECTED_STEP = 'Rejected';
    private static final String EMAIL_STRING_BATCHJOB = 'BatchJob - ';
    private static final String EMAIL_STRING_BATCHJOB_STATUS = ' - Status: ';
    private static final String EMAIL_STRING_BATCHES = ' batches with ';
    private static final String EMAIL_STRING_BATCHJOB_PROCESSED = 'The batch Apex job processed ';
    private static final String EMAIL_STRING_BATCHJOB_FAILURE = ' failures. ExtendedStatus: ';
    private static final String API_NAME_OPENANSWERSET = 'SYSOpenAnswerSets__c';
    private static final String INNERQUERY_ANSWERSET ='(SELECT ID, Locked__c, QuestionSet__c,QuestionSet__r.Name,Communication__c,SYS_CommunicaitonQuestionSetType__c FROM Answer_Sets__r WHERE  Locked__c = FALSE)' ;
    private static final String WHERECONDITION_INCENTIVE = ' WHERE Id IN:setRecordIds';
    private static final String WHERECONDITION_CREATIVE = ' WHERE Id IN:setRecordIds';
    private static final String WHERECONDITION_communication = ' WHERE Id IN:setRecordIds';
    private static final String WHERECONDITION_IDcommunication = ' WHERE Id IN:communicationIdsSet';
    private static final String SELECT_STRING = 'SELECT ';
    private static final String RECORDTYPE_DEVELOPERNAME = 'RecordType.DeveloperName';
    private static final String FROM_STRING = ' From ';
    //For Uniquness Function
    private static final String QUESTION_API = 'IMH_Question__c';
    private static final String QUESTIONWARNING_API ='IMH_QuestionWarning__c';
    private static final String RESPONSEVALUE_API = 'IMH_ResponseValue__c';
    private static final String QUESTIONSET_API = 'IMH_QuestionSet__c';
    private static final String PARENT_FIELD_QUESTION = 'QuestionSet__c';
    private static final String PARENT_FIELD_QUESTIONWARNING = 'Question__c';
    private static final String PARENT_FIELD_RESPONSEVALUE = 'Question__c';
    private static final String PARENT_FIELD_QUESTIONSET = 'ParentQuestionSet__c';
    private static final String UNIQUE_ACTIVE_SEQUENCE = 'UniqueActiveSequence__c';
    private static final String UNIQUE_SEQUENCE_VERSION = 'UniqueSequenceVersion__c';
    private static final String ORDER_SEQUENCE = 'OrderSequence__c';
    private static final String VERSION = 'Version__c';
    private static final String ACTIVE = 'Active__c';
    private static final String QUERY_SPACE = ' ';
    private static final String ID_OPERATOR = 'ID';
    private static final String IN_OPERATOR = 'IN';
    private static final String WHERE_CLAUSE = 'WHERE';
    private static final String NOT_OPERATOR = 'NOT';
    private static final String AND_OPERATOR = 'AND';
    private static final String LABEL_NAME = 'Name';
    private static final String COLON = ':';
    private static final String GENERIC_QUERY_STR = 'SELECT Id,UniqueActiveSequence__c,UniqueSequenceVersion__c,Name FROM ';
    private static final String WHEREQUERY_COMMS = ' WHERE Id IN : communicationIds';
    private static final String BOOLEAN_STR_TRUE = 'TRUE';
    private static final String BOOLEAN_STR_FALSE = 'FALSE';
    private static final String VAR_SOBJECTIDS = 'sObjectIds';
    private static final String VAR_INDEXSET = 'indexSet';
    
    private static final String COMMA_QUERY_STR = ', ';
    private static final String WHERE_CLAUSE_QUERY_STR = ' WHERE Id IN : recordIds';  
    
    //Variables Specific To Batch Class
    //private static final String REMOVED = 'Removed';
    private static final String MON = 'Mon';
    private static final String TUE = 'Tue';
    private static final String WED = 'Wed';
    private static final String THU = 'Thu';
    private static final String FRI = 'Fri';
    private static final String SAT = 'Sat';
    private static final String SUN = 'Sun';
    private static final String ED = 'E';
    private static final String SPLIT_STRING = '\\(';
    private static final String REJECTED = 'Rejected';
    private static final String NO_RESPONSE = 'NoResponse';
    private static final String STARTED = 'Started';
    private static final String REASSIGNED = 'Reassigned';
    private static final String APPROVED = 'Approved';
    private static final String CANCELLED = 'Cancelled';
    private static final String MANAGER = 'Manager';
    
    //Hardcodings
    private static final String COMMUNICATIONTYPE_API = 'Communication_Type__c';
    private static final String TARGETMARKET_API = 'TargetMarket__c';
    private static final String PREEXECUTIONDESIGN = 'Pre-Execution Testing - Design';
    private static final String READYFOREXECUTIONCOMP = 'Ready for Execution - Complete';
    private static final String CREATIVEDESIGN = 'Creative - Design';
    private static final String CONCEPTDEIGN = 'Concept - Design';
    private static final String REQUIREDAPPROVER_API = 'RequiredApprovers__c';
    private static final String RECORDTYPENAME = 'RecordType.Name';
    private static final String RECORDTYPENAMECOMMA = 'RecordType.Name, ';
    private static final String ESCAPESYSFIELDS = 'IMH_EscapeSYSFields';
    private static final String CLOSINGBRACE = ')';
    private static final String OPENINGBRACE = '(';
    
    //Chatter Group Methods
    private static final String REGULARGROUPTYPE = 'Regular';
    public static Boolean isAvoidEntryinTrigger = false;
    
    public static Map<String, map<String,RecordType>> mRecordType  = new Map<String, map<String,RecordType>>() ;
     
    static {
        mRecordType = new Map<String, map<String,RecordType>>();
        set<string> queryString = new set<String>{IMH_UtilityConstants.INCENTIVE_OBJECT_API,IMH_UtilityConstants.COMMCREATIVE_OBJECT_API,IMH_UtilityConstants.COMMUNICATION_OBJECT_API}; 
        Map<String, RecordType> mRecordTypeByDevName = new Map<String, RecordType>();
        for (RecordType eachRecordType :[ SELECT Id
                                               , DeveloperName
                                               , SobjectType
                                          FROM RecordType
                                          WHERE isActive = true AND SobjectType 
                                          IN :queryString
                                          LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
            if (mRecordType.containsKey(eachRecordType.SobjectType)) {
                mRecordType.get(eachRecordType.SobjectType).put(eachRecordType.DeveloperName, eachRecordType);
            } else {
                mRecordTypeByDevName = new Map<String, RecordType>();
                mRecordTypeByDevName.put(eachRecordType.DeveloperName, eachRecordType);
                mRecordType.put(eachRecordType.SobjectType, mRecordTypeByDevName);
            }
        }
     }
       
    
   /*****************************************************************************
    * @description -  Used to create the answer set record for Communications and Incentive
    * @param - Trigger.New(Communication/Incentive), Trigger.newMap(Communication/Incentive),Trigger.OldMap(Communication/Incentive)
    * @return - void
    */ 
    public static void createAnswerSet(List<sObject> ltriggernew,Map<Id,sObject> mtriggernew,Map<Id,sObject> mtriggerold){
        //CONSTRUCT THE MAP WITH LABEL NAMES AND API NAMES - LATER I CAN BE REPLACE WITH CUSTOM SETTINGS
        Map<String,String> mLabelNameBYObjectAPIName = new Map<String,String>();
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,COMMUNICATION);
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.INCENTIVE_OBJECT_API,IMH_UtilityConstants.INCENTIVE_LABELNAME);
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API,CREATIVE);
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.BENEFIT_API,IMH_UtilityConstants.BENEFITS_ENTRY_LABEL);
        Map<String, Schema.SObjectType> mSobjectTypeByName = new  Map<String, Schema.SObjectType>();
        Map<String,Map<String, Schema.SObjectField>> fieldMapByObjectName = new Map<String,Map<String, Schema.SObjectField>>();
        mSobjectTypeByName = Schema.getGlobalDescribe();
        
        fieldMapByObjectName.put(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,constructFieldMap(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,mSobjectTypeByName));
        fieldMapByObjectName.put(IMH_UtilityConstants.BENEFIT_API,constructFieldMap(IMH_UtilityConstants.BENEFIT_API,mSobjectTypeByName));   
        String innerQuery = INNERQUERY_ANSWERSET;
        List<IMH_AnswerSet__c> lAnswerSet = new List<IMH_AnswerSet__c>();
        List<IMH_QuestionSet__c> lQuestionSet = new List<IMH_QuestionSet__c>();
        List<sObject> lSObject = new List<sObject>();
        Map<Id,sObject> mParentSObject = new Map<Id,sObject>();
        SET<ID> setRecordIds = new SET<ID>();
        IMH_AnswerSet__c answerset = new IMH_AnswerSet__c();
        Set<String> sObjectTargetMarket = new set<String>();
        String sObjectType = IMH_UtilityConstants.EMPTY_STRING;
        String finalQueryString = IMH_UtilityConstants.EMPTY_STRING;
        String previousValueAPIName = IMH_UtilityConstants.EMPTY_STRING;
        String communicationSpecificQueryString = IMH_UtilityConstants.EMPTY_STRING;
        String indexedsObject = IMH_UtilityConstants.EMPTY_STRING;
        Set<String> communicationIdsSet = new SET<String>();
        Map<String,Map<String,IMH_AnswerSet__c>> msameQuestionSet = new Map<String,Map<String,IMH_AnswerSet__c>>();
        Map<String,Map<String,IMH_AnswerSet__c>> msameQuestionSetByName = new Map<String,Map<String,IMH_AnswerSet__c>>();
        List<IMH_Communication__c> lupdatedcomm = new List<IMH_Communication__c>(); ///NEW LINE
        communicationSpecificQueryString = IMH_GeneralApplicationUility.fetchAllFields(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,innerQuery);
        if(ltriggernew.get(0).getSObjectType() == IMH_Incentive__c.sObjectType){
            //USED TO GET THE SET OF SOBJECT(INCENTIVE) WHEN THE INCENTIVE IS CREATED OR UPDATED
            sObjectType = IMH_UtilityConstants.INCENTIVE_OBJECT_API;
            indexedsObject = IMH_UtilityConstants.INCENTIVE_LABELNAME;
            finalQueryString = IMH_GeneralApplicationUility.fetchAllFields(sObjectType,innerQuery);
            previousValueAPIName =  INCENTIVE_STATUS_API;
            finalQueryString += WHERECONDITION_INCENTIVE;
            //USED TO QUERY THE RECORDS FOR THE REQUIRED SET OF INCENTIVES
          
        }
        else if(ltriggernew.get(0).getSObjectType() == IMH_CommCreative__c.sObjectType){
            //USED TO GET THE SET OF SOBJECT(INCENTIVE) WHEN THE CREATIVE IS CREATED OR UPDATED
            sObjectType = IMH_UtilityConstants.COMMCREATIVE_OBJECT_API;
            indexedsObject = CREATIVE;
            finalQueryString = IMH_GeneralApplicationUility.fetchAllFields(sObjectType,innerQuery);
            previousValueAPIName =  CREATIVE_STATUS_API;
            finalQueryString += WHERECONDITION_CREATIVE;
            //USED TO QUERY THE RECORDS FOR THE REQUIRED SET OF INCENTIVES
        }
        else if(ltriggernew.get(0).getSObjectType() == IMH_Benefits__c.sObjectType){
             //USED TO GET THE SET OF SOBJECT(INCENTIVE) WHEN THE communication IS CREATED OR UPDATED
            sObjectType = IMH_UtilityConstants.BENEFIT_API;
            indexedsObject = IMH_UtilityConstants.BENEFITS_ENTRY_LABEL;
            finalQueryString = IMH_GeneralApplicationUility.fetchAllFields(sObjectType,innerQuery);
            finalQueryString += WHERECONDITION_CREATIVE;
            previousValueAPIName =  BENEFITSTAGE_API;
         }
        else{
             //USED TO GET THE SET OF SOBJECT(INCENTIVE) WHEN THE communication IS CREATED OR UPDATED
            sObjectType = IMH_UtilityConstants.COMMUNICATION_OBJECT_API;
            indexedsObject = COMMUNICATION;
            finalQueryString = communicationSpecificQueryString + WHERECONDITION_communication; 
            previousValueAPIName =  REVIEWSTAGE_API;
         }
        for(Id sobj:mtriggernew.keySet()){
            if(!IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(sObjectType)
                                            && !IMH_UtilityConstants.BENEFIT_API.equalsIgnoreCase(sObjectType)){
                communicationIdsSet.add(String.valueOf(mtriggernew.get(sobj).get(IMH_UtilityConstants.communication_REF_FIELD)));
            }
            if(mtriggerold.isEmpty() 
               || (
                   mtriggerold.get(sobj)!=null 
                   && (
                       mtriggerold.get(sobj).get(previousValueAPIName)!= mtriggernew.get(sobj).get(previousValueAPIName)
                        || (
                            IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(sObjectType)
                            && (
                                mtriggerold.get(sobj).get(COMMUNICATIONTYPE_API)!= mtriggernew.get(sobj).get(COMMUNICATIONTYPE_API)
                                || mtriggerold.get(sobj).get(TARGETMARKET_API)!= mtriggernew.get(sobj).get(TARGETMARKET_API)
                               )
                           )
                       || (!sObjectType.equalsIgnoreCase(IMH_UtilityConstants.BENEFIT_API) && 
                           mtriggerold.get(sobj).get('SYS_IsUnderComplianceReview__c')
                           != mtriggernew.get(sobj).get('SYS_IsUnderComplianceReview__c'))
                      )
                  )
              ) {
                setRecordIds.add(sobj);
            }
        }
        lsObject = Database.query(finalQueryString);
        
        mParentSObject.putALL(Database.query(communicationSpecificQueryString + WHERECONDITION_IDcommunication));
        Set<String> objectList = new Set<String>{COMMUNICATION};
         if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(sObjectType)){
            objectList = new Set<String>{COMMUNICATION,IMH_UtilityConstants.INCENTIVE_LABELNAME,IMH_UtilityConstants.PREAPPROVEDBENEFITS_LABELNAME,CREATIVE};
        }
        //ITERATE THROUGH THE SOBJECT TO GET THE ANSWERSETS ALREADY CREATED
        Map<String,IMH_AnswerSet__c> innermap = new Map<String,IMH_AnswerSet__c>();
         Map<String,IMH_AnswerSet__c> mNewInnermap = new Map<String,IMH_AnswerSet__c>();
        for(Sobject offie :lSObject){
           innermap = new Map<String,IMH_AnswerSet__c>();
           for(Sobject ans :offie.getSobjects(ANSWER_RELSHIP)){
                    innermap.put(String.valueof(ans.get(QUESTIONSET_API_NAME)),(IMH_AnswerSet__c)ans);
                    mNewInnermap.put(String.valueof(ans.getsObject('QuestionSet__r').get('Name')),(IMH_AnswerSet__c)ans);
           }
           msameQuestionSet.put(String.valueof(offie.get(IMH_UtilityConstants.ID)),innermap); 
           msameQuestionSetByName.put(String.valueof(offie.get(IMH_UtilityConstants.ID)),mnewinnermap);
        }
        lQuestionSet = [SELECT Name,Id,Version__c,ActionBy__c,Description__c
                                            ,Active__c
                                            ,(SELECT Id,Object__c,Field__c,Equals__c FROM EntryCriterias__r 
                                               WHERE Object__c = :indexedsObject OR Object__c IN : objectList)
                                        FROM IMH_QuestionSet__c
                                        WHERE Active__c=true
                                        AND ParentQuestionSet__c = NULL AND ObjectEntryCriteria__c = :indexedsObject
                                        LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
        List<sObject> lsObjectToUpdate = new List<sObject>();
        Integer noOfAnswerSetCreated = 0;
        Boolean validQuestionSet = true;
        Object valueToCheck  = null;
        Map<String,String> stageByAPIName = new Map<String,String>();
        stageByAPIName.put(IMH_UtilityConstants.CONCEPT,IMH_UtilityConstants.OPEN_ANSSET_CONCEPT);
        stageByAPIName.put(IMH_UtilityConstants.CREATIVE,IMH_UtilityConstants.OPEN_ANSSET_CREATIVE);
        stageByAPIName.put(IMH_UtilityConstants.PRE_EXECUTION,IMH_UtilityConstants.OPEN_ANSSET_PREEXECUTION);
        stageByAPIName.put(IMH_UtilityConstants.READY_FOR_EXECUTION,IMH_UtilityConstants.OPEN_ANSSET_READYFOREXECUTION);  
        Set<String> multiselectValues = new Set<String>();
        Set<String> entryValueSetToCheck = new Set<String>();
        List<IMH_AnswerSet__c> lAnswerSetToDelete = new List<IMH_AnswerSet__c>();
        Boolean isNumberOfAnswerSetUpdated = false;
        //QUERIES THE LIST OF QUESTION SET PRESENT.
        for(sObject sObjRecord: lSObject){
            isNumberOfAnswerSetUpdated = false;
            noOfAnswerSetCreated = 0;
            for(IMH_QuestionSet__c quest: lQuestionSet){
                validQuestionSet  =false;
                String owenrsid = IMH_UtilityConstants.EMPTY_STRING;
                validQuestionSet = IMH_GeneralApplicationUility.checkEntryCriteria(quest,mParentSObject, sObjectType,sObjRecord,fieldMapByObjectName,validQuestionSet);
                if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(sObjectType)
                  || IMH_UtilityConstants.BENEFIT_API.equalsIgnoreCase(sObjectType)){
                     owenrsId = String.valueOf(sObjRecord.get(OWNERID));
                }
                else{
                    owenrsId = String.valueOf(mParentSObject.get(Id.valueOf(String.valueOf(sObjRecord.get(
                             IMH_UtilityConstants.communication_REF_FIELD)))).get(OWNERID));
                }
                if(validQuestionSet 
                    && ((!msameQuestionSet.get(String.valueof(sObjRecord.get(IMH_UtilityConstants.ID))).keyset().contains(quest.ID)
                         && !msameQuestionSetByName.get(String.valueof(sObjRecord.get(IMH_UtilityConstants.ID))).keyset().contains(quest.Name))
                        || (IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(sObjectType) 
                            && Boolean.valueOf(sObjRecord.get(REINSTATE_CHECK)) && 
                            ((Boolean.valueOf(sObjRecord.get(SYSREINTIATERECALL))
                            && sObjRecord.get(REVIEWSTAGE_API) == PREEXECUTIONDESIGN)//NEW LINES (updated conditions)
                            || sObjRecord.get(REVIEWSTAGE_API) == READYFOREXECUTIONCOMP
                            || (Boolean.valueOf(sObjRecord.get(SYSREINITATEREJECT))
                                && sObjRecord.get(REVIEWSTAGE_API) ==CREATIVEDESIGN))))){
                    System.debug('>>>>>IN IF loop for Creating Anserrtw set<><<<<<<<::');
                    answerset = new IMH_AnswerSet__c();
                    answerset.Name__c = quest.Name;
                    answerset.VersionUsed__c = quest.Version__c;
                    answerset.Status__c = NOT_STARTED;
                    answerset.QuestionSet__c = quest.Id;
                    answerset.QuestionnaireDescription__c = quest.Description__c;
                    answerset.QuestionnaireName__c = quest.Name;
                    answerset.OwnerID = owenrsid;   
                    lAnswerSet.add(answerset);
                    noOfAnswerSetCreated++;
                    if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(sObjectType)){
                        answerset.Communication__c = sObjRecord.Id;
                        //answerSet.SYS_CommunicaitonQuestionSetType__c = String.valueOf(sObjRecord.get(STAGE_API_NAME));     
                        if(quest.ActionBy__c!= NULL && 'Compliance'.equalsIgnorecase(quest.ActionBy__c)) {
                            answerSet.SYS_CommunicaitonQuestionSetType__c = 'Creative-Compliance';   
                        }
                        else{
                            answerSet.SYS_CommunicaitonQuestionSetType__c = String.valueOf(sObjRecord.get(STAGE_API_NAME));     
                        }
                    }
                    else{
                        answerset.Benefits__c = sObjRecord.Id;
                    }
                
                }else if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(sObjectType)
                         && !validQuestionSet 
                         && msameQuestionSet.get(String.valueof(sObjRecord.get(IMH_UtilityConstants.ID))).keyset().contains(quest.ID)
                         && IMH_UtilityConstants.CONCEPT.equalsIgnoreCase(msameQuestionSet.get(String.valueof(sObjRecord.get(
                                                IMH_UtilityConstants.ID))).get(quest.ID).SYS_CommunicaitonQuestionSetType__c)
                         && CONCEPTDEIGN.equalsIgnoreCase(String.valueOf(sObjRecord.get(REVIEWSTAGE_API)))
                            ){
                        lAnswerSetToDelete.add(msameQuestionSet.get(String.valueof(sObjRecord.get(IMH_UtilityConstants.ID))).get(quest.ID));
                        sObjRecord.put(stageByAPIName.get(msameQuestionSet.get(String.valueof(sObjRecord.get(
                                                IMH_UtilityConstants.ID))).get(quest.ID).SYS_CommunicaitonQuestionSetType__c),Integer.valueOf(sObjRecord.get(stageByAPIName.get(msameQuestionSet.get(String.valueof(sObjRecord.get(
                                                IMH_UtilityConstants.ID))).get(quest.ID).SYS_CommunicaitonQuestionSetType__c)))-1);
                        sObjRecord.put(REQUIREDAPPROVER_API,IMH_UtilityConstants.EMPTY_STRING);                                                    
                        isNumberOfAnswerSetUpdated = true;        
                }
                
            }
            if(noOfAnswerSetCreated>0 || isNumberOfAnswerSetUpdated){
                if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(sObjectType)
                         && (Boolean.valueOf(sObjRecord.get(SYSREINTIATERECALL))
                            && sObjRecord.get(REVIEWSTAGE_API) ==PREEXECUTIONDESIGN)){
                    sObjRecord.put(SYSREINTIATERECALL,false);
                }
                else if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(sObjectType)
                         && ((Boolean.valueOf(sObjRecord.get(SYSREINITATEREJECT))
                                && sObjRecord.get(REVIEWSTAGE_API) == CREATIVEDESIGN))){
                    sObjRecord.put(SYSREINITATEREJECT,false);
                }
                lsObjectToUpdate.add(sObjRecord);
            }
        }
       if(!lsObjectToUpdate.isEmpty()){
            Database.update(lsObjectToUpdate,false);
       }
        //INSERT ANSWER SET RECORDS AGAINST communication/INCENTIVE
        if(!lAnswerSet.isEmpty()){
            Database.upsert(lAnswerSet,false);
            IMH_CommunicationTriggerHandler.iscreatedAnswerSet = true;
       }
        
       if(!lAnswerSetToDelete.isEmpty()){
            Database.delete(lAnswerSetToDelete,false);
            Database.emptyRecycleBin(lAnswerSetToDelete);
       }
       
   }
    /**
    * @description  - Method is used for recalling the Warning Exceptions.
    * @param  - Set<Id>
    * @return  - Void
    */ 
    public static void recallWarningExceptions(Set<Id> exceptionRaisedIds){
        //GET THE APPROVAL PROCESS IF ANY APPLIED ON INCENTIVE LEVEL
        Approval.ProcessWorkitemRequest workitem;
        List<Approval.ProcessWorkitemRequest> lprocess = new List<Approval.ProcessWorkitemRequest>();
        if(!exceptionRaisedIds.isEmpty()){
            for(ProcessInstanceWorkitem proc: [SELECT Id
                                               , ProcessInstanceId
                                               , ProcessInstance.TargetObjectId
                                               FROM ProcessInstanceWorkitem 
                                               WHERE ProcessInstance.TargetObjectId IN:exceptionRaisedIds
                                               LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){ 
                                                   workitem = new Approval.ProcessWorkitemRequest();
                                                   workitem.setComments(RECALLED);
                                                   workitem.setAction(REMOVED);
                                                   workitem.setWorkitemId(proc.Id);
                                                   lprocess.add(workitem);                                      
                                               } 
        }
        if(!lprocess.isEmpty()){
            Approval.process(lprocess,false);
        } 
    }
    
    /**
    * @description  - Method is used for recalling the Warning Exceptions.
    * @param  - Set<Id>
    * @return  - Void
    */ 
    public static Map<Id,ProcessInstanceHistory> retrieveProcessInstanceHistory(Set<Id> exceptionRaisedIds){
        //GET THE APPROVAL PROCESS IF ANY APPLIED ON ANSWER WARNING LEVEL
        Map<Id,ProcessInstanceHistory> mProcessInstanceByAnswerWarningId = new Map<Id,ProcessInstanceHistory>();
        for(ProcessInstance proc : [SELECT Id,TargetObjectId, (SELECT Id, StepStatus, Comments FROM StepsAndWorkitems WHERE (StepStatus = :APPROVED_STEP OR StepStatus = :REJECTED_STEP)) 
                                                    FROM ProcessInstance where TargetObjectId IN :exceptionRaisedIds ORDER By SystemModstamp DESC LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
           for(ProcessInstanceHistory steps : proc.StepsAndWorkitems){
              if(!mProcessInstanceByAnswerWarningId.containsKey(proc.targetObjectId)){
                mProcessInstanceByAnswerWarningId.put(proc.targetObjectId,steps);                                            
           } 
           }                                                            
        }
        return mProcessInstanceByAnswerWarningId;
    }
 
    /**
    * @description  - Method is used for sending email on batch failure.
    * @param  - ID
    * @return  - Void
    */ 
    public static void sendEmailNotifcationForBatchJOb(Id batchId){
        
        // Get the AsyncApexJob that represents the Batch job using the Id from the BatchableContext  
         AsyncApexJob asyncJob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,  TotalJobItems,ApexClass.Name ,
                                                CreatedBy.Email, ExtendedStatus FROM AsyncApexJob WHERE Id = :batchId LIMIT 1];  
        if(BATCH_FAIL.equalsIgnoreCase(asyncJob.Status) || asyncJob.NumberOfErrors > 0){
          // Email the Batch Job's submitter that the Job is finished.  
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
         String[] toAddresses = new String[] {asyncJob.CreatedBy.Email};  
         mail.setToAddresses(toAddresses);  
         mail.setSubject(EMAIL_STRING_BATCHJOB+asyncJob.ApexClass.Name + EMAIL_STRING_BATCHJOB_STATUS + asyncJob.Status);   
         mail.setPlainTextBody(EMAIL_STRING_BATCHJOB_PROCESSED + asyncJob.TotalJobItems +  
          EMAIL_STRING_BATCHES+ asyncJob.NumberOfErrors + EMAIL_STRING_BATCHJOB_FAILURE + asyncJob.ExtendedStatus);  
            
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
        } 
    }
    
    /**
    * @description  - METHOD IS USED FOR CALCULATING THE UNIQUE SEQUENCE OF FIELDS ON QUESTION RELATED OBJECTS
    * @param  - LIST<sobject>,MAP<Id,sObject>
    * @return  - Void
    */ 
    public static void checkUniquenessOfRecord(List<sObject> lTriggerNew,Map<Id,sObject> mTriggerOld){
        String queryStr = GENERIC_QUERY_STR;
        Set<String> indexSet = new Set<String>();
        String queryObj = IMH_UtilityConstants.EMPTY_STRING;
        String parentFieldName = IMH_UtilityConstants.EMPTY_STRING;
        String finalQueryStr = IMH_UtilityConstants.EMPTY_STRING;
        String parentQuestionSet = IMH_UtilityConstants.EMPTY_STRING;
        List<sObject> iteratablesObj = new List<sObject>();
        //FIND SOBJECT TYPE AND ASSIGN PARENT FIELD SO THAT IT CAN BE USED AS INDEXED FIELD IN DYNAMIC QUERY
        if(lTriggerNew.get(0).getSObjectType() == IMH_Question__c.sObjectType){
            queryObj =QUESTION_API;
            parentFieldName = PARENT_FIELD_QUESTION;
        }else if(lTriggerNew.get(0).getSObjectType() == IMH_QuestionSet__c.sObjectType){
            queryObj = QUESTIONSET_API;
            parentFieldName = PARENT_FIELD_QUESTIONSET;
        }else if(lTriggerNew.get(0).getSObjectType() == IMH_ResponseValue__c.sObjectType){
            queryObj = RESPONSEVALUE_API;
            parentFieldName = PARENT_FIELD_RESPONSEVALUE;
        }else{
            queryObj = QUESTIONWARNING_API;
            parentFieldName = PARENT_FIELD_QUESTIONWARNING;
        }
        Set<String> sObjectIds = new Set<String>();
        //ITERATE THROUGH THE TRIGGER VARIABLE TO EXECUTE ONLY IF THERE IS CHANGE IN SPECIFIC FIELDS
        for(sObject tempsObj : lTriggerNew){
            if(mTriggerOld.containsKey(String.valueOf(tempsObj.get(IMH_UtilityConstants.ID)))){
                if(mTriggerOld.get(String.valueOf(tempsObj.get(IMH_UtilityConstants.ID))).get(ACTIVE)!= tempsObj.get(ACTIVE)
                   || mTriggerOld.get(String.valueOf(tempsObj.get(IMH_UtilityConstants.ID))).get(VERSION)!= tempsObj.get(VERSION)
                   || mTriggerOld.get(String.valueOf(tempsObj.get(IMH_UtilityConstants.ID))).get(ORDER_SEQUENCE)!= tempsObj.get(ORDER_SEQUENCE)
                   || mTriggerOld.get(String.valueOf(tempsObj.get(IMH_UtilityConstants.ID))).get(parentFieldName)!= tempsObj.get(parentFieldName)){
                       iteratablesObj.add(tempsObj);
                       sObjectIds.add(String.valueOf(tempsObj.get(IMH_UtilityConstants.ID)));
                   }
            }else{
               iteratablesObj.add(tempsObj); 
            }
            // ADD PARENT FIELD ID TO A SET TO BE USED IN DYNAMIC QUERY
            indexSet.add(String.valueOf(tempsObj.get(parentFieldName)));
        } 
        
        // CONSTRUCT A DYNAMIC QUERY
        finalQueryStr = queryStr + queryObj + QUERY_SPACE + WHERE_CLAUSE + QUERY_SPACE + parentFieldName + QUERY_SPACE + IN_OPERATOR 
                        + QUERY_SPACE + COLON + QUERY_SPACE + VAR_INDEXSET + QUERY_SPACE 
                        + AND_OPERATOR +QUERY_SPACE + ID_OPERATOR + QUERY_SPACE + NOT_OPERATOR + QUERY_SPACE + IN_OPERATOR + COLON + VAR_SOBJECTIDS;
        Map<String,String> uniqueSequenceIds = new Map<String,String>();
        Map<String,String> uniqueVersionSequenceIds = new Map<String,String>();
        //ITERATE THROUGH THE LOOP WITH EXISTING RECORDS TO IDENTIFY THE UNIQUE IDS PRESENT IN THE SYSTEM ALREADY 
        for(sObject temp : Database.query(finalQueryStr)){
            uniqueSequenceIds.put(String.ValueOf(temp.get(UNIQUE_ACTIVE_SEQUENCE)),String.ValueOf(temp.get(LABEL_NAME)));
            uniqueVersionSequenceIds.put(String.ValueOf(temp.get(UNIQUE_SEQUENCE_VERSION)),String.ValueOf(temp.get(LABEL_NAME)));
        } 
        String dynamicErrorMsg = IMH_UtilityConstants.EMPTY_STRING;
        // ITERATE THROUGH THE TRIGGER VARIABLE TO POPULATE UNIQUE SEQUENCE IDS/THROW VALIDATION ERROR 
        for(sObject tempsObj: iteratablesObj){
            dynamicErrorMsg = IMH_UtilityConstants.EMPTY_STRING;
            if(tempsObj.get(parentFieldName)!=null){
                    tempsObj.put(UNIQUE_ACTIVE_SEQUENCE,String.valueOf(tempsObj.get(parentFieldName)) 
                            + String.valueOf(tempsObj.get(ORDER_SEQUENCE))
                                + (Boolean.valueOf(tempsObj.get(ACTIVE))? BOOLEAN_STR_TRUE : BOOLEAN_STR_FALSE + String.valueOf(tempsObj.get(VERSION))));
                    tempsObj.put(UNIQUE_SEQUENCE_VERSION,String.valueOf(tempsObj.get(parentFieldName)) 
                            + String.valueOf(tempsObj.get(ORDER_SEQUENCE)) 
                                + String.valueOf(tempsObj.get(VERSION))); 
                if(uniqueVersionSequenceIds.containsKey(String.valueOf(tempsObj.get(UNIQUE_SEQUENCE_VERSION)))){
                    dynamicErrorMsg = Label.IMH_VersionValidation_1 
                                        + QUERY_SPACE +  uniqueVersionSequenceIds.get(String.valueOf(tempsObj.get(UNIQUE_SEQUENCE_VERSION))) 
                                        + QUERY_SPACE + Label.IMH_VersionValidation_2;
                }else{
                    uniqueVersionSequenceIds.put(String.valueOf(tempsObj.get(UNIQUE_SEQUENCE_VERSION)),IMH_UtilityConstants.EMPTY_STRING);
                }        
                if(uniqueSequenceIds.containsKey(String.valueOf(tempsObj.get(UNIQUE_ACTIVE_SEQUENCE)))){
                    if(Boolean.valueOf(tempsObj.get(ACTIVE))){
                        dynamicErrorMsg = Label.IMH_OrderSequenceValidation_1 
                                        + QUERY_SPACE + uniqueSequenceIds.get(String.valueOf(tempsObj.get(UNIQUE_ACTIVE_SEQUENCE))) 
                                        + QUERY_SPACE  + Label.IMH_OrderSequenceValidation_2;
                    }
                }else{
                    uniqueSequenceIds.put(String.valueOf(tempsObj.get(UNIQUE_ACTIVE_SEQUENCE)),IMH_UtilityConstants.EMPTY_STRING);
                }
             }
            // ADDING THE ERROR TO TOP OF THE PAGE FOR PARTICULAR  SOBJECT
            if(String.isNotBlank(dynamicErrorMsg)){
                tempsObj.addError(dynamicErrorMsg);
            }
                
        }
    }
    
    public static String fetchAllFields(String SobjectApiName,String innerQuery) {
        String query =IMH_UtilityConstants.EMPTY_STRING;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        
        String commaSepratedFields =IMH_UtilityConstants.EMPTY_STRING;
        String recordTypeString =RECORDTYPENAMECOMMA;
        for(String fieldName : fieldMap.keyset()){
            if(commaSepratedFields == null || commaSepratedFields ==IMH_UtilityConstants.EMPTY_STRING){
                commaSepratedFields = fieldName;
            } else {
                commaSepratedFields = commaSepratedFields + IMH_UtilityConstants.COMMA + IMH_UtilityConstants.BLANK_SPACE + fieldName;
            }
        }
        if(String.isNotBlank(innerQuery)){
            commaSepratedFields = commaSepratedFields + IMH_UtilityConstants.COMMA 
                                + IMH_UtilityConstants.BLANK_SPACE + innerQuery;
        }
        if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(SobjectApiName)){
            commaSepratedFields = commaSepratedFields + IMH_UtilityConstants.COMMA
                                + IMH_UtilityConstants.INNER_QUERY_CREATIVE + IMH_UtilityConstants.COMMA 
                                + IMH_UtilityConstants.INNER_QUERY_INCENTIVE + IMH_UtilityConstants.COMMA
                                + IMH_UtilityConstants.INNER_QUERY_PRE_APPROVED + IMH_UtilityConstants.COMMA + IMH_UtilityConstants.BLANK_SPACE + RECORDTYPE_DEVELOPERNAME;
        }
        
        query = SELECT_STRING + IMH_UtilityConstants.BLANK_SPACE + (!IMH_UtilityConstants.BENEFIT_API.equalsIgnoreCase(SobjectApiName)?recordTypeString:IMH_UtilityConstants.EMPTY_STRING) + commaSepratedFields + FROM_STRING + SobjectApiName ;
        return query;
    }
    
    /**
    * @description  - contructs a map for describe calls for field tokens
    * @param  - Object Api Name , query index, map of sobejcts retrieved By Id
    * @return  - void
    */ 
    public Static void getSOBjectRecords(String sobjectApiName, Set<Id> recordIds
                                         , Map<Id,sObject> msObjectRecords
                                         , Map<String,Map<String, Schema.SObjectField>> fieldMapByObjectName){
        String queryString = IMH_UtilityConstants.EMPTY_STRING;
        String commaSepratedFields = IMH_UtilityConstants.EMPTY_STRING;
        // CONSTRCUT A QUERY STRING TO RETRIEVE ALL THE FIELDS OF THE OBJECT 
        for(String fieldName : fieldMapByObjectName.get(sobjectApiName).keyset()){
            if(commaSepratedFields == null 
                    || commaSepratedFields.equalsIgnoreCase(IMH_UtilityConstants.EMPTY_STRING)){
                commaSepratedFields = fieldName;
            }else{
                commaSepratedFields = commaSepratedFields + COMMA_QUERY_STR + fieldName;
            }
        }
         if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(SobjectApiName)){
                commaSepratedFields = commaSepratedFields + IMH_UtilityConstants.COMMA
                                + IMH_UtilityConstants.INNER_QUERY_CREATIVE + IMH_UtilityConstants.COMMA 
                                + IMH_UtilityConstants.INNER_QUERY_INCENTIVE + IMH_UtilityConstants.COMMA
                                + IMH_UtilityConstants.INNER_QUERY_PRE_APPROVED + IMH_UtilityConstants.COMMA + IMH_UtilityConstants.BLANK_SPACE + RECORDTYPE_DEVELOPERNAME;
            }                                     
        queryString = SELECT_STRING + commaSepratedFields + FROM_STRING + SobjectApiName + WHERE_CLAUSE_QUERY_STR;
        //DYNAMIC QUERY THE SOBJECT RECORDS WITH ALL FIELDS
        msObjectRecords.putALL(Database.query(queryString));
    }
    
    /**
    * @description  - contructs a map for describe calls for field tokens
    * @param  - Object Name 
    * @return  - Map<String, Schema.SObjectField>
    */ 
    public static Map<String, Schema.SObjectField> constructFieldMap (String objectName , Map<String, Schema.SObjectType> mSobjectTypeByName){
        Schema.SObjectType schemaObjectType = mSobjectTypeByName.get(objectName);
        Map<String, Schema.SObjectField> fieldMap = schemaObjectType.getDescribe().fields.getMap();
        return fieldMap;
    }
    
    /**
    * @description  - Method used to check the Entry Criteria Condition
    * @param  - None
    * @return  - Boolean
    */ 
    public static Boolean checkEntryCriteria(sobject qwarn, 
                                       Map<Id,sObject> mParentSObject,
                                      String sObjectType,
                                      sobject sObjRecord,
                                      Map<String,Map<String, Schema.SObjectField>> fieldMapByObjectName,
                                      Boolean validToDisplay){
        Map<String,String> mAPINameByLabalName = new Map<String,String>();
        Map<String,String> mLabelNameBYObjectAPIName = new Map<String,String>();
        mAPINameByLabalName.PUT(COMMUNICATION,IMH_UtilityConstants.COMMUNICATION_OBJECT_API);
        mAPINameByLabalName.PUT(IMH_UtilityConstants.INCENTIVE_LABELNAME,IMH_UtilityConstants.INCENTIVE_OBJECT_API);
        mAPINameByLabalName.PUT(CREATIVE,IMH_UtilityConstants.COMMCREATIVE_OBJECT_API);
        mAPINameByLabalName.PUT(IMH_UtilityConstants.BENEFITS_ENTRY_LABEL,IMH_UtilityConstants.BENEFIT_API);
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,COMMUNICATION);
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.INCENTIVE_OBJECT_API,IMH_UtilityConstants.INCENTIVE_LABELNAME);
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API,CREATIVE);
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.BENEFIT_API,IMH_UtilityConstants.BENEFITS_ENTRY_LABEL);
        Object valueToCheck1 = null;
        Set<String> multiselectValues = new Set<String>();
        IMH_EntryCriteria__c entryCriteria= null;
        String innerQueryRel = IMH_UtilityConstants.EMPTY_STRING;
        String childRecordValues = IMH_UtilityConstants.EMPTY_STRING;
        Boolean isChildRecordCheck = false;                                    
        for(sObject eCriteria : qwarn.getSObjects(ENTRYCRITERIA_REL)){
                    isChildRecordCheck = false;
                    entryCriteria = (IMH_EntryCriteria__c)eCriteria;
                    multiselectValues.clear();
                    multiselectValues.addAll(entryCriteria.Equals__c.split(IMH_UtilityConstants.SEMI_COLON));
                    if(COMMUNICATION.equalsIgnoreCase(entryCriteria.Object__c) 
                        && !IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(sObjectType)){
                        valueToCheck1 = mParentSObject.get(Id.valueOf(String.valueOf(sObjRecord.get(
                                            IMH_UtilityConstants.communication_REF_FIELD)))).get(entryCriteria.Field__c);                
                    }
                    else if (mLabelNameBYObjectAPIName.get(sObjectType).equalsIgnoreCase(entryCriteria.Object__c)){
                        valueToCheck1 = sObjRecord.get(entryCriteria.Field__c);
                    }
                    if(String.valueOf(valueToCheck1) != NULL && (String.valueOf(valueToCheck1).equalsIgnorecase('true') || String.valueOf(valueToCheck1).equalsIgnorecase('false'))) {
                        valueToCheck1 = String.valueOf(valueToCheck1).toUpperCase();
                    }
                    if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(sObjectType) 
                       && !COMMUNICATION.equalsIgnoreCase(entryCriteria.Object__c)){
                           isChildRecordCheck = true;
                           innerQueryRel = IMH_UtilityConstants.INCENTIVE_LABELNAME.equalsIgnoreCase(entryCriteria.Object__c)
                                                    ?INCENTIVES_REL:CREATIVE.equalsIgnoreCase(entryCriteria.Object__c)
                                                                                    ?CREATIVE_REL:PREAPPROVED_REL;
                           for(sObject childObject : sObjRecord.getSObjects(innerQueryRel)){
                               if(String.isBlank(childRecordValues)){
                                   childRecordValues = childObject.get(entryCriteria.Field__c)!=NULL?String.valueOf(childObject.get(entryCriteria.Field__c)):childRecordValues;
                               }else{
                                   childRecordValues = childObject.get(entryCriteria.Field__c)!=NULL?childRecordValues +IMH_UtilityConstants.SEMI_COLON + String.valueOf(childObject.get(entryCriteria.Field__c)):childRecordValues;
                               }
                                
                           }
                        valueToCheck1 = childRecordValues;                           
                    }   
                    
                    if(isChildRecordCheck || (fieldMapByObjectName.get(mAPINameByLabalName.get(entryCriteria.Object__c)).get(entryCriteria.Field__c).getDescribe().getType() 
                                                                                        == Schema.DisplayType.MultiPicklist
                      && valueToCheck1 != NULL) ){
                        validToDisplay = false;                                                                                            
                         for(String str : String.valueOf(valueToCheck1).split(IMH_UtilityConstants.SEMI_COLON)){
                             validToDisplay = multiselectValues.contains(str)?true:false;
                             if(validToDisplay){
                                 break;
                             }
                         }       
                    }
                    else{
                        if(valueToCheck1 != null 
                            && multiselectValues.contains(String.valueOf(valueToCheck1))){
                            validToDisplay  =true;
                        }
                        else{
                            validToDisplay  = false;
                        } 
                    }
                    // MIGRATE THIS LINE TO CONTROLLER
                    if(!validToDisplay){
                       break;
                    }
                }   
        return validToDisplay;
    }

  /**
    * @description  - This method is used to calculate the threshold time for SLA tracker records
    * @param  - List<IMH_SLATracker__c>
    * @return  - Void
    */    
    public static void calcualteThreshold(IMH_SLATracker__c tempSLATracker, Integer Threshold){
        Integer numberofdays = 0;
        if(tempSLATracker.Started__c.format(ED).equalsIgnoreCase(SAT)){
            numberofdays = 2;
        }
        else if(tempSLATracker.Started__c.format(ED).equalsIgnoreCase(SUN)){
            numberofdays = 1;
        }
        if(numberofdays > 0){
            tempSLATracker.Started__c = DateTime.newInstance(tempSLATracker.Started__c.date().addDays(numberofdays), Time.newInstance(9, 0, 0,0));
        }
        tempSLATracker.Threshold__c  = null;
        tempSLATracker.Threshold__c  = tempSLATracker.Started__c.addHours(Threshold);
        tempSLATracker.Threshold__c = excludeWeekends(tempSLATracker.Threshold__c,tempSLATracker.Started__c);
        if(tempSLATracker.Threshold__c.format(ED).equalsIgnoreCase(MON)){
            tempSLATracker.SYS_WarningDate__c = tempSLATracker.Threshold__c.addHours(-96);                     
        }
        else if(tempSLATracker.Threshold__c.format(ED).equalsIgnoreCase(TUE)) {
            tempSLATracker.SYS_WarningDate__c = tempSLATracker.Threshold__c.addHours(-72);                     
        }
        else{
            tempSLATracker.SYS_WarningDate__c = tempSLATracker.Threshold__c.addHours(-48);                          
        }   
     }
    
    /**
    * @description  - This public method is used to calculate the threshold date excluding weekends.
    * @param  - Datetime,DateTime
    * @return  - DateTime
    */   
    public static DateTime excludeWeekends(Datetime date1,DateTime date2){
        if(date1!=null){
              Datetime middate;
              Integer doi = date2.Date().daysBetween(date1.Date());
              Integer quote = doi / 7;
              Integer remainder = Math.mod(doi,7);
              middate = date1.addDays(quote*2);
              If(date2.format(ED).equalsIgnoreCase(MON)){
                  date1 = middate; 
              }
              else if(date2.format(ED).equalsIgnoreCase(TUE)){
                  if(remainder > 3 && remainder <= 6){
                      date1 = middate.addDays(2);
                  }
                  else if(quote > 0){
                      date1 = middate + (quote - 1)*2;
                  }
              }
              else if(date2.format(ED).equalsIgnoreCase(WED)){
                  if(remainder > 2 && remainder <= 6){
                     
                       date1 = middate.addDays(2);
                  }
                  else if(quote > 0){
                      date1 = middate + (quote - 1)*2   ;
                  }
              }
              else if(date2.format(ED).equalsIgnoreCase(THU)){
                  if(remainder > 1 && remainder <= 6){
                       date1 = middate.addDays(2);
                  }
                  else if(quote > 0){
                      date1 = middate +  (quote - 1)*2;
                  }
              }
              else if(date2.format(ED).equalsIgnoreCase(FRI)){
                  if(remainder > 0 && remainder <= 6){
                       date1 = middate.addDays(2);
                  }
                  else{
                      date1 = middate;
                  }
              }
                if(date1.format(ED).equalsIgnoreCase(SAT)){
                        date1 = date1.addDays(2);
                    }
                    else if(date1.format(ED).equalsIgnoreCase(SUN)){
                        date1 = date1.addDays(2);
                    }
                    else
                    {
                        date1 = date1;
                    }
            }
        return date1;
    }
    
  /**
    * @description  - This private method is used to call calculateDelta function.
    * @param  - List<IMH_SLATracker__c>,List<IMH_SLATracker__c>
    * @return  - void
    */    
    public static void  deltaCalculation(List<IMH_SLATracker__c> ltempSlaTracker){
        List<IMH_SLATracker__c> lupdatedtrackers = new List<IMH_SLATracker__c>();
            if(ltempSlaTracker != NULL){
                for(IMH_SLATracker__c tempSlaTracker:ltempSlaTracker){
                    if(tempSlaTracker.Threshold__c != NULL && tempSlaTracker.Completed__c != NULL){
                        tempSlaTracker.DeltaHours__c=calculateDelta( tempSlaTracker.Threshold__c,tempSlaTracker.Completed__c);  
                    }
                    if(tempSLATracker.Started__c != NULL &&  tempSLATracker.Completed__c != NULL){
                        tempSlaTracker.TotalHours__c = calculateDelta( tempSlaTracker.Started__c,tempSlaTracker.Completed__c);
                    }
                    lupdatedtrackers.add(tempSlaTracker);
                }
           } 
     /*if(!lupdatedtrackers.isEmpty()){
         Database.update(lupdatedtrackers,false);
     }*/
           //return  lupdatedtrackers;                         
   } 
   /**
    * @description  - This private method is used to calculate the delta and total hours.
    * @param  - Datetime,DateTime
    * @return  - DateTime
    */
    public static Double calculateDelta(Datetime thresdate,Datetime completedate){
       
        Double timetaken;
        Datetime startingdate;
        Long dt1Long = thresdate.getTime();
        Long dt2Long = completedate.getTime();
        // System.debug('****DDD '+(Long)(dt2Long - dt1Long));
        Long milliseconds = dt2Long - dt1Long;
        // System.debug('****MS '+milliseconds);
        Long seconds = milliseconds / 1000;
        //System.debug('****MILLI '+milliseconds);
        Long minutes = seconds / 60;
         // System.debug('****MIN '+minutes);
        Long hours = minutes / 60;
        Long days = hours / 24;
        Integer workingDays = 0;
        Integer doi;
        
        if(thresdate > completedate)
        {
            doi = completedate.Date().daysBetween(thresdate.Date());
            startingdate = completedate;
        }
        else{
           doi = thresdate.Date().daysBetween(completedate.Date());
            startingdate = thresdate;
        }
        Integer quote = doi / 7;
        Integer remainder = Math.mod(doi,7);    
        Integer midsubtractdays = quote * 2;
        integer finalsubtractdays = 0;
        if(startingdate.format(ED).equalsIgnorecase(MON)){
            finalsubtractdays = midsubtractdays;
        }
        else if(startingdate.format(ED).equalsIgnorecase(TUE)){
            if(remainder==6){
               finalsubtractdays = midsubtractdays + 2;
              
            }
            else{
                finalsubtractdays = midsubtractdays;
            }
        }
        else if(startingdate.format(ED).equalsIgnorecase(WED)){
            if(remainder >= 5){
               finalsubtractdays = midsubtractdays + 2; 
            }
            else{
                finalsubtractdays = midsubtractdays;
            }
        }
        else if(startingdate.format(ED).equalsIgnorecase(THU)){
            if(remainder >= 4){
               finalsubtractdays = midsubtractdays + 2; 
            }
            else{
                finalsubtractdays = midsubtractdays;
            }
        }
        else if(startingdate.format(ED).equalsIgnorecase(FRI)){
            if(remainder>=3){
               finalsubtractdays = midsubtractdays + 2; 
            }
            else{
                finalsubtractdays = midsubtractdays;
            }
        }
        if(hours < 0){
            timetaken = hours + (finalsubtractdays * 24);
        }
        else{
            timetaken = hours - (finalsubtractdays * 24); 
        }
        return timetaken;
    }
    
    public static void updateAnswerStatus(List<sObject>ltriggernew
                                         , Map<Id,sObject> mtriggernew
                                         , Set<Id> communicationIds
                                         , String questionStage
                                         , String sObjectType){
        Map<String, Schema.SObjectType> mSobjectTypeByName = new  Map<String, Schema.SObjectType>();
        Map<String,Map<String, Schema.SObjectField>> fieldMapByObjectName = new Map<String,Map<String, Schema.SObjectField>>();
        mSobjectTypeByName = Schema.getGlobalDescribe();
        
        fieldMapByObjectName.put(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,IMH_GeneralApplicationUility.constructFieldMap(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,mSobjectTypeByName));
        
        Map<Id,List<IMH_AnswerSet__c>> answerSetByCommId = new Map<Id,List<IMH_AnswerSet__c>>(); 
        Map<Id,IMH_AnswerSet__c> answerSetByQsetId = new Map<Id,IMH_AnswerSet__c>();  
        Map<Id,IMH_AnswerSet__c> mapOfAnswerSet = new Map<Id,IMH_AnswerSet__c>();                                             
        for(IMH_Communication__c commObj : [SELECT Id ,ProcessStage__c,ReviewStage__c, (SELECT Id,SYS_CommunicaitonQuestionSetType__c,Status__c,QuestionSet__c,Communication__c FROM Answer_Sets__r WHERE Status__c!= :NOT_STARTED) 
                                                            FROM IMH_Communication__c WHERE Id IN :communicationIds ]){
            
            for(IMH_AnswerSet__c anset : commObj.Answer_Sets__r){
                if(commObj.ProcessStage__c.equalsIgnoreCase(anset.SYS_CommunicaitonQuestionSetType__c)
                   && 'Design'.equalsIgnoreCase(commObj.ReviewStage__c)){
                    mapOfAnswerSet.put(anset.Id,anset);
                    answerSetByQsetId.put(anset.QuestionSet__c,anset);
                }
             }                                                                
        }                                     
        Map<Id,Set<Id>> setOfExistingQSetIdsByAnswerSet = new Map<Id,Set<Id>>(); 
        Set<Id> tempSet = new Set<Id>();                                             
        for(IMH_Answer__c tempAns : [SELECT Id,Question__r.QuestionSet__c,AnswerSet__c FROM IMH_Answer__c
                                     WHERE AnswerSet__c IN : mapOfAnswerSet.keySet()
                                    AND Answer__c !=:IMH_UtilityConstants.NONE AND Status__c != :IMH_UtilityConstants.NOT_REQUIRED
                                    AND Question__r.QuestionSet__r.ParentQuestionSet__c!=null]){
            tempSet = new Set<Id>();                             
            if(setOfExistingQSetIdsByAnswerSet.containsKey(tempAns.AnswerSet__c)){
                tempSet = setOfExistingQSetIdsByAnswerSet.get(tempAns.AnswerSet__c);
                tempSet.add(tempAns.Question__r.QuestionSet__c);
                setOfExistingQSetIdsByAnswerSet.put(tempAns.AnswerSet__c,tempSet);
            }else{
                setOfExistingQSetIdsByAnswerSet.put(tempAns.AnswerSet__c, new Set<Id>{tempAns.Question__r.QuestionSet__c});
            }
        }
        //CHECK THE VALID STATUS AS PER NEW DATA
        Map<String,String> mLabelNameBYObjectAPIName = new Map<String,String>();
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,IMH_UtilityConstants.COMMUNICATION_LABELNAME);
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.INCENTIVE_OBJECT_API,IMH_UtilityConstants.INCENTIVE_LABELNAME);
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API,CREATIVE);
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.BENEFIT_API,IMH_UtilityConstants.BENEFITS_ENTRY_LABEL);
        Map<Id,Set<Id>> setOfvalidQSetIdsByAnswerSet = new Map<Id,Set<Id>>();                                      
        Boolean validQuestionSet = false;
        Map<Id,sObject> mParentSObject = new Map<Id,sObject>();                                             
        String sObjectQueryString = IMH_GeneralApplicationUility.fetchAllFields(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,IMH_UtilityConstants.EMPTY_STRING);
        MAP<Id,sObject> mapOfsObjectById  = new Map<Id,sObject>(Database.query(sObjectQueryString + WHEREQUERY_COMMS));                                     
        
        
        for(IMH_QuestionSet__c childSet : [SELECT Id ,ParentQuestionSet__c,(SELECT Id,Object__c,Field__c,Equals__c FROM EntryCriterias__r 
                                                           WHERE Object__c = : mLabelNameBYObjectAPIName.get(IMH_UtilityConstants.COMMUNICATION_OBJECT_API)
                                                           OR Object__c = :mLabelNameBYObjectAPIName.get(sObjectType)
                                                           LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows()))
                                               FROM IMH_QuestionSet__c WHERE Active__c = TRUE 
                                               AND (ParentQuestionSet__c IN : answerSetByQsetId.keySet())]){
            validQuestionSet  = false;
            validQuestionSet = IMH_GeneralApplicationUility.checkEntryCriteria(childSet,mParentSObject, IMH_UtilityConstants.COMMUNICATION_OBJECT_API,
                                                                                mapOfsObjectById.get(answerSetByQsetId.get(childSet.ParentQuestionSet__c).Communication__c) 
                                                                               ,fieldMapByObjectName,validQuestionSet);
            tempSet = new Set<Id>();                                                   
            if(validQuestionSet){
                if(setOfvalidQSetIdsByAnswerSet.containsKey(answerSetByQsetId.get(childSet.ParentQuestionSet__c).Id)){
                    tempSet = setOfvalidQSetIdsByAnswerSet.get(answerSetByQsetId.get(childSet.ParentQuestionSet__c).Id);
                    tempSet.add(childSet.Id);
                    setOfvalidQSetIdsByAnswerSet.put(answerSetByQsetId.get(childSet.ParentQuestionSet__c).Id,tempSet);
                }else{
                    setOfvalidQSetIdsByAnswerSet.put(answerSetByQsetId.get(childSet.ParentQuestionSet__c).Id, new Set<Id>{childSet.Id});
                }   
            }                                  
        }
        
        List<IMH_AnswerSet__c> lAnswerSetToUpdate = new List<IMH_AnswerSet__c>(); 
        IMH_AnswerSet__c ansSetTempObj = new IMH_AnswerSet__c();                                        
        for(Id answerSetId : setOfvalidQSetIdsByAnswerSet.keySet()){
            if(!setOfvalidQSetIdsByAnswerSet.get(answerSetId).equals(setOfExistingQSetIdsByAnswerSet.get(answerSetId))){
                ansSetTempObj = mapOfAnswerSet.get(answerSetId);
                ansSetTempObj.Status__c = IMH_UtilityConstants.ANS_INPROGRESS;
                lAnswerSetToUpdate.add(ansSetTempObj);
            }
        }

        if(!lAnswerSetToUpdate.isEmpty()){
            Database.update(lAnswerSetToUpdate,false);
        }                                             
    }
    
    // PEER REVIEW - METHOD DOCUMENTATION IS MISSING 
    public static String fetchAllFieldsClone(String SobjectApiName,String innerQuery) {
        String query =IMH_UtilityConstants.EMPTY_STRING;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
          Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>();
        // if(!SobjectApiName.containsIgnoreCase('User') && !SobjectApiName.containsIgnoreCase('PermissionSetAssignment') && !SobjectApiName.containsIgnoreCase('GroupMember')){
          //System.debug(); 
         fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        //}
        
        List<Schema.FieldSetMember> listfieldMembers = new List<Schema.FieldSetMember>();
        if(!SobjectApiName.containsIgnoreCase('User')){
            listfieldMembers = readFieldSet(ESCAPESYSFIELDS,SobjectApiName);
        }
        
        Set<String> setescapefields = new Set<String>();
        //System.debug('*(*(*'+);
        for(Schema.FieldSetMember apiname:listfieldMembers){
            setescapefields.add(apiname.getFieldPath().toLowerCase());
        }
        //System.debug('*(*(*'+setescapefields);
        String recordTypeString =IMH_UtilityConstants.EMPTY_STRING;
        String commaSepratedFields =IMH_UtilityConstants.EMPTY_STRING;
        //PEER REVIEW - USE CONSTANT FIRST WHILE COMPARING 
        if(!SobjectApiName.equalsIgnoreCase(IMH_UtilityConstants.TARGETEDPRODUCT_OBJECT_API) 
           && !IMH_UtilityConstants.TARGETEDCHANNEL_OBJECT_API.equalsIgnoreCase(SobjectApiName)
          && !SobjectApiName.containsIgnoreCase(IMH_UtilityConstants.PREAPPROVED_OBJECT_API)
           && !SobjectApiName.containsIgnoreCase(IMH_UtilityConstants.TARGETEDCOMMPRODUCT_OBJECT_API)
           && !SobjectApiName.containsIgnoreCase(IMH_UtilityConstants.TARGETEDCOMMCHANNEL_OBJECT_API)){
            recordTypeString =RECORDTYPENAMECOMMA;
        }
        System.debug(SobjectApiName + recordTypeString );
        integer count = 0;
        for(String fieldName : fieldMap.keyset()){
        if(!setescapefields.contains(fieldName)){
            //PEER REVIEW - USE STRING METHODS TO COMPARE
            if(commaSepratedFields == null || commaSepratedFields.equalsIgnoreCase(IMH_UtilityConstants.EMPTY_STRING)){
                commaSepratedFields = fieldName;
            } else {
                commaSepratedFields = commaSepratedFields + IMH_UtilityConstants.COMMA + IMH_UtilityConstants.BLANK_SPACE + fieldName;
            }
            }
            else{
               count++; 
            }
        }
       // System.debug(count);
       /* if(String.isNotBlank(innerQuery)){
            commaSepratedFields = commaSepratedFields + IMH_UtilityConstants.COMMA 
                                + IMH_UtilityConstants.BLANK_SPACE + innerQuery;
        }*/
        if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(SobjectApiName)){
            commaSepratedFields = commaSepratedFields + IMH_UtilityConstants.COMMA
                                + OPENINGBRACE + IMH_DeepClone.constructQueryObj1 +CLOSINGBRACE + IMH_UtilityConstants.COMMA 
                                + OPENINGBRACE + IMH_DeepClone.constructQueryObj2 + CLOSINGBRACE+ IMH_UtilityConstants.COMMA
                                + OPENINGBRACE + IMH_DeepClone.constructQueryObj3 + CLOSINGBRACE + IMH_UtilityConstants.COMMA 
                                + OPENINGBRACE + IMH_DeepClone.constructQueryObj4 + CLOSINGBRACE + IMH_UtilityConstants.COMMA
                                + OPENINGBRACE + IMH_DeepClone.constructQueryObj5 + CLOSINGBRACE + IMH_UtilityConstants.COMMA
                                + IMH_UtilityConstants.BLANK_SPACE + RECORDTYPE_DEVELOPERNAME;
        }
        //PEER REVIEW - USE STRING METHOD TO CHECK IF THE STRING IS EMPTY
        else if(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API.equalsIgnoreCase(SobjectApiName) && !innerquery.equalsIgnoreCase(IMH_UtilityConstants.EMPTY_STRING)){
            commaSepratedFields = commaSepratedFields +IMH_UtilityConstants.COMMA
                                + OPENINGBRACE + IMH_DeepClone.constructQueryObj1 + CLOSINGBRACE + IMH_UtilityConstants.COMMA 
                                + OPENINGBRACE + IMH_DeepClone.constructQueryObj2 + CLOSINGBRACE + IMH_UtilityConstants.COMMA
                                + IMH_UtilityConstants.BLANK_SPACE + RECORDTYPE_DEVELOPERNAME;
        }
        
        query = SELECT_STRING + IMH_UtilityConstants.BLANK_SPACE + (!IMH_UtilityConstants.TARGETEDPRODUCT_OBJECT_API.equalsIgnoreCase(SobjectApiName)?recordTypeString:IMH_UtilityConstants.EMPTY_STRING) + commaSepratedFields + FROM_STRING + SobjectApiName ;
        
        /*else{
            query = SELECT_STRING + IMH_UtilityConstants.BLANK_SPACE + commaSepratedFields + FROM_STRING + SobjectApiName ;
        }*/
          return query;
    }
    
    //Querying From Field Set
     public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName)
    {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        if(fieldSetObj == NULL)
            return null;
        else
          return fieldSetObj.getFields(); 
    }   
    
        /*****************************************************************************
    * @description -  This method is called to remove the required approvers from communication if there are any deletion of targeted product/channel
    * @param - Trigger.Old(sObject)
    * @return - void
    */
    private static final string CHANNEL_API_NAME = 'Channel__c';
    private static final string REF_OBJECT_QUERYSTRING_P1 = 'SELECT Id,RequiredApprovers__c FROM ';
    private static final string REF_OBJECT_QUERYSTRING_P2 = ' WHERE RequiredApprovers__c != NULL AND Id IN :refObjIds';
    private static final string REQUIREDAPPROVERS_FIELD_API_NAME = 'RequiredApprovers__c';
    public static void removeRequiredApprovers(Map<Id,sObject> mtriggerOld, String refObjectRelName){
        Set<Id> communicationIds = new Set<Id>();
        Map<Id,Set<Id>> referenceIdsByCommId = new Map<Id,Set<Id>>();
        Set<Id> refObjIds = new Set<Id>();
        Set<String> tempString = new Set<String>();
        Set<Id> creativeIds = new Set<Id>();
        List<IMH_Communication__c> lCommunicationToUpdate = new List<IMH_Communication__c>();
        String refObjectAPIName = IMH_UtilityConstants.PRODUCT_API;
        if(CHANNEL_API_NAME.equalsIgnoreCase(refObjectRelName)){
            refObjectAPIName = IMH_UtilityConstants.CHANNEL_API;
        }
        Set<Id> tempSet = new Set<Id>();
        for(sObject sobj:mtriggerOld.values()){
            communicationIds.add((Id)sObj.get(IMH_UtilityConstants.COMMUNICATION_REF_FIELD));
            refObjIds.add((Id)sObj.get(refObjectRelName));
            if(referenceIdsByCommId.containsKey((Id)sObj.get(IMH_UtilityConstants.COMMUNICATION_REF_FIELD))){
                tempSet = referenceIdsByCommId.get((Id)sObj.get(IMH_UtilityConstants.COMMUNICATION_REF_FIELD));
                tempset.add((Id)sObj.get(refObjectRelName));
                referenceIdsByCommId.put((Id)sObj.get(IMH_UtilityConstants.COMMUNICATION_REF_FIELD),tempset);
            }else{
                referenceIdsByCommId.put((Id)sObj.get(IMH_UtilityConstants.COMMUNICATION_REF_FIELD),new Set<Id>{(Id)sObj.get(refObjectRelName)});
            }
        }
        Set<String> stampedRequiredApprovers = new Set<String>();
        String refObjectQueryStr = REF_OBJECT_QUERYSTRING_P1 +refObjectAPIName + REF_OBJECT_QUERYSTRING_P2;
        Map<Id,Sobject> mRefSObject = new Map<Id,Sobject>(Database.query(refObjectQueryStr));
        for(IMH_Communication__c commObj:[SELECT Id,RequiredApprovers__c,
                            (SELECT Id , RequiredApprovers__c FROM Creative__r WHERE RequiredApprovers__c !=NULL)
                            , (SELECT Id, Product__r.RequiredApprovers__c FROM CommunicationProducts__r WHERE Product__r.RequiredApprovers__c!=NULL)
                            , (SELECT Id, Channel__r.RequiredApprovers__c FROM CommunicationChannel__r WHERE Channel__r.RequiredApprovers__c!=NULL)
                            FROM IMH_Communication__c WHERE Id IN : communicationIds AND RequiredApprovers__c != NULL
                                LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
            stampedRequiredApprovers.addAll(commObj.RequiredApprovers__c.split(IMH_UtilityConstants.SEMI_COLON));
            for(IMH_CommCreative__c creativeObj :commObj.Creative__r){
                creativeIds.add(creativeObj.Id);
            }
            tempString = new Set<String>();
            if(referenceIdsByCommId.containsKey(commObj.Id)){
                for(Id refId : referenceIdsByCommId.get(commObj.Id)){
                    if(mRefSObject.containsKey(refId)){
                        tempString.addAll(((String)mRefSObject.get(refId).get(REQUIREDAPPROVERS_FIELD_API_NAME)).split(IMH_UtilityConstants.SEMI_COLON));
                    }
                }
            }
            stampedRequiredApprovers.removeAll(tempString);
            for(IMH_CommProducts__c cProduct : commObj.CommunicationProducts__r){
                stampedRequiredApprovers.addAll(cProduct.Product__r.RequiredApprovers__c.split(IMH_UtilityConstants.SEMI_COLON));
            }
            for(IMH_CommChannels__c cChannel : commObj.CommunicationChannel__r){
                stampedRequiredApprovers.addAll(cChannel.Channel__r.RequiredApprovers__c.split(IMH_UtilityConstants.SEMI_COLON));
            }
            if(!stampedRequiredApprovers.containsAll(commObj.RequiredApprovers__c.split(';'))){
                commObj.RequiredApprovers__c = '';
                for(String reqStr : stampedRequiredApprovers){
                    if(String.isBlank(commObj.RequiredApprovers__c)){
                        commObj.RequiredApprovers__c = reqStr;
                    }
                    else{
                        commObj.RequiredApprovers__c = commObj.RequiredApprovers__c + ';' + reqStr;
                    }
                }
                lCommunicationToUpdate.add(commObj);
            }
        }
        if(!lCommunicationToUpdate.isEmpty()){
            Database.update(lCommunicationToUpdate,false);
        }
        //UPDATE REQUIRED APPROVERS ON CREATIVE AS WELL SINCE CASCADE DELETE WILL NOT TRIGGER WHERE THE RECORD HAS NOT BEEN INITIATED
        IMH_ChannelProductRejectHandler.updateRequiredApproversOnCreative(new List<sObject>(),creativeIds);
    }
    
    
     /*****************************************************************************
    * @description -  This method is called to prevent the deletion of Child Object - TargetedProduct/Targeted Channel if communication stage is not Concept - Design
    * @param - Trigger.Old(sObject)
    * @return - void
    */
    public static void preventDeletion(Map<Id,sObject> mtriggerOld, String errMsg, String sObjName) {
        Map<Id,Set<Id>> communicationsObjIdMap = new Map<Id,Set<Id>>();
        String profileName = [SELECT Id,Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1].Name;
        Set<Id> tempSetIds = new Set<Id>();
        String addErrorMsg = '';
        for(sObject sobj:mtriggerOld.values()){
            if(communicationsObjIdMap.containsKey((Id)sobj.get('Communication__c'))){
                tempSetIds = communicationsObjIdMap.get((Id)sobj.get('Communication__c'));
                tempSetIds.add((Id)sobj.get('Id'));
                communicationsObjIdMap.put((Id)sobj.get('Communication__c'), tempSetIds);
            }
            communicationsObjIdMap.put((Id)sobj.get('Communication__c'), new Set<Id>{(Id)sobj.get('Id')});
        }
        Boolean throwError = false;
        for(IMH_Communication__c sobj:[SELECT ID,
                                          Stage__c
                                         ,OwnerId
                                       FROM IMH_Communication__c
                                       WHERE ID IN:communicationsObjIdMap.keySet() 
                                       AND Stage__c!=NULL LIMIT : (Limits.getLimitQueryRows()-Limits.getQueryRows())] ) {
                throwError = false;                                           
                if(sobj.OwnerId != UserInfo.getUserId() 
                            && 'IMH_Incentive__c'.equalsIgnoreCase(sObjName)
                            && !'System Administrator'.equalsIgnoreCase(profileName)
                            && !'iMH Business Admin'.equalsIgnoreCase(profileName)){
                    throwError  = true;
                    addErrorMsg = Label.IMH_PreventDeletionIncentive;                               
                }else if((!'Concept - Design'.equalsIgnoreCase(sobj.Stage__c) && !'iMH Banking Partner'.equalsIgnoreCase(profileName)) || ((!'Creative - Design'.equalsIgnoreCase(sobj.Stage__c)) && 'iMH Banking Partner'.equalsIgnoreCase(profileName))){
                    //System.debug('***ABC '+sobj.Stage__c+'$$$$PQR  '+profileName);
                    throwError  = true;
                    if('iMH Banking Partner'.equalsIgnoreCase(profileName)){
                        if( IMH_UtilityConstants.TARGETEDCOMMPRODUCT_OBJECT_API.equalsIgnoreCase(sObjName)){
                            addErrorMsg = Label.IMH_PreventDeletionOfTargetedProduct_BP;
                        }
                            
                        else{
                            addErrorMsg =Label.IMH_PreventDeletionOfTargetedChannel_BP ;
                            
                        }
                    }
                    else{
                       addErrorMsg = errMsg;
                    }
                }
                if(throwError){
                    for(Id triggerObjId : communicationsObjIdMap.get(sObj.Id)){
                        mtriggerOld.get(triggerObjId).addError(addErrorMsg);
                    }
                }                                           
        }
    }
     /*****************************************************************************
    * @description -  This method is called to create the chatter groups from the public groups present in the system
    * @param - None
    * @return - void
    */ 
    public static void createChatterGroups(String OwnerIDvalue){
        List<CollaborationGroup> lColbrationGroup = new List<CollaborationGroup>();
        SET<String> setexistingcollabrationgrp = new SET<String>();
        List<Group> lgrouprecords = new List<Group>();
        
        if(!Test.isRunningTest())
        {
            lgrouprecords = [SELECT Id, Name, DeveloperName, Type FROM Group WHERE  Type = 'Regular'
                                   AND DeveloperName LIKE 'IMH%'];
        }
       else{
             lgrouprecords = [SELECT Id, Name, DeveloperName, Type FROM Group WHERE  Type =: 'Regular'
                                   AND DeveloperName LIKE 'IMH_TestClassDummy%'];
        }
        
        Integer maxLimitCount = [SELECT Id from CollaborationGroupMember WHERE MemberId =:OwnerIDvalue].size();
        //Getting the Set of All the Existing Collabration Groups
        for (CollaborationGroup colabgrp: [Select Id,OwnerId,Name From 
                                            CollaborationGroup]){
                setexistingcollabrationgrp.add(colabgrp.Name);
        }
        Integer i =0;
        //Adding the Collabration Group to IMH if it is still not existing
        for(Group approvalGroup : lgrouprecords){
            if(maxLimitCount<300){
               if(!setexistingcollabrationgrp.contains(approvalGroup.Name)){  
                    i++;
                    CollaborationGroup colbgrp;  
                    colbgrp = new CollaborationGroup();
                    colbgrp.Name = approvalGroup.Name;
                    colbgrp.CollaborationType = 'Private';
                    colbgrp.IsAutoArchiveDisabled  = true;
                    colbgrp.OwnerID = OwnerIDvalue;
                    lColbrationGroup.add(colbgrp);
                    maxLimitCount++;
                } 
            }else{
                break;
            }
            
        }
        
        if(!lColbrationGroup.isEmpty()){
             System.debug('****Test 4'); 
            //System.debug('****Final '+lColbrationGroup);
            database.insert(lColbrationGroup,true);
        }
    }
    /*****************************************************************************
    * @description -  This method is called to add the chatter group members from the corresponding public group members
    * @param - None
    * @return - void
    */ 
    public static void addChatterGroupMembers(){
        Map<String,String>mgroupmember = new Map<String,String>();
        SET<Id> setGroups = new SET<Id>();
        List<CollaborationGroupMember> lchattermembers = new List<CollaborationGroupMember>();
        Integer i=0,j=0;
        Map<Id,Id> mGroupCollabGroupMember = new  Map<Id,Id>();
        Map<Id,List<Id>> mCollabGroupnCollabMenber = new Map<Id,List<Id>>();
        Map<Id,Group> mgroupGroupMap = new Map<Id,Group>();
        //Map of user and their active/inactive status
        Map<Id,User> minactiveUsers = new Map<Id,User>([SELECT Id,isActive FROM User Where Market__c != NULL and IsActive=TRUE AND  SYS_FromCloneUserId__c =NULL]);
        List<Group> lgrouprecords;
        if(!Test.isRunningTest()){
            lgrouprecords = [SELECT Id, 
                                    Name,
                                    DeveloperName,
                                    Type,
                                    (SELECT UserOrGroupId, 
                                            GroupId, 
                                            Id 
                                     FROM GroupMembers
                                    WHERE UserOrGroupId IN:minactiveUsers.keySet())             
                             FROM Group WHERE  Type =: REGULARGROUPTYPE
                             AND DeveloperName LIKE 'IMH%'];
        }
        else{
             lgrouprecords = [SELECT Id, 
                                      Name, 
                                     DeveloperName, 
                                    Type,
                                   (SELECT UserOrGroupId, 
                                            GroupId, 
                                            Id 
                                     FROM GroupMembers
                                     WHERE UserOrGroupId IN:minactiveUsers.keySet())
                              FROM Group WHERE  Type =: REGULARGROUPTYPE
                                   AND DeveloperName LIKE 'IMH_TestClassDummy%'];
        }
        /*for(Group approvalGroup : lgrouprecords){
                                       setGroups.add(approvalGroup.Id);                      
       }*/
        //Map of Public Group and members associated to it
       for(Group gm:lgrouprecords){
                                /*if(mgroupmember.containsKey(gm.ID)){
                                    List<Id> lgmlist = mgroupmember.get(gm.I);
                                    if(gm.UserOrGroupID.getsObjectType() == Schema.User.sObjectType 
                                            && minactiveUsers.containsKey(gm.UserOrGroupId)){
                                       lgmlist.add(gm.UserOrGroupId);
                                    }
                                    mgroupmember.put(gm.GroupId,lgmlist);
                                    
                                }
                                else{
                                    if(gm.UserOrGroupID.getsObjectType() == Schema.User.sObjectType 
                                                && minactiveUsers.containsKey(gm.UserOrGroupId)){
                                        mgroupmember.put(gm.GroupId,new List<Id>{gm.UserOrGroupId});
                                    }
                                } */
                               mgroupmember.put(gm.Name,gm.Id);
                            }
        System.debug(mgroupmember);
        /*List<Group> lapprovalGroupId = [SELECT Id, Name, DeveloperName, Type FROM Group WHERE  Type =: REGULARGROUPTYPE
                                        AND DeveloperName LIKE 'IMH%'];*/
         //Creating a map of Public Group and Collabration Group Present in IMH
        for(CollaborationGroup grp:[Select Id,Name From 
                                    CollaborationGroup]){
                                       // for(Group pgrp:lgrouprecords){
                                            if(mgroupmember.containsKey(grp.Name)){
                                                mGroupCollabGroupMember.put(mgroupmember.get(grp.Name),grp.Id);
                                            }
                                       // }               
                                    }
        //System.debug('****PPO '+mGroupCollabGroupMember);
        //Creating a map of Collabration Group and Members in it
        for(CollaborationGroupMember colabmember:[SELECT Id
                                                         ,CollaborationGroupId
                                                         ,MemberId
                                                  FROM CollaborationGroupMember]){
                           if(mCollabGroupnCollabMenber.containsKey(colabmember.CollaborationGroupId)){
                                    List<Id> lnewmembers =  mCollabGroupnCollabMenber.get(colabmember.CollaborationGroupId);
                                    lnewmembers.add(colabmember.MemberId);
                                    mCollabGroupnCollabMenber.put(colabmember.CollaborationGroupId,lnewmembers); 
                            }
                          else{
                              mCollabGroupnCollabMenber.put(colabmember.CollaborationGroupId,new List<Id>{colabmember.MemberId});                            
                          }       
                           // mCollabGroupnCollabMenber.put(colabmember.Id,colabmember.GroupMembers);                         
           }
        //System.debug('****PPO 2 '+mCollabGroupnCollabMenber);
        //Insertion of Chatter Group Members
       CollaborationGroupMember colabgroup;
        Set<ID> setIds;
        for(Group grp:lgrouprecords){
            //CollaborationGroupMember colabgroup;
            i++;
            setIds = new Set<ID>();
            //System.debug('ALMAMATER  '+ mCollabGroupnCollabMenber.get(mGroupCollabGroupMember.get(grpIds)) + 'ALPHA '+mGroupCollabGroupMember.get(grpIds)+'KKO '+grpIds);
            if(!mCollabGroupnCollabMenber.isEmpty() && mCollabGroupnCollabMenber.get(mGroupCollabGroupMember.get(grp.Id)) != NULL)
                {
                    setIds.addAll(mCollabGroupnCollabMenber.get(mGroupCollabGroupMember.get(grp.Id)));
                }
            for(GroupMember grpmember:grp.GroupMembers){
                j++;
                
                if(!setIds.contains(grpmember.UserOrGroupId))
                {
                       colabgroup = new CollaborationGroupMember();
                       colabgroup.MemberId = grpmember.UserOrGroupId;
                       colabgroup.CollaborationGroupId = mGroupCollabGroupMember.get(grpmember.GroupId);
                       lchattermembers.add(colabgroup);
                }
           }
        } 
        if(!lchattermembers.isEmpty()){
             IMH_GeneralApplicationUility.isAvoidEntryinTrigger = true;
             Database.insert(lchattermembers,true);
           /* for(Database.SaveResult sr:drresult){
                if(!sr.isSuccess()){
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('** 1 '+err.getMessage()+'  ***2  '+sr);
                    }
                }
            }*/
        }
       
    } 
}