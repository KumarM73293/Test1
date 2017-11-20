/**
* @author Accenture IDC 
* @date 05/28/2015
* @group QuestionSet
* @group-content N/A
* @description: iMH Release 1 (Sprint 1) - Test Class for Validation Rule on QuestionSet object 
* 
*/
@isTest
private class IMH_QuestionSetValidationTest {
    private static Final String MARKET_ENTRY = 'Thailand';
    private static Final String STAGE_ENTRY = 'Concept';
    private static Final String CAMPOBJECT_ENTRY = 'Campaign';
    private static Final String STATUS_ENTRY = 'Approved';
    private static Final String VERSION_ERROR = 'Version should be greater than previous value';
    private static Final String EMPTY_STRING = '';
    private static final String CAMPAIGN_SUBMITTER_PROFILE = 'iMH Campaign Submitter';
    private static final String RUNNING_USER = 'RunningUser';
    
    /**
    * @description  -TestMethod of the Validation rule for  "Version" field on QuestionSet Object
    * @param  - NONE
    * @return  - VOID
    */ 
    static testMethod void questionSetValidationTestMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            // Variable is declared hold the Version value for validation error message
            String versionerrormsg = EMPTY_STRING;
            //TestData for QuestionSet Object
            IMH_QuestionSet__c questionset = new IMH_QuestionSet__c();
            questionset = IMH_TestClassUtility.createQuestionSet(CAMPOBJECT_ENTRY);
            questionset.Version__c = 4.0;
            Database.insert(questionset,false);             
            questionset.Version__c = 3.0;
            try{
                update questionset;
            }
            catch(Exception e){
                versionerrormsg = e.getMessage();
            }        
            system.assert(versionerrormsg.contains(VERSION_ERROR));   
        }
    }
    
    /**
    * @description  - TestMethod of the Validation rule for -ve value in "Version" field on QuestionSet Object
    * @param  - NONE
    * @return  - VOID
    */ 
    static testMethod void questionSetValidationTestMethod1() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            // Variable is declared hold the Version value for validation error message
            String versionerrormsg1 = EMPTY_STRING;
            //TestData for QuestionSet Object
            IMH_QuestionSet__c questionset1 = new IMH_QuestionSet__c();
            questionset1.Name = 'TestQuestionSet1';
            questionset1.Version__c = 2.0;
            questionset1.Active__c =true;
            questionset1.ObjectEntryCriteria__c = 'Campaign';
            Database.insert(questionset1,false);             
            questionset1.Version__c = -1.0;
            try{
                update questionset1;
            }
            catch(Exception e){
                versionerrormsg1 = e.getMessage();
            }        
            system.assert(versionerrormsg1.contains('The version should be a positive number')); 
        }
    }
    
    /*****************************************************************************
    * @description: Mehod used for  inserting unique questionset while inserting
    * @param: none
    * @return: void
    */ 
    static testmethod void insertUniqueQuestion(){
        String errormessage='';
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        lquestionset.add(IMH_TestClassUtility.createQuestionSet(CAMPOBJECT_ENTRY));
        lquestionset[0].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').ID;
        insert lquestionset;
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_QuestionSet__c> lchildquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0;i<2;i++){
            lchildquestionset.add(IMH_TestClassUtility.createQuestionSet(CAMPOBJECT_ENTRY));
            lchildquestionset[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').ID;
            lchildquestionset[i].ParentQuestionSet__c = lquestionset[0].Id;
            lchildquestionset[i].OrderSequence__c = i;
        }
        try{
            insert lchildquestionset;
            }
        catch(Exception e){
            errormessage = e.getMessage();
        }
       System.assertEquals(errormessage.contains('There is another record with at this order sequence'),false);
       System.assertEquals(errormessage.contains('There is already an active record at this order sequence.'),false);
    }
    /*****************************************************************************
    * @description: Method used for checking the scenario when we throw error when questionset are active and order sequence is same
    * @param: none
    * @return: void
    * */
   static testmethod void updateUniqueQuestionSET(){
        String errormessage='';
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        lquestionset.add(IMH_TestClassUtility.createQuestionSet(CAMPOBJECT_ENTRY));
        lquestionset[0].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').ID;
        insert lquestionset;
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_QuestionSet__c> lchildquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0;i<2;i++){
            lchildquestionset.add(IMH_TestClassUtility.createQuestionSet(CAMPOBJECT_ENTRY));
            lchildquestionset[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').ID;
            lchildquestionset[i].ParentQuestionSet__c = lquestionset[0].Id;
            lchildquestionset[i].OrderSequence__c = i;
        }
      insert lchildquestionset;
    List<IMH_QuestionSet__c> limhquest = new List<IMH_QuestionSet__c>();
    for(IMH_QuestionSet__c quest : [SELECT ID
                                       ,OrderSequence__c
                                       ,Version__c
                                       ,Active__c
                                       ,ParentQuestionSet__c
                                       ,UniqueSequenceVersion__c
                                       ,UniqueActiveSequence__c
                                 From IMH_QuestionSet__c where ID IN:lchildquestionset]){
            quest.OrderSequence__c = 4; 
            limhquest.add(quest);                         
        }
        try{
            IMH_QuestionSetTriggerHandler.isExecutedBefore = false;
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
         lquestionset.add(IMH_TestClassUtility.createQuestionSet(CAMPOBJECT_ENTRY));
        lquestionset[0].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').ID;
        insert lquestionset;
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_Communication__c','TargetMarket__c',MARKET_ENTRY));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_Incentive__c','OfferType__c','Incentive'));
         
        insert lentrycriteria;  
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_QuestionSet__c> lchildquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0;i<2;i++){
            lchildquestionset.add(IMH_TestClassUtility.createQuestionSet(CAMPOBJECT_ENTRY));
            lchildquestionset[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Child').ID;
            lchildquestionset[i].ParentQuestionSet__c = lquestionset[0].Id;
            lchildquestionset[i].OrderSequence__c = i;
        }
      insert lchildquestionset;
    List<IMH_QuestionSet__c> limhquest = new List<IMH_QuestionSet__c>();
    for(IMH_QuestionSet__c quest : [SELECT ID
                                       ,OrderSequence__c
                                       ,Version__c
                                       ,Active__c
                                       ,UniqueSequenceVersion__c
                                       ,UniqueActiveSequence__c
                                 From IMH_QuestionSet__c where ID IN:lchildquestionset]){
            quest.Active__c = false;
             quest.OrderSequence__c = 4;                        
            //quest.Version__c = 4;                         
            limhquest.add(quest);                         
        }
        try{
            IMH_QuestionSetTriggerHandler.isExecutedBefore = false;
            update limhquest;
        }
        catch(Exception e){
           errormessage = e.getMessage(); 
        }
        System.assertEquals(errormessage.contains('There is another record with at this order sequence with the same version number'),true);
 }
}