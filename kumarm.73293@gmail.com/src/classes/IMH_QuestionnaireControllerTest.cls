/**
* @author Accenture IDC 
* @date 06/01/2015
* @group Answer
* @group-content N/A
* @description: iMH Release 1 (Sprint 1)Test Class for QuestionnaireWrapper and IMH_QuestionnaireController covering both 
 positive and negative test cases.
*/
@isTest
private class IMH_QuestionnaireControllerTest {
    private static final PageReference QUESTIONNAIRE_PAGE = Page.IMH_Questionnaire;
    private static final String STAGE_NAME = 'Concept';
    private static final String PRE_EXECUTION = 'Pre-Execution Testing';
    private static final String STATUS_NAME = 'In Progress';
    private static final String MARKET_NAME = 'Thailand';
    private static final String DIFF_MARKET_NAME = 'Australia';
    private static final String INCENTIVE_NAME = 'Incentive';
    private static final String CREATIVE_NAME = 'Creative';
    private static final String COMMUNICATION_NAME = 'Communication';
    private static final String QID = 'Qid';
    private static final String ID = 'Id';
    private static final String RAISE_EXCEPTION = 'Raise Exception';
    private static final String TEXT_DESCRIPTION = 'Text Description';
    private static final String AMBER = 'Amber';
    private static final String RED = 'Red';
    private static final String START = 'Start';
    private static final String YES = 'Yes';
    private static final String NO = 'No';
    private static final String RET_URL = 'retUrl';
    private static final String PAGE_MODE = 'pageMode';
    private static IMH_Communication__c sampleAmexCommunication = new IMH_Communication__c();
    private static IMH_CommCreative__c sampleAmexCreative = new IMH_CommCreative__c();
    private static IMH_QuestionSet__c questionSetForIncentive = new IMH_QuestionSet__c();
    private static IMH_QuestionSet__c questionSetForCreative = new IMH_QuestionSet__c();
    private static List<IMH_QuestionSet__c> lchildquestionSetCreative = new List<IMH_QuestionSet__c>();
    private static List<IMH_QuestionSet__c> lchildquestionSetCreative1 = new List<IMH_QuestionSet__c>();
    private static IMH_QuestionSet__c childquestionsetIncentive = new IMH_QuestionSet__c();
    private static IMH_QuestionSet__c questionSetCommunication = new IMH_QuestionSet__c();
    private static List<IMH_QuestionSet__c> lchildquestionsetCommunication = new List<IMH_QuestionSet__c>();
   private static List<IMH_QuestionSet__c> lchildquestionsetCommunication1 = new List<IMH_QuestionSet__c>();
    private static IMH_Incentive__c sampleAmexIncentive = new IMH_Incentive__c();
    private static final String IMH_QUESTION_API = 'IMH_Question__c';
    private static final String IMH_RESPONSE_API = 'IMH_ResponseValue__c';
    private static final String YES_NO_NA = 'Yes_No_NA';
    private static final String PICKLIST = 'Picklist';
    private static final String QUESTION_WARNING = 'QuestionWarning';
    private static final String RESPONSE_VALUE = 'responseValue';
    
        
    //@testSetup
     /*****************************************************************************
    * @description: Mehod used for  creating common Data
    * @param: none
    * @return: void
    */ 
    /*static void createCommonData() {
        List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        //List<IMH_ResponseValue__c> lresponseErrorMessage = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        insert questionSetForIncentive;
        //System.assertEqulas();
        
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        Database.insert(childquestionsetIncentive,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Incentive','IncentiveType__c','Incentive'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        // childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
        
        Id pickListQuestionId = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST
                                 LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert,false);
        IMH_ResponseValue__c response  = new IMH_ResponseValue__c();
        response.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response.ResponseValue__c = 'Advice has been applied';
        response.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response,false);
        createCreativeCommonData();
        createCommunicationCommonData();
    } 
  /*****************************************************************************
    * @description: Mehod used for  creating common Data
    * @param: none
    * @return: void
    */
    /*static void createCreativeCommonData(){
       List<IMH_Question__c> lQuestionsToBeInserted1    = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert1 = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForCreative = IMH_TestClassUtility.createQuestionSet(CREATIVE_NAME);
       insert questionSetForCreative;
        for(Integer i=0;i<20;i++)
        {
            lchildquestionSetCreative.add(IMH_TestClassUtility.createQuestionSet(CREATIVE_NAME));
            lchildquestionSetCreative[i].RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
            lchildquestionSetCreative[i].ParentQuestionSet__c = questionSetForCreative.Id;
             lchildquestionSetCreative[i].OrderSequence__c = i;
        }
        insert lchildquestionSetCreative;   
        
        //Entry Criteria Logics
            List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
            lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForCreative.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
            for(Integer i=1;i<20;i++)
            {
                
                lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lchildquestionSetCreative[i].Id,'Incentive','IMH_RequiredProductOwnerEngagement__c','Lending'));
            }
            insert lentrycriteria;
        for(Integer i=0;i<20;i++)
        {
            lchildquestionSetCreative1.add(IMH_TestClassUtility.createQuestionSet(CREATIVE_NAME));
            lchildquestionSetCreative1[i].RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
            lchildquestionSetCreative1[i].ParentQuestionSet__c = questionSetForCreative.Id;
             lchildquestionSetCreative1[i].OrderSequence__c = 20 + i;
        }
        insert lchildquestionSetCreative1;
       IMH_Question__c parentQuestion1 = new IMH_Question__c();
        parentquestion1 = IMH_TestClassUtility.createQuestion((ID)questionSetForCreative.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion1,false);     
    
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion1 = new IMH_Question__c();
        childQuestion1 = IMH_TestClassUtility.createQuestion((ID)lchildquestionSetCreative[0].Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion1.DependentQuestion__c = parentquestion1.ID;
        childQuestion1.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted1.add(childQuestion1);
        childQuestion1 = new IMH_Question__c();
        childQuestion1 = IMH_TestClassUtility.createQuestion((ID)lchildquestionSetCreative[1].Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        childQuestion1.DependentQuestion__c = parentquestion1.ID;
        childQuestion1.DependentQuestionEntryCriteria__c = NO;
        lQuestionsToBeInserted1.add(childQuestion1);
        Database.insert(lQuestionsToBeInserted1,false);
        
        Id pickListQuestionId1 = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST
                                 LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert1.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId1, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert1,false);
        IMH_ResponseValue__c response1  = new IMH_ResponseValue__c();
        response1.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response1.ResponseValue__c = 'Advice has been applied';
        response1.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response1,false);  
    }
      /*****************************************************************************
    * @description: Mehod used for  creating common Data
    * @param: none
    * @return: void*/
    static void createCommunicationCommonData(){
       List<IMH_Question__c> lQuestionsToBeInserted1    = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert1 = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetCommunication = IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        questionSetCommunication.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').Id;
        insert questionSetCommunication;
        for(Integer i=0;i<20;i++)
        {
            lchildquestionsetCommunication.add(IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME));
            lchildquestionsetCommunication[i].RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
            lchildquestionsetCommunication[i].ParentQuestionSet__c = questionSetCommunication.Id;
             lchildquestionsetCommunication[i].OrderSequence__c = i;
        }
        insert lchildquestionsetCommunication;
        
          //Entry Criteria Logics
            List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
            lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetCommunication.Id,'Communication','TargetMarket__c',MARKET_NAME));   
            for(Integer i=1;i<20;i++)
            {
                lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lchildquestionsetCommunication[i].Id,'Communication','CommunicationRecordType__c','Marketing Communication'));
                // lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive[i].Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
            }
            insert lentrycriteria;
        
        for(Integer i=0;i<20;i++)
        {
            lchildquestionsetCommunication1.add(IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME));
            lchildquestionsetCommunication1[i].RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
            lchildquestionsetCommunication1[i].ParentQuestionSet__c = questionSetCommunication.Id;
             lchildquestionsetCommunication1[i].OrderSequence__c = 20 + i;
        }
        insert lchildquestionsetCommunication1;
        
        IMH_Question__c parentQuestion1 = new IMH_Question__c();
        parentquestion1 = IMH_TestClassUtility.createQuestion((ID)questionSetCommunication.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion1,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion1 = new IMH_Question__c();
        childQuestion1 = IMH_TestClassUtility.createQuestion((ID)lchildquestionsetCommunication[0].Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion1.DependentQuestion__c = parentquestion1.ID;
        childQuestion1.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted1.add(childQuestion1);
        childQuestion1 = new IMH_Question__c();
        childQuestion1 = IMH_TestClassUtility.createQuestion((ID)lchildquestionsetCommunication[1].Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        childQuestion1.DependentQuestion__c = parentquestion1.ID;
        childQuestion1.DependentQuestionEntryCriteria__c = NO;
        lQuestionsToBeInserted1.add(childQuestion1);
        Database.insert(lQuestionsToBeInserted1,false);
        
        Id pickListQuestionId1 = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST
                                 LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert1.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId1, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert1,false);
        IMH_ResponseValue__c response1  = new IMH_ResponseValue__c();
        response1.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response1.ResponseValue__c = 'Advice has been applied';
        response1.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response1,false);  
    }
    /*****************************************************************************
    * @description: Mehod used for covering the case when we have the both the questions with 
    *               Yes/No/NA status and User click on Start
    * @param: none
    * @return: void
    */ 
    static testmethod void questionnaireDisplayForIncentive(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT 
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
       
        List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;
        
        List<IMH_Question__c> lQuestionsToBeInserted1    = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert1 = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetCommunication = IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        questionSetCommunication.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').Id;
        insert questionSetCommunication;
        for(Integer i=0;i<20;i++)
        {
            lchildquestionsetCommunication.add(IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME));
            lchildquestionsetCommunication[i].RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
            lchildquestionsetCommunication[i].ParentQuestionSet__c = questionSetCommunication.Id;
             lchildquestionsetCommunication[i].OrderSequence__c = i;
        }
        insert lchildquestionsetCommunication;
        
          //Entry Criteria Logics
           /* List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
            lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetCommunication.Id,'Communication','TargetMarket__c',MARKET_NAME));   
            for(Integer i=1;i<20;i++)
            {
                lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lchildquestionsetCommunication[i].Id,'Communication','CommunicationRecordType__c','Marketing Communication'));
                 lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lchildquestionsetCommunication[i].Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
            }
            insert lentrycriteria;*/
             
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetCommunication.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','ProcessStage__c','Pre-Execution Testing'));     
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lchildquestionsetCommunication[0].Id,'Incentive','IncentiveType__c','New Offer Construct Type')); 
        insert lentrycriteria; 

        IMH_Question__c parentQuestion1 = new IMH_Question__c();
        parentquestion1 = IMH_TestClassUtility.createQuestion((ID)questionSetCommunication.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion1,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion1 = new IMH_Question__c();
        childQuestion1 = IMH_TestClassUtility.createQuestion((ID)lchildquestionsetCommunication[0].Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion1.DependentQuestion__c = parentquestion1.ID;
        childQuestion1.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted1.add(childQuestion1);
        childQuestion1 = new IMH_Question__c();
        childQuestion1 = IMH_TestClassUtility.createQuestion((ID)lchildquestionsetCommunication[1].Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        childQuestion1.DependentQuestion__c = parentquestion1.ID;
        childQuestion1.DependentQuestionEntryCriteria__c = NO;
        lQuestionsToBeInserted1.add(childQuestion1);
        Database.insert(lQuestionsToBeInserted1,false);
        
        Id pickListQuestionId1 = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST
                                 LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert1.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId1, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert1,false);
        IMH_ResponseValue__c response1  = new IMH_ResponseValue__c();
        response1.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response1.ResponseValue__c = 'Advice has been applied';
        response1.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response1,false);          
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
         sampleAmexCommunication.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id; 
            
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
       IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(sampleAmexIncentive,false);
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c                                
                                ,Communication__r.RecordType.Name
                                ,Status__c
                                FROM IMH_AnswerSet__c
                            // where QuestionSet__r.ObjectEntryCriteria__c = 'Incentive'
                            LIMIT 50000];
        //CREATE A PARENT QUESTION    
        Test.startTest();
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
            pagecontroller.qWrapper.lQuestionWrapper[0].answer.Answer__c = YES;
            pagecontroller.onChangeOfAnswer();
        }
        Test.stopTest();
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
        //Assert To check the Communication Record Type is Marketing Communication
       System.assertEquals(lanswerset_Incentive[0].Communication__r.RecordType.Name,'Marketing Communication');
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2); 
      
    }
     /*****************************************************************************
    * @description: Mehod used for covering the case when we have the both the questions with 
    *               Yes/No/NA status and User click on Start
    * @param: none
    * @return: void
    */
   static testmethod void questionnaireDisplayForCreative(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
        createCommunicationCommonData();
        List<IMH_AnswerSet__c> lanswerset_Creative = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;
        
        List<IMH_Question__c> lQuestionsToBeInserted1    = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert1 = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetCommunication = IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        questionSetCommunication.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').Id;
        insert questionSetCommunication;
       
        lchildquestionsetCommunication = new List<IMH_QuestionSet__c>();
        for(Integer i=0;i<20;i++)
        {
            lchildquestionsetCommunication.add(IMH_TestClassUtility.createQuestionSet(CREATIVE_NAME));
            lchildquestionsetCommunication[i].RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
            lchildquestionsetCommunication[i].ParentQuestionSet__c = questionSetCommunication.Id;
             lchildquestionsetCommunication[i].OrderSequence__c = i;
        }
        insert lchildquestionsetCommunication;
             
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetCommunication.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','ProcessStage__c','Pre-Execution Testing'));     
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lchildquestionsetCommunication[0].Id,'Creative','IMH_RequiredProductOwnerEngagement__c','Consumer Lending')); 
        insert lentrycriteria; 

        IMH_Question__c parentQuestion1 = new IMH_Question__c();
        parentquestion1 = IMH_TestClassUtility.createQuestion((ID)questionSetCommunication.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion1,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion1 = new IMH_Question__c();
        childQuestion1 = IMH_TestClassUtility.createQuestion((ID)lchildquestionsetCommunication[0].Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion1.DependentQuestion__c = parentquestion1.ID;
        childQuestion1.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted1.add(childQuestion1);
        childQuestion1 = new IMH_Question__c();
        childQuestion1 = IMH_TestClassUtility.createQuestion((ID)lchildquestionsetCommunication[1].Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        childQuestion1.DependentQuestion__c = parentquestion1.ID;
        childQuestion1.DependentQuestionEntryCriteria__c = NO;
        lQuestionsToBeInserted1.add(childQuestion1);
        Database.insert(lQuestionsToBeInserted1,false);
        
        Id pickListQuestionId1 = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST
                                 LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert1.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId1, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert1,false);
        IMH_ResponseValue__c response1  = new IMH_ResponseValue__c();
        response1.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response1.ResponseValue__c = 'Advice has been applied';
        response1.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response1,false);

        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
       // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        sampleAmexCommunication.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;     
        Database.insert(sampleAmexCommunication,false);
        sampleAmexCreative = IMH_TestClassUtility.createFinalCreative(sampleAmexCommunication.ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
        sampleAmexCreative.IMH_RequiredProductOwnerEngagement__c = 'Consumer Lending';    
        insert sampleAmexCreative;   
        lanswerset_Creative = [SELECT Id
                                      ,QuestionSet__c
                                      ,Communication__r.RecordType.Name
                                      ,Status__c
                               FROM IMH_AnswerSet__c
                                //where QuestionSet__r.ObjectEntryCriteria__c = 'Creative'
                               LIMIT 50000];
                system.debug('<<<AnswerSet>>>'+lanswerset_Creative);
        Test.startTest();
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Creative[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Creative[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Creative[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
            pagecontroller.qWrapper.lQuestionWrapper[0].answer.Answer__c = YES;
            pagecontroller.onChangeOfAnswer();
        }
        Test.stopTest();
        //Query To Retrieve the Parent Question Set with Object Entry Criteria as Communication
        //List<IMH_Questionset__c> ltestdataquestionSet = [Select id From IMH_Questionset__c Where ObjectEntryCriteria__c = 'Creative' AND RecordType.DeveloperName = 'Parent'];
        //Query To Retrieve the Child Question Set with Object Entry Criteria as Creative and whose Product Owner is Lending
        List<IMH_Questionset__c> ltestdataquestionSetChild = [Select id 
                                                              From IMH_Questionset__c 
                                                              Where ObjectEntryCriteria__c = 'Creative' 
                                                              AND RecordType.DeveloperName = 'Child'
                                                              AND ParentQuestionSet__c=:questionSetCommunication.Id LIMIT 50000];
       /*List<IMH_EntryCriteria__c> lentrycriteria = [SELECT QuestionSet__c 
                                                     FROM IMH_EntryCriteria__c];
                                                    // WHERE Object__c = 'Creative'
                                                     AND Equals__c = 'Lending'];*/
        //Assert To check whether all the child question set are associated to parent question set irrespective of any Market
        System.assertEquals(20,[Select Id from IMH_Questionset__c where ParentQuestionSet__c = :questionSetCommunication.Id LIMIT 50000].size());
        //Assert To check the number of Answer Set that's get created in the process
        System.assertEquals(lanswerset_Creative.size(),2);
        //Assert To check whether the answer set created is associated to correct parent question set record
        //System.assertEquals(lanswerset_Creative[0].QuestionSet__c,questionSetCommunication.Id);
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
       System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2);  
        
    }
/*****************************************************************************
    * @description: Mehod used for covering the case when we have the both the questions with 
    *               Yes/No/NA status and User click on Start
    * @param: none
    * @return: void
    */
    static testmethod void questionnaireDisplayForCommunication(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
        
        List<IMH_AnswerSet__c> lanswerset_Communication = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;
        createCommunicationCommonData();
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(PRE_EXECUTION,STATUS_NAME,MARKET_NAME);
       insert sampleAmexCommunication;   
        lanswerset_Communication = [SELECT Id
                                      ,QuestionSet__c
                                      ,Communication__c
                                      ,Status__c
                               FROM IMH_AnswerSet__c
                               LIMIT 50000];
            
        //CREATE A PARENT QUESTION    
        Test.startTest();
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Communication[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Communication[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Communication[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
            pagecontroller.qWrapper.lQuestionWrapper[0].answer.Answer__c = YES;
            pagecontroller.onChangeOfAnswer();
        }
        Test.stopTest();
        //Query To Retrieve the Parent Question Set with Object Entry Criteria as Communication
        List<IMH_Questionset__c> ltestdataquestionSet = [Select id From IMH_Questionset__c Where ObjectEntryCriteria__c = 'Communication' AND RecordType.DeveloperName = 'Parent' LIMIT 50000];
        //Query To Retrieve the Child Question Set with Object Entry Criteria as Communication and whose Market is Thailand
         List<IMH_EntryCriteria__c> lentrycriteria = [SELECT QuestionSet__c 
                                                     FROM IMH_EntryCriteria__c
                                                     WHERE Object__c = 'Communication'
                                                     AND Field__c = 'CommunicationRecordType__c'
                                                     AND Equals__c = 'Marketing Communication' LIMIT 50000];
        //Assert To check whether all the child question set are associated to parent question set irrespective of any Market
        System.assertEquals(40,[Select Id from IMH_Questionset__c where ParentQuestionSet__c = :ltestdataquestionSet[0].Id LIMIT 50000].size());
        //Assert To check the number of Answer Set that's get created in the process
        System.assertEquals(lanswerset_Communication.size(),1);
        //Assert To check the number of Question Set Created for particular Market Criteria
        System.assertEquals(19,lentrycriteria.size());
        //Assert To check whether the answer set created is associated to correct parent question set record
        System.assertEquals(lanswerset_Communication[0].QuestionSet__c,ltestdataquestionSet[0].Id);
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2); 
        
    }
    /*****************************************************************************
    * @description: Mehod used for covering the case when we have the both the questions with 
    *               Yes/No/NA status and User click on Start
    * @param: none
    * @return: void
    */
    static testmethod void questionnaireSubmitActionForIncentive(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
        runningUser.IMH_UserRoleTypeNew__c = 'Submitter';
        List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;
        
        List<IMH_Question__c> lQuestionsToBeInserted1    = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert1 = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetCommunication = IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        questionSetCommunication.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').Id;
        insert questionSetCommunication;
        lchildquestionsetCommunication = new List<IMH_QuestionSet__c>();
        for(Integer i=0;i<20;i++)
        {
            lchildquestionsetCommunication.add(IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME));
            lchildquestionsetCommunication[i].RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
            lchildquestionsetCommunication[i].ParentQuestionSet__c = questionSetCommunication.Id;
             lchildquestionsetCommunication[i].OrderSequence__c = i;
        }
        insert lchildquestionsetCommunication;
                    
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetCommunication.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','ProcessStage__c','Pre-Execution Testing'));     
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lchildquestionsetCommunication[0].Id,'Incentive','IncentiveType__c','New Offer Construct Type')); 
        insert lentrycriteria; 

        IMH_Question__c parentQuestion1 = new IMH_Question__c();
        parentquestion1 = IMH_TestClassUtility.createQuestion((ID)questionSetCommunication.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion1,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion1 = new IMH_Question__c();
        IMH_Question__c childQuestion2 = new IMH_Question__c();
        childQuestion1 = IMH_TestClassUtility.createQuestion((ID)lchildquestionsetCommunication[0].Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion1.DependentQuestion__c = parentquestion1.ID;
        childQuestion1.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted1.add(childQuestion1);
        childQuestion2 = new IMH_Question__c();
        childQuestion2 = IMH_TestClassUtility.createQuestion((ID)lchildquestionsetCommunication[1].Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        childQuestion2.DependentQuestion__c = parentquestion1.ID;
        childQuestion2.DependentQuestionEntryCriteria__c = NO;
        lQuestionsToBeInserted1.add(childQuestion2);
        Database.insert(lQuestionsToBeInserted1,false);
        
        Id pickListQuestionId1 = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST
                                 LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert1.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId1, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert1,false);
        IMH_ResponseValue__c response1  = new IMH_ResponseValue__c();
        response1.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response1.ResponseValue__c = 'Advice has been applied';
        response1.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response1,false);     

        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
        IMH_IncentiveTriggerHandler.isExecutedAfter = false;
         insert sampleAmexIncentive;
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__r.RecordType.Name
                                ,Status__c
                                FROM IMH_AnswerSet__c
                                //where QuestionSet__r.ObjectEntryCriteria__c = 'Incentive'
                            LIMIT 50000];
							
		System.debug('** Debug Ans ** '+lanswerset_Incentive[0].QuestionSet__c);
        //CREATE A PARENT QUESTION    
        Test.startTest();
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,'start');
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
			System.debug('** Debug 1 ** '+pagecontroller.qWrapper);
			System.debug('** Debug 2 ** '+pagecontroller.qWrapper.mQuestionSetWrapper);
			System.debug('** Debug 3 ** '+pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id));
			System.debug('** Debug 4 ** '+pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0));
			System.debug('** Debug 5 ** '+pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer);
			System.debug('** Debug 6 ** '+pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c );			
            pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = YES;
			System.debug('** Debug 1 ** '+pagecontroller.qWrapper);
			System.debug('** Debug 2 ** '+pagecontroller.qWrapper.mQuestionSetWrapper);
			System.debug('** Debug 3 ** '+pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id));
			System.debug('** Debug 4 ** '+pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0));
			System.debug('** Debug 5 ** '+pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer);
			System.debug('** Debug 6 ** '+pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c );
            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
        }
        
        Test.stopTest();
        List<IMH_AnswerSet__c> lupanswerset = [SELECT Id
                                               ,QuestionSet__c
                                               ,Communication__c
                                               ,Status__c
                                               ,CompletionPercentage__c
                                               FROM IMH_AnswerSet__c 
                                               WHERE Communication__c =:lanswerset_Incentive[0].Communication__c
                                               LIMIT 50000];
        // CHECK THE ANSWERSET STATUS SINCE SECOND QUESTION IS NOT ANSWERED YET - IN PROGRESS
        //System.assertEquals('In Progress',lupanswerset[0].Status__c);
        //system.assertEquals([SELECT Id FROM IMH_Answer__c 
        //                     LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())].size(), 2);
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2);  
    }
    
    /*****************************************************************************
    * @description: Mehod used for covering the case when we have the both the questions with 
    *               Yes/No/NA status and User click on Start
    * @param: none
    * @return: void
    */ 
    static testmethod void questionnaireCompletionPercentage(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);

        List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        //List<IMH_ResponseValue__c> lresponseErrorMessage = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        insert questionSetForIncentive;
        //System.assertEqulas();
        
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        Database.insert(childquestionsetIncentive,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        // childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
        
        Id pickListQuestionId = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST
                                 LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert,false);
        IMH_ResponseValue__c response  = new IMH_ResponseValue__c();
        response.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response.ResponseValue__c = 'Advice has been applied';
        response.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response,false);

        List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;
        Integer cPercentBeforeOnChange; 
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(sampleAmexIncentive,false);
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__c
                                ,Status__c
                                FROM IMH_AnswerSet__c
                                LIMIT 50000];
         
        //CREATE A PARENT QUESTION    
        Test.startTest();
            ID childqusetId = [Select id from IMH_QuestionSet__c where ParentQuestionSet__c =:lanswerset_Incentive[0].QuestionSet__c LIMIT 1].ID; 
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
           pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = YES;
           // ApexPages.currentPage().getParameters().put('selectedQuestionSetId',lanswerset_Incentive[0].Id);
           // ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            
            pagecontroller.onChangeOfAnswer();
            cPercentBeforeOnChange = pagecontroller.percentCompletion;
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[SELECT Id FROM IMH_Answer__c WHERE archivedSection__c IN (SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id) LIMIT 1].Id);
            pagecontroller.qWrapper.mQuestionSetWrapper.get([SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id).get(0).answer.Answer__c = YES;
            
            pagecontroller.onChangeOfAnswer();
           
          Test.stopTest();
        }
        
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2); 
        System.assertEquals(cPercentBeforeOnChange,50);
        System.assertEquals(pagecontroller.percentCompletion,50);
        
    }
    /*****************************************************************************
    * @description: Method used for creating questionnaire with warning
    * @param: none
    * @return: void
    */ 
    static testmethod void questionnaireDisplayWithWarning(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
        List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;

        List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        //List<IMH_ResponseValue__c> lresponseErrorMessage = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        insert questionSetForIncentive;
        //System.assertEqulas();
        
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        Database.insert(childquestionsetIncentive,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        // childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
        
        Id pickListQuestionId = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST
                                 LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert,false);
        IMH_ResponseValue__c response  = new IMH_ResponseValue__c();
        response.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response.ResponseValue__c = 'Advice has been applied';
        response.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response,false);

        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE    
        Boolean isErrorThrown = false; 
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(sampleAmexIncentive,false);
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__c
                                ,Status__c
                                FROM IMH_AnswerSet__c
                                //where QuestionSet__r.ObjectEntryCriteria__c = 'Incentive'
                            LIMIT 50000];
            List<IMH_QuestionWarning__c> lQuestionWarning = new List<IMH_QuestionWarning__c>();
            Id parentquestionId = [SELECT ID FROM IMH_Question__c WHERE QuestionSet__c = :lanswerset_Incentive[0].QuestionSet__c 
                                   LIMIT 1].Id;
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId, YES, RED,1));
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,NO, AMBER,2));
            Database.insert(lQuestionWarning,false);
         
        //CREATE A PARENT QUESTION    
        
        Test.startTest();
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            ID childquset = [Select id from IMH_QuestionSet__c where ParentQuestionSet__c =:lanswerset_Incentive[0].QuestionSet__c LIMIT 1].ID;
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
           pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = YES;
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            pagecontroller.onChangeOfAnswer();
            
            for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id)){
                if(tempWrap.isWarning && YES.equalsIgnoreCase(tempWrap.ansWarning.EntryCriteria__c)){
                   tempWrap.warningResponse = RAISE_EXCEPTION;
                    //tempWrap.ansWarning.Detail__c = TEXT_DESCRIPTION;
                    //isErrorThrown = true;
                }   
            }
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
            for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id)){
                if(tempWrap.isWarning && YES.equalsIgnoreCase(tempWrap.ansWarning.EntryCriteria__c) && String.isNotBlank(tempWrap.errorMessage)){
                    tempWrap.warningResponse = RAISE_EXCEPTION;
                    tempWrap.ansWarning.Detail__c = TEXT_DESCRIPTION;
                    isErrorThrown = true;
                }
            }
            
            pagecontroller.confirmAction();
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.lQuestionWrapper){
                tempWrap.getPickListValues();
            }
        Test.stopTest();
        }
        List<IMH_AnswerSet__c> lupanswerset = [SELECT Id
                                               ,QuestionSet__c
                                               ,Communication__c
                                               ,Status__c
                                               ,CompletionPercentage__c
                                               FROM IMH_AnswerSet__c 
                                               WHERE Communication__c =:lanswerset_Incentive[0].Communication__c
                                               LIMIT 50000];
        // CHECK THE ANSWERSET STATUS SINCE SECOND QUESTION IS NOT ANSWERED YET - IN PROGRESS
        System.assertEquals('In Progress',lupanswerset[0].Status__c);   
        system.assert(isErrorThrown);
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2);
    }
    
     /*****************************************************************************
    * @description: Mehod used for creating questionnaire with Amber warning
    * @param: none
    * @return: void
    */
    static testmethod void questionnaireDisplayWithWarningAsAmber(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);

        List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        //List<IMH_ResponseValue__c> lresponseErrorMessage = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        insert questionSetForIncentive;
        //System.assertEqulas();
        
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        Database.insert(childquestionsetIncentive,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        // childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
        
        Id pickListQuestionId = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST
                                 LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert,false);
        IMH_ResponseValue__c response  = new IMH_ResponseValue__c();
        response.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response.ResponseValue__c = 'Advice has been applied';
        response.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response,false);
       
        List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;
         //List<SelectOption> lSelectOptionToAssert;
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE    
        //Boolean isErrorThrown = false; 
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(sampleAmexIncentive,false);
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__c
                                ,Status__c
                                FROM IMH_AnswerSet__c
                                //where QuestionSet__r.ObjectEntryCriteria__c = 'Incentive'
                            LIMIT 50000];
         List<IMH_QuestionWarning__c> lQuestionWarning = new List<IMH_QuestionWarning__c>();
            Id parentquestionId = [SELECT ID FROM IMH_Question__c WHERE QuestionSet__c = :lanswerset_Incentive[0].QuestionSet__c LIMIT 1].Id;
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,YES,RED,1));
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,NO,AMBER,2));
            Database.insert(lQuestionWarning,false);
        //CREATE A PARENT QUESTION    
        
        Test.startTest();
            ID childquset = [Select id from IMH_QuestionSet__c where ParentQuestionSet__c =:lanswerset_Incentive[0].QuestionSet__c LIMIT 1].ID;
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
            pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = NO;
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Id);

            pagecontroller.onChangeOfAnswer();
            
           for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id)){
                if(tempWrap.isWarning && YES.equalsIgnoreCase(tempWrap.ansWarning.EntryCriteria__c)){
                    tempWrap.warningResponse = RAISE_EXCEPTION;
                    tempWrap.ansWarning.Detail__c = TEXT_DESCRIPTION;
                }
            }
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Id);

            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            pagecontroller.qWrapper.lQuestionWrapper[0].answer.Answer__c = 'None';
            ApexPages.currentPage().getParameters().put('selectedQID',pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Id);
            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
            pagecontroller.exitAction();
        Test.stopTest();
        }
         List<IMH_AnswerWarning__c> lanswerwarn = new List<IMH_AnswerWarning__c>();
        //Queries the answer warning if present
       lanswerwarn = [SELECT Id,
                             QuestionWarning__c,
                             Status__c
                      FROM IMH_AnswerWarning__c
                      WHERE QuestionWarning__r.Question__c =:pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).question.Id
                      LIMIT 50000];
        //System.assertEquals(lanswerwarn,null);
      //Assertion to check whether the Exception is raised.
      System.assertEquals('N/A',lanswerwarn[0].Status__c);
        List<IMH_AnswerSet__c> lupanswerset = [SELECT Id
                                               ,QuestionSet__c
                                               ,Communication__c
                                               ,Status__c
                                               ,CompletionPercentage__c
                                               FROM IMH_AnswerSet__c 
                                               WHERE Communication__c =:lanswerset_Incentive[0].Communication__c
                                               LIMIT 50000];
        // CHECK THE ANSWERSET STATUS SINCE SECOND QUESTION IS NOT ANSWERED YET - IN PROGRESS
        System.assertEquals('In Progress',lupanswerset[0].Status__c);   
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2);
    }
    /*****************************************************************************
    * @description: Method used for covering the case users answers in such a way that
    *               red warning gets popped up and User Changes the answer again so as to recall
    *               the question
    * @param: none
    * @return: void
    */
    static testmethod void questionnaireDisplayWithWarningAsRedRecall(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
        List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;

        List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        //List<IMH_ResponseValue__c> lresponseErrorMessage = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        insert questionSetForIncentive;
        //System.assertEqulas();
        
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        Database.insert(childquestionsetIncentive,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        // childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
        
        Id pickListQuestionId = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST
                                 LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert,false);
        IMH_ResponseValue__c response  = new IMH_ResponseValue__c();
        response.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response.ResponseValue__c = 'Advice has been applied';
        response.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response,false);

         //List<SelectOption> lSelectOptionToAssert;
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE    
        Boolean isErrorThrown = false; 
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(sampleAmexIncentive,false);
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__c
                                ,Status__c
                                FROM IMH_AnswerSet__c
                                //where QuestionSet__r.ObjectEntryCriteria__c = 'Incentive'
                            LIMIT 50000];
        List<IMH_QuestionWarning__c> lQuestionWarning = new List<IMH_QuestionWarning__c>();
            Id parentquestionId = [SELECT ID FROM IMH_Question__c WHERE QuestionSet__c = :lanswerset_Incentive[0].QuestionSet__c 
                                   LIMIT 1].Id;
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId, YES, RED,2));
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,NO, AMBER,1));
            Database.insert(lQuestionWarning,false); 
            
        //CREATE A PARENT QUESTION    
        
        Test.startTest();
            ID childquset = [Select id from IMH_QuestionSet__c where ParentQuestionSet__c =:lanswerset_Incentive[0].QuestionSet__c LIMIT 1].ID;
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,'start');
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
            pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = YES;
              ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            pagecontroller.onChangeOfAnswer();
            
            for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id)){
                tempWrap.getPickListValues();
                if(tempWrap.isWarning && YES.equalsIgnoreCase(tempWrap.ansWarning.EntryCriteria__c)){
                    tempWrap.warningResponse = RAISE_EXCEPTION;
                    tempWrap.ansWarning.Detail__c = TEXT_DESCRIPTION;
                }
            }
             ApexPages.currentPage().getParameters().put('selectedQuestionSetId',lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = NO;
            //ApexPages.currentPage().getParameters().put('selectedQID',pagecontroller.qWrapper.lQuestionWrapper[0].question.Id);
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);
            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
            //  pagecontroller.exitAction();
            Test.stopTest();
        }
       List<IMH_AnswerWarning__c> lanswerwarn = new List<IMH_AnswerWarning__c>();
       lanswerwarn = [SELECT Id,
                             QuestionWarning__c,
                             Status__c
                      FROM IMH_AnswerWarning__c
                      WHERE QuestionWarning__r.Question__c =:pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).question.Id
                      LIMIT 50000];
     //Assertion to check whether the Exception is recalled. 
      System.assertEquals('N/A',lanswerwarn[0].Status__c);
      List<IMH_AnswerSet__c> lupanswerset = [SELECT Id
                                               ,QuestionSet__c
                                               ,Communication__c
                                               ,Status__c
                                               ,CompletionPercentage__c
                                               FROM IMH_AnswerSet__c 
                                               WHERE Communication__c =:lanswerset_Incentive[0].Communication__c
                                               LIMIT 50000];
      // CHECK THE ANSWERSET STATUS SINCE SECOND QUESTION IS NOT ANSWERED YET - IN PROGRESS
      System.assertEquals('In Progress',lupanswerset[0].Status__c);   
      // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
      System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2);
    }
  /*****************************************************************************
    * @description: Method used for covering the case users answers in such a way that
    *               red warning gets popped up 
    *              
    * @param: none
    * @return: void
    */
    static testmethod void questionnaireDisplayWithWarningAsRed(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
       
        List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;

        List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        //List<IMH_ResponseValue__c> lresponseErrorMessage = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        insert questionSetForIncentive;
        //System.assertEqulas();
        
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        Database.insert(childquestionsetIncentive,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        // childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
        
        Id pickListQuestionId = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST
                                 LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert,false);
        IMH_ResponseValue__c response  = new IMH_ResponseValue__c();
        response.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response.ResponseValue__c = 'Advice has been applied';
        response.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response,false);

         //List<SelectOption> lSelectOptionToAssert;
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE    
        //Boolean isErrorThrown = false; 
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(sampleAmexIncentive,false);
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__c
                                ,Status__c
                                FROM IMH_AnswerSet__c
                               //where QuestionSet__r.ObjectEntryCriteria__c = 'Incentive'
                            LIMIT 50000];
         List<IMH_QuestionWarning__c> lQuestionWarning = new List<IMH_QuestionWarning__c>();
            Id parentquestionId = [SELECT ID FROM IMH_Question__c WHERE QuestionSet__c = :lanswerset_Incentive[0].QuestionSet__c LIMIT 1].Id;
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId, YES, RED,2));
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,NO, AMBER,1));
            Database.insert(lQuestionWarning,false);
        //CREATE A PARENT QUESTION    
        
        Test.startTest();
             ID childquset = [Select id from IMH_QuestionSet__c where ParentQuestionSet__c =:lanswerset_Incentive[0].QuestionSet__c LIMIT 1].ID;
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
            pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = YES;
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            pagecontroller.onChangeOfAnswer();
            
            for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id)){
                tempWrap.getPickListValues();
                if(tempWrap.isWarning && YES.equalsIgnoreCase(tempWrap.ansWarning.EntryCriteria__c)){
                    tempWrap.warningResponse = RAISE_EXCEPTION;
                    tempWrap.ansWarning.Detail__c = TEXT_DESCRIPTION;
                }
            }
            
              ApexPages.currentPage().getParameters().put('selectedQuestionSetId',lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
           
        Test.stopTest();
        }
       List<IMH_AnswerWarning__c> lanswerwarn = new List<IMH_AnswerWarning__c>();
      //Queries the answer warning if present
       lanswerwarn = [SELECT Id,
                             QuestionWarning__c,
                             Status__c
                      FROM IMH_AnswerWarning__c
                      WHERE QuestionWarning__r.Question__c =:pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).question.Id
                      LIMIT 50000];
      
      //Assertion to check whether the Exception is raised.
        System.assertEquals('Raise Exception',lanswerwarn[0].Status__c);
        List<IMH_AnswerSet__c> lupanswerset = [SELECT Id
                                               ,QuestionSet__c
                                               ,Communication__c
                                               ,Status__c
                                               ,CompletionPercentage__c
                                               FROM IMH_AnswerSet__c 
                                               WHERE Communication__c =:lanswerset_Incentive[0].Communication__c
                                               LIMIT 50000];
        // CHECK THE ANSWERSET STATUS SINCE SECOND QUESTION IS NOT ANSWERED YET - IN PROGRESS
        System.assertEquals('In Progress',lupanswerset[0].Status__c);   
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2);
    }  

/*****************************************************************************
    * @description: Mehod used for creating questionnaire with warning and attaching file to it
    * @param: none
    * @return: void
    */ 
    static testmethod void questionnaireDisplayWithOnlyAttachment(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
        List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;
         
        List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        //List<IMH_ResponseValue__c> lresponseErrorMessage = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        insert questionSetForIncentive;
        //System.assertEqulas();
        
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        Database.insert(childquestionsetIncentive,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        // childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
        
        Id pickListQuestionId = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert,false);
        IMH_ResponseValue__c response  = new IMH_ResponseValue__c();
        response.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response.ResponseValue__c = 'Advice has been applied';
        response.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response,false);

         List<Attachment> lattachment = new List<Attachment>();
       //Attachment details
        Blob b = Blob.valueOf('Test Data');
        Attachment attach;
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE    
        Boolean isErrorThrown = false; 
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(sampleAmexIncentive,false);
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__c
                                ,Status__c
                                FROM IMH_AnswerSet__c
                                //where QuestionSet__r.ObjectEntryCriteria__c = 'Incentive'
                            LIMIT 50000];
            
            List<IMH_QuestionWarning__c> lQuestionWarning = new List<IMH_QuestionWarning__c>();
            Id parentquestionId = [SELECT ID FROM IMH_Question__c WHERE QuestionSet__c = :lanswerset_Incentive[0].QuestionSet__c 
                                   LIMIT 1].Id;
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId, YES, RED,2));
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,NO, AMBER,1));
            Database.insert(lQuestionWarning,false);
         
        //CREATE A PARENT QUESTION    
        
        Test.startTest();
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            ID childquset = [Select id from IMH_QuestionSet__c where ParentQuestionSet__c =:lanswerset_Incentive[0].QuestionSet__c LIMIT 1].ID;
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            attach = new Attachment();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
           pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = YES;
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            pagecontroller.onChangeOfAnswer();
             attach.ParentId = lanswerset_Incentive[0].Id;
                    attach.Name  = 'Test Attachment for Parent'; 
                    attach.body = b;
                    lattachment.add(attach);
                    Database.insert(lattachment,false);
            for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id)){
                if(tempWrap.isWarning && YES.equalsIgnoreCase(tempWrap.ansWarning.EntryCriteria__c)){
                   tempWrap.warningResponse = 'File evidence to be attached';
                   
                    tempWrap.ansWarning.Detail__c = TEXT_DESCRIPTION;
                    tempWrap.ansWarning.SYSAttachmentId__c = lattachment[0].Id;
                      
                    //isErrorThrown = true;
                }   
            }
             
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[SELECT Id FROM IMH_Answer__c WHERE archivedSection__c IN (SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id) LIMIT 1].Id);
            
            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
             
        Test.stopTest();
        }
        List<IMH_AnswerWarning__c> lanswerwarn = new List<IMH_AnswerWarning__c>();
       lanswerwarn = [SELECT Id,
                             QuestionWarning__c,
                             Status__c,
                             SYSAttachmentId__c
                      FROM IMH_AnswerWarning__c
                      WHERE QuestionWarning__r.Question__c =:pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).question.Id
                      LIMIT 50000];
        //Checks whether the file ID gets stored in Answer Warning
        System.assertEquals(lanswerwarn[0].SYSAttachmentId__c,lattachment[0].Id);
        ApexPages.currentPage().getParameters().put('contIdParam',lattachment[0].Id);
        List<IMH_AnswerSet__c> lupanswerset = [SELECT Id
                                               ,QuestionSet__c
                                               ,Communication__c
                                               ,Status__c
                                               ,CompletionPercentage__c
                                               FROM IMH_AnswerSet__c 
                                               WHERE Communication__c =:lanswerset_Incentive[0].Communication__c
                                               LIMIT 50000];
        //Checks whether attachment is correctly assigned to parent object
        System.assertEquals([Select ParentId From Attachment].ParentId,lupanswerset[0].Id);   
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2);
    }
  /*****************************************************************************
    * @description: Mehod used for creating questionnaire with warning and attaching file to it
    * @param: none
    * @return: void
    */ 
    static testmethod void questionnaireDisplayWithDeleteAttachment(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
        List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;

        List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        //List<IMH_ResponseValue__c> lresponseErrorMessage = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        insert questionSetForIncentive;
        //System.assertEqulas();
        
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        Database.insert(childquestionsetIncentive,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        // childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
        
        Id pickListQuestionId = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert,false);
        IMH_ResponseValue__c response  = new IMH_ResponseValue__c();
        response.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response.ResponseValue__c = 'Advice has been applied';
        response.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response,false);

         List<Attachment> lattachment = new List<Attachment>();
       //Attachment details
        Blob b = Blob.valueOf('Test Data');
        Attachment attach;
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE    
        Boolean isErrorThrown = false; 
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(sampleAmexIncentive,false);
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__c
                                ,Status__c
                                FROM IMH_AnswerSet__c
                            //where QuestionSet__r.ObjectEntryCriteria__c = 'Incentive'
                            LIMIT 50000];
            
            List<IMH_QuestionWarning__c> lQuestionWarning = new List<IMH_QuestionWarning__c>();
            Id parentquestionId = [SELECT ID FROM IMH_Question__c WHERE QuestionSet__c = :lanswerset_Incentive[0].QuestionSet__c LIMIT 1].Id;
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId, YES, RED,2));
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,NO, AMBER,1));
            Database.insert(lQuestionWarning,false);
         
        //CREATE A PARENT QUESTION    
        
        Test.startTest();
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            ID childquset = [Select id from IMH_QuestionSet__c where ParentQuestionSet__c =:lanswerset_Incentive[0].QuestionSet__c LIMIT 1].ID;
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            attach = new Attachment();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
           	pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = YES;
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            pagecontroller.onChangeOfAnswer();
             attach.ParentId = lanswerset_Incentive[0].Id;
                    attach.Name  = 'Test Attachment for Parent'; 
                    attach.body = b;
                    lattachment.add(attach);
                    Database.insert(lattachment,false);
            for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id)){
                if(tempWrap.isWarning && YES.equalsIgnoreCase(tempWrap.ansWarning.EntryCriteria__c)){
                   tempWrap.warningResponse = 'File evidence to be attached';
                   
                    tempWrap.ansWarning.Detail__c = TEXT_DESCRIPTION;
                    tempWrap.ansWarning.SYSAttachmentId__c = lattachment[0].Id;
                      
                    //isErrorThrown = true;
                }   
            }
             
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[SELECT Id FROM IMH_Answer__c WHERE ArchivedSection__c IN (SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id) LIMIT 1].Id);
            
            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
           
         
             
        Test.stopTest();
        }
        List<IMH_AnswerWarning__c> lanswerwarn = new List<IMH_AnswerWarning__c>();
       lanswerwarn = [SELECT Id,
                             QuestionWarning__c,
                             Status__c,
                             SYSAttachmentId__c
                      FROM IMH_AnswerWarning__c
                      WHERE QuestionWarning__r.Question__c =:pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).question.Id
                      LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
        //Checks whether the file ID gets stored in Answer Warning
        System.assertEquals(lanswerwarn[0].SYSAttachmentId__c,lattachment[0].Id);
        ApexPages.currentPage().getParameters().put('contIdParam',lattachment[0].Id);
            pagecontroller.delAttachment();
            pagecontroller.dummyRender();
        List<IMH_AnswerSet__c> lupanswerset = [SELECT Id
                                               ,QuestionSet__c
                                               ,Communication__c
                                               ,Status__c
                                               ,CompletionPercentage__c
                                               FROM IMH_AnswerSet__c 
                                               //WHERE Incentive__c =:lanswerset_Incentive[0].Incentive__c
                                               LIMIT 5000];
        //Checks whether attachment is correctly assigned to parent object
        //System.assertEquals([Select ParentId From Attachment].ParentId,lupanswerset[0].Id);   
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2);
    }
    
      /*****************************************************************************
    * @description: Mehod used for creating questionnaire with warning and attaching file to it
    *               and chanign the warning status to anything other the File Evidence upload
    * @param: none
    * @return: void
    */ 
    static testmethod void questionnaireChangeWithDeleteAttachment(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
        List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;

        List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        //List<IMH_ResponseValue__c> lresponseErrorMessage = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        insert questionSetForIncentive;
        //System.assertEqulas();
        
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        Database.insert(childquestionsetIncentive,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        // childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
        
        Id pickListQuestionId = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert,false);
        IMH_ResponseValue__c response  = new IMH_ResponseValue__c();
        response.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response.ResponseValue__c = 'Advice has been applied';
        response.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response,false);

         List<Attachment> lattachment = new List<Attachment>();
       //Attachment details
        Blob b = Blob.valueOf('Test Data');
        Attachment attach;
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE    
        Boolean isErrorThrown = false; 
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(sampleAmexIncentive,false);
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__c
                                ,Status__c
                                FROM IMH_AnswerSet__c
                                //where QuestionSet__r.ObjectEntryCriteria__c = 'Incentive'
                            LIMIT 50000];
            
            List<IMH_QuestionWarning__c> lQuestionWarning = new List<IMH_QuestionWarning__c>();
            Id parentquestionId = [SELECT ID FROM IMH_Question__c WHERE QuestionSet__c = :lanswerset_Incentive[0].QuestionSet__c LIMIT 1].Id;
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId, YES, RED,2));
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,NO, AMBER,1));
            Database.insert(lQuestionWarning,false);
         
        //CREATE A PARENT QUESTION    
        
        Test.startTest();
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            ID childquset = [Select id from IMH_QuestionSet__c where ParentQuestionSet__c =:lanswerset_Incentive[0].QuestionSet__c LIMIT 1].ID;
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            attach = new Attachment();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
           pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = YES;
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            pagecontroller.onChangeOfAnswer();
             attach.ParentId = lanswerset_Incentive[0].Id;
                    attach.Name  = 'Test Attachment for Parent'; 
                    attach.body = b;
                    lattachment.add(attach);
                    Database.insert(lattachment,false);
            for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id)){
                if(tempWrap.isWarning && YES.equalsIgnoreCase(tempWrap.ansWarning.EntryCriteria__c)){
                   tempWrap.warningResponse = 'Review Group and Amend';
                   
                    tempWrap.ansWarning.Detail__c = TEXT_DESCRIPTION;
                    tempWrap.ansWarning.SYSAttachmentId__c = lattachment[0].Id;
                }   
            }
             
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[SELECT Id FROM IMH_Answer__c WHERE archivedSection__c IN (SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id) LIMIT 1].Id);
            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
            
        Test.stopTest();
        }
        List<IMH_AnswerWarning__c> lanswerwarn = new List<IMH_AnswerWarning__c>();
       lanswerwarn = [SELECT Id,
                             QuestionWarning__c,
                             Status__c,
                             SYSAttachmentId__c
                      FROM IMH_AnswerWarning__c
                      WHERE QuestionWarning__r.Question__c =:pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).question.Id
                      LIMIT 50000];
        
        //Checks whether the file ID gets stored in Answer Warning
        System.assertEquals(lanswerwarn[0].SYSAttachmentId__c,null);
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2);
    }
    
    /*****************************************************************************
    * @description: Mehod used for creating questionnaire with warning and attaching file but we don't actaully attach it.
    * @param: none
    * @return: void
    */ 
    static testmethod void questionnaireDisplayWithoutAttachment(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
        List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;

        List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        //List<IMH_ResponseValue__c> lresponseErrorMessage = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        insert questionSetForIncentive;
        //System.assertEqulas();
        
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        Database.insert(childquestionsetIncentive,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        // childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
        
        Id pickListQuestionId = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert,false);
        IMH_ResponseValue__c response  = new IMH_ResponseValue__c();
        response.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response.ResponseValue__c = 'Advice has been applied';
        response.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response,false);

         List<Attachment> lattachment = new List<Attachment>();
       //Attachment details
        Blob b = Blob.valueOf('Test Data');
        Attachment attach;
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE    
        Boolean isErrorThrown = false; 
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(sampleAmexIncentive,false);
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__c
                                ,Status__c
                                FROM IMH_AnswerSet__c
                                //where QuestionSet__r.ObjectEntryCriteria__c = 'Incentive'
                            LIMIT 50000];
            
            List<IMH_QuestionWarning__c> lQuestionWarning = new List<IMH_QuestionWarning__c>();
            Id parentquestionId = [SELECT ID FROM IMH_Question__c WHERE QuestionSet__c = :lanswerset_Incentive[0].QuestionSet__c LIMIT 1].Id;
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,YES,RED,2));
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,NO,AMBER,1));
            Database.insert(lQuestionWarning,false);
         
        //CREATE A PARENT QUESTION    
        
        Test.startTest();
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            ID childquset = [Select id from IMH_QuestionSet__c where ParentQuestionSet__c =:lanswerset_Incentive[0].QuestionSet__c LIMIT 1].ID;
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            attach = new Attachment();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
           pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = YES;
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            pagecontroller.onChangeOfAnswer();
             attach.ParentId = lanswerset_Incentive[0].Id;
                    attach.Name  = 'Test Attachment for Parent'; 
                    attach.body = b;
                    lattachment.add(attach);
                    Database.insert(lattachment,false);
            for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id)){
                if(tempWrap.isWarning && YES.equalsIgnoreCase(tempWrap.ansWarning.EntryCriteria__c)){
                   tempWrap.warningResponse = 'File evidence to be attached';
                   tempWrap.ansWarning.Detail__c = TEXT_DESCRIPTION;
                }   
            }
             
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            pagecontroller.onChangeOfAnswer();
            
            pagecontroller.confirmAction();
            for(List<IMH_QuestionnaireWrapperEDIT.QuestionWrapper> tempQuestionSetValues : pagecontroller.qWrapper.mQuestionSetWrapper.values()){
                for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : tempQuestionSetValues){
                    if(Label.IMH_AttachmentOnWarning.equalsIgnoreCase(tempWrap.errorMessage)){
                        isErrorThrown = true;
                    }
                }
            }
         
             
        Test.stopTest();
        }
        List<IMH_AnswerWarning__c> lanswerwarn = new List<IMH_AnswerWarning__c>();
       lanswerwarn = [SELECT Id,
                             QuestionWarning__c,
                             Status__c,
                             SYSAttachmentId__c
                      FROM IMH_AnswerWarning__c
                      WHERE QuestionWarning__r.Question__c =:pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).question.Id
                      AND SYSAttachmentId__c!=NULL
                      LIMIT 50000];
        //Checks whether the file ID gets stored in Answer Warning
        System.assertEquals(lanswerwarn.size(),0);
        //CHEKC WHETHER THE ERROR MESSAGE IS DISPLAYED TO THE USER WHEN THERE IS NO ATTACHMENT
        System.assert(isErrorThrown);
        List<IMH_AnswerSet__c> lupanswerset = [SELECT Id
                                               ,QuestionSet__c
                                               ,Communication__c
                                               ,Status__c
                                               ,CompletionPercentage__c
                                               FROM IMH_AnswerSet__c 
                                               //WHERE Incentive__c =:lanswerset_Incentive[0].Incentive__c
                                               LIMIT 50000];  
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2);
    }
       /*****************************************************************************
    * @description: Mehod used for creating questionnaire with warning and checking Translation
    * @param: none
    * @return: void
    */
     static testmethod void questionnaireDisplayWithWarningTranslation(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('System Administrator','RunningUser',null);
        runningUser.LanguageLocaleKey = 'fr';
        
       List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        //List<IMH_ResponseValue__c> lresponseErrorMessage = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        insert questionSetForIncentive;
        //System.assertEqulas();
        
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        Database.insert(childquestionsetIncentive,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        // childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
        
        Id pickListQuestionId = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert,false);
        IMH_ResponseValue__c response  = new IMH_ResponseValue__c();
        response.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response.ResponseValue__c = 'Advice has been applied';
        response.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response,false);        
         
        List<IMH_Translation__c> translation = new List<IMH_Translation__c>();
       /* Id questionwarningId = [SELECT ID FROM IMH_QuestionWarning__c WHERE EntryCriteria__c = 'Yes' 
                               LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())].Id;*/
        
        IMH_Language__c lang  = new IMH_Language__c(Language_Code__c = 'fr');
        insert lang;
                        
        Id responsevalueId  = [SELECT ID FROM IMH_ResponseValue__c WHERE OrderSequence__c = 2 
                               LIMIT 1].Id;
        //ID lquestID = [Select ID From IMH_QuestionSet__c where ObjectEntryCriteria__c = 'Incentive' AND ParentQuestionSet__c = NULL].Id;
        ID lquestID = [Select ID From IMH_QuestionSet__c where ObjectEntryCriteria__c = 'Communication' LIMIT 1].Id;
        //translation.add(IMH_TestClassUtility.createTranslation((String)IMH_TestClassUtility.mRecordType.get('IMH_Translation__c').get('Question').Id,(String)parentquestionId.Id, (String)responsevalueId, questionwarningId,(String)lang.Id));
        //translation.add(IMH_TestClassUtility.createTranslation((String)IMH_TestClassUtility.mRecordType.get('IMH_Translation__c').get('ResponseValue').Id,parentquestionId.Id, (String)responsevalueId, null,lang.Id));
        //translation.add(IMH_TestClassUtility.createTranslation((String)IMH_TestClassUtility.mRecordType.get('IMH_Translation__c').get('Warning').Id,parentquestionId.Id, (String)responsevalueId, questionwarningId,lang.Id));
        IMH_Translation__c transquest = IMH_TestClassUtility.createTranslation((String)IMH_TestClassUtility.mRecordType.get('IMH_Translation__c').get('QuestionSet').Id,null, null, null,lang.Id);
         transquest.QuestionSetDescription__c = 'Ja habite aa Description';
         transquest.QuestionSetName__c = 'Je mapple French Name';
         transquest.QuestionSet__c = lquestID;
         translation.add(transquest);
         insert translation;       
         
         List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE    
        Boolean isErrorThrown = false; 
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(sampleAmexIncentive,false);
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__c
                                ,Status__c
                                FROM IMH_AnswerSet__c
                                //where QuestionSet__r.ObjectEntryCriteria__c = 'Incentive'
                            LIMIT 50000];
            List<IMH_QuestionWarning__c> lQuestionWarning = new List<IMH_QuestionWarning__c>();
            Id parentquestionId = [SELECT ID FROM IMH_Question__c WHERE QuestionSet__c = :lanswerset_Incentive[0].QuestionSet__c 
                                   LIMIT 1].Id;
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId, YES, RED,1));
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,NO, AMBER,2));
            Database.insert(lQuestionWarning,false);
         
        //CREATE A PARENT QUESTION    
        
        Test.startTest();
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            ID childquset = [Select id from IMH_QuestionSet__c where ParentQuestionSet__c =:lanswerset_Incentive[0].QuestionSet__c LIMIT 1].ID;
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
           pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = YES;
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            pagecontroller.onChangeOfAnswer();
            
            for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id)){
                if(tempWrap.isWarning && YES.equalsIgnoreCase(tempWrap.ansWarning.EntryCriteria__c)){
                   tempWrap.warningResponse = RAISE_EXCEPTION;
                    //tempWrap.ansWarning.Detail__c = TEXT_DESCRIPTION;
                    //isErrorThrown = true;
                }   
            }
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',[Select id from IMH_Answer__c where AnswerSet__c =:lanswerset_Incentive[0].Id LIMIT 1].ID);

            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
            for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id)){
                if(tempWrap.isWarning && YES.equalsIgnoreCase(tempWrap.ansWarning.EntryCriteria__c) && String.isNotBlank(tempWrap.errorMessage)){
                    tempWrap.warningResponse = RAISE_EXCEPTION;
                    tempWrap.ansWarning.Detail__c = TEXT_DESCRIPTION;
                    isErrorThrown = true;
               }
            }
            
            pagecontroller.confirmAction();
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.lQuestionWrapper){
                tempWrap.getPickListValues();
            }
        Test.stopTest();
        }
        List<IMH_AnswerSet__c> lupanswerset = [SELECT Id
                                               ,QuestionSet__c
                                               ,Communication__c
                                               ,Status__c
                                               ,CompletionPercentage__c
                                               FROM IMH_AnswerSet__c 
                                               //WHERE Incentive__c =:lanswerset_Incentive[0].Incentive__c
                                               LIMIT 50000];
        // CHECK THE ANSWERSET STATUS SINCE SECOND QUESTION IS NOT ANSWERED YET - IN PROGRESS
        System.assertEquals('In Progress',lupanswerset[0].Status__c);   
        system.assert(isErrorThrown);
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2);
         //Question Set Name Check
         
         System.assertEquals(runningUser.LanguageLocaleKey,'fr');
         System.assertEquals(pagecontroller.ansset.QuestionnaireName_UserLang__c,'Ja habite aa Description');
         System.assertEquals(pagecontroller.ansset.QuestionnaireDescription_UserLang__c,'Je mapple French Name');
    }
    /*****************************************************************************
    * @description: Method used for covering the case when we have the Question Set is created for Pre Execution Questionnaire
    * @param: none
    * @return: void
    */
    static testMethod void createPreExecutionQuestion() {
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
        List<IMH_AnswerSet__c> lansset = new List<IMH_AnswerSet__c>();
        List<IMH_Communication__c> lpreexecution = new List<IMH_Communication__c>();
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE  
         List<IMH_QuestionSet__c> ldeleteanswer = [Select Id From IMH_QuestionSet__c LIMIT 50000];
            delete ldeleteanswer;   
        //TestData for QuestionSet Object
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME));
            lquestionset[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').Id;
             lquestionset[i].Active__c = true;
        }
        Database.insert (lquestionset,false);
        IMH_CommunicationTriggerHandler.isExecutedAfter = false;
       IMH_QuestionSet__c childquestionsetCheck = new IMH_QuestionSet__c();
            childquestionsetCheck=IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
            childquestionsetCheck.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
            childquestionsetCheck.ParentQuestionSet__c = lquestionset[0].Id;
            childquestionsetCheck.OrderSequence__c = 1;
            childquestionsetCheck.Active__c = true;
        
        insert childquestionsetCheck;
         
       
        //Entry Criteria Logics
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','ProcessStage__c','Pre-Execution Testing'));     
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetCheck.Id,'Communication','SYS_IncentiveType__c','Message;Incentive')); 
        insert lentrycriteria; 
        system.runAs(runningUser){ 
            
            
            
        /*List<IMH_Communication__c> lcampaign = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++)
        {
             lcampaign.add(IMH_TestClassUtility.createCommunication('Concept',STATUS_NAME,MARKET_NAME));
        }
        Database.insert(lcampaign,false);*/
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication('Concept',STATUS_NAME,MARKET_NAME);
       insert sampleAmexCommunication;         
        IMH_Incentive__c offer = new IMH_Incentive__c();
        offer = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        offer.IncentiveType__c = 'Message';
        //Database.Insert(offer,false); 
        Insert offer;
        IMH_Incentive__c offer1 = (IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress',sampleAmexCommunication.Id));
        offer1.IncentiveType__c = 'Incentive';    
       // IMH_IncentiveTriggerHandler.isExecutedAfter = false; 
        //Database.Insert(offer1,false);   
        Insert offer1;
        IMH_CommunicationTriggerHandler.isExecutedAfter = false;
         /*lpreexecution = [Select Id,ReviewStatus__c,ProcessStage__c,SYS_IncentiveType__c From IMH_Communication__c
                                                Where Id IN :lcampaign];  
         lpreexecution[0].ProcessStage__c = 'Pre-Execution Testing'; 
         Database.update(lpreexecution[0],false); */
         //System.assertEquals(lpreexecution[0].SYS_IncentiveType__c,'');   
          lansset = [SELECT Id,
                           Status__c,
                            QuestionSet__c,
                            Communication__r.SYS_IncentiveType__c,
                            Communication__c,
                            CompletionPercentage__c
                    FROM IMH_AnswerSet__c 
                    //WHERE Communication__c =:lpreexecution[0].ID
                    LIMIT 50000]; 
            //System.assertEquals(lansset[0].Communication__c,lpreexecution[0].ID);
            IMH_QuestionnaireController pagecontroller;
        Test.startTest(); 
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lansset[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lansset[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lansset[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
        }
        
        Test.stopTest();
        //Assert to Check whether Answer Set for Communication are  created with proper status and completion percentage      
        System.assertEquals(0, lansset[0].CompletionPercentage__c);
        //System.assertEquals(lansset[0].  Communication__r.SYS_IncentiveType__c,'Message;Incentive');    
    }
     /*****************************************************************************
    * @description: Mehod used for creating questionnaire with Amber warning having appropriate Entry Criteria
    * @param: none
    * @return: void
    */
    static testmethod void questionnaireDisplayWithWarningEntry(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
        
        List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;

       List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        //List<IMH_ResponseValue__c> lresponseErrorMessage = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        insert questionSetForIncentive;
        //System.assertEqulas();
        
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        Database.insert(childquestionsetIncentive,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        // childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
        
        Id pickListQuestionId = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert,false);
        IMH_ResponseValue__c response  = new IMH_ResponseValue__c();
        response.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response.ResponseValue__c = 'Advice has been applied';
        response.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response,false);   

         //List<SelectOption> lSelectOptionToAssert;
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE    
        //Boolean isErrorThrown = false; 
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(sampleAmexIncentive,false);
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__c
                                ,Status__c
                                FROM IMH_AnswerSet__c
                                //where QuestionSet__r.ObjectEntryCriteria__c = 'Incentive'
                            LIMIT 50000];
         List<IMH_QuestionWarning__c> lQuestionWarning = new List<IMH_QuestionWarning__c>();
            Id parentquestionId = [SELECT ID FROM IMH_Question__c WHERE QuestionSet__c = :lanswerset_Incentive[0].QuestionSet__c LIMIT 1].Id;
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,YES,RED,1));
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,NO,AMBER,2));
            Database.insert(lQuestionWarning,false);
        //CREATE a entry criteria for Question Warning  
        List<IMH_EntryCriteria__c> lqwentry = new List<IMH_EntryCriteria__c>();
           lqwentry.add(IMH_TestClassUtility.createEntryCriteria(null,'Communication','TargetMarket__c',MARKET_NAME));
           lqwentry.add(IMH_TestClassUtility.createEntryCriteria(null,'Communication','TargetMarket__c',MARKET_NAME)); 
        Database.insert(lqwentry,false);
         
        List<IMH_EntryCriteria__c> lupdateqwentry = new List<IMH_EntryCriteria__c>();
            integer I = 0;
            for(IMH_EntryCriteria__c entry : [Select id,QuestionWarning__c
                                              FROM IMH_EntryCriteria__c
                                              WHERE ID IN:lqwentry LIMIT 50000]){
                                                  if(I < 1){
                                                        entry.QuestionWarning__c = lQuestionWarning[0].Id;  
                                                  }                
                                                  else{
                                                     entry.QuestionWarning__c = lQuestionWarning[1].Id;  
                                                  } 
                   I++;
                  lupdateqwentry.add(entry);                                
            }
           update lupdateqwentry;    
        
        Test.startTest();
            ID childquset = [Select id from IMH_QuestionSet__c where ParentQuestionSet__c =:lanswerset_Incentive[0].QuestionSet__c LIMIT 1].ID;
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
            pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = NO;
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Id);

            pagecontroller.onChangeOfAnswer();
            
           for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id)){
                if(tempWrap.isWarning && YES.equalsIgnoreCase(tempWrap.ansWarning.EntryCriteria__c)){
                    tempWrap.warningResponse = RAISE_EXCEPTION;
                    tempWrap.ansWarning.Detail__c = TEXT_DESCRIPTION;
                }
            }
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Id);

            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            pagecontroller.qWrapper.lQuestionWrapper[0].answer.Answer__c = 'None';
            ApexPages.currentPage().getParameters().put('selectedQID',pagecontroller.qWrapper.lQuestionWrapper[0].answer.Id);
            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
            pagecontroller.exitAction();
        Test.stopTest();
        }
         List<IMH_AnswerWarning__c> lanswerwarn = new List<IMH_AnswerWarning__c>();
        //Queries the answer warning if present
       lanswerwarn = [SELECT Id,
                             QuestionWarning__c,
                             Status__c
                      FROM IMH_AnswerWarning__c
                      WHERE QuestionWarning__r.Question__c =:pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).question.Id
                      LIMIT 50000];
        //System.assertEquals(lanswerwarn,null);
      //Assertion to check whether the Exception is raised.
      System.assertEquals('N/A',lanswerwarn[0].Status__c);
        List<IMH_AnswerSet__c> lupanswerset = [SELECT Id
                                               ,QuestionSet__c
                                               ,Communication__c
                                               ,Status__c
                                               ,CompletionPercentage__c
                                               FROM IMH_AnswerSet__c 
                                               WHERE Communication__c =:lanswerset_Incentive[0].Communication__c
                                               LIMIT 50000];
        // CHECK THE ANSWERSET STATUS SINCE SECOND QUESTION IS NOT ANSWERED YET - IN PROGRESS
        System.assertEquals('In Progress',lupanswerset[0].Status__c);   
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2);
    }
     /*****************************************************************************
    * @description: Method used for creating questionnaire with Amber warning and associating Entry Critrea that
    *               doesn't matches the Object Entry. 
    * @param: none
    * @return: void
    */
    /*static testmethod void questionWarningEntryCriteria(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
        
        List<IMH_AnswerSet__c> lanswerset_Incentive = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;

       List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        //List<IMH_ResponseValue__c> lresponseErrorMessage = new List<IMH_ResponseValue__c>();
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        insert questionSetForIncentive;
        //System.assertEqulas();
        
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        Database.insert(childquestionsetIncentive,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Communication','CommunicationRecordType__c','Marketing Communication'));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childquestionsetIncentive.Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 2,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childquestionsetIncentive.Id, 3,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(PICKLIST).Id);
        // childQuestion.DependentQuestion__c = parentquestion.ID;
        childQuestion.DependentQuestionEntryCriteria__c = YES;
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
        
        Id pickListQuestionId = [SELECT Id FROM IMH_Question__c WHERE RecordType.DeveloperName = :PICKLIST LIMIT 1].Id;
        for(Integer i=0; i<3;i++){
            responseValuestoInsert.add(IMH_TestClassUtility.createResponseValues(pickListQuestionId, RESPONSE_VALUE+i, i));
        }
        Database.insert(responseValuestoInsert,false);
        IMH_ResponseValue__c response  = new IMH_ResponseValue__c();
        response.RecordTypeId = IMH_TestClassUtility.mRecordType.get(IMH_RESPONSE_API).get(QUESTION_WARNING).Id;
        response.ResponseValue__c = 'Advice has been applied';
        response.Text__c = 'Please provide a detailed explanation outlining why an exception is being sought';
        Database.insert(response,false);   

         //List<SelectOption> lSelectOptionToAssert;
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE    
        //Boolean isErrorThrown = false; 
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(sampleAmexCommunication,false);
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(sampleAmexIncentive,false);
        lanswerset_Incentive = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__c
                                ,Status__c
                                FROM IMH_AnswerSet__c
                               // where QuestionSet__r.ObjectEntryCriteria__c = 'Incentive'
                            LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
         List<IMH_QuestionWarning__c> lQuestionWarning = new List<IMH_QuestionWarning__c>();
            Id parentquestionId = [SELECT ID FROM IMH_Question__c WHERE QuestionSet__c = :lanswerset_Incentive[0].QuestionSet__c 
                                   LIMIT 1].Id;
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,YES,RED,1));
            lQuestionWarning.add(IMH_TestClassUtility.createQuestionWarning(parentquestionId,NO,AMBER,2));
            Database.insert(lQuestionWarning,false);
        //CREATE a entry criteria for Question Warning  
        List<IMH_EntryCriteria__c> lqwentry = new List<IMH_EntryCriteria__c>();
           lqwentry.add(IMH_TestClassUtility.createEntryCriteria(null,'Incentive','TargetMarket__c','ABC'));
           lqwentry.add(IMH_TestClassUtility.createEntryCriteria(null,'Incentive','TargetMarket__c','ABC')); 
        Database.insert(lqwentry,false);
         
        List<IMH_EntryCriteria__c> lupdateqwentry = new List<IMH_EntryCriteria__c>();
            integer I = 0;
            for(IMH_EntryCriteria__c entry : [Select id,QuestionWarning__c
                                              FROM IMH_EntryCriteria__c
                                              WHERE ID IN:lqwentry]){
                                                  if(I < 1){
                                                        entry.QuestionWarning__c = lQuestionWarning[0].Id;  
                                                  }                
                                                  else{
                                                     entry.QuestionWarning__c = lQuestionWarning[1].Id;  
                                                  } 
                   I++;
                  lupdateqwentry.add(entry);                                
            }
           update lupdateqwentry;
       Test.startTest();
            ID childquset = [Select id from IMH_QuestionSet__c where ParentQuestionSet__c =:lanswerset_Incentive[0].QuestionSet__c LIMIT 1].ID;
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Incentive[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Incentive[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Incentive[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
            if(pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id) != NULL)
              pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Answer__c = NO;
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
            //ApexPages.currentPage().getParameters().put('selectedQID',pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Id);

            pagecontroller.onChangeOfAnswer();
            
           for(IMH_QuestionnaireWrapperEDIT.QuestionWrapper tempWrap : pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id)){
                if(tempWrap.isWarning && YES.equalsIgnoreCase(tempWrap.ansWarning.EntryCriteria__c)){
                    tempWrap.warningResponse = RAISE_EXCEPTION;
                    tempWrap.ansWarning.Detail__c = TEXT_DESCRIPTION;
                }
            }
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Incentive[0].Id LIMIT 1].Id);
           // ApexPages.currentPage().getParameters().put('selectedQID',pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0).answer.Id);

            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
            
            pagecontroller.exitAction();
        Test.stopTest();
        }
      //System.assertEquals((pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Incentive[0].Id).get(0),null);
         List<IMH_AnswerWarning__c> lanswerwarn = new List<IMH_AnswerWarning__c>();
        //Queries the answer warning if present
       lanswerwarn = [SELECT Id,
                             QuestionWarning__c,
                             Status__c
                      FROM IMH_AnswerWarning__c];
        System.assertEquals(lanswerwarn.isEmpty(),true);
        List<IMH_AnswerSet__c> lupanswerset = [SELECT Id
                                               ,QuestionSet__c
                                               ,Communication__c
                                               ,Status__c
                                               ,CompletionPercentage__c
                                               FROM IMH_AnswerSet__c 
                                               //WHERE Incentive__c =:lanswerset_Incentive[0].Incentive__c
                                               LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
        // CHECK THE ANSWERSET STATUS SINCE SECOND QUESTION IS NOT ANSWERED YET - IN PROGRESS
        System.assertEquals('Not Started',lupanswerset[0].Status__c);  
    }*/
    
    
    
    
     /*****************************************************************************
    * @description: Mehod used for testing the systematic update of the questionnaire
    * @param: none
    * @return: void
    */
    static testmethod void systematicUpdateOfQuestionnaireStatus(){
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUser',null);
        
        List<IMH_AnswerSet__c> lanswerset_Communication = new List<IMH_AnswerSet__c>();
        IMH_QuestionnaireController pagecontroller;

        List<IMH_Question__c> lQuestionsToBeInserted = new List<IMH_Question__c>();
        List<IMH_ResponseValue__c> responseValuestoInsert = new List<IMH_ResponseValue__c>();
        
        // CREATE A QUESTION SET FOR OFFER ANSWER SET TO GET CREATED
        questionSetForIncentive =  IMH_TestClassUtility.createQuestionSet(COMMUNICATION_NAME);
        insert questionSetForIncentive;
        List<IMH_QuestionSet__c> childQSetToInsert = new List<IMH_QuestionSet__c>();
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        childQSetToInsert.add(childquestionsetIncentive);
        childquestionsetIncentive = IMH_TestClassUtility.createQuestionSet(INCENTIVE_NAME);
        childquestionsetIncentive.RecordTypeID = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').Id;
        childquestionsetIncentive.ParentQuestionSet__c = questionSetForIncentive.Id;
        childQSetToInsert.add(childquestionsetIncentive);
        Database.insert(childQSetToInsert,false);
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','TargetMarket__c',MARKET_NAME));
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','ProcessStage__c','Concept'));
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(questionSetForIncentive.Id,'Communication','ReviewStage__c','Attestation'));
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childQSetToInsert.get(0).Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(childQSetToInsert.get(1).Id,'Incentive','IncentiveType__c','Existing Offer Construct Type'));
        
        insert lentrycriteria;
               
        IMH_Question__c parentQuestion = new IMH_Question__c();
        parentquestion = IMH_TestClassUtility.createQuestion((ID)questionSetForIncentive.Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        Database.insert(parentquestion,false);
        //CREATE A DEPENDET QUESTION
        IMH_Question__c childQuestion = new IMH_Question__c();
        childQuestion = IMH_TestClassUtility.createQuestion((ID)childQSetToInsert.get(0).Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        lQuestionsToBeInserted.add(childQuestion);
        childQuestion = new IMH_Question__c();
        
        childQuestion= IMH_TestClassUtility.createQuestion((ID)childQSetToInsert.get(0).Id, 1,IMH_TestClassUtility.mRecordType.get(IMH_QUESTION_API).get(YES_NO_NA).Id);
        lQuestionsToBeInserted.add(childQuestion);
        Database.insert(lQuestionsToBeInserted,false);
         

        
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE    
        
        system.runAs(runningUser){
        // CREATE A CAMPAIGN TO RELATE OFFERS TO IT
        sampleAmexCommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        sampleAmexCommunication.ReviewStage__c = 'Design';
        Database.insert(sampleAmexCommunication,false);
        
        sampleAmexIncentive = IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress', sampleAmexCommunication.Id);
        sampleAmexIncentive.IncentiveType__c = 'New Offer Construct Type';
        Database.insert(sampleAmexIncentive,false);
        IMH_CommunicationTriggerHandler.iscreatedAnswerSet = false;
        IMH_CommunicationTriggerHandler.isExecutedAfter = false;
        sampleAmexCommunication.ReviewStage__c = 'Attestation';
        Database.update(sampleAmexCommunication,false);
        lanswerset_Communication = [SELECT Id
                                ,QuestionSet__c
                                ,Communication__c
                                ,Status__c
                                FROM IMH_AnswerSet__c
                                WHERE QuestionSet__c = :questionSetForIncentive.Id
                            LIMIT 50000];
        
        Test.startTest();
            ID childquset = [Select id from IMH_QuestionSet__c where ParentQuestionSet__c =:lanswerset_Communication[0].QuestionSet__c LIMIT 1].ID;
            Test.setCurrentPage(QUESTIONNAIRE_PAGE);
            //PASS THE REQUIRED PARAMTER TO QUERY THE QUESTIONS RELATED AND PAGE MODE
            ApexPages.currentPage().getParameters().put(QID,lanswerset_Communication[0].QuestionSet__c);
            ApexPages.currentPage().getParameters().put(ID,lanswerset_Communication[0].Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lanswerset_Communication[0].Communication__c);
            ApexPages.currentPage().getParameters().put(PAGE_MODE,START);
            pagecontroller = new IMH_QuestionnaireController();
            pagecontroller.createAnswersOnLoad();
            //CHANGE THE ANSWER FOR CHECKING THE ONCHANGE PAGEREFERENCE METHOD
            pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Communication[0].Id).get(0).answer.Answer__c = NO;
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Communication[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',pagecontroller.qWrapper.mQuestionSetWrapper.get(lanswerset_Communication[0].Id).get(0).question.Id);
            pagecontroller.onChangeOfAnswer();
            
            pagecontroller.qWrapper.mQuestionSetWrapper.get([SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Communication[0].Id LIMIT 1].Id).get(0).answer.Answer__c = NO;
            ApexPages.currentPage().getParameters().put('selectedQuestionSetId',[SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Communication[0].Id LIMIT 1].Id);
            ApexPages.currentPage().getParameters().put('selectedQID',pagecontroller.qWrapper.mQuestionSetWrapper.get([SELECT Id FROM IMH_ArchivedSection__c WHERE ArchivedQuestionnaire__c = :lanswerset_Communication[0].Id LIMIT 1].Id).get(0).question.Id);

            pagecontroller.onChangeOfAnswer();
            pagecontroller.confirmAction();
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            sampleAmexIncentive.IncentiveType__c = 'Existing Offer Construct Type';
            Database.update(sampleAmexIncentive,false);
        Test.stopTest();
        }
        
        List<IMH_AnswerSet__c> lupanswerset = [SELECT Id
                                               ,QuestionSet__c
                                               ,Communication__c
                                               ,Status__c
                                               ,CompletionPercentage__c
                                               FROM IMH_AnswerSet__c 
                                               LIMIT 50000];
        // CHECK THE ANSWERSET STATUS SINCE SECOND QUESTION IS NOT ANSWERED YET - IN PROGRESS
        System.assertEquals('In Progress',lupanswerset[0].Status__c);   
        // CHECK THE ANSWERSET WRAPPER SIZE SINCE THERE WERE THREE QUESIONS WITH ACTIVE STAGE
        System.assertEquals(pagecontroller.qWrapper.mQuestionSetWrapper.size(),2);
    }
}