/**
* @author Accenture IDC 
* @date 05/28/2015
* @group Question
* @group-content N/A
* @description: iMH Release 1 (Sprint 1) - Test Class for Trigger on Question object.
*/
@isTest
private class IMH_QuestionValidationTest {    
    private static final String STAGE_NAME = 'Concept';
    private static final String STATUS_NAME = 'Approved';
    private static final String MARKET_NAME = 'Thailand';
    private static final String OBJECT_NAME = 'Communication';
    private static Final String RECORDTYPE_QUESTION_API = 'IMH_Question__c';
    private static Final String EMPTY_STRING = '';
    
    private static final String CAMPAIGN_SUBMITTER_PROFILE = 'iMH Campaign Submitter';
    private static final String RUNNING_USER = 'RunningUser';
    /******************
    * TestMethod of the Validation rule for  Version field on Question Object
    *
    *****************/
    static testMethod void questionValidationTestMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
                // Variable is declared hold the validation error message
                String versionerrormsg = EMPTY_STRING;
                
                //TestData for QuestionSet Object
                IMH_QuestionSet__c questionset = new IMH_QuestionSet__c();
                questionset.Name = 'TestQuestionSet';
                questionset.Version__c = 1.0;
                questionset.Active__c =true;
                questionset.ObjectEntryCriteria__c = 'Communication';
                Database.insert(questionset,false);
                
                //TestData for Question Object field 
                IMH_Question__c question = new IMH_Question__c();
                question.Question__c = 'Does the campaign require for markting approval?';
                question.OrderSequence__c = 1;
                question.Version__c = 4; 
                question.Active__c =true;
                question.QuestionSet__c = questionset.Id;
                insert question;
                
                question.Version__c = 3;
                try{
                    update question;
                }
                catch(Exception e){
                    versionerrormsg = e.getMessage();
                }
                system.assert(versionerrormsg.contains('Version should be greater than previous value'),True);  
        }
    }
    
    /******************
    * TestMethod of the Validation rule for  Version field on Question Object
    *
    *****************/
    static testMethod void questionValidationTestMethod2() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
                // Variable is declared hold the validation error message
                String versionerrormsg1 = EMPTY_STRING;
                
                //TestData for QuestionSet Object
                IMH_QuestionSet__c questionset2 = new IMH_QuestionSet__c();
                questionset2.Name = 'TestQuestionSet1';
                questionset2.Version__c = 4.0;
                questionset2.Active__c =true;
                questionset2.ObjectEntryCriteria__c = 'Communication';
                Database.insert(questionset2,false);
                
                //TestData for Question Object field 
                IMH_Question__c question2 = new IMH_Question__c();
                question2.Question__c = 'Does the campaign require for markting approval?';
                question2.OrderSequence__c = 2;
                question2.Version__c = 1; 
                question2.Active__c = true;
                question2.QuestionSet__c = questionset2.Id;
                Database.insert(question2,false);
                
                question2.Version__c = -3;
                try{
                    update question2;
                }
                catch(Exception e){
                    versionerrormsg1 = e.getMessage();
                }
                system.assert(versionerrormsg1.contains('Version is a posiive integer.'));
        }
    }
    
   
    /******************
    * TestMethod of the Validation rule for  "Dependent Question Entry Criteria" field on Question Object
    *
    *****************/
    static testMethod void questionValidationTestMethod3() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
                // Variable is declared hold the validation error message
                String depenQuestEntCriterrormsg = EMPTY_STRING;
                    
                //TestData for QuestionSet Object
                IMH_QuestionSet__c questionset3 = new IMH_QuestionSet__c();
                questionset3.Name = 'TestQuestionSet2';
                questionset3.Version__c = 2.0;
                questionset3.Active__c =true;
                questionset3.ObjectEntryCriteria__c = 'Communication';
                Database.insert(questionset3,false);
                
                //TestData1 for Question Object
                IMH_Question__c question3 = new IMH_Question__c();
                question3.Question__c = 'Does the campaign require for markting approval?';
                question3.OrderSequence__c = 1;
                question3.Version__c = 3;
                question3.Active__c =true;
                question3.QuestionSet__c = questionset3.Id;
                
                Database.insert(question3,false);
                IMH_Question__c question4 = new IMH_Question__c();
                question4.DependentQuestion__c = question3.Id;
                question4.DependentQuestionEntryCriteria__c = EMPTY_STRING;
                
                try{
                    insert question4;
                }
                catch(Exception e){
                    depenQuestEntCriterrormsg = e.getMessage();
                }   
                system.assert(depenQuestEntCriterrormsg.contains('Dependent Question Entry Criteria should be mandatory'), True);
            }
    }
    /*****************************************************************************
    * @description: Mehod used for  inserting unique question while inserting
    * @param: none
    * @return: void
    */ 
    static testmethod void insertUniqueQuestion(){
        String errormessage='';
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
         lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        lquestionset[0].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').ID;
        insert lquestionset;
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_Communication__c','TargetMarket__c',MARKET_NAME));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_Incentive__c','IncentiveType__c','Incentive'));
         
        insert lentrycriteria;  
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
        for(Integer i=0;i<2;i++){
            lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
        }
        try{
            insert lquestion;
            }
        catch(Exception e){
            errormessage = e.getMessage();
        }
       System.assertEquals(errormessage.contains('There is another record with at this order sequence'),false);
       System.assertEquals(errormessage.contains('There is already an active record at this order sequence.'),false);
    }
    /*****************************************************************************
    * @description: Method used for checking the scenario when we throw error when questions are active and order sequence is same
    * @param: none
    * @return: void
    */ 
    static testmethod void updateUniqueQuestion(){
        String errormessage='';
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
         lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        lquestionset[0].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').ID;
        insert lquestionset;
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_Communication__c','TargetMarket__c',MARKET_NAME));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_Incentive__c','IncentiveType__c','Incentive'));
         
        insert lentrycriteria;  
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
        for(Integer i=0;i<2;i++){
            lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
        }
        insert lquestion;
    List<IMH_Question__c> limhquest = new List<IMH_Question__c>();
    for(IMH_Question__c quest : [SELECT ID
                                       ,OrderSequence__c
                                       ,Version__c
                                       ,Active__c
                                       ,UniqueSequenceVersion__c
                                       ,UniqueActiveSequence__c
                                 From IMH_Question__c where ID IN:lquestion]){
            quest.OrderSequence__c = 4; 
            limhquest.add(quest);                         
        }
        try{
            IMH_QuestionTriggerHandler.isExecutedBefore = false;
            update limhquest;
        }
        catch(Exception e){
           errormessage = e.getMessage(); 
        }
        System.assertEquals(errormessage.contains('There is already an active record at this order sequence'),true);
 }
        /*****************************************************************************
    * @description: Method used for checking the scenario when we throw error when questions are inactive and version is same
    * @param: none
    * @return: void
    */ 
    static testmethod void updateVersionUniqueQuestion(){
        String errormessage='';
       List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
         lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        lquestionset[0].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').ID;
        insert lquestionset;
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_Communication__c','TargetMarket__c',MARKET_NAME));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_Incentive__c','IncentiveType__c','Incentive'));
         
        insert lentrycriteria;  
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
        for(Integer i=0;i<2;i++){
            lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get(RECORDTYPE_QUESTION_API).get('Yes_No').ID));
        }
        insert lquestion;
    List<IMH_Question__c> limhquest = new List<IMH_Question__c>();
    for(IMH_Question__c quest : [SELECT ID
                                       ,OrderSequence__c
                                       ,Version__c
                                       ,Active__c
                                       ,UniqueSequenceVersion__c
                                       ,UniqueActiveSequence__c
                                 From IMH_Question__c where ID IN:lquestion]){
            quest.Active__c = false;
             quest.OrderSequence__c = 4;                        
            //quest.Version__c = 4;                         
            limhquest.add(quest);                         
        }
        try{
            IMH_QuestionTriggerHandler.isExecutedBefore = false;
            update limhquest;
        }
        catch(Exception e){
           errormessage = e.getMessage(); 
        }
        System.assertEquals(errormessage.contains('There is another record with at this order sequence with the same version number'),true);
 }
}