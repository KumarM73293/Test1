/**
* @author Accenture IDC 
* @date 05/28/2015
* @group Question Warning
* @group-content N/A
* @description: iMH Release 1 (Sprint 1) - Test Class for Validation Rule on Question Warning object 
* 
*/
@isTest
private class IMH_QuestionWarningValidationTest {
     private static Final String EMPTY_STRING = '';
     private static final String CAMPAIGN_SUBMITTER_PROFILE = 'iMH Campaign Submitter';
     private static final String RUNNING_USER = 'RunningUser';
    /*********************
    * TestMethod of the Validation rule for  "Version" field on QuestionSet Object
    *
    *********************/
    static testMethod void questionWarningValidationTestMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){  
                // Variable is declared hold the Version value for validation error message
                String versionerrormsg = EMPTY_STRING;
                
                //TestData for Question Object field 
                IMH_Question__c question1 = new IMH_Question__c();
                //question1.Question__c = 'Does the campaign require for markting approval?';
                question1.OrderSequence__c = 2;
                question1.Version__c = 1; 
                question1.Active__c =true;
                //question1.ResponseType__c = 'Picklist';
                //question1.PicklistValues__c = 'testValue';
                Database.insert(question1,false);
                
                //TestData for QuestionSet Object
                IMH_QuestionWarning__c questionwarning = new IMH_QuestionWarning__c();
                questionwarning.Name = 'TestQuestionWarning';
                questionwarning.EntryCriteria__c = 'TextEntry';
                questionwarning.Detail__c = 'TestDetails';
                questionwarning.Flag__c = 'Red';
                questionwarning.Question__c = question1.Id;            
                questionwarning.Version__c = 4.0;
                questionwarning.Active__c =true;
                
                Database.insert(questionwarning,false);             
                
                questionwarning.Version__c = 3.0;
                
                try{
                    Update questionwarning;
                }
                catch(Exception e){
                    versionerrormsg = e.getMessage();
                    
                }        
                
                system.assert(versionerrormsg.contains('Version should be greater than previous value'));  
        }
    }
    
    /******************
    * TestMethod of the Validation rule for -ve value in "Version" field on QuestionSet Object
    *
    *****************/
    static testMethod void questionSetValidationTestMethod1() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){  
                // Variable is declared hold the Version value for validation error message
                String versionerrormsg1 = EMPTY_STRING;
                
                //TestData for Question Object field 
                IMH_Question__c question2 = new IMH_Question__c();
                question2.OrderSequence__c = 2;
                question2.Version__c = 1; 
                question2.Active__c =true;
               // question2.ResponseType__c = 'Picklist';
                //question2.PicklistValues__c = 'testValue';
                Database.insert(question2,false);
                
                //TestData for QuestionSet Object
                IMH_QuestionWarning__c questionwarning1 = new IMH_QuestionWarning__c();
                questionwarning1.Name = 'TestQuestionWarning';
                questionwarning1.EntryCriteria__c = 'TextEntry1';
                questionwarning1.Detail__c = 'TestDetails1';
                questionwarning1.Flag__c = 'Red';
                questionwarning1.Question__c = question2.Id;            
                questionwarning1.Version__c = 2.0;
                questionwarning1.Active__c =true;
                
                Database.insert(questionwarning1,false);             
                
                questionwarning1.Version__c = -1.0;
                
                try{
                    Update questionwarning1;
                }
                catch(Exception e){
                    versionerrormsg1 = e.getMessage();   
                }        
                
                system.assert(versionerrormsg1.contains('Version is a positive integer'));   
            }
    }
    
      /*****************************************************************************
    * @description: Mehod used for  inserting unique questionswarningt while inserting
    * @param: none
    * @return: void
    */ 
    static testmethod void insertUniqueQuestionWarning(){
        String errormessage='';
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        lquestionset.add(IMH_TestClassUtility.createQuestionSet('Communication'));
        lquestionset[0].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').ID;
        insert lquestionset;
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lchildquestion = new List<IMH_Question__c>();
        
        lchildquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id,1,IMH_TestClassUtility.mRecordType.get('IMH_Question__c').get('Yes_No').ID));
        insert lchildquestion;
        List<IMH_QuestionWarning__c> lwarning = new List<IMH_QuestionWarning__c>();
        for(Integer i=0;i<2;i++){
            lwarning.add(IMH_TestClassUtility.createQuestionWarning(lchildquestion[0].Id,'Yes','Red',1));
        }
        try{
            insert lwarning;
        }
        catch(Exception e){
            errormessage = e.getMessage();
        }
        System.assertEquals(errormessage.contains('There is already an active record at this order sequence.'),true);
    }
       /*****************************************************************************
    * @description: Mehod used for  unique questionswarning while updating
    * @param: none
    * @return: void
    */ 
    static testmethod void updateUniqueQuestionWarning(){
        String errormessage='';
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        lquestionset.add(IMH_TestClassUtility.createQuestionSet('Communication'));
        lquestionset[0].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').ID;
        insert lquestionset;
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lchildquestion = new List<IMH_Question__c>();
        
        lchildquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id,1,IMH_TestClassUtility.mRecordType.get('IMH_Question__c').get('Yes_No').ID));
        insert lchildquestion;
        List<IMH_QuestionWarning__c> lwarning = new List<IMH_QuestionWarning__c>();
        for(Integer i=0;i<2;i++){
            lwarning.add(IMH_TestClassUtility.createQuestionWarning(lchildquestion[0].Id,'Yes','Red',i));
        }
        insert lwarning;
        List<IMH_QuestionWarning__c> lupdatwarning = new List<IMH_QuestionWarning__c>();
        for(IMH_QuestionWarning__c warn:[Select id,OrderSequence__c
                                         FROM IMH_QuestionWarning__c
                                         WHERE ID IN:lwarning]){
                                             warn.OrderSequence__c = 4;
                                             lupdatwarning.add(warn);
                                         }
        try{
            IMH_QuestionWarningTriggerHandler.isExecutedBefore = false;
            update lupdatwarning;
        }
        catch(Exception e){
            errormessage = e.getMessage();
        }
        System.assertEquals(errormessage.contains('There is already an active record at this order sequence.'),true);
    }
}