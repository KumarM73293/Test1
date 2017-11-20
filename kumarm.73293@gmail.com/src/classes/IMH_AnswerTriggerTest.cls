/** 3 methods
* @author Accenture IDC 
* @date 05/27/2015
* @group Answer
* @group-content N/A
* @description: iMH Release 1 (Sprint 1) - Test Class for Trigger on Answer object which looks for the after insert and after update event 
* logic has been triggered on particular event of an object.
*/
@isTest
private class IMH_AnswerTriggerTest {
    private static final String OFFER_TYPE = 'Message';
    private static final String STAGE_NAME = 'Concept';
    private static final String STATUS_NAME = 'In Progress';
    private static final String MARKET_NAME = 'Thailand';
    private static final String MARKET_MULTI_NAME = 'Australia;Thailand';
    private static final String OBJECT_NAME = 'Communication'; 
    private static final String OFFEROBJ_NAME = 'Incentive';
    private static final String FIELD_NAME = 'MarketingOpsRqd__c';
    private static Final String CREATE_NAME = 'CreativeDesign';
    private static Final String QUESTION_ACTION_REQ_APPROVER = 'RequiredApprovers__c';
    private static Final String CREATIVE_API_NAME = 'IMH_CommCreative__c';
    private static Final String COMPLIANCE = 'Compliance';
    private static Final String RECORDTYPE_QUESTION_API = 'IMH_Question__c';
    private static Final String OFFER_FIELD_API = 'Incentive';
    private static Final String COMPLETED_ANSWER = 'Completed';
    private static Final String OFFER_FIELD_NAME = 'IncentiveType__c';
    private static Final String QUEUE_CENTRAL_OFFGOV = 'Central Incentive Governance';
    private static Final String QUEUE_CENTRAL_BRAND = 'Central Brand';
    private static final String CAMPAIGN_SUBMITTER_PROFILE = 'iMH Campaign Submitter';
    private static final String RUNNING_USER = 'RunningUser';

