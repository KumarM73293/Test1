/**
* @author Accenture IDC 
* @date 05/26/2015
* @group QuestionSet
* @group-content Questionnaire
* @description - iMH Release 1 (Sprint 1) HandShake Class for Questionnaire page/Component of Warning.
*/
public with sharing class IMH_QuestionnaireWrapperEDIT{
    private static final String PICKLIST = 'Picklist';
    private static final String NOT_APPLICABLE = 'N/A';
    private static final String RED = 'Red';
    private static final String EXCEPTIONREJECTED = 'Exception Rejected';
    public Boolean visible {get;set;}
    public String answerSetId {get;set;}
    public List<QuestionWrapper> lQuestionWrapper{get;set;}
    public Map<Id,List<QuestionWrapper>> mQuestionSetWrapper{get;set;}
    public Map<Id,ArchivedAnswerSet> mArchivedSectionWrapper{get;set;}
    
    /**
    * @description  - Non Parameterized Constructor to intialize the lists/Map
    * @param  - None
    * @return  - N/A
    */ 
    public IMH_QuestionnaireWrapperEDIT(){
        lQuestionWrapper = new List<QuestionWrapper>();
        this.visible = false;
        mQuestionSetWrapper = new Map<Id,List<QuestionWrapper>>();
        mArchivedSectionWrapper = new Map<Id,ArchivedAnswerSet>();
    }
    
    public class ArchivedAnswerSet{
            public string answerSetDescription {get;set;}
            public string answerSetName {get;set;}
            public Boolean isParent {get;set;}
    }
    
    /**
    * @author Accenture IDC 
    * @date 05/26/2015
    * @group QuestionSet
    * @group-content Questionnaire
    * @description - iMH Release 1 (Sprint 1) Wrapper for binding answer and question set.
    */
    public class QuestionWrapper{
        //GETTER VARIABLES OF WRAPPER CLASS
        public IMH_Answer__c parentAnswer{get;set;}
        public IMH_Question__c question{get;set;}
        public Integer index{get;set;}
        public IMH_Answer__c answer{get;set;}
        public String cssClassName{get;set;}
        public Boolean isWarning{get;set;}
        public IMH_QuestionWarning__c quesWarning{get;set;}
        public IMH_AnswerWarning__c ansWarning{get;set;}
        public String warningResponse{get;set;}
        public String questionRecordType{get;set;}
        public String errorMessage{get;set;}
        public Boolean notValidToRender{get;set;}
        public Map<String,String> mTranslationsByRespValues{get;set;}
        public String approvalComments{get;set;}
        public Integer wrapperTreeLevel{get;set;}
        public String questionTextToDisplay{get;set;}
        public Map<Id,ArchivedAnswerSet> mArchivedSectionWrapper{get;set;}
        
        
        
        
        /**
        * @description  - Getter method for picklist values - select option display
        * @param  - None
        * @return  - List<SelectOption>
        */ 
        public List<SelectOption> getPickListValues(){
            List<SelectOption> retOptions = new List<SelectOption>();
            // BUILD A SELECTOPTION LISTS BASED ON THE RESPONSE TYPE - RECORD TYPE QUESTIONS
            if(!isWarning){
                retOptions.add(new SelectOption(IMH_UtilityConstants.NONE,Label.IMH_WarningDefault));
                if(answer.Question__c==NULL
                  || question.Id==NULL){
                    	if('None'.equalsIgnoreCase(answer.Answer__c)){
                           retOptions.add(new SelectOption('N/A','N/A'));  
                        }else{
                            retOptions.add(new SelectOption(answer.Answer__c,('en_US'.equalsIgnoreCase(Userinfo.getLanguage()) || answer.ResponseUserLang__c == NULL)?answer.Answer__c:(answer.ResponseUserLang__c)));
                        }
                }
                else if(PICKLIST.equalsIgnoreCase(question.RecordType.DeveloperName) ){
                    //ITERATE THROUGHT THE RESPONSE VALUES IF RECORD TYPE IS PICKLIST
                    for(IMH_ResponseValue__c resValue : question.ResponseValues__r){
                        if(mTranslationsByRespValues.containsKey(resValue.Id)){
                            retOptions.add(new SelectOption(resValue.Text__c,mTranslationsByRespValues.get(resValue.Id)));
                        }else{
                            retOptions.add(new SelectOption(resValue.Text__c,resValue.Text__c));
                        }                        
                    }
                }
                //POPULATE THE RESPECTIVE VALUES FROM CUSTOM LABEL FOR YES_NO/YES_NO_NA RECORD TYPE QUESTIONS
                else if(IMH_UtilityConstants.YES_NO.equalsIgnoreCase(question.RecordType.DeveloperName)
                        || IMH_UtilityConstants.YES_NO_NA.equalsIgnoreCase(question.RecordType.DeveloperName)){
                    retOptions.add(new SelectOption(IMH_UtilityConstants.YES,mTranslationsByRespValues.get(IMH_UtilityConstants.YES)));
                    retOptions.add(new SelectOption(IMH_UtilityConstants.NO,mTranslationsByRespValues.get(IMH_UtilityConstants.NO)));
                    if(IMH_UtilityConstants.YES_NO_NA.equalsIgnoreCase(question.RecordType.DeveloperName)){
                        retOptions.add(new SelectOption(NOT_APPLICABLE,mTranslationsByRespValues.get(NOT_APPLICABLE)));
                    } 
                } 
            }
            else{
                 //POPULATE THE RESPECTIVE VALUES FROM CUSTOM LABEL FOR QUESTION WARNINGS 
                List<String> lresponseValues = new List<String>();
                retOptions.add(new SelectOption(IMH_UtilityConstants.CONFIRM_CHANGES,Label.IMH_WarningDefault));
                if(quesWarning.ResponseValue__c != NULL){
                   lresponseValues = quesWarning.ResponseValue__c.split(IMH_UtilityConstants.SEMI_COLON);
                   
                }
                if(!lresponseValues.isEmpty()){
                   for(String str:lresponseValues){
                       retOptions.add(new SelectOption(str,mTranslationsByRespValues.containsKey(str)?mTranslationsByRespValues.get(str):str));
                   }
                    //retOptions.add(new SelectOption(IMH_UtilityConstants.RAISE_EXCEPTION,Label.IMH_RaiseException));
                }
                // CHECK THE VALUE OF THE WARNING RESPONSE AND UPDATE THE SELECT OPTION TO APPROPRIATE
                if(IMH_UtilityConstants.EXCEPTION_APPROVED.equalsIgnoreCase(warningResponse) 
                            || IMH_UtilityConstants.EXCEPTION_RAISED.equalsIgnoreCase(warningResponse) 
                  			|| EXCEPTIONREJECTED.equalsIgnoreCase(warningResponse) ){
                    //retOptions = new List<SelectOption>();
                    retOptions.add(new SelectOption(warningResponse
                                                    , IMH_UtilityConstants.EXCEPTION_APPROVED.equalsIgnoreCase(warningResponse)
                                                                                            ?Label.IMH_ExceptionApproved:(EXCEPTIONREJECTED.equalsIgnoreCase(warningResponse))
                                                                                            ?Label.IMH_ExceptionRejected:Label.IMH_ExceptionRaised));
                }
            }
            
            return retOptions;
        }
        
        
        
        /**
        * @description  - Parameterized Constructor to intialize the lists/Map
        * @param  - Question(IMH_Question__c),Parent Question(IMH_Question__c),
        *       Index (Integer), Answer(IMH_Answer__c),CssClass Name(String),List of Question Warnings (List<IMH_QuestionWarning__c>)
        * @return  - N/A
        */
        public QuestionWrapper(IMH_Question__c question
                               , IMH_Answer__c parentAnswer
                               , Integer index
                               , String cssClassName
                               , IMH_QuestionWarning__c quesWarning
                               , IMH_AnswerWarning__c ansWarning
                               , Integer wrapperTreeLevel
                               , IMH_Answer__c answer){
            errorMessage = IMH_UtilityConstants.EMPTY_STRING;                                   
            this.parentAnswer = parentAnswer;
            isWarning = false;
            this.question = question;
            this.index = index;
            this.answer = answer;
            this.notValidToRender = false;
            this.wrapperTreeLevel = wrapperTreeLevel; 
			if(ansWarning!=null){
                this.questionTextToDisplay = ('en_US'.equalsIgnoreCase(Userinfo.getLanguage()) || ansWarning.WarningText_UserLang__c == NULL)?ansWarning.WarningText__c:ansWarning.WarningText_UserLang__c;
                this.quesWarning = quesWarning;
                isWarning = true;
                this.ansWarning = ansWarning;
                this.warningResponse = IMH_UtilityConstants.NOT_APPLICABLE.equalsIgnoreCase(ansWarning.Status__c)?IMH_UtilityConstants.CONFIRM_CHANGES:ansWarning.Status__c;
            }
                                   
             if(answer!=NULL){
                 this.questionTextToDisplay = ('en_US'.equalsIgnoreCase(Userinfo.getLanguage()) || answer.QuestionText_UserLang__c == NULL)?answer.QuestionText__c:answer.QuestionText_UserLang__c;
             }                      
            this.cssClassName = cssClassName;
			if(this.Question!=NULL &&
               	this.Question.RecordType.DeveloperName != NULL){
                questionRecordType = this.Question.RecordType.DeveloperName;
            }else{
                questionRecordType = 'Picklist';
            }                                   
          }
    }
}