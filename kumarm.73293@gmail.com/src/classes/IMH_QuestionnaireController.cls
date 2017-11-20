/**
* @author Accenture IDC 
* @date 05/26/2015
* @group QuestionSet
* @group-content Questionnaire Page
* @description - iMH Release 1 (Sprint 1) Controller for Questionnaire page where list of questions are displayed to the user
*/
public without sharing class IMH_QuestionnaireController{
   //Varibales used for Attachment functionality
    public String IdChoosen{get; set;}
    public Boolean flip {get;set;}
    public Attachment attachmentObj {get;set;}
    public Map<ID,Attachment> mattachment{get;set;}
    public Map<Id,IMH_Answer__c> mAnswers {get;set;}
    List<sObject> lupdateAttachment;
    public IMH_QuestionnaireWrapperEDIT qWrapper{get;set;}
    private Map<Id,Integer> mIndexById = new Map<Id,Integer>();
    public Map<Id,String> mAnswerByQuesId {get;set;}
    private Map<String,String> mtranslationByErrorMessage = new Map<String,String>();
    private String questionsetId = IMH_UtilityConstants.EMPTY_STRING;
    private User currentUser = null;
    public String returnURL {get;set;}
    public String pageMode {get;set;}
    public IMH_QuestionSet__c questionset {get;set;}
    public String changedQuestionId {get;set;}
    public Integer percentCompletion {get;set;}
    public Integer totalQuestions {get;set;}
    public Integer totalInProgressQuestions {get;set;}
    public  IMH_AnswerSet__c ansset {get;set;}
    Private String cssClassName = IMH_UtilityConstants.EMPTY_STRING;
    public Boolean systemError{get;set;}
    public Boolean warningError{get;set;}
    public Boolean warningRaised{get;set;}
    public Boolean dmlSucess{get;set;}
    public Boolean showUploadSection{get;set;}
    public Map<Id,IMH_QuestionSet__c> mQuestionSets{get;set;}
    public set<Id> answerIds{get;set;}
    public Map<Integer,String> sortedQuestionSet {get;set;}
    private String errorMessage;
    private Boolean isReviewer = false; 
    private Boolean isSubmitterRole = false;
    private Boolean isSystemAdmin = false;
    private Boolean isReviewerRoleType = false;
    private Boolean isCompliance = false;
    private String pageParamPageMode  = '';
    public List <IMH_QuestionWarning__c> lquestwarn;
    public Map<Id,Boolean> mvalidwarning;
    public Map<String,String> mLabelNameBYObjectAPIName;
    public List<Attachment> lattachment {get
        {lattachment = [SELECT id,Name,Description 
                            FROM Attachment
                         WHERE ParentID =:qWrapper.answerSetId
                         LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
        return lattachment;}set;}
    
    // FINAL STATIC STRING USED ONLY IN THIS CONTROLLER CLASS 
    private static final String QID = 'QId';
    private static final String RET_URL = 'retUrl';
    private static final String PAGE_MODE = 'pageMode';
    private static final String PAGE_PARAM_ONCHANGE = 'selectedQID';
    private static final String CSS_CLASSNAME_TREE_GRID = 'treegrid-';
    private static final String CSS_CLASSNAME_TREE_GRID_PARENT = 'treegrid-parent-';
    private static final String PAGE_MODE_VALUE_VIEW = 'View';
    private static final String NOT_APPLICABLE = 'N/A';
    private static Final String BUTTON_CALL = 'buttonCall';
    private static Final String EXIT_STATUS = 'Exit';
    private static Final String TAB_SPACE = '    ';
    private static Final String VIEW_STATE = 'view';
    private static Final String EMPTY_STRING = '';
    private static Final String SPACE_COLON = ' : ';
    private static Final String QUERY_STRING_WHERE_CLAUSE = ' WHERE Id = \'';
    private static Final String ESCAPE_CHARACTER =  '\'';
    private static Final String PAGE_PARAM_ATTACH_TO_DEL = 'contIdParam';
    private static Final String NO_COMMENTS = 'No Comments';
    private static Final String PAGE_PARAM_SELECTEDQID  = 'selectedQuestionSetId';
    private static Final String SYSTEM_ADMIN  = 'System Administrator';
    private static final String OWNERID       = 'OwnerId';
    private static final String JAPANMARKET   = 'Japan';
    
    
    /**
    * @description  - Non Parameterized Constructor where Page paramters are fectched and Quesion List are retrived
    * @param  - None
    * @return  - N/A
    */ 
    public IMH_QuestionnaireController(){
        attachmentObj = new Attachment();
        mAnswerByQuesId = new Map<Id,String>();
        qWrapper = new IMH_QuestionnaireWrapperEDIT();
        systemError = false;
        warningError = false;
        warningRaised = false;
        dmlSucess = false;
        flip = false;
        mQuestionSets = new Map<Id,IMH_QuestionSet__c>();
        mattachment = new Map<ID,Attachment>();
        lupdateAttachment = new List<sObject>();
        answerIds = new Set<Id>();
        lquestwarn = new List<IMH_QuestionWarning__c>();
        mvalidwarning = new Map<Id,Boolean>();
        sortedQuestionSet = new Map<Integer,String>();
        errorMessage= IMH_UtilityConstants.EMPTY_STRING;
        mLabelNameBYObjectAPIName = new Map<String,String>();
        Set<String> roleofCurrentUser= new Set<String>();
        try{
            // GET PAGE PARAMETERS FOR RETREVING THE QUESTIONS RELATED
            //GET THE ANSWER ID PASSED FROM URL PARAMETER
            qWrapper.answerSetId = ApexPages.currentPage().getParameters().get(IMH_UtilityConstants.ID)!=null?
                ApexPages.currentPage().getParameters().get(IMH_UtilityConstants.ID):IMH_UtilityConstants.EMPTY_STRING;
            //GET THE QUESTIONSETID PASSED FROM URL PARAMETER
            questionsetId = ApexPages.currentPage().getParameters().get(QID)!=null?
                ApexPages.currentPage().getParameters().get(QID):IMH_UtilityConstants.EMPTY_STRING;
            //GET THE RETURN URL PASSED FROM URL PARAMETER
            returnURL = IMH_UtilityConstants.FORWARD_SLASH + ApexPages.currentPage().getParameters().get(RET_URL)!=null?
                ApexPages.currentPage().getParameters().get(RET_URL):IMH_UtilityConstants.EMPTY_STRING;
            //GET THE PAGE MODE PASSED FROM URL PARAMETER
            pageMode = ApexPages.currentPage().getParameters().get(PAGE_MODE)!=null?
                ApexPages.currentPage().getParameters().get(PAGE_MODE):IMH_UtilityConstants.EMPTY_STRING;
            pageParamPageMode = pageMode;
            currentUser = [SELECT Id,Name,Profile.Name,SYS_IMHHROLE__c,IMH_UserRoleTypeNew__c FROM User WHERE Id = :UserInfo.getUserId()  
                                                    LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
            System.debug('Curenmt User>: '+currentUser);           
            isReviewerRoleType = currentUser.SYS_IMHHROLE__c;
             if(SYSTEM_ADMIN.eqUalsIgnoreCase(currentUser.Profile.Name) || 'iMH Business Admin'.equalsIgnoreCase(currentUser.Profile.Name)){
               isSystemAdmin = true;
            }
           
            if(String.isBlank(qWrapper.answerSetId)){
                errorMessage = Label.IMH_SessionExpired;
                systemError = true;
            }
        }
        catch(Exception exp){
            
            errorMessage = Label.IMH_SystemError + exp.getMessage();
            systemError = true;
        }
        if(systemError){
           // ADD ERROR MESSAGE TO THE USER IF ANY EXCEPTION HAVE OCCURED
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,
                        errorMessage)); 
        }
        
    }
    
    /**
    * @description  - Action method on Questionnaire page to create answer records on load of the page and also constructs the wrapper structure to display the question blocks
    * @param  - None
    * @return  - Void
    */ 
    public void createAnswersOnLoad() {
        Map<String, Schema.SObjectType> mSobjectTypeByName = new  Map<String, Schema.SObjectType>();
        Map<String,Map<String, Schema.SObjectField>> fieldMapByObjectName = new Map<String,Map<String, Schema.SObjectField>>();
        mSobjectTypeByName = Schema.getGlobalDescribe();
        
        fieldMapByObjectName.put(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,IMH_GeneralApplicationUility.constructFieldMap(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,mSobjectTypeByName));
        fieldMapByObjectName.put(IMH_UtilityConstants.BENEFIT_API,IMH_GeneralApplicationUility.constructFieldMap(IMH_UtilityConstants.BENEFIT_API,mSobjectTypeByName));
        
        // INITIALIZE ALL LOCAL VARIABLES
        Map<Id,IMH_Question__c> mQuestions = new Map<Id,IMH_Question__c>();
        Map<String,IMH_Translation__c> mTranslationByQWarningId = new Map<String,IMH_Translation__c>();
        Map<String,String> mTranslationByResponseId = new Map<String,String>();
        //Question Set Translation
        
        String marketAPIName = 'TargetMarket__c';
        
        Map<Id,IMH_AnswerWarning__c> mAnswerWarningByQWarningId = new Map<Id,IMH_AnswerWarning__c>();
        Schema.SObjectType token = Id.valueOf(returnURL).getSObjectType();
        String sObjectType = token.getDescribe().getName();
        IMH_AnswerWarning__c ansWarning = null;
        Map<String,String> tempmTranslationByResponseId = new Map<String,String>();
        Set<Id> targetObjectId = new Set<Id>();
        IMH_QuestionnaireWrapperEDIT.QuestionWrapper quesWrapper = null; 
        IMH_QuestionnaireWrapperEDIT.ArchivedAnswerSet ansSetWrapper = null; 
        Map<Id,ProcessInstanceHistory> mProcessInstanceByAnswerWarningId = new Map<Id,ProcessInstanceHistory>();
        showUploadSection = true;
        if(IMH_UtilityConstants.BENEFIT_API.equalsIgnoreCase(sObjectType)){
            marketAPIName = 'Market__c';
        }
        String sObjectQueryString = IMH_GeneralApplicationUility.fetchAllFields(sObjectType,IMH_UtilityConstants.EMPTY_STRING);
        Boolean validQuestionSet = false;
        Boolean validQuestWarn = false;
        String parentId = IMH_UtilityConstants.EMPTY_STRING;
        
        Map<Id,sObject> mParentSObject = new Map<Id,sObject>();
        
        Set<String> objectList = new Set<String>{IMH_UtilityConstants.COMMUNICATION_LABELNAME};
         if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(sObjectType)){
            objectList = new Set<String>{IMH_UtilityConstants.COMMUNICATION_LABELNAME,IMH_UtilityConstants.INCENTIVE_LABELNAME
                                                    ,IMH_UtilityConstants.PREAPPROVEDBENEFITS_LABELNAME,IMH_UtilityConstants.CREATIVE};
        }
        
        //CONSTRUCT THE MAP WITH LABEL NAMES AND API NAMES - LATER I CAN BE REPLACE WITH CUSTOM SETTINGS
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,IMH_UtilityConstants.COMMUNICATION_LABELNAME);
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.INCENTIVE_OBJECT_API,IMH_UtilityConstants.INCENTIVE_LABELNAME);
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API,IMH_UtilityConstants.CREATIVE);
        mLabelNameBYObjectAPIName.PUT(IMH_UtilityConstants.BENEFIT_API,IMH_UtilityConstants.BENEFITS_ENTRY_LABEL);
        
        
        sObject sObjRecord = Database.query(sObjectQueryString + QUERY_STRING_WHERE_CLAUSE + returnURL + ESCAPE_CHARACTER);
        String recordOwnerId = String.valueOf(sObjRecord.get(OWNERID));
        // GET QUESTION SET DETAILS FROM THE PAGE PARAMETER ID
        // QUERY THE ANSWER SET OBJECT USING THE PAGE PARAMTER
        
        if(String.isNotBlank(qWrapper.answerSetId)){
            ansset = [Select Id,OwnerId,Versionused__c,QuestionnaireName_UserLang__c,QuestionnaireDescription_UserLang__c,QuestionSet__c,QuestionnaireName__c,QuestionnaireDescription__c
                                    , CompletionPercentage__c
                                   , (SELECT Id,Question__c,Status__c FROM Answers__r WHERE ArchivedSection__c = NULL)
                                    FROM IMH_AnswerSet__c 
                                    WHERE ID =:qWrapper.answerSetId
                                    LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
            
            questionset = [SELECT Id,Description__c,RecordType.DeveloperName,Name, ActionBy__c,(SELECT Id
                                                                                     ,QuestionSetName__c
                                                                                     ,QuestionSetDescription__c
                                                                                     ,QuestionSet__c
                                                                                     FROM Translations__r
                                                                                     WHERE Language_IMH__r.Language_Code__c = : Userinfo.getLanguage()) FROM IMH_QuestionSet__c 
                                                 WHERE Id = : ansset.QuestionSet__c
                                                LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
            mQuestionSets.put(questionset.Id,questionset);
            if(!questionset.Translations__r.isEmpty()){
                ansset.QuestionnaireName_UserLang__c = ansset.QuestionnaireName_UserLang__c!=NULL?ansset.QuestionnaireName_UserLang__c:questionset.Translations__r.get(0).QuestionSetName__c;
                ansset.QuestionnaireDescription_UserLang__c = ansset.QuestionnaireDescription_UserLang__c!=NULL?ansset.QuestionnaireDescription_UserLang__c:questionset.Translations__r.get(0).QuestionSetDescription__c;
            }
            
            ansSetWrapper = new IMH_QuestionnaireWrapperEDIT.ArchivedAnswerSet(); 
            ansSetWrapper.answerSetDescription = ('en_US'.equalsIgnoreCase(Userinfo.getLanguage()) || ansset.QuestionnaireDescription_UserLang__c == NULL)?ansset.QuestionnaireDescription__c:(ansset.QuestionnaireDescription_UserLang__c);
            ansSetWrapper.answerSetName = ('en_US'.equalsIgnoreCase(Userinfo.getLanguage()) || ansset.QuestionnaireName_UserLang__c == NULL)?ansset.QuestionnaireName__c:(ansset.QuestionnaireName_UserLang__c);            
            ansSetWrapper.isParent = true;
            qWrapper.mArchivedSectionWrapper.put(ansset.Id,ansSetWrapper);
            if(!ansset.answers__r.isEmpty()){
                sortedQuestionSet.put(1,ansset.Id);
            }
        }
       	update ansset;
		Set<String> setRoletype = new Set<String>();
        if(currentUser.IMH_UserRoleTypeNew__c == NULL){
            currentUser.IMH_UserRoleTypeNew__c = 'Submitter';
        }
        setRoletype.addAll(currentUser.IMH_UserRoleTypeNew__c.split(';'));
        if(!isSystemAdmin 
           		&& (recordOwnerId != UserInfo.getUserId() 
             		&& 'Submitter'.equalsIgnorecase(questionset.ActionBy__c)
           			&& (IMH_UtilityConstants.BENEFIT_API.equalsIgnoreCase(sObjectType)
                        || !JAPANMARKET.equalsIgnoreCase(String.valueOf(sObjRecord.get(marketAPIName)))))
          	|| !setroletype.contains(questionset.ActionBy__c)){
            isReviewer = true;
        }
                                
        // SET PAGE MODE TO VIEW FOR REVIWER PROFILE
        if(!VIEW_STATE.equalsIgnoreCase(pageMode) 
           							&& isReviewer ){
               pageMode = VIEW_STATE;
        }      
        System.debug('***DEBUG 5 '+pageMode);
        List<IMH_ArchivedSection__c> lArchivedSectionToInsert =  new List<IMH_ArchivedSection__c>();
        Map<Id,IMH_ArchivedSection__c> archivedSectionByQuestionSetId = new Map<Id,IMH_ArchivedSection__c>();
        IMH_ArchivedSection__c tempArchivedSection = new IMH_ArchivedSection__c();
        Set<Id> archivedAnswerSetIds = new Set<Id>();
        if(ansset!=null){
            Object valueToCheck  = null;
            if(!VIEW_STATE.equalsIgnoreCase(pageParamPageMode)){
                for(IMH_QuestionSet__c childSet : [SELECT Id , OrderSequence__c, (SELECT Id,Name,SectionDescription__c,Sequence__c FROM ArchivedSections__r 
                                                           WHERE ArchivedQuestionnaire__c = : ansset.Id),(SELECT Id,Object__c,Field__c,Equals__c FROM EntryCriterias__r 
                                                           WHERE Object__c = : mLabelNameBYObjectAPIName.get(sObjectType)
                                                           OR Object__c IN :objectList
                                                           LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows()))
                                               ,Name , Description__c,RecordType.DeveloperName,ParentQuestionSet__c,Active__c
                                               ,(SELECT Id
                                                 ,QuestionSetName__c
                                                 ,QuestionSetDescription__c
                                                 ,QuestionSet__c
                                                 FROM Translations__r
                                                 WHERE Language_IMH__r.Language_Code__c = : Userinfo.getLanguage())
                                               FROM IMH_QuestionSet__c
                                               WHERE RecordType.DeveloperName = : IMH_UtilityConstants.QUESTIONSET_CHILD_RT_DEVNAME 
                                               AND Active__c = TRUE
                                               AND ParentQuestionSet__c = : ansset.QuestionSet__c LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
                                                   // TO IGNORE THE ENTRY CRITERIA IF PAGE MODE IS VIEW ORIGINALLY FROM PAGE PARAM
                                                   validQuestionSet  = FALSE;
                                                   validQuestionSet = IMH_GeneralApplicationUility.checkEntryCriteria(childSet,mParentSObject, sObjectType,sObjRecord,fieldMapByObjectName,validQuestionSet);
                                                   if(validQuestionSet){
                                                       mQuestionSets.put(childSet.Id,childSet);
                                                       if(childSet.ArchivedSections__r.isEmpty()){
                                                          if('Child'.equalsIgnoreCase(childSet.RecordType.DeveloperName)){
															   tempArchivedSection = new IMH_ArchivedSection__c();
															   if(!childSet.Translations__r.isEmpty()){
																	tempArchivedSection.SectionDescription_UserLang__c = childSet.Translations__r.get(0).QuestionSetDescription__c;
																	tempArchivedSection.SectionName_UserLang__c =  childSet.Translations__r.get(0).QuestionSetName__c;
															   }   
															   tempArchivedSection.Name = childSet.Name;
															   tempArchivedSection.SectionDescription__c = childSet.Description__c;
															   tempArchivedSection.Sequence__c = childSet.OrderSequence__c;
															   tempArchivedSection.QuestionSet__c = childSet.Id;
															   tempArchivedSection.ArchivedQuestionnaire__c = ansset.Id;
															   archivedSectionByQuestionSetId.put(childSet.Id,tempArchivedSection);   
															   lArchivedSectionToInsert.add(tempArchivedSection);
                                                          }
                                                       }
                                                       else{
															archivedSectionByQuestionSetId.put(childSet.Id,childSet.ArchivedSections__r.get(0));
                                                            archivedAnswerSetIds.add(childSet.ArchivedSections__r.get(0).Id);
                                                        }
                                                   }                                  
                                               }
                                insert lArchivedSectionToInsert;
                }
            
                } 
            
            for(IMH_ResponseValue__c resp:[SELECT ResponseValue__c,Text__c,(SELECT Id
                                                                            ,Translation__c
                                                                            ,QuestionWarning__c
                                                                            ,ResponseValue__c 
                                                                            FROM Translations__r
                                                                            WHERE Language_IMH__r.Language_Code__c = : Userinfo.getLanguage()) 
                                          FROM IMH_ResponseValue__c
                                          WHERE Question__c = NULL 
                                          LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
                if(!resp.Translations__r.isEmpty()){
                    mtranslationByErrorMessage.put(resp.ResponseValue__c,resp.Translations__r.get(0).Translation__c);                         
                } 
                else{
                    mtranslationByErrorMessage.put(resp.ResponseValue__c,resp.Text__c); 
                }                                    
            }
            for(IMH_Translation__c tran : [SELECT Id, Translation__c,QuestionWarning__c,ResponseValue__c,ResponseValue__r.Text__c,
                                                                                            ResponseValue__r.ResponseValue__c FROM IMH_Translation__c 
                                                                            WHERE Language_IMH__r.Language_Code__c = : Userinfo.getLanguage()
                                                                            LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
                if(tran.ResponseValue__c!=null){
                    mTranslationByResponseId.put(tran.ResponseValue__c, tran.Translation__c);
                    if(tran.ResponseValue__r.Text__c!=NULL){
                    	mTranslationByResponseId.put(tran.ResponseValue__r.Text__c,tran.Translation__c);
                	}
                    if(tran.ResponseValue__r.ResponseValue__c!=NULL){
                    	mTranslationByResponseId.put(tran.ResponseValue__r.ResponseValue__c,tran.Translation__c);
                	} 
                }
                                                                              
            }
        mTranslationByResponseId.put(IMH_UtilityConstants.YES,Label.IMH_Yes);
        mTranslationByResponseId.put(IMH_UtilityConstants.NO, Label.IMH_No);
        mTranslationByResponseId.put(NOT_APPLICABLE, Label.IMH_NA);                
        if(!VIEW_STATE.equalsIgnoreCase(pageParamPageMode)){
            // QUERY TO FETCH QUESTION LIST AGAINST THE QUESTION SET USING THE ID PASSED FROM PAGE PARAMETER AND ALSO THE RESPONS
                mQuestions = new Map<Id,IMH_Question__c>([SELECT Id ,QuestionSet__c,QuestionSet__r.RecordType.DeveloperName,
                                                      (SELECT Id,Translation__c FROM Translations__r WHERE Language_IMH__r.Language_Code__c = : Userinfo.getLanguage()),(SELECT Id
                                                                  , Detail__c
                                                                  , EntryCriteria__c
                                                                  , Flag__c
                                                                  , SYSFlagIcon__c
                                                                  , ResponseValue__c                                                                                                            
                                                                  , Question__c
                                                                  , Question__r.Question__c FROM QuestionWarnings__r WHERE Active__c = TRUE ORDER BY OrderSequence__c
                                                                    LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows()))
                                   , (SELECT Id, Status__c ,Question__r.RecordType.DeveloperName, Answer__c FROM Answers__r 
                                      WHERE Answerset__c = :qWrapper.answerSetId 
                                        LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows()))
                                   , RecordType.DeveloperName
                                   , (SELECT Id , Text__c , OrderSequence__c FROM ResponseValues__r ORDER BY OrderSequence__c LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows()))                   
                                   , DependentQuestion__r.DependentQuestion__c
                                   , DependentQuestion__r.DependentQuestionEntryCriteria__c
                                   , DependentQuestionEntryCriteria__c
                                   , OrderSequence__c
                                   , DependentQuestion__c
                                   , Question__c FROM IMH_Question__c 
                            WHERE Active__c = TRUE
                            AND QuestionSet__c IN :mQuestionSets.keySet() ORDER BY QuestionSet__r.ParentQuestionSet__c NULLS LAST , 
                                                      QuestionSet__r.OrderSequence__c DESC,DependentQuestion__c NULLS FIRST , OrderSequence__c DESC 
                             LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]);
        List<IMH_Answer__c> lAnswerToInsert = new List<IMH_Answer__c>();
        List<IMH_Answer__c> lAnswerToUpdate = new List<IMH_Answer__c>();
        Map<Id,IMH_Answer__c> mapAnsByQuestionId = new Map<Id,IMH_Answer__c>();
        IMH_Answer__c ansObj = new IMH_Answer__c();
        for(IMH_Question__c ques : mQuestions.values()){
            if(ques.Answers__r.isEmpty()){
                ansObj = new IMH_Answer__c();
                ansObj.Question__c = ques.Id; 
                ansObj.AnswerSet__c= qWrapper.answerSetId;
                if(!ques.Translations__r.isEmpty()){
                    ansObj.QuestionText_UserLang__c = ques.Translations__r.get(0).Translation__c;
                }
                ansObj.QuestionText__c = ques.Question__c;
                ansObj.Sequence__c = ques.OrderSequence__c;
                ansObj.Answer__c = IMH_UtilityConstants.NONE;
                ansObj.Status__c = (ques.DependentQuestion__c == NULL ? 'In Progress': 'Not Required');
                mapAnsByQuestionId.put(ques.Id,ansObj);
                if('Child'.equalsIgnoreCase(ques.QuestionSet__r.RecordType.DeveloperName)){
                   ansObj.ArchivedSection__c =  archivedSectionByQuestionSetId.get(ques.QuestionSet__c).Id;
                }else{
                   sortedQuestionSet.put(1,ansset.Id);
                }
                lAnswerToInsert.add(ansObj); 
            }else{
                ansObj = ques.Answers__r.get(0);
                if(!'Completed'.equalsIgnoreCase(ansObj.Status__c)){
                    ansObj.QuestionText__c = ques.Question__c;
                    lAnswerToInsert.add(ansObj); 
                }
                mapAnsByQuestionId.put(ques.Id,ques.Answers__r.get(0));
            }
            if(!ques.QuestionWarnings__r.isEmpty()){
                lquestwarn.addAll(ques.QuestionWarnings__r);
            } 
           
        }
        upsert lAnswerToInsert;
        for(IMH_Answer__c ans : lAnswerToInsert){
            if(mQuestions.get(ans.Question__c).DependentQuestion__c != NULL){
                ans.DependantArchivedAnswer__c = mapAnsByQuestionId.get((mQuestions.get(ans.Question__c).DependentQuestion__c)).Id;
                ans.DependantEntryCriteria__c = mQuestions.get(ans.Question__c).DependentQuestionEntryCriteria__c;
                lAnswerToUpdate.add(ans);
            }
        } 
        update lAnswerToUpdate;
        List<IMH_AnswerWarning__c> lAnswerWarningToInsert = new List<IMH_AnswerWarning__c>();
        IMH_AnswerWarning__c ansWarningObj = new IMH_AnswerWarning__c();
        for(IMH_QuestionWarning__c qwarn  :[Select Id,Detail__c,Flag__c,EntryCriteria__c,Question__c,OrderSequence__c,ResponseValue__c ,(Select Id
                                                       ,Equals__c
                                                       ,Field__c
                                                       ,Object__c
                                                       ,QuestionWarning__c
                                                       FROM EntryCriterias__r WHERE Object__c = : mLabelNameBYObjectAPIName.get(sObjectType)
                                                           OR Object__c IN :ObjectList),
                                                                (SELECT Id,Translation__c FROM Translations__r WHERE Language_IMH__r.Language_Code__c = : Userinfo.getLanguage()),
                                            (SELECT Id,Detail__c,SYSAttachmentId__c,QuestionWarning__c,Status__c,
                                                ApprovalStatus__c,Comments__c,EntryCriteria__c FROM AnswerWarnings__r
                                            WHERE Answer__r.AnswerSet__c = : qWrapper.answerSetId )
                                            FROM IMH_QuestionWarning__c
                                            WHERE ID IN:lquestwarn LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
            validQuestWarn = true;                                   
            validQuestWarn = IMH_GeneralApplicationUility.checkEntryCriteria(qwarn,mParentSObject, sObjectType,sObjRecord,fieldMapByObjectName,validQuestWarn);
            if(validQuestWarn){
                if(qwarn.AnswerWarnings__r.isEmpty()){
                    ansWarningObj = new IMH_AnswerWarning__c();
                    ansWarningObj.Answer__c = mapAnsByQuestionId.get(qwarn.Question__c).Id;
                    ansWarningObj.Status__c = 'N/A'; 
                    ansWarningObj.QuestionWarning__c = qwarn.Id;
                }else{
                    ansWarningObj = qwarn.AnswerWarnings__r.get(0);
                    ansWarningObj.Status__c = (mapAnsByQuestionId.get(qwarn.Question__c).Answer__c!=ansWarningObj.EntryCriteria__c)?'N/A':ansWarningObj.Status__c;
                }
                if(!qwarn.Translations__r.isEmpty()){
                     ansWarningObj.WarningText_UserLang__c = qwarn.Translations__r.get(0).Translation__c;
                }
                ansWarningObj.Flag__c = qwarn.Flag__c;
                ansWarningObj.Sequence__c = qwarn.OrderSequence__c;
                ansWarningObj.EntryCriteria__c = qwarn.EntryCriteria__c;
                ansWarningObj.WarningText__c = qwarn.Detail__c;
                lAnswerWarningToInsert.add(ansWarningObj);
            }                               
        }
        upsert lAnswerWarningToInsert;
        mAnswers = new Map<Id,IMH_Answer__c>([SELECT Id,AnswerSet__c,Sequence__c,Question__c,QuestionText__c,ArchivedSection__c,QuestionText_UserLang__c,
                                                     Status__c,Answer__c,DependantArchivedAnswer__c,DependantEntryCriteria__c,
                                                     DependantArchivedAnswer__r.Question__c,
                                                     (SELECT Id,Detail__c,FlagIcon__c,Flag__c,SYSAttachmentId__c,
														WarningText_UserLang__c,WarningResponse_UserLang__c,WarningText__c,
														Status__c,EntryCriteria__c,Answer__c,QuestionWarning__c FROM AnswerWarnings__r) FROM IMH_Answer__c
                                                     WHERE (ArchivedSection__c = NULL AND Answerset__c = :ansset.Id) 
                                              OR ArchivedSection__c IN : archivedAnswerSetIds 
                                              OR ArchivedSection__c IN : lArchivedSectionToInsert
                                              ORDER BY ArchivedSection__c  NULLS FIRST , ArchivedSection__r.Sequence__c ASC,
                                              DependantArchivedAnswer__c NULLS LAST , Sequence__c ASC]);
            
        }else{
            mAnswers = new Map<Id,IMH_Answer__c>([SELECT Id,AnswerSet__c,Sequence__c,Question__c,QuestionText__c,QuestionText_UserLang__c,
                                                                  ArchivedSection__c,Status__c,Answer__c,DependantArchivedAnswer__c,DependantEntryCriteria__c,
                                                                                DependantArchivedAnswer__r.Question__c,ResponseUserLang__c,
                                                                                (SELECT Id,Detail__c,FlagIcon__c,Flag__c,SYSAttachmentId__c,WarningText__c,Status__c,WarningText_UserLang__c,
                                                                                EntryCriteria__c,Answer__c,QuestionWarning__c FROM AnswerWarnings__r) FROM IMH_Answer__c
                                                                                WHERE Answerset__c = :ansset.Id AND Status__c != 'Not Required' ORDER BY ArchivedSection__c  NULLS FIRST , ArchivedSection__r.Sequence__c ASC,
                                                                                DependantArchivedAnswer__c NULLS LAST , Sequence__c ASC]);
        }
                
        system.debug('---->>>>>'+mAnswers.size());
        system.debug('---->>>>>'+lArchivedSectionToInsert.size());
        system.debug('---->>>>>'+archivedAnswerSetIds);
        Map<Id,Id> mQuesIdByAnswerId = new Map<Id,Id>();
        Set<Id> archivedSectionIds = new Set<Id>();
        List<IMH_Answer__c> tempSortedList = new List<IMH_Answer__c>();
        Integer sortIndex = 0;
        Map<Id,Integer> mQuestionIdAndLevel = new Map<Id,Integer>();
        Set<Id> qWarningIds = new Set<Id>();
        for(IMH_Answer__c ans: mAnswers.values()){
            archivedSectionIds.add(ans.ArchivedSection__c);
            if(ans.Question__c!=NULL){
				mQuesIdByAnswerId.put(ans.Id,ans.Question__c);
            }
            for(IMH_AnswerWarning__c ansWarn : ans.AnswerWarnings__r){
                if(ansWarn.QuestionWarning__c!=NULL){
                    qWarningIds.add(ansWarn.QuestionWarning__c);
                }
            }
            if(ans.DependantArchivedAnswer__c == null){
                mQuestionIdAndLevel.put(ans.Id, 1);
                if(sortIndex<1){
                    tempSortedList.add(ans);
                }else{
                    tempSortedList.add(sortIndex,ans);
                }
                sortIndex--;
            }
        }
		List<IMH_Answer__c> finalParentSortedList = new List<IMH_Answer__c>();
		finalParentSortedList.addALL(tempSortedList);
		Integer parentIndex = 1;
        Boolean addChildElement = false;
        for(IMH_Answer__c tempAns  : mAnswers.values()){
            parentIndex = 0;
            addChildElement = false;
            for(IMH_Answer__c sortedList  : finalParentSortedList){
                if(tempAns.DependantArchivedAnswer__c!=null && tempAns.DependantArchivedAnswer__c == sortedList.Id){
                    mQuestionIdAndLevel.put(tempAns.Id,mQuestionIdAndLevel.get(sortedList.Id)+1);
                    addChildElement = true; 
                    break;
                }
                parentIndex++;
            }
            if(addChildElement ){
                if((parentIndex + 1)>=finalParentSortedList.size()){
                    finalParentSortedList.add(tempAns);
                }else{
                    finalParentSortedList.add((parentIndex + 1), tempAns);
                }
           }
        }
        for(IMH_Answer__c sortedList  : finalParentSortedList){
            system.debug('--->>>>>'+sortedList.QuestionText__c +'---->>>' + sortedList.Sequence__c );
        }
        Map<Id,IMH_QuestionWarning__c> mQuestionWarning = new Map<Id,IMH_QuestionWarning__c>();
        for(IMH_QuestionWarning__c qwarn  :[Select Id,ResponseValue__c ,(Select Id
                                                       ,Equals__c
                                                       ,Field__c
                                                       ,Object__c
                                                       ,QuestionWarning__c
                                                       FROM EntryCriterias__r WHERE Object__c = : mLabelNameBYObjectAPIName.get(sObjectType)
                                                           OR Object__c IN :ObjectList) FROM IMH_QuestionWarning__c
                                            WHERE ID IN:qWarningIds LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
                                                mQuestionWarning.put(qWarn.Id,qWarn);                                                
            validQuestWarn = true;                                   
            validQuestWarn = IMH_GeneralApplicationUility.checkEntryCriteria(qwarn,mParentSObject, sObjectType,sObjRecord,fieldMapByObjectName,validQuestWarn);
            mvalidwarning.put(qwarn.ID,validQuestWarn);                                
        }
        
        for(IMH_ArchivedSection__c archSection : [SELECT Id ,Name, SectionDescription__c,SectionDescription_UserLang__c,SectionName_UserLang__c,
                                                      Sequence__c
                                                      FROM IMH_ArchivedSection__c 
                                                      WHERE ID IN : archivedSectionIds ORDER BY Sequence__c ASC ]){
		  ansSetWrapper = new IMH_QuestionnaireWrapperEDIT.ArchivedAnswerSet();
		  ansSetWrapper.answerSetDescription = ('en_US'.equalsIgnoreCase(Userinfo.getLanguage()) || archSection.SectionDescription_UserLang__c == NULL)?archSection.SectionDescription__c:(archSection.SectionDescription_UserLang__c);
		  ansSetWrapper.answerSetName = ('en_US'.equalsIgnoreCase(Userinfo.getLanguage()) || archSection.SectionName_UserLang__c == NULL)?archSection.Name:(archSection.SectionName_UserLang__c);                                                                                                                                                                        
		  ansSetWrapper.isParent = false;
		  qWrapper.mArchivedSectionWrapper.put(archSection.Id,ansSetWrapper);
		  sortedQuestionSet.put(sortedQuestionSet.size()+1,archSection.Id);     
                                                      }
        IMH_Question__c tempQuest = new IMH_Question__c();
        Integer cssLength = 1;
        String keyForAnswer = '';
        for(IMH_Answer__c tempAns : finalParentSortedList){
            tempQuest = new IMH_Question__c();
            if(String.isBlank(tempAns.Answer__c)){
                tempAns.Answer__c = IMH_UtilityConstants.NONE;
            }
            mIndexById.put(tempAns.Id,cssLength);
            if(tempAns.ArchivedSection__c!=NULL){
                if(!qWrapper.mQuestionSetWrapper.containsKey(tempAns.ArchivedSection__c)){
                    keyForAnswer = tempAns.ArchivedSection__c;
                    qWrapper.lQuestionWrapper = new List<IMH_QuestionnaireWrapperEDIT.QuestionWrapper>();
				}
            }else{
				if(!qWrapper.mQuestionSetWrapper.containsKey(tempAns.AnswerSet__c)){
					keyForAnswer = tempAns.AnswerSet__c;
					qWrapper.lQuestionWrapper = new List<IMH_QuestionnaireWrapperEDIT.QuestionWrapper>();
				}
            }
            if(tempAns.Question__c!=NULL
                && mQuestions.containsKey(tempAns.Question__c)){
                tempQuest = mQuestions.get(tempAns.Question__c);
                tempQuest.Question__c = tempAns.QuestionText__c;
            }
            mAnswerByQuesId.put(tempAns.Id,tempAns.Answer__c);
            IMH_Answer__c parentQues = null; 
            // GET THE PARENT OF THE QUESTION
            if(tempAns.DependantArchivedAnswer__c!=null){
                parentQues = (IMH_Answer__c)IMH_Answer__c.SObjectType.newSObject(tempAns.DependantArchivedAnswer__c);
            }
            if(parentQues == null){
                cssClassName = CSS_CLASSNAME_TREE_GRID + cssLength;
            }else{
                cssClassName = CSS_CLASSNAME_TREE_GRID + cssLength + IMH_UtilityConstants.BLANK_SPACE 
                                + CSS_CLASSNAME_TREE_GRID_PARENT + mIndexById.get(tempAns.DependantArchivedAnswer__c);
            }
            // BUILD A WRAPPER WITH THE QUESTIONS RETRIEVED   
            quesWrapper = new IMH_QuestionnaireWrapperEDIT.QuestionWrapper(tempQuest,parentQues,cssLength,cssClassName,
                                                                    null,null,mQuestionIdAndLevel.get(tempAns.Id),tempAns);
            quesWrapper.mTranslationsByRespValues = mTranslationByResponseId;
            qWrapper.lQuestionWrapper.add(quesWrapper);
            cssLength++;
            qWrapper.mQuestionSetWrapper.put(keyForAnswer,qWrapper.lQuestionWrapper);
            for(IMH_AnswerWarning__c aWarning :tempAns.AnswerWarnings__r){
                IMH_QuestionWarning__c qWarning = NULL;
                if(aWarning.QuestionWarning__c == NULL || mvalidwarning.get(aWarning.QuestionWarning__c)){
                    if(aWarning.QuestionWarning__c!=NULL){
                        qWarning = mQuestionWarning.get(aWarning.QuestionWarning__c);
                    }else{
                        qWarning = new IMH_QuestionWarning__c();
                        qWarning.ResponseValue__c = aWarning.Status__c;
                    }
                    
                    // BUILD A WRAPPER WITH THE QUESTIONS RETRIEVED   
                    cssClassName = IMH_UtilityConstants.EMPTY_STRING;
                    cssClassName = CSS_CLASSNAME_TREE_GRID + cssLength + IMH_UtilityConstants.BLANK_SPACE + CSS_CLASSNAME_TREE_GRID_PARENT 
                                                                                                                                                                                                                                                                                                                                                                                                + mIndexById.get(aWarning.Answer__c);
                    
                    parentQues = (IMH_Answer__c)IMH_Answer__c.SObjectType.newSObject(aWarning.Answer__c);
                    quesWrapper = new IMH_QuestionnaireWrapperEDIT.QuestionWrapper(null,parentQues,cssLength,cssClassName,
                                                                               qWarning,aWarning,mQuestionIdAndLevel.get(aWarning.Answer__c)+1,null);
                    quesWrapper.approvalComments = EMPTY_STRING;
                    quesWrapper.mTranslationsByRespValues = mTranslationByResponseId;
                    //DISPLAY COMMENTS FROM ANSWER WARNING -  CHANGE WITH NEW CUSTOM APPROVAL PROCESS CHANGE
                    if(mAnswerWarningByQWarningId.containsKey(qWarning.Id)){
                        quesWrapper.approvalComments = mAnswerWarningByQWarningId.get(qWarning.Id).Comments__c;
                    }
                    
                    qWrapper.lQuestionWrapper.add(quesWrapper);
                    qWrapper.mQuestionSetWrapper.put(keyForAnswer,qWrapper.lQuestionWrapper);
                    cssLength++;   
                }
                
            }
                                }
        mattachment.putall([SELECT Id,Name,Description FROM Attachment WHERE ParentID =:qWrapper.answerSetId 
                        LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]);
        onChangeOfAnswer();
     }
    /**
    * @description  - Method to make the child question answer to Status as 
    * None and also does the percentage calcualtion of question completed
    * @param  - None
    * @return  - PageReference
    */ 
    public PageReference onChangeOfAnswer(){
        qwrapper.visible = false;
        warningError = false;
        
        String correspondingQuestionSetId = IMH_UtilityConstants.EMPTY_STRING;
        try{
        //mAnswerByQuesId = new Map<Id,String>();
        List<String> sChildIds = new List<String>();
        Set<Integer> listIndexToRemove = new Set<Integer>();  
        // GET THE PARAMETER FOR THE QUESTION ID PASSED FROM PAGE WHERE ON CHANGE HAS HAPPENED
        changedQuestionId = ApexPages.currentPage().getParameters().get(PAGE_PARAM_ONCHANGE);
        correspondingQuestionSetId = ApexPages.currentPage().getParameters().get(PAGE_PARAM_SELECTEDQID); 
        sChildIds.add(changedQuestionId);
        Integer i=0;    
        do{
            if(correspondingQuestionSetId!=null){
                for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : qWrapper.mQuestionSetWrapper.get(correspondingQuestionSetId)){
                    i++;
                    // CONSTRUCT A MAP OF QUESTION ID AND ANSWER RELATED TO IT.
                    if(!tempWrap.isWarning){
                        mAnswerByQuesId.put(tempWrap.answer.Id,tempWrap.answer.Answer__c);
                        if((tempWrap.ParentAnswer!= null 
                            &&  sChildIds.get(0)==tempWrap.parentAnswer.Id
                            && tempWrap.answer.DependantEntryCriteria__c != mAnswerByQuesId.get(tempWrap.parentAnswer.Id))){
                                // UPDATE THE ANSWER VALUE TO NONE IF ANSWER OF QUESTION DOESN'T MATCH WITH CRITERIA
                                if(tempWrap.answer.Question__c!=NULL){
                                   tempWrap.answer.Answer__c = IMH_UtilityConstants.NONE;
                                   tempWrap.answer.Status__c = IMH_UtilityConstants.ANS_INPROGRESS; 
                                }else{
                                    tempWrap.notValidToRender = true;
                                }
                                sChildIds.add(tempWrap.answer.Id);
                            }
                    } 
                }
            } 
            sChildIds.remove(0);
        }
        while(sChildIds.size()>0);
        totalQuestions = 0;
        totalInProgressQuestions = 0;
        // ITERATE THROUGH THE QUESTION WRAPPER TO CALCULATE THE PERCENTAGE 
            for(List<IMH_QuestionnaireWrapperEDIT.QuestionWrapper> tempQuestionSetValues : qWrapper.mQuestionSetWrapper.values()){
                for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : tempQuestionSetValues){
                    if(!tempwrap.isWarning){
                        if(!tempWrap.notValidToRender){
                            if( tempWrap.parentAnswer!= null ){
								if(tempWrap.answer.DependantEntryCriteria__c == mAnswerByQuesId.get(tempWrap.parentAnswer.Id)){
									totalQuestions++;
                                //INCREASE THE IN PROGRESS COUNT IF ANSWER IS NONE OR N/A 
									if(IMH_UtilityConstants.NONE.equalsIgnoreCase(tempWrap.answer.Answer__c)){
										   totalInProgressQuestions++;
									 }
								}
                            }
                            else{
                                totalQuestions++;
                                // INCREASE THE IN PROGRESS COUNT FOR GRANT PARENT QUESTIONS
                                if(IMH_UtilityConstants.NONE.equalsIgnoreCase(tempWrap.answer.Answer__c)){
                                    totalInProgressQuestions++;     
                                }
                            }
                        }
                    }
                    else{
                        tempWrap.errorMessage = IMH_UtilityConstants.EMPTY_STRING;
                        if(tempWrap.ansWarning.EntryCriteria__c == mAnswerByQuesId.get(tempWrap.ansWarning.Answer__c) ){
                            totalQuestions++;
                            if(IMH_UtilityConstants.CONFIRM_CHANGES.equalsIgnoreCase(tempWrap.warningResponse)
                               || IMH_UtilityConstants.I_WILL_REVIEW_AND_AMEND.equalsIgnoreCase(tempWrap.warningResponse)){
                                   totalInProgressQuestions++;
                               }
                        }
                    }
                }
            }
        
        // CALCULATE THE COMPLETION PERCENTAGE 
        percentCompletion = (totalQuestions - totalInProgressQuestions)*100;
        percentCompletion  = percentCompletion/totalQuestions;
        }
        catch(Exception exp){
            // ADD ERROR MESSAGE TO THE USER IF ANY EXCEPTION HAVE OCCURED
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.IMH_SystemError));
            systemError = true;
        }
        return null;
    }
    
    /**
    * @description  - Method to perform DML sattements based on the answer provided. This method will be invoked if user clicks OK button on UI
    * @param  - None
    * @return  - PageReference
    */ 
    public PageReference confirmAction(){
        // CREATE PAGE REFERNCE WITH RET URL AS TARGET OBJECT - INCENTIVE/COMMUNICATION
        PageReference pageRef = null;
        try{
            Map<Id,IMH_Answer__c> mAnswerToUpsert = new Map<Id,IMH_Answer__c>();
            Map<String,String> mQeustionIdByQuesWarningId = new Map<String,String>();
            List<IMH_Answer__c> lAnswersToDelete = new List<IMH_Answer__c>();
            List<IMH_AnswerWarning__c> lAnswerWarningsToUpsert = new List<IMH_AnswerWarning__c>();
            Boolean flagError = false;
            List<String>deleteAttachmentIds = new List<String>();
            warningError = false;
            warningRaised =false;
            // ITERATE THROUGH THE WRAPPER LIST TO CHECK IF JUSTIFICATION IS FILLED - IF NOT THROW ERRO MESSAGE
            for(List<IMH_QuestionnaireWrapperEDIT.QuestionWrapper> tempQuestionSetValues : qWrapper.mQuestionSetWrapper.values()){
                for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : tempQuestionSetValues){
                    tempWrap.errorMessage = IMH_UtilityConstants.EMPTY_STRING;
                    if(tempWrap.isWarning 
                   && tempWrap.ansWarning.EntryCriteria__c == mAnswerByQuesId.get(tempWrap.ansWarning.Answer__c) 
                   && (!(IMH_UtilityConstants.CONFIRM_CHANGES.equalsIgnoreCase(tempWrap.warningResponse)
                        || IMH_UtilityConstants.I_WILL_REVIEW_AND_AMEND.equalsIgnoreCase(tempWrap.warningResponse)))
                   && String.isBlank(tempWrap.ansWarning.Detail__c)
                  && !IMH_UtilityConstants.FILE_EVIDENCE_ATTACHMENT.equalsIgnoreCase(tempWrap.warningResponse)){
                       
                       tempWrap.errorMessage = mtranslationByErrorMessage.containsKey(tempWrap.warningResponse)
                                            ?mtranslationByErrorMessage.get(tempWrap.warningResponse):Label.IMH_QuestionWarningErrorMessage;
                       pageRef = null;
                       flagError = true;
                       warningError = true;
                   }
                else if(tempWrap.isWarning
                        && tempWrap.ansWarning.EntryCriteria__c == mAnswerByQuesId.get(tempWrap.ansWarning.Answer__c)
                        && IMH_UtilityConstants.FILE_EVIDENCE_ATTACHMENT.equalsIgnoreCase(tempWrap.warningResponse)
                        && String.isBlank(tempWrap.ansWarning.SYSAttachmentId__c)){
                           tempWrap.errorMessage =  mtranslationByErrorMessage.containsKey(tempWrap.warningResponse)
                               ?mtranslationByErrorMessage.get(tempWrap.warningResponse):Label.IMH_AttachmentOnWarning;
                           pageRef = null;
                           flagError = true;
                           warningError = true;
                       }
                } 
            }
            system.debug('--->>>>>> mQuestionSetWrapper ' + qWrapper.mQuestionSetWrapper);
            List<IMH_Answer__c> lAnswersToUpsert = new List<IMH_Answer__c>();
            // CHECK IF THE PAGE IS NOT IN VIEW MODE
            if(!PAGE_MODE_VALUE_VIEW .equalsIgnoreCase(pageMode) && !flagError && !dmlSucess){
                for(List<IMH_QuestionnaireWrapperEDIT.QuestionWrapper> tempQuestionSetValues : qWrapper.mQuestionSetWrapper.values()){
                    for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : tempQuestionSetValues){
                         if(!tempWrap.isWarning){
                            // UPDATE THE STATUS TO COMPLETED IF ANSWER IS SELECTED/ TO INPROGRESS IF ANSWER IS SELECETD AS NONE
                            if(tempWrap.parentAnswer== null 
                                    || (tempWrap.answer.DependantEntryCriteria__c == mAnswerByQuesId.get(tempWrap.parentAnswer.Id))){
                                    if(!'en_US'.equalsIgnoreCase(Userinfo.getLanguage())){
                                        tempWrap.answer.ResponseUserLang__c = tempWrap.mTranslationsByRespValues.containsKey(tempWrap.answer.Answer__c)
                                            										?tempWrap.mTranslationsByRespValues.get(tempWrap.answer.Answer__c):tempWrap.answer.Answer__c;
                                    }
                                    
									if(!IMH_UtilityConstants.NONE.equalsIgnoreCase(tempWrap.answer.Answer__c)){
										tempWrap.answer.Status__c = IMH_UtilityConstants.ANS_COMPLETED;
										mAnswerToUpsert.put(tempWrap.answer.Id,tempWrap.answer);
									}
									else{
										if(tempWrap.answer.Question__c!=NULL){
											tempWrap.answer.Status__c =  IMH_UtilityConstants.ANS_INPROGRESS;
											mAnswerToUpsert.put(tempWrap.answer.Id,tempWrap.answer);
										}else{
											lAnswersToDelete.add(tempWrap.answer);
										}
									}
                            }
                            else{
                                // IF ANSWER IS UPDATED TO NONE AND DOESN'T MEET THE CRITERIA, MAKE IT N/A AND STATUS TO COMPLETED
                                if(tempWrap.answer.Id!=null 
												&& IMH_UtilityConstants.NONE.equalsIgnoreCase(tempWrap.answer.Answer__c)){
                                       tempWrap.answer.Status__c =  IMH_UtilityConstants.NOT_REQUIRED;
                                       tempWrap.answer.Answer__c =  TAB_SPACE;
                                       tempWrap.answer.ResponseUserLang__c =  TAB_SPACE;             
                                       //lAnswersToUpsert.add(tempWrap.answer);
									   if(tempWrap.answer.Question__C!=NULL){
										  mAnswerToUpsert.put(tempWrap.answer.Id,tempWrap.answer);
									   }else{
										  lAnswersToDelete.add(tempWrap.answer);
									   }
                               }
                            }   
                        }
                    // INSERT WARNING IF ANY - CHECK THE CRITERIA IF IT MATHCES THE PARENT QUESTION ANWER
                        else{
                            if(tempWrap.ansWarning.EntryCriteria__c == mAnswerByQuesId.get(tempWrap.ansWarning.Answer__c)){
                                //tempWrap.ansWarning.QuestionWarning__c = tempWrap.quesWarning.Id;
                                //mQeustionIdByQuesWarningId.put(tempWrap.quesWarning.Id, tempWrap.quesWarning.Question__c);
                                tempWrap.ansWarning.Status__c = tempWrap.warningResponse;
                                // CHECK IF RAISE EXCEPTION /CONFIRM_CHANGES/RESOLVED AND ADD THE SAME TO INSERT/UPDATE
                                if(!(IMH_UtilityConstants.EXCEPTION_RAISED.equalsIgnoreCase(tempWrap.warningResponse)
                                    && IMH_UtilityConstants.EXCEPTION_APPROVED.equalsIgnoreCase(tempWrap.warningResponse))){
                                       lAnswerWarningsToUpsert.add(tempWrap.ansWarning);
                                       warningRaised = IMH_UtilityConstants.RAISE_EXCEPTION.equalsIgnoreCase(tempWrap.warningResponse) 
                                    && !warningRaised?true:warningRaised;
                                   }
                                 if(IMH_UtilityConstants.FILE_EVIDENCE_ATTACHMENT.equalsIgnoreCase(tempWrap.ansWarning.Status__c)
                                   && String.isNotBlank(tempWrap.ansWarning.SYSAttachmentId__c)
                                   && String.isNotBlank(tempWrap.ansWarning.Detail__c)){
                                       Attachment att = (Attachment)Attachment.sObjectType.newSObject(tempWrap.ansWarning.SYSAttachmentId__c);
                                       att.Description = tempWrap.ansWarning.Detail__c;
                                       lupdateAttachment.add(att);
                                   }  
                           }
                           else{
                                // CHCEK IF ANSWER WARNING IS THE SYSTEM ALREADY. IF ANY MODIFY EXISTING RECORDS TO UPDATE
                                if(tempWrap.ansWarning.Id!=null 
                                   && !IMH_UtilityConstants.EXCEPTION_RAISED.equalsIgnoreCase(tempWrap.warningResponse)){
                                       tempWrap.ansWarning.Status__c = NOT_APPLICABLE;
                                       lAnswerWarningsToUpsert.add(tempWrap.ansWarning);
                                   }
                            }
                            if(tempWrap.isWarning
                               && !IMH_UtilityConstants.FILE_EVIDENCE_ATTACHMENT.equalsIgnoreCase(tempWrap.ansWarning.Status__c)
                               && !String.isBlank(tempWrap.ansWarning.SYSAttachmentId__c)){
                                   deleteAttachmentIds.add(tempWrap.ansWarning.SYSAttachmentId__c);
                                   tempWrap.ansWarning.SYSAttachmentId__c = IMH_UtilityConstants.EMPTY_STRING; 
                            }
                        }
                    }  
                }
                lAnswersToUpsert.addAll(mAnswerToUpsert.values());
                for(IMH_Answer__c ansUnwtd : [SELECT Id,Status__c,Question__c,ResponseUserLang__c,Answer__c,(SELECT Id, Flag__c,  Status__c FROM AnswerWarnings__r) FROM IMH_Answer__c 
                                                WHERE Answerset__c = :qWrapper.answerSetId AND Id NOT IN : mAnswers.keySet() 
                                                        LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
                    ansUnwtd.Answer__c = IMH_UtilityConstants.NONE;                                                    
                    ansUnwtd.Status__c =  IMH_UtilityConstants.NOT_REQUIRED;
                    if(ansUnwtd.Question__c!=NULL){
                        lAnswersToUpsert.add(ansUnwtd);
                    }else{
                        lAnswersTODelete.add(ansUnwtd);
                    }                                        
                    
                    for(IMH_AnswerWarning__c ansWarn :ansUnwtd.AnswerWarnings__r ){
                        ansWarn.Status__c = IMH_UtilityConstants.ANS_NA;
                        lAnswerWarningsToUpsert.add(ansWarn);
                    }
                }
                // INSERT/UPDATE ANSWER RECORDS WITH THE ANSWER SELECTED BY CAMPAIGN SUBMITTER
                if(!lAnswersToUpsert.isEmpty()){
                    Database.upsert(lAnswersToUpsert,true);
                    dmlSucess = true;
                }
                if(!deleteAttachmentIds.isEmpty()){
                    List<Attachment> lattach = [SELECT Id FROM Attachment where ID IN:deleteAttachmentIds 
                                                        LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
                    if(!lattach.isEmpty()){
                        Database.delete(lattach,false);
                    }
                }
                
                // INSERT/UPDATE  ANSWER WARNING RECORDS
                if(!lAnswerWarningsToUpsert.isEmpty()){
                    Database.upsert(lAnswerWarningsToUpsert,false);
                }
                // DELETE ANSWER RECORDS
                if(!lAnswersToDelete.isEmpty()){
                    Database.delete(lAnswersToDelete,false);
                }
                if(!lupdateAttachment.isEmpty()){
                    Database.update(lupdateAttachment,false);
                }
                IMH_AnswerSet__c ansSetToUpdate = [SELECT Id,CompletionPercentage__c,Status__c 
                                                   FROM IMH_AnswerSet__c WHERE ID = :ansset.Id 
                                                   LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
                if(ansSetToUpdate.CompletionPercentage__c == 100  && !IMH_UtilityConstants.ANS_SET_COMPLETED.equalsIgnoreCase(ansSetToUpdate.Status__c)){
                     ansSetToUpdate.Status__c = IMH_UtilityConstants.ANS_SET_COMPLETED;
                     Database.update(ansSetToUpdate,false);
                }
            }
        }
        catch(Exception exp){
            // ADD ERROR MESSAGE TO THE USER IF ANY EXCEPTION HAVE OCCURED
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.IMH_SystemError));
            systemError = true;
        }
        return pageRef;
    }
    
    /**
    * @description  - Method to redirect to Target Object where Page has been intiated. This method will be invoked if user clicks EXIT button on UI
    * @param  - None
    * @return  - PageReference
    */
    public PageReference exitAction(){
        String buttonName = ApexPages.currentPage().getParameters().get(BUTTON_CALL);
        PageReference pageRef = null;
        try{
            if(buttonName!=null
                    && EXIT_STATUS.equalsIgnoreCase(buttonName) || !warningError ){
                    pageRef = new PageReference(IMH_UtilityConstants.FORWARD_SLASH + returnURL);
            }
        }
        catch(Exception exp){
            // ADD ERROR MESSAGE TO THE USER IF ANY EXCEPTION HAVE OCCURED
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,
                        Label.IMH_SystemError));
            systemError = true;
        }
        
        return pageRef;
    }
    
    /**
    * @description  - Method to redirect to Target Object where Page has been intiated. This method will be invoked if user clicks EXIT button on UI
    * @param  - None
    * @return  - PageReference
    */
    public PageReference dummyRender(){
        for(List<IMH_QuestionnaireWrapperEDIT.QuestionWrapper> tempQuestionSetValues : qWrapper.mQuestionSetWrapper.values()){
            for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : tempQuestionSetValues){
                tempWrap.errorMessage = NULL;
                warningError = false;         
            }
        }
        mattachment.putall([SELECT Id,Name,Description FROM Attachment WHERE ParentID =:qWrapper.answerSetId 
                                                LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]);
        return null;
    }
        
    /**
    * @description  - Method used to delete the Attachment
    * @param  - None
    * @return  - PageReference
    */ 
    public PageReference delAttachment(){
        try{
            Database.DeleteResult ldeleteresult;  
            IdChoosen = ApexPages.currentPage().getParameters().get(PAGE_PARAM_ATTACH_TO_DEL);  
            Attachment attachmenttoDel = new Attachment(ID = IdChoosen);
            ldeleteresult = Database.delete(AttachmenttoDel,false);
            if(ldeleteresult.isSuccess()){
                List<IMH_AnswerWarning__c> lanswerwarning = new List<IMH_AnswerWarning__c>();
                for(List<IMH_QuestionnaireWrapperEDIT.QuestionWrapper> tempQuestionSetValues : qWrapper.mQuestionSetWrapper.values()){
                    for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : tempQuestionSetValues){
                        if(tempWrap.ansWarning.SYSAttachmentId__c ==  IdChoosen){
                            tempWrap.ansWarning.SYSAttachmentId__c = IMH_UtilityConstants.EMPTY_STRING;
                        }
                    }
                }
            }            
        }
        catch(Exception exp){
            // ADD ERROR MESSAGE TO THE USER IF ANY EXCEPTION HAVE OCCURED
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,
                        Label.IMH_SystemError));
            systemError = true;
        }
        return null;
    }
    
    
}