    /**
    * @description  - Method to validate the question action with multiple values as entry criteria and to validate the case insensitive
    * @param  - None
    * @return  - None
    */
    static testMethod void multipleValuesCaseInsensitiveCheck() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTION    
        system.runAs(runningUser){
        List<IMH_AnswerSet__c> lansset = new List<IMH_AnswerSet__c>();
        //CREATE QUESTION SET RECORD
        
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        }
       Database.insert (lquestionset,false);
        //Entry Criteria Logics
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));  
        insert lentrycriteria;   
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
        for(Integer i=0;i<2;i++){
            lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
        }
        Database.insert(lquestion,false);
        
        //CREATE QUESTION ACTION RECORDS FOR BULK TESTING
        List<IMH_QuestionAction__c> lquestionaction = new List<IMH_QuestionAction__c>();
        lquestionaction.add(IMH_TestClassUtility.createQuestionAction('Manual;AUTO',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[0].Id,'GCP HR'));
        lquestionaction.add(IMH_TestClassUtility.createQuestionAction('Auto matic',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[0].Id,'Compliance'));
        Database.insert(lquestionaction,false);
        IMH_EntryCriteria__c tempEntry = new  IMH_EntryCriteria__c();
        lentrycriteria = new List<IMH_EntryCriteria__c>();
        for(Integer i=0; i<2; i++){
               tempEntry = IMH_TestClassUtility.createEntryCriteria(null,'Communication','TargetMarket__c',MARKET_NAME); 
               tempEntry.QuestionAction__c =lquestionaction[i].Id;
               lentrycriteria.add(tempEntry);  
        }    
        insert lentrycriteria;     
        
        //ASSERT IF QUESTION RECORDS ARE CREATED WITH EXPECTED RESULTS - MAKING SURE NO DUPLICATE ACTIONS
        System.assertEquals(2,lquestionaction.size());
        
        //CREATE A CAMPAIGN TO GET ANSWER SET CREATED BY TRIGGER 
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<2;i++){
            lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
         IMH_CommunicationTriggerHandler.iscreatedAnswerSet = false;
            IMH_CommunicationTriggerHandler.isExecutedAfter = false;   
        Database.insert (lcommunication,false);
        // System.debug('*** 2TEST '+lcommunication);
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<2;i++){            
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[i].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATE_NAME).Id));
        }
            
       insert lcreative;
        //System.debug('*** 3TEST '+lcommunication);
        //lansset = [SELECT Id FROM IMH_AnswerSet__c WHERE Creative__c IN :lcreative];
       lansset = [SELECT Id FROM IMH_AnswerSet__c LIMIT 50000];
        
        Test.startTest();
        //CREATE ANSWER RECORDS WITH ANSWER THAT MEETS QUESTION ACTION CRITERIA
        List<IMH_Answer__c> lanswer = new List<IMH_Answer__c>();
        lanswer.add(IMH_TestClassUtility.createAnswer('Auto',COMPLETED_ANSWER,lansset[0].id,lquestion[0].Id));
        lanswer.add(IMH_TestClassUtility.createAnswer('Manual',COMPLETED_ANSWER,lansset[1].id,lquestion[1].Id));
        Database.insert(lanswer,false);
        
        
        List<IMH_CommCreative__c> lupdatecreate = [SELECT Id,Communication__r.RequiredApprovers__c
                                             FROM IMH_CommCreative__c
                                             WHERE Id IN:lcreative
                                              LIMIT 50000];
        Test.stopTest();
        
        // ASSERT THE EXPECTED SIZE OF THE CAMPAIGN FROM QUERY ABOVE
        System.assertEquals(2,lanswer.size());
        System.assertEquals(lupdatecreate.get(0).Communication__r.RequiredApprovers__c,'GCP HR');    
        System.assertEquals(2, lupdatecreate.size());
        }  
    }
    
    /**
    * @description  - Method to validate the question action with multiple values as entry criteria and with switching answer
    * @param  - None
    * @return  - None
    */
    static testMethod void multipleValuesSwitchingtheAnswer() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
        List<IMH_AnswerSet__c> lansset = new List<IMH_AnswerSet__c>();
        //CREATE QUESTION SET RECORD
        
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        }
       Database.insert (lquestionset,false);
           // System.debug('*** 1TEST '+lquestionset);
        //Entry Criteria Logics
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));  
        insert lentrycriteria;   
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
        for(Integer i=0;i<2;i++){
            lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
        }
        Database.insert(lquestion,false);
        
        //CREATE QUESTION ACTION RECORDS FOR BULK TESTING
        List<IMH_QuestionAction__c> lquestionaction = new List<IMH_QuestionAction__c>();
        lquestionaction.add(IMH_TestClassUtility.createQuestionAction('Manual;Auto',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[0].Id,'GCP HR'));
        lquestionaction.add(IMH_TestClassUtility.createQuestionAction('Reverse;Forward',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[0].Id,'Compliance'));
        Database.insert(lquestionaction,false);
        IMH_EntryCriteria__c tempEntry = new  IMH_EntryCriteria__c();
        lentrycriteria = new List<IMH_EntryCriteria__c>();
        for(Integer i=0; i<2; i++){
               tempEntry = IMH_TestClassUtility.createEntryCriteria(null,'Communication','TargetMarket__c',MARKET_NAME); 
               tempEntry.QuestionAction__c =lquestionaction[i].Id;
               lentrycriteria.add(tempEntry);  
        }    
        insert lentrycriteria;     
        
        //ASSERT IF QUESTION RECORDS ARE CREATED WITH EXPECTED RESULTS - MAKING SURE NO DUPLICATE ACTIONS
        System.assertEquals(2,lquestionaction.size());
        
        //CREATE A CAMPAIGN TO GET ANSWER SET CREATED BY TRIGGER 
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<2;i++){
            lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
         IMH_CommunicationTriggerHandler.iscreatedAnswerSet = false;
            IMH_CommunicationTriggerHandler.isExecutedAfter = false;   
        Database.insert (lcommunication,false);
        // System.debug('*** 2TEST '+lcommunication);
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<2;i++){            
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[i].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATE_NAME).Id));
        }
            
       insert lcreative;
        //System.debug('*** 3TEST '+lcommunication);
        //lansset = [SELECT Id FROM IMH_AnswerSet__c WHERE Creative__c IN :lcreative];
       lansset = [SELECT Id FROM IMH_AnswerSet__c LIMIT 1];
        
        Test.startTest();
        //CREATE ANSWER RECORDS WITH ANSWER THAT MEETS QUESTION ACTION CRITERIA
            List<IMH_Answer__c> lanswer = new List<IMH_Answer__c>();
            lanswer.add(IMH_TestClassUtility.createAnswer('Auto',COMPLETED_ANSWER,lansset[0].id,lquestion[0].Id));
            Database.insert(lanswer,false);
        
        
        List<IMH_CommCreative__c> lupdatecreate = [SELECT Id,Communication__r.RequiredApprovers__c
                                             FROM IMH_CommCreative__c
                                             WHERE Id IN:lcreative
                                              LIMIT 50000];
        System.assertEquals(lupdatecreate.get(0).Communication__r.RequiredApprovers__c,'GCP HR');    
                   
        //CREATE ANSWER RECORDS WITH ANSWER THAT MEETS QUESTION ACTION CRITERIA
            lanswer[0].Answer__c = 'Reverse';
            Database.update(lanswer,false);
        Test.stopTest();    
        //QUERY LIST OF UPDATED CAMPAIGN WITH RESPECTIVE UPDATE FIELD VALUE IN WHERE CLAUSE
        lupdatecreate = [SELECT Id,Communication__r.RequiredApprovers__c
                                             FROM IMH_CommCreative__c
                                             WHERE Id IN:lcreative
                                              LIMIT 1];
        
        
        
        System.assertEquals(lupdatecreate.get(0).Communication__r.RequiredApprovers__c,'Compliance');    
        
        }  
    }
    
    /**
    * @description  - Method to validate the question action with multiple values as entry criteria
    * @param  - None
    * @return  - None
    */
    static testMethod void multipleValuesOnQuestionAction() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
        List<IMH_AnswerSet__c> lansset = new List<IMH_AnswerSet__c>();
        //CREATE QUESTION SET RECORD
        
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        }
       Database.insert (lquestionset,false);
           // System.debug('*** 1TEST '+lquestionset);
        //Entry Criteria Logics
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));  
        insert lentrycriteria;   
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
        for(Integer i=0;i<2;i++){
            lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
        }
        Database.insert(lquestion,false);
        
        //CREATE QUESTION ACTION RECORDS FOR BULK TESTING
        List<IMH_QuestionAction__c> lquestionaction = new List<IMH_QuestionAction__c>();
        lquestionaction.add(IMH_TestClassUtility.createQuestionAction('Yes;No',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[0].Id,COMPLIANCE));
        lquestionaction.add(IMH_TestClassUtility.createQuestionAction('Yes',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[1].Id,'GCP'));
        Database.insert(lquestionaction,false);
        IMH_EntryCriteria__c tempEntry = new  IMH_EntryCriteria__c();
        lentrycriteria = new List<IMH_EntryCriteria__c>();
        for(Integer i=0; i<2; i++){
               tempEntry = IMH_TestClassUtility.createEntryCriteria(null,'Communication','TargetMarket__c',MARKET_NAME); 
               tempEntry.QuestionAction__c =lquestionaction[i].Id;
               lentrycriteria.add(tempEntry);  
        }    
        insert lentrycriteria;     
        
        //ASSERT IF QUESTION RECORDS ARE CREATED WITH EXPECTED RESULTS - MAKING SURE NO DUPLICATE ACTIONS
        System.assertEquals(2,lquestionaction.size());
        
        //CREATE A CAMPAIGN TO GET ANSWER SET CREATED BY TRIGGER 
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<2;i++){
            lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
         IMH_CommunicationTriggerHandler.iscreatedAnswerSet = false;
            IMH_CommunicationTriggerHandler.isExecutedAfter = false;   
        Database.insert (lcommunication,false);
        // System.debug('*** 2TEST '+lcommunication);
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<2;i++){            
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[i].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATE_NAME).Id));
        }
            
       insert lcreative;
        //System.debug('*** 3TEST '+lcommunication);
        //lansset = [SELECT Id FROM IMH_AnswerSet__c WHERE Creative__c IN :lcreative];
       lansset = [SELECT Id FROM IMH_AnswerSet__c LIMIT 50000];
        
        Test.startTest();
        //CREATE ANSWER RECORDS WITH ANSWER THAT MEETS QUESTION ACTION CRITERIA
        List<IMH_Answer__c> lanswer = new List<IMH_Answer__c>();
        lanswer.add(IMH_TestClassUtility.createAnswer('Yes',COMPLETED_ANSWER,lansset[0].id,lquestion[0].Id));
        lanswer.add(IMH_TestClassUtility.createAnswer('No',COMPLETED_ANSWER,lansset[1].id,lquestion[1].Id));
        Database.insert(lanswer,false);
        
        //QUERY LIST OF UPDATED CAMPAIGN WITH RESPECTIVE UPDATE FIELD VALUE IN WHERE CLAUSE
        List<IMH_CommCreative__c> lupdatecreate = [SELECT Id,Communication__r.RequiredApprovers__c
                                             FROM IMH_CommCreative__c
                                             WHERE Id IN:lcreative
                                              LIMIT 50000];
        Test.stopTest();
        
        // ASSERT THE EXPECTED SIZE OF THE CAMPAIGN FROM QUERY ABOVE
        System.assertEquals(2,lanswer.size());
        System.assertEquals(lupdatecreate.get(0).Communication__r.RequiredApprovers__c,COMPLIANCE);    
        System.assertEquals(2, lupdatecreate.size());
        }  
    }
   
   /**
    * @description  - Method used for checking whether field is updated on Creative When answer is created
    * @param  - none
    * @return  - none
    */  
    static testMethod void answerCommunicationTestMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
        List<IMH_AnswerSet__c> lansset = new List<IMH_AnswerSet__c>();
        //CREATE QUESTION SET RECORD
        
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        }
       Database.insert (lquestionset,false);
           // System.debug('*** 1TEST '+lquestionset);
        //Entry Criteria Logics
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));  
        insert lentrycriteria;   
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
        for(Integer i=0;i<2;i++){
            lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
        }
        Database.insert(lquestion,false);
        
        //CREATE QUESTION ACTION RECORDS FOR BULK TESTING
        List<IMH_QuestionAction__c> lquestionaction = new List<IMH_QuestionAction__c>();
        for(Integer i=0; i<2; i++){
            lquestionaction.add(IMH_TestClassUtility.createQuestionAction('Yes',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[i].Id,COMPLIANCE));
        }
        Database.insert(lquestionaction,false);
        IMH_EntryCriteria__c tempEntry = new  IMH_EntryCriteria__c();
        lentrycriteria = new List<IMH_EntryCriteria__c>();
        for(Integer i=0; i<2; i++){
               tempEntry = IMH_TestClassUtility.createEntryCriteria(null,'Communication','TargetMarket__c',MARKET_NAME); 
               tempEntry.QuestionAction__c =lquestionaction[i].Id;
               lentrycriteria.add(tempEntry);  
        }    
        insert lentrycriteria;     
        
        //ASSERT IF QUESTION RECORDS ARE CREATED WITH EXPECTED RESULTS - MAKING SURE NO DUPLICATE ACTIONS
        System.assertEquals(2,lquestionaction.size());
        
        //CREATE A CAMPAIGN TO GET ANSWER SET CREATED BY TRIGGER 
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<2;i++){
            lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
         IMH_CommunicationTriggerHandler.iscreatedAnswerSet = false;
            IMH_CommunicationTriggerHandler.isExecutedAfter = false;   
        Database.insert (lcommunication,false);
        // System.debug('*** 2TEST '+lcommunication);
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<2;i++){            
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[i].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATE_NAME).Id));
           // lcreative[i].IMH_RequiredProductOwnerEngagement__c = 'Consumer Lending';
        }
            
       insert lcreative;
        //System.debug('*** 3TEST '+lcommunication);
        //lansset = [SELECT Id FROM IMH_AnswerSet__c WHERE Creative__c IN :lcreative];
       lansset = [SELECT Id FROM IMH_AnswerSet__c LIMIT 50000];
        
        Test.startTest();
        //CREATE ANSWER RECORDS WITH ANSWER THAT MEETS QUESTION ACTION CRITERIA
        List<IMH_Answer__c> lanswer = new List<IMH_Answer__c>();
        for(Integer i=0;i<2;i++){
            lanswer.add(IMH_TestClassUtility.createAnswer('Yes',COMPLETED_ANSWER,lansset[i].id,lquestion[i].Id));
        }
        Database.insert(lanswer,false);
        
        //QUERY LIST OF UPDATED CAMPAIGN WITH RESPECTIVE UPDATE FIELD VALUE IN WHERE CLAUSE
        List<IMH_CommCreative__c> lupdatecreate = [SELECT Id,Communication__r.RequiredApprovers__c
                                             FROM IMH_CommCreative__c
                                             WHERE Id IN:lcreative
                                              LIMIT 50000];
        Test.stopTest();
        
        // ASSERT THE EXPECTED SIZE OF THE CAMPAIGN FROM QUERY ABOVE
        System.assertEquals(2,lanswer.size());
         System.assertEquals(lupdatecreate.get(0).Communication__r.RequiredApprovers__c,COMPLIANCE);    
        System.assertEquals(2, lupdatecreate.size());
        }  
    }
    
    
      /**
    * @description  - Method used for checking whether field is updated on Incentive When answer is created
    *                 but with wrong value as entry criteria
    * @param  - none
    * @return  - none
     */ 
    static testMethod void answerIncentiveWronAnswer() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
        //CREATE QUESTION SET RECORD
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        }
       Database.insert (lquestionset,false);
        //Entry Criteria Logics

        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));   
       // lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
         
        insert lentrycriteria;   
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
        for(Integer i=0;i<5;i++){
            lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
        }
        Database.insert(lquestion,false);
        
        //CREATE QUESTION ACTION RECORDS FOR BULK TESTING
        List<IMH_QuestionAction__c> lquestionaction = new List<IMH_QuestionAction__c>();
        for(Integer i=0; i<5; i++){
            lquestionaction.add(IMH_TestClassUtility.createQuestionAction('Yes',QUESTION_ACTION_REQ_APPROVER,OBJECT_NAME,lquestion[i].Id,QUEUE_CENTRAL_OFFGOV));
            
        }
        Database.insert (lquestionaction,false);
        
        //ASSERT IF QUESTION RECORDS ARE CREATED WITH EXPECTED RESULTS - MAKING SURE NO DUPLICATE ACTIONS
        System.assertEquals(5,lquestionaction.size());
        
        IMH_EntryCriteria__c tempEntry = new  IMH_EntryCriteria__c();
        lentrycriteria = new List<IMH_EntryCriteria__c>();
        
        for(Integer i=0; i<2; i++){
               tempEntry = IMH_TestClassUtility.createEntryCriteria(null,'Communication','TargetMarket__c',MARKET_NAME); 
               tempEntry.QuestionAction__c =lquestionaction[i].Id;
               lentrycriteria.add(tempEntry);  
        }    
        insert lentrycriteria;      
        
        //CREATE CAMPAIGNS TO GET ANSWER SET CREATED BY TRIGGER    
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){
            lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert (lcommunication,false);
        System.debug('*** 0.01 '+lcommunication[0]);
    
                                        
        //CREATE OFFERS TO GET ANSWER SET CREATED BY TRIGGER 
        List<IMH_Incentive__c> lincentivelist = new List<IMH_Incentive__c>();
        for(Integer i=0;i<5;i++){
            lincentivelist.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, STATUS_NAME,lcommunication[0].Id));
            lincentivelist[i].IncentiveType__c = 'New Offer Construct Type';
            //lincentivelist[i].RequiredApprovers__c = QUEUE_CENTRAL_BRAND;
        }
        
        Database.insert(lincentivelist,false); 
             IMH_CommunicationTriggerHandler.iscreatedAnswerSet = false;
            IMH_CommunicationTriggerHandler.isExecutedAfter = false;
        System.debug('*** 0.1 '+lincentivelist[0]   );
        System.debug('*** 0.2 '+lcommunication[0].getSObjects('Incentives__r'));    
        //List<IMH_AnswerSet__c> lansset = [SELECT Id FROM IMH_AnswerSet__c LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
        List<IMH_AnswerSet__c> lansset = new List<IMH_AnswerSet__c>();      

        lansset = [SELECT Id FROM IMH_AnswerSet__c LIMIT 50000]; 
            System.debug('*** 1 '+lansset[0]    );
            //System.assertEquals(lansset.size(),5);
        List<IMH_Answer__c> lanswer = new List<IMH_Answer__c>();

        
        Test.startTest();
        //CREATE ANSWER RECORDS WITH ANSWER THAT MEETS QUESTION ACTION CRITERIA
        for(Integer i=0;i<5;i++){
            lanswer.add(IMH_TestClassUtility.createAnswer('No',COMPLETED_ANSWER,lansset[0].id,lquestion[i].Id));
        }
        Database.insert (lanswer,false);
        List<IMH_Incentive__c> lupdateincentive = [SELECT Id,
                                           Communication__r.RequiredApprovers__c
                                           FROM IMH_Incentive__c
                                           Where Id IN:lincentivelist
                                          LIMIT 50000];

        Test.stopTest();
        System.assertEquals(1,lansset.size());
        System.assertEquals(5,lanswer.size());
        System.assertEquals(lupdateincentive.get(0).Communication__r.RequiredApprovers__c,null);  
        System.assertEquals(5, lupdateincentive.size());        
        }
    }
    
    /**
    * @description  - Method used for checking negative scenario when question action is not present
    * @param  - none
    * @return  - none
   */ 
    static testMethod void negateAnswerIncentiveTestMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
        //CREATE QUESTION SET RECORD
       List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        }
       Database.insert (lquestionset,false);
        //Entry Criteria Logics
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));   
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
         
        insert lentrycriteria;   
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
        for(Integer i=0;i<5;i++){
            lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
        }
        Database.insert(lquestion,false);       
        
        //CREATE CAMPAIGNS TO MAP AGAINST OFFER  
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){
            lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert (lcommunication,false);
        
      
        //CREATE OFFERS TO GET ANSWER SET CREATED BY TRIGGER 
        List<IMH_Incentive__c> lincentivelist = new List<IMH_Incentive__c>();
        for(Integer i=0;i<5;i++){
            lincentivelist.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, STATUS_NAME,lcommunication[0].Id));
            lincentivelist[i].IncentiveType__c = 'New Offer Construct Type';
        }
        
        Database.insert(lincentivelist,false);  

        
        List<IMH_AnswerSet__c> lansset = [SELECT Id FROM IMH_AnswerSet__c LIMIT 50000];
        
       
        //CREATE ANSWER RECORDS WITH ANSWER TO CHECK NO UPDATE HAS HAPPENED ON TARGET OBJECT SINCE NO ACTION IS CREATION
        List<IMH_Answer__c> lanswer = new List<IMH_Answer__c>();
        Test.startTest();
            for(Integer i=0;i<5;i++){
                lanswer.add(IMH_TestClassUtility.createAnswer('Yes',COMPLETED_ANSWER,lansset[0].id,lquestion[i].Id));
            }
           Database.insert(lanswer,false);
            
            List<IMH_Incentive__c> lupdateincentive = [SELECT Id,
                                               Communication__r.RequiredApprovers__c
                                               FROM IMH_Incentive__c
                                               Where Communication__r.RequiredApprovers__c='Central Incentive Governance'
                                              LIMIT 50000];
        
        Test.stopTest();
         System.assertEquals(1,lansset.size());
        System.assertEquals(5,lanswer.size());
        //ASSERT TO MAKE SURE NO ACTION UPDATE HAPPENED ON OFFER
        System.assertEquals(0, lupdateincentive.size());
        }
    }   
    
    /**
* @description  - Method used for checking negative scenario when answers are not present
* @param  - none
* @return  - none
 */
    static testMethod void negateAnswerIncentiveOnNoAnswer() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
        Test.startTest();
        
            //CREATE QUESTION SET RECORD
            List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        }
       Database.insert (lquestionset,false);
        //Entry Criteria Logics
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));   
       // lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Incentive','IncentiveType__c','New Offer Construct Type'));
                  
        insert lentrycriteria;   
            
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
        for(Integer i=0;i<5;i++){
            lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
        }
        Database.insert(lquestion,false);               
            
            //CREATE CAMPAIGNS TO MAP ON OFFER OBJECT
            List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++){
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
            }
            Database.insert (lcommunication,false);
                  //CREATE INCENTIVES TO GET ANSWER SET CREATED BY TRIGGER 
        List<IMH_Incentive__c> lincentivelist = new List<IMH_Incentive__c>();
        for(Integer i=0;i<5;i++){
            lincentivelist.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, STATUS_NAME,lcommunication[0].Id));
            lincentivelist[i].IncentiveType__c = 'New Offer Construct Type';
        }
        
        Database.insert(lincentivelist,false);  

            List<IMH_AnswerSet__c> lansset = [SELECT Id FROM IMH_AnswerSet__c LIMIT 50000];
            
            
            List<IMH_Incentive__c> lupdateincentive = [SELECT Id,
                                               Communication__r.RequiredApprovers__c
                                               FROM IMH_Incentive__c
                                               Where  Communication__r.RequiredApprovers__c='Central Offer Governance'
                                              LIMIT 50000];
        
        Test.stopTest();
        //CHECK THE ANSWER SET CREATED AGAINST OFFER RECORD
        System.assertEquals(1,lansset.size());
        System.assertEquals(0, lupdateincentive.size());
    }    
    }
    
      /**
    * @description  - Method used for checking whether field is updated on Commmunciation When answer is created
    *                 and question action has entry criteria associated.
    * @param  - none
    * @return  - none
     */
    static testMethod void answerEntryTestMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
        List<IMH_AnswerSet__c> lansset = new List<IMH_AnswerSet__c>();
        //CREATE QUESTION SET RECORD
        
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        }
       Database.insert (lquestionset,false);

        //Entry Criteria Logics
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));  
        //lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Creative','IMH_RequiredProductOwnerEngagement__c','Consumer Lending')); 
        insert lentrycriteria;   
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
        for(Integer i=0;i<2;i++){
            lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
        }
        Database.insert(lquestion,false);
        
        //CREATE QUESTION ACTION RECORDS FOR BULK TESTING
        List<IMH_QuestionAction__c> lquestionaction = new List<IMH_QuestionAction__c>();
        for(Integer i=0; i<2; i++){
            lquestionaction.add(IMH_TestClassUtility.createQuestionAction('Yes',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[i].Id,COMPLIANCE));
        }
        Database.insert(lquestionaction,false);
        
        
        
             //CREATE a entry criteria for Question Warning  
        List<IMH_EntryCriteria__c> lqwentry = new List<IMH_EntryCriteria__c>();
           lqwentry.add(IMH_TestClassUtility.createEntryCriteria(null,'Communication','TargetMarket__c',MARKET_NAME)); 
        Database.insert(lqwentry,false);
        

        IMH_EntryCriteria__c tempEntry = new  IMH_EntryCriteria__c();
        lentrycriteria = new List<IMH_EntryCriteria__c>();
        for(Integer i=0; i<2; i++){
               tempEntry = IMH_TestClassUtility.createEntryCriteria(null,'Communication','TargetMarket__c',MARKET_NAME); 
               tempEntry.QuestionAction__c =lquestionaction[i].Id;
               lentrycriteria.add(tempEntry);  
        }    
        insert lentrycriteria;         

         
        List<IMH_EntryCriteria__c> lupdateqwentry = new List<IMH_EntryCriteria__c>();
            integer K = 0;
            for(IMH_EntryCriteria__c entry : [Select id,QuestionAction__c
                                              FROM IMH_EntryCriteria__c
                                              WHERE ID IN:lqwentry LIMIT 50000]){
                                                  if(K < 1){
                                                        entry.QuestionAction__c = lquestionaction[0].Id;  
                                                  }                
                                                  else{
                                                     entry.QuestionAction__c = lquestionaction[1].Id;  
                                                  } 
                   K++;
                  lupdateqwentry.add(entry);                                
            }
           update lupdateqwentry;
        //ASSERT IF QUESTION RECORDS ARE CREATED WITH EXPECTED RESULTS - MAKING SURE NO DUPLICATE ACTIONS
        System.assertEquals(2,lquestionaction.size());
        
        //CREATE A CAMPAIGN TO GET ANSWER SET CREATED BY TRIGGER 
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<2;i++){
            lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert (lcommunication,false);
         
        
        //CREATE A CREATIVE TO GET ANSWER SET CREATED BY TRIGGER        
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<2;i++){            
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[i].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATE_NAME).Id));
            lcreative[i].IMH_RequiredProductOwnerEngagement__c = 'Consumer Lending';
        }
       insert lcreative;
      
      lansset = [SELECT Id FROM IMH_AnswerSet__c LIMIT 50000];
        
     Test.startTest();
        //CREATE ANSWER RECORDS WITH ANSWER THAT MEETS QUESTION ACTION CRITERIA
        List<IMH_Answer__c> lanswer = new List<IMH_Answer__c>();
        for(Integer i=0;i<2;i++){
            lanswer.add(IMH_TestClassUtility.createAnswer('Yes',COMPLETED_ANSWER,lansset[i].id,lquestion[i].Id));
        }
        Database.insert(lanswer,false);
        
        //QUERY LIST OF UPDATED CAMPAIGN WITH RESPECTIVE UPDATE FIELD VALUE IN WHERE CLAUSE
        List<IMH_CommCreative__c> lupdatecreate = [SELECT Id,Communication__r.RequiredApprovers__c
                                             FROM IMH_CommCreative__c
                                             WHERE Id IN:lcreative
                                              LIMIT 50000];
        Test.stopTest();
        
        // ASSERT THE EXPECTED SIZE OF THE CAMPAIGN FROM QUERY ABOVE
        System.assertEquals(2,lanswer.size());
        System.assertEquals(lupdatecreate[1].Communication__r.RequiredApprovers__c,COMPLIANCE);    
        System.assertEquals(2, lupdatecreate.size());
        }  
    }
    /**
    * @description  - Method used for Reevluationg Questionnaire When Incentive Changes
    * @param  - none
    * @return  - none
    */  
    static testMethod void ReEvaluateOnIncentiveTestMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        List<IMH_Incentive__c> lincentivelist;
        system.runAs(runningUser) {
            //CREATE QUESTION SET RECORD
            List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
            for(Integer i=0; i<1; i++) {
                lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
            }
            Database.insert (lquestionset,false);
            //Entry Criteria Logics
            List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
            lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c','Singapore'));  
            insert lentrycriteria;   
            
            //CREATE QUESTION RECORDS FOR BULK TESTING
            List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
            for(Integer i=0;i<1;i++){
                lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
            }
            Database.insert(lquestion,false);
            
            //CREATE QUESTION ACTION RECORDS FOR BULK TESTING
            List<IMH_QuestionAction__c> lquestionaction = new List<IMH_QuestionAction__c>();
            for(Integer i=0; i<1; i++){
                lquestionaction.add(IMH_TestClassUtility.createQuestionAction('Yes',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[i].Id,COMPLIANCE));
            }
            Database.insert(lquestionaction,false);
            IMH_EntryCriteria__c tempEntry = new  IMH_EntryCriteria__c();
            lentrycriteria = new List<IMH_EntryCriteria__c>();
            for(Integer i=0; i<1; i++){
                   tempEntry = IMH_TestClassUtility.createEntryCriteria(null,'Incentive','IncentiveType__c','New Offer Construct Type'); 
                   tempEntry.QuestionAction__c =lquestionaction[i].Id;
                   lentrycriteria.add(tempEntry);  
            }    
            insert lentrycriteria;     
            
            //ASSERT IF QUESTION RECORDS ARE CREATED WITH EXPECTED RESULTS - MAKING SURE NO DUPLICATE ACTIONS
            System.assertEquals(1,lquestionaction.size());
            
            //CREATE A CAMPAIGN TO GET ANSWER SET CREATED BY TRIGGER 
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++){
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,'Singapore'));
            }
            IMH_CommunicationTriggerHandler.iscreatedAnswerSet = false;
            IMH_CommunicationTriggerHandler.isExecutedAfter = false;   
            Database.insert (lcommunication,false);
            lincentivelist = new List<IMH_Incentive__c>();
            for(Integer i=0;i<1;i++){
                lincentivelist.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, STATUS_NAME,lcommunication[0].Id));
                lincentivelist[i].IncentiveType__c = 'New Offer Construct Type';
            }
            Database.insert(lincentivelist,false); 
            List<IMH_AnswerSet__c> lansset = new List<IMH_AnswerSet__c>();      
            lansset = [SELECT Id FROM IMH_AnswerSet__c LIMIT 50000]; 
            //CREATE ANSWER RECORDS WITH ANSWER THAT MEETS QUESTION ACTION CRITERIA
            List<IMH_Answer__c> lanswer = new List<IMH_Answer__c>();
            for(Integer i=0;i<1;i++){
                lanswer.add(IMH_TestClassUtility.createAnswer('Yes',COMPLETED_ANSWER,lansset[i].id,lquestion[i].Id));
            }
            Database.insert(lanswer,false);
            Test.startTest();
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            List<IMH_Incentive__c> lincentiveUpdate = new List<IMH_Incentive__c>();
            List<IMH_Incentive__c> lIncentiveRec = new List<IMH_Incentive__c>();
            lIncentiveRec = [SELECT Id, IncentiveType__c FROM IMH_Incentive__c 
                                                WHERE Id =: lincentivelist LIMIT 1];
            for(IMH_Incentive__c inc : lIncentiveRec){
                inc.IncentiveType__c = 'Existing Offer Construct Type';
                lincentiveUpdate.add(inc);
            }
            Database.update(lincentiveUpdate,true);
            Test.stopTest();    
            IMH_Communication__c commCheck = [SELECT Id, RequiredApprovers__c FROM IMH_Communication__c WHERE id=:lcommunication LIMIT 1];
            System.assertEquals(null,commCheck.RequiredApprovers__c);
        }  
    }
    
    /**
    * @description  - Method used for Reevaluationg Questionnaire When Communication Changes
    * @param  - none
    * @return  - none
    */  
    static testMethod void ReEvaluateOnCommTestMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        List<IMH_Incentive__c> lincentivelist;
        system.runAs(runningUser) {
            //CREATE QUESTION SET RECORD
            List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
            for(Integer i=0; i<1; i++) {
                lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
            }
            Database.insert (lquestionset,false);
            //Entry Criteria Logics
            List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
            lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c','Singapore'));  
            insert lentrycriteria;   
            
            //CREATE QUESTION RECORDS FOR BULK TESTING
            List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
            for(Integer i=0;i<1;i++){
                lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
            }
            Database.insert(lquestion,false);
            
            //CREATE QUESTION ACTION RECORDS FOR BULK TESTING
            List<IMH_QuestionAction__c> lquestionaction = new List<IMH_QuestionAction__c>();
            for(Integer i=0; i<1; i++){
                lquestionaction.add(IMH_TestClassUtility.createQuestionAction('Yes',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[i].Id,COMPLIANCE));
            }
            Database.insert(lquestionaction,false);
            IMH_EntryCriteria__c tempEntry = new  IMH_EntryCriteria__c();
            lentrycriteria = new List<IMH_EntryCriteria__c>();
            for(Integer i=0; i<1; i++){
                   tempEntry = IMH_TestClassUtility.createEntryCriteria(null,'Communication','Submitters_Team__c','IMH'); 
                   tempEntry.QuestionAction__c =lquestionaction[i].Id;
                   lentrycriteria.add(tempEntry);  
            }    
            insert lentrycriteria;     
            
            //ASSERT IF QUESTION RECORDS ARE CREATED WITH EXPECTED RESULTS - MAKING SURE NO DUPLICATE ACTIONS
            System.assertEquals(1,lquestionaction.size());
            
            //CREATE A CAMPAIGN TO GET ANSWER SET CREATED BY TRIGGER 
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++){
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,'Singapore'));
                lcommunication[i].Submitters_Team__c = 'IMH';
            }
            IMH_CommunicationTriggerHandler.iscreatedAnswerSet = false;
            IMH_CommunicationTriggerHandler.isExecutedAfter = false;   
            Database.insert (lcommunication,true);
            List<IMH_AnswerSet__c> lansset = new List<IMH_AnswerSet__c>();      
            lansset = [SELECT Id FROM IMH_AnswerSet__c LIMIT 50000]; 
            //CREATE ANSWER RECORDS WITH ANSWER THAT MEETS QUESTION ACTION CRITERIA
            List<IMH_Answer__c> lanswer = new List<IMH_Answer__c>();
            for(Integer i=0;i<1;i++){
                lanswer.add(IMH_TestClassUtility.createAnswer('Yes',COMPLETED_ANSWER,lansset[i].id,lquestion[i].Id));
            }
            Database.insert(lanswer,false);
            Test.startTest();
            
            List<IMH_Communication__c> lCommUpdate = new List<IMH_Communication__c>();
            List<IMH_Communication__c> lCommRec = new List<IMH_Communication__c>();
            lCommRec = [SELECT Id, Submitters_Team__c FROM IMH_Communication__c 
                                                WHERE Id =: lcommunication LIMIT 1];
            for(IMH_Communication__c comm : lCommRec){
                comm.Submitters_Team__c = 'Retail Insurance';
                lCommUpdate.add(comm);
            }
            IMH_CommunicationTriggerHandler.iscreatedAnswerSet = false;
            IMH_CommunicationTriggerHandler.isExecutedAfter = false;  
            Database.update(lCommUpdate,true);
            Test.stopTest();    
            IMH_Communication__c commCheck = [SELECT Id, RequiredApprovers__c FROM IMH_Communication__c WHERE id=:lcommunication LIMIT 1];
            System.assertEquals(null,commCheck.RequiredApprovers__c);
        }  
    }
    
     /**
    * @description  - Method to test the delimiter case for the value "GCP" and "GCP MR"
    * @param  - none
    * @return  - none
    */ 
    static testMethod void delimiterTestMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
        List<IMH_AnswerSet__c> lansset = new List<IMH_AnswerSet__c>();
        //CREATE QUESTION SET RECORD
        
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        }
       Database.insert (lquestionset,false);
           // System.debug('*** 1TEST '+lquestionset);
        //Entry Criteria Logics
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));  
        insert lentrycriteria;   
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
        for(Integer i=0;i<6;i++){
            lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
        }
        Database.insert(lquestion,false);
        
        //CREATE QUESTION ACTION RECORDS FOR BULK TESTING
        List<IMH_QuestionAction__c> lquestionaction = new List<IMH_QuestionAction__c>();
        lquestionaction.add(IMH_TestClassUtility.createQuestionAction('Yes',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[0].Id,'GCP MR'));
        lquestionaction.add(IMH_TestClassUtility.createQuestionAction('No',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[0].Id,'GCP'));
        lquestionaction.add(IMH_TestClassUtility.createQuestionAction('No',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[1].Id,'GCP Product 1'));
        lquestionaction.add(IMH_TestClassUtility.createQuestionAction('No',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[2].Id,'GCP Product 2'));
        lquestionaction.add(IMH_TestClassUtility.createQuestionAction('No',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[3].Id,'GCP Product 3'));
        lquestionaction.add(IMH_TestClassUtility.createQuestionAction('No',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[4].Id,'GCP Product 4'));
        lquestionaction.add(IMH_TestClassUtility.createQuestionAction('No',QUESTION_ACTION_REQ_APPROVER,'Communication',lquestion[5].Id,'GCP Product 5'));
        
        Database.insert(lquestionaction,false);
        IMH_EntryCriteria__c tempEntry = new  IMH_EntryCriteria__c();
        lentrycriteria = new List<IMH_EntryCriteria__c>();
        for(Integer i=0; i<2; i++){
               tempEntry = IMH_TestClassUtility.createEntryCriteria(null,'Communication','TargetMarket__c',MARKET_NAME); 
               tempEntry.QuestionAction__c =lquestionaction[i].Id;
               lentrycriteria.add(tempEntry);  
        }    
        insert lentrycriteria;     
        
        //ASSERT IF QUESTION RECORDS ARE CREATED WITH EXPECTED RESULTS - MAKING SURE NO DUPLICATE ACTIONS
        System.assertEquals(7,lquestionaction.size());
        
        //CREATE A CAMPAIGN TO GET ANSWER SET CREATED BY TRIGGER 
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<2;i++){
            lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
         IMH_CommunicationTriggerHandler.iscreatedAnswerSet = false;
            IMH_CommunicationTriggerHandler.isExecutedAfter = false;   
        Database.insert (lcommunication,false);
        // System.debug('*** 2TEST '+lcommunication);
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<2;i++){            
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[i].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATE_NAME).Id));
        }
            
       insert lcreative;
        //System.debug('*** 3TEST '+lcommunication);
        //lansset = [SELECT Id FROM IMH_AnswerSet__c WHERE Creative__c IN :lcreative];
       lansset = [SELECT Id FROM IMH_AnswerSet__c];
        
        Test.startTest();
        //CREATE ANSWER RECORDS WITH ANSWER THAT MEETS QUESTION ACTION CRITERIA
        List<IMH_Answer__c> lanswer = new List<IMH_Answer__c>();
        lanswer.add(IMH_TestClassUtility.createAnswer('Yes',COMPLETED_ANSWER,lansset[0].id,lquestion[0].Id));
        lanswer.add(IMH_TestClassUtility.createAnswer('No',COMPLETED_ANSWER,lansset[0].id,lquestion[1].Id));
        lanswer.add(IMH_TestClassUtility.createAnswer('Yes',COMPLETED_ANSWER,lansset[0].id,lquestion[2].Id));
        lanswer.add(IMH_TestClassUtility.createAnswer('Yes',COMPLETED_ANSWER,lansset[0].id,lquestion[3].Id));
        lanswer.add(IMH_TestClassUtility.createAnswer('No',COMPLETED_ANSWER,lansset[0].id,lquestion[4].Id));
        lanswer.add(IMH_TestClassUtility.createAnswer('Yes',COMPLETED_ANSWER,lansset[0].id,lquestion[5].Id));
        Database.insert(lanswer,false);
        
        //QUERY LIST OF UPDATED CAMPAIGN WITH RESPECTIVE UPDATE FIELD VALUE IN WHERE CLAUSE
        List<IMH_CommCreative__c> lupdatecreate = [SELECT Id,Communication__r.RequiredApprovers__c
                                             FROM IMH_CommCreative__c
                                             WHERE Id IN:lcreative
                                              LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
        Test.stopTest();
        
        Set<String> tempStr = new Set<String>();
        
        tempStr.addAll(lupdatecreate.get(0).Communication__r.RequiredApprovers__c.split(';'));
        // ASSERT THE EXPECTED SIZE OF THE CAMPAIGN FROM QUERY ABOVE
        System.assertEquals(6,lanswer.size());
        System.assert(tempStr.contains('GCP MR'));
        System.assert(tempStr.contains('GCP Product 1')); 
        System.assert(tempStr.contains('GCP Product 4'));     
        System.assertEquals(2, lupdatecreate.size());
        }  
    }
    
}