/**
* @author Accenture IDC 
* @date 05/28/2015
* @group Answer
* @group-content N/A
* @description: iMH Release 1 (Sprint 1) - Test Class for Trigger on Incentive object which looks for the after insert and after update event 
* logic has been triggered on particular event of an object.
*/
@isTest
private class IMH_IncentiveTrigger_Test {   
    private static final String INCENTIVE_TYPE = 'Message';
    private static final String INCENTIVE_STATUS = 'In Progress';
    private static final String STAGE_NAME = 'Concept';
    private static final String STATUS_NAME = 'In Progress';
    private static final String MARKET_NAME = 'Thailand';
    private static final String OBJECT_NAME = 'Incentive';
    private static Final String CREATE_NAME = 'Creative';
    private static Final String NEW_STAGE = 'Creative';
    private static Final String NEW_STATUS = 'In Review';
    private static final String CAMPAIGN_API = 'IMH_Communication__c';
    private static final String INCENTIVE_API = 'IMH_Incentive__c';
    private static final String CANCEL_REASON = 'Submission made in error';
    private static final String CAMPAIGN_SUBMITTER_PROFILE = 'iMH Campaign Submitter';
    private static final String RUNNING_USER = 'RunningUser';
    /*****************************************************************************
    * @description: Method used for covering the case when we have the Question Set And Incentive
    *               and Answer Set gets created.
    * @param: none
    * @return: void
    */
    static testMethod void incentiveTriggerTestMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
         User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
        //TestData for QuestionSet Object
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        }
       Database.insert (lquestionset,false);
        //Entry Criteria Logics
        
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Incentive','IncentiveType__c','Incentive'));
         
        insert lentrycriteria;          
            
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<5;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert(lcommunication,false);
        
        Test.startTest();        
        List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
       
        for(Integer i=0; i<5; i++)
        {
            imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[i].Id));
            imhIncentiveList[i].IncentiveType__c = 'Incentive';
        }
        IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(imhIncentiveList,false);
        System.assertEquals(imhIncentiveList.size(),5);
        
       }   
    }
   /*****************************************************************************
    * @description: Method used for covering the case when we have the Question Set And Incentive
    *               and Answer Set gets created for central Governance Communication
    * @param: none
    * @return: void
     */ 
    static testMethod void centralIncentiveTriggerTestMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
        //TestData for QuestionSet Object
         List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
            lquestionset[i].CentralGovernanceQuestionSet__c = true;
        }
        Database.insert(lquestionset,false);
            
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Incentive','IncentiveType__c','Incentive'));
         
        insert lentrycriteria; 
            
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<10;i++)
        {
             
                 lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,' '));
                 lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
        }
        
        Database.insert(lcommunication,false);
        Test.startTest();        
        List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
       
        for(Integer i=0; i<10; i++)
        {
            imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[i].Id));
             imhIncentiveList[i].IncentiveType__c = 'Incentive';
        }
        IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(imhIncentiveList,false);
        
        SET<ID> imhOffList = new SET<ID>();        
        for(IMH_Incentive__c imh: imhIncentiveList){
            imh.IncentiveStatus__c = 'Approved';
            imhOffList.add(imh.ID);
        }
        IMH_IncentiveTriggerHandler.isExecutedAfter = false;    
        Database.update(imhIncentiveList,false);
        
        }  
    }
     /*****************************************************************************
    * @description: Method used for covering the negative scenario where question set is 
    *               not present.
    * @param: none
    * @return: void
    */
     static testMethod void negativeIncentiveMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){  
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<10;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert(lcommunication,false);
 
         
        Test.startTest();        
        List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
        
        for(Integer i=0; i<10; i++)
        {
            imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[i].Id));
        }
         Database.insert(imhIncentiveList,false);
                 
        SET<ID> imhOffList = new SET<ID>();
        
        for(IMH_Incentive__c imh: imhIncentiveList){
            imh.IncentiveStatus__c = 'Cancelled';
            imhOffList.add(imh.ID);
        }
        Database.update (imhIncentiveList,false);
        
         
        }  
    }
  /*****************************************************************************
    * @description: Method used for covering the negative scenario where Incentive Status and Question Set Status donot match
    * @param: none
    * @return: void
   */
    static testMethod void questionSetDifferetStatus() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
        //TestData for QuestionSet Object
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        }
       Database.insert (lquestionset,false);
        //Entry Criteria Logics     
       List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Incentive','IncentiveType__c','Incentive'));
         
        insert lentrycriteria;          
        
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<10;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert(lcommunication,false);
        
        Test.startTest();        
        List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
       
        for(Integer i=0; i<10; i++)
        {
            imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, NEW_STATUS,lcommunication[i].Id));
            imhIncentiveList[i].IncentiveType__c = 'Message';
        }
        Database.insert(imhIncentiveList,false);
        
        SET<ID> imhOffList = new SET<ID>();        
        for(IMH_Incentive__c imh: imhIncentiveList){
            imhOffList.add(imh.ID);
        }
        Database.update(imhIncentiveList,false);
        
        }   
    } 
     /*****************************************************************************
    * @description: Method used for covering the negative scenario where Question Set 
    *                is for Creative Object
    * @param: none
    * @return: void
    */
    static testMethod void questionSetDifferetObject() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
        //TestData for QuestionSet Object
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(CREATE_NAME));
        }
       Database.insert (lquestionset,false);
        //Entry Criteria Logics
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));   
         
        insert lentrycriteria;      


        
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<10;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert(lcommunication,false);
        
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<10;i++)
        {
            
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[i].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,false);
        
        Test.startTest();        
        List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
       
        for(Integer i=0; i<10; i++)
        {
            imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[i].Id));
            imhIncentiveList[i].IncentiveType__c = 'Message';
        }
        Database.insert(imhIncentiveList,false);
        
        SET<ID> imhOffList = new SET<ID>();        
        for(IMH_Incentive__c imh: imhIncentiveList){
            imh.IncentiveStatus__c = 'Approved';
            imhOffList.add(imh.ID);
        }
        Database.update(imhIncentiveList,false);
        
        
        
        Test.stopTest();
      
      
       
        } 
    } 
    
   /*****************************************************************************
    * @description: Method used for covering the case when we recall the incentive and we check the count of question set.
    * @param: none
    * @return: void
    */
    static testMethod void noNewAnswerSetCreated() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
        //TestData for QuestionSet Object
         List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        }
       Database.insert (lquestionset,false);
        //Entry Criteria Logics
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));   
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Incentive','IncentiveType__c','Incentive'));
         
        insert lentrycriteria;              
        
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert(lcommunication,false);
        
        Test.startTest();        
       List<IMH_Incentive__c> lincentives = new List<IMH_Incentive__c>();
        for(Integer i=0;i<10;i++)
        {
            lincentives.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id,STATUS_NAME,lcommunication[0].ID));
            
                lincentives[i].IncentiveType__c = 'Incentive';
        }
        IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(lincentives,false);

        
        //Incentive Updated to In Review and send for approval 
        List<IMH_Incentive__c> linrevincentive = [Select ID,
                                                 IncentiveStatus__c
                                          FROM IMH_Incentive__c
                                          WHERE ID IN:lincentives
                                          AND IncentiveStatus__c =:STATUS_NAME
                                          LIMIT 50000];
        
        
        IMH_IncentiveTriggerHandler.isExecutedAfter = False;       
        for(Integer i=0;i<5;i++){
            if(i >=2 )
            {
                linrevincentive[i].IncentiveStatus__c = 'Approved';
            }
            else
            {
                linrevincentive[i].IncentiveStatus__c = 'In Progress';
            }
        }
        IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.update(linrevincentive,false);
       
        
         Test.stopTest();
        System.assertEquals(10,linrevincentive.size());
         System.assertEquals('Approved',[Select IncentiveStatus__c From IMH_Incentive__c Where ID =:linrevincentive[4].Id LIMIT 1].IncentiveStatus__c);
        //Assert to check the number of answer set remains the same on recall of the incentive
      
    }
    }
    
    /*****************************************************************************
    * @description: Method used to check the SYS_IncentiveType__c field value on Communication Object
    * @param: none
    * @return: void
    */
    static testMethod void checkSysIncentiveType(){
    //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){        
        //TestData for Communication object
        List<IMH_Communication__c> communicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++)
        {
             communicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }                        
        Database.insert(communicationList,false);
        
        Test.startTest();
        //TestData for Incentive Type object        
        List<IMH_Incentive__c> incentiveList=new List<IMH_Incentive__c>();
        
        for(Integer i=0; i<6; i++)
        {
            if(i<2){            
                incentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,communicationList[0].Id));
                incentiveList[i].IncentiveType__c = 'Message';
             }else if(i>=2 && i<4){
                incentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,communicationList[0].Id));
                incentiveList[i].IncentiveType__c = 'Incentive';
               }else{
                incentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('Merchant_Fulfilled').Id, INCENTIVE_STATUS,communicationList[0].Id));
                incentiveList[i].IncentiveType__c = 'Incentive';
               }
        }
         Database.insert(incentiveList,false);
         IMH_Communication__c campIncentiveType=[Select Id,SYS_IncentiveType__c,ProcessStage__c,ReviewStatus__c,TargetMarket__c from IMH_Communication__c where Id in :communicationList LIMIT 1];
         
         Test.stopTest();
         //Assert to check whether incentive is created or not 
         system.assertNotEquals(10,incentiveList.size());
         System.AssertEquals(6,incentiveList.size());
        // System.AssertEquals('Message;Incentive',campIncentiveType.SYS_IncentiveType__c);
         System.AssertNotEquals('Message',campIncentiveType.SYS_IncentiveType__c);
         System.AssertNotEquals('Incentive',campIncentiveType.SYS_IncentiveType__c);
         System.AssertNotEquals('Incentive;Message',campIncentiveType.SYS_IncentiveType__c);
         //System.AssertNotEquals(null,campIncentiveType.SYS_IncentiveType__c);
       }
    
    }
    
    
     /*****************************************************************************
    * @description: Method used to check the SYS_IncentiveType__c field value on Communication Object when IncentiveStatus__c is 'Cancelled'
    * @param: none
    * @return: void
    */
    static testMethod void testSysIncentiveType(){
    //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){        
        //TestData for Communication object
        List<IMH_Communication__c> communicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++)
        {
             communicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }                        
        Database.insert(communicationList,false);
        
        Test.startTest();
        //TestData for Incentive Type object        
        List<IMH_Incentive__c> incentiveList=new List<IMH_Incentive__c>();
        
        for(Integer i=0; i<6; i++)
        {
            if(i<2){            
                incentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,communicationList[0].Id));
                incentiveList[i].IncentiveType__c = 'Message';
                incentiveList[i].IncentiveStatus__c='Cancelled';
             }else if(i>=2 && i<4){
                incentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,communicationList[0].Id));
                incentiveList[i].IncentiveType__c = 'Incentive';
               }else{
                incentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('Merchant_Fulfilled').Id, INCENTIVE_STATUS,communicationList[0].Id));
                incentiveList[i].IncentiveType__c = 'Incentive';
               }
        }
         Database.insert(incentiveList,false);
         
         IMH_Communication__c campIncentiveType=[Select Id,SYS_IncentiveType__c,ProcessStage__c,ReviewStatus__c,TargetMarket__c from IMH_Communication__c where Id in :communicationList LIMIT 50000];
         
         Test.stopTest();
         //Assert to check whether incentive is created or not 
         system.assertNotEquals(10,incentiveList.size());
         System.AssertEquals(6,incentiveList.size());
         //System.AssertEquals('Incentive',campIncentiveType.SYS_IncentiveType__c);
         System.AssertNotEquals('Message',campIncentiveType.SYS_IncentiveType__c);
         System.AssertNotEquals('Incentive;Message',campIncentiveType.SYS_IncentiveType__c);
         System.AssertNotEquals('Message;Incentive',campIncentiveType.SYS_IncentiveType__c);
         //System.AssertNotEquals(null,campIncentiveType.SYS_IncentiveType__c);
       }
    
    }
    
    
    /*****************************************************************************
    * @description: Method used to check the null value on the fields 'IncentiveType' on Incentive object and 'SYS_IncentiveType__c' on Communication object
    * @param: none
    * @return: void
    */
     static testMethod void nullIncentiveType(){
    //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){        
        //TestData for Communication object
        List<IMH_Communication__c> communicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++)
        {
             communicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }                        
        Database.insert(communicationList,false);
        
        Test.startTest();
        //TestData for Incentive Type object        
        List<IMH_Incentive__c> incentiveList=new List<IMH_Incentive__c>();
        
        for(Integer i=0; i<6; i++)
        {
            if(i<2){            
                incentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,communicationList[0].Id));
                incentiveList[i].IncentiveType__c = '';
             }else if(i>=2 && i<4){
                incentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,communicationList[0].Id));
                incentiveList[i].IncentiveType__c = '';
               }else{
                incentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('Merchant_Fulfilled').Id, INCENTIVE_STATUS,communicationList[0].Id));
                incentiveList[i].IncentiveType__c = '';
               }
        }
         Database.insert(incentiveList,false);
         List<IMH_Incentive__c> offr = [Select Id,IncentiveType__c From IMH_Incentive__c Where IncentiveStatus__c != 'Cancelled' LIMIT 50000];
         IMH_Communication__c campIncentiveType=[Select Id,SYS_IncentiveType__c,ProcessStage__c,ReviewStatus__c,TargetMarket__c from IMH_Communication__c where Id in :communicationList LIMIT 50000];
         
         Test.stopTest();
         //Assert to check whether incentives are created or not 
         system.assertNotEquals(10,incentiveList.size());
         System.AssertEquals(6,incentiveList.size());
         
         //Assert to check the null value
         System.AssertEquals(null,campIncentiveType.SYS_IncentiveType__c);       
         System.AssertEquals(offr[0].IncentiveType__c,campIncentiveType.SYS_IncentiveType__c);
         System.AssertNotEquals('Message',campIncentiveType.SYS_IncentiveType__c);
         System.AssertNotEquals('Incentive',campIncentiveType.SYS_IncentiveType__c);
         System.AssertNotEquals('Message;Incentive',campIncentiveType.SYS_IncentiveType__c);
         System.AssertNotEquals('Incentive;Message',campIncentiveType.SYS_IncentiveType__c);
         
       }
    
    }

    /*****************************************************************************
    * @description: Method used for covering the case when incentive is deleted by Submitter
    * @param: none
    * @return: void
    */
    static testMethod void IncentiveDeleteSubmitter() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
         User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){  

            //TestData for Campaign Object
        IMH_Communication__c lcommunication = new IMH_Communication__c();
        lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(lcommunication,false);
        
        Test.startTest();        
       List<IMH_Incentive__c> lincentives = new List<IMH_Incentive__c>();
        for(Integer i=0;i<10;i++)
        {
            lincentives.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id,STATUS_NAME,lcommunication.ID));
                            lincentives[i].IncentiveType__c = 'New Offer Construct Type';
        }
        
        IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(lincentives,false);
        System.assertEquals(lincentives.size(),10);

        //Deleting Incentives
         List<IMH_Incentive__c> lincentivesDeleteList = new List<IMH_Incentive__c>();  
         for(Integer i=0;i<2;i++){
                lincentivesDeleteList.add(lincentives[i]);
         }        

        Database.delete(lincentivesDeleteList,true);

        Test.stopTest();   
        List<IMH_Incentive__c> IncentiveAfterDelete = new List<IMH_Incentive__c>();
        IncentiveAfterDelete = [SELECT id, communication__c from IMH_Incentive__c 
                                        WHERE communication__c =: lcommunication.Id
                                        LIMIT 50000];
        System.assertEquals(IncentiveAfterDelete.size(),8);            
        }
    }   
   
    
     /*****************************************************************************
    * @description: Method used for covering the case when incentive is being tried to be deleted by Reviewer
    * @param: none
    * @return: void
    */
    static testMethod void IncentiveDeleteReviewer() {
         String responseReturned = '';        
         Boolean flag = False;   
        User runningUserReviewer  = IMH_TestClassUtility.createUser('iMH Campaign Reviewer','RunningUserReviewer',null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Thailand Reviewer' LIMIT 1];
        runningUserReviewer.Market__c= 'Thailand';
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser('iMH Campaign Submitter','RunningUserSubmitter',null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Thailand Submitter' LIMIT 1];
        runningUserSubmitter.Market__c= 'Thailand';
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');
        Insert adminUser;
        system.runAs(adminUser) {    
            //COG Group
            Group groupCOG = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CentralOfferGovernance' LIMIT 1];
            GroupMember groupMemCOG = new GroupMember();
            groupMemCOG.GroupId = groupCOG.Id;
            groupMemCOG.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCOG;
            
            //Central Brand Group
            Group groupCB = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CentralBrand' LIMIT 1];
            GroupMember groupMemCB = new GroupMember();
            groupMemCB.GroupId = groupCB.Id;
            groupMemCB.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCB;
        
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication( 'Concept','In Progress', 'Thailand'));              
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress',lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'New Offer Construct Type';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            
        }
        Test.startTest();   
        //RUNNING AS CAMPAIGN Reviewer CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer) {         
        try {

        List<IMH_Communication__c>  commList = new List<IMH_Communication__c>();
        commList = [SELECT Id,ProcessStage__c FROM IMH_Communication__c WHERE Id =: insertedCommunicationId LIMIT 50000];
    
        List<IMH_Incentive__c> IncentiveList = new List<IMH_Incentive__c>();
        IncentiveList = [SELECT id, communication__c from IMH_Incentive__c 
                                        WHERE communication__c =: commList[0].Id
                        LIMIT 50000];            
        System.assertEquals(IncentiveList.size(),1);  
        
        //Reviewer Deletes Incentive
        Database.delete(IncentiveList,true);    
        }
        catch(Exception e){
                   responseReturned = e.getMessage();
            }
        if(responseReturned.contains('You do not have sufficient privileges to delete the incentive')){
            flag = True;
        }
        System.assertEquals(flag,true);              
        //Reviewer should not be able to delete.
        }
        Test.stopTest();                
    }    

   /*****************************************************************************
    * @description: Method used for covering the case when incentive is deleted by Submitter on Creative Stage
    * @param: none
    * @return: void
    */
    static testMethod void IncentiveDeleteSubmitterStageCreative() {

         String responseReturned = '';        
         Boolean flag = False;           
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
         User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 

        try {            
       
            //TestData for Communication Object
        IMH_Communication__c lcommunication = new IMH_Communication__c();
        lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(lcommunication,false);
        
        Test.startTest();        
       List<IMH_Incentive__c> lincentives = new List<IMH_Incentive__c>();
        for(Integer i=0;i<10;i++)
        {
            lincentives.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id,STATUS_NAME,lcommunication.ID));
                            lincentives[i].IncentiveType__c = 'New Offer Construct Type';
        }
        
        IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(lincentives,false);
        System.assertEquals(lincentives.size(),10);

        lcommunication.ProcessStage__c = 'Creative';
        lcommunication.ReviewStatus__c = 'In Progress';
        Update lcommunication;

        Database.delete(lincentives,true);
        }

         catch(Exception e){
         responseReturned = e.getMessage();
            }
        if(responseReturned.contains('Incentives can only be deleted during Concept Design Stage. If you wish to delete this Incentive, please go back to the Concept stage. Alternatively if this Incentive no longer applies, please select cancelled in the status field.')){
            flag = True;
        }
        System.assertEquals(flag,true);           
        }


        Test.stopTest();   
    }   
/*****************************************************************************
    * @description: Method used for covering the case when incentive is deleted by Submitter
    * @param: none
    * @return: void
    */
    static testMethod void IncentiveUnDeleteSubmitter() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
         User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){  

            //TestData for Campaign Object
        IMH_Communication__c lcommunication = new IMH_Communication__c();
        lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(lcommunication,false);
        
        Test.startTest();        
       List<IMH_Incentive__c> lincentives = new List<IMH_Incentive__c>();
        for(Integer i=0;i<10;i++)
        {
            lincentives.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id,STATUS_NAME,lcommunication.ID));
                            lincentives[i].IncentiveType__c = 'New Offer Construct Type';
        }
        
        IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        Database.insert(lincentives,false);
        System.assertEquals(lincentives.size(),10);

        IMH_IncentiveTriggerHandler.isExecutedAfter = False;
        Database.delete(lincentives[0].id,true);

        //Assert To Check if the incentive is getting deleted
        List<IMH_Incentive__c> IncentiveAfterDelete = new List<IMH_Incentive__c>();
        IncentiveAfterDelete = [SELECT id, communication__c from IMH_Incentive__c 
                                        WHERE communication__c =: lcommunication.Id
                                       LIMIT 50000];
        System.assertEquals(IncentiveAfterDelete.size(),9);   

        IMH_IncentiveTriggerHandler.isExecutedAfter = False;
        Database.undelete(lincentives[0].id,true);

        //Assert To Check if the incentive is getting undelete
        List<IMH_Incentive__c> IncentiveAfterUnDelete = new List<IMH_Incentive__c>();
        IncentiveAfterUnDelete = [SELECT id, communication__c from IMH_Incentive__c 
                                        WHERE communication__c =: lcommunication.Id
                                       LIMIT 50000];
        System.assertEquals(IncentiveAfterUnDelete.size(),10);        

       }
    }   
    /**
    * @description  - Method used for checking whether reevaluation Occurs on Insert, delete and undelete (US693031)
    * @param  - none
    * @return  - none
    */  
    static testMethod void checkReEvaluate() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
        List<IMH_AnswerSet__c> lansset = new List<IMH_AnswerSet__c>();
        //CREATE QUESTION SET RECORD
        
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet('Communication'));
        }
        Database.insert (lquestionset,false);
           // System.debug('*** 1TEST '+lquestionset);
        //Entry Criteria Logics
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c','Singapore'));  
        insert lentrycriteria;   
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lquestion = new List<IMH_Question__c>();
        for(Integer i=0;i<1;i++){
            lquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id, i,IMH_TestClassUtility.mRecordType.get('IMH_Question__c').get('Yes_No').ID));
        }
        Database.insert(lquestion,false);
        
        //CREATE QUESTION ACTION RECORDS FOR BULK TESTING
        List<IMH_QuestionAction__c> lquestionaction = new List<IMH_QuestionAction__c>();
        for(Integer i=0; i<1; i++){
            lquestionaction.add(IMH_TestClassUtility.createQuestionAction('Yes','RequiredApprovers__c','Communication',lquestion[i].Id,'Central Offer Governance'));
        }
        Database.insert(lquestionaction,false);
        IMH_EntryCriteria__c tempEntry = new  IMH_EntryCriteria__c();
        lentrycriteria = new List<IMH_EntryCriteria__c>();
        for(Integer i=0; i<1; i++){
               tempEntry = IMH_TestClassUtility.createEntryCriteria(null,'Incentive','Merchant_Fulfillment_Detail__c','In-Store'); 
               tempEntry.QuestionAction__c =lquestionaction[i].Id;
               lentrycriteria.add(tempEntry);  
        }    
        insert lentrycriteria;     
        
        //ASSERT IF QUESTION RECORDS ARE CREATED WITH EXPECTED RESULTS - MAKING SURE NO DUPLICATE ACTIONS
        System.assertEquals(1,lquestionaction.size());
        
        //CREATE A CAMPAIGN TO GET ANSWER SET CREATED BY TRIGGER 
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){
            lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,'Singapore'));
        }
        IMH_CommunicationTriggerHandler.iscreatedAnswerSet = false;
        IMH_CommunicationTriggerHandler.isExecutedAfter = false;   
        insert lcommunication;
        List<IMH_Incentive__c> lincentives = new List<IMH_Incentive__c>();
        for(Integer i=0;i<1;i++)
        {
            lincentives.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('Merchant_Fulfilled').Id,STATUS_NAME,lcommunication[i].ID));
            lincentives[i].IncentiveType__c = 'New Offer Construct Type';
            lincentives[i].Merchant_Fulfillment_Detail__c = 'Online';
        }
        
        IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        insert lincentives;
        //lansset = [SELECT Id FROM IMH_AnswerSet__c WHERE Creative__c IN :lcreative];
        lansset = [SELECT Id FROM IMH_AnswerSet__c WHERE Communication__c =: lcommunication];
        System.debug('>>>lsize>: '+lansset.size());
        
        //CREATE ANSWER RECORDS WITH ANSWER THAT MEETS QUESTION ACTION CRITERIA
        List<IMH_Answer__c> lanswer = new List<IMH_Answer__c>();
        for(Integer i=0;i<1;i++){
            lanswer.add(IMH_TestClassUtility.createAnswer('Yes','Completed',lansset[i].id,lquestion[i].Id));
        }
        Database.insert(lanswer,false);
        
        List<IMH_Incentive__c> lIncentivesAdd = new List<IMH_Incentive__c>();
        for(Integer i=0;i<1;i++)
        {
            lIncentivesAdd.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('Merchant_Fulfilled').Id,STATUS_NAME,lcommunication[i].ID));
            lIncentivesAdd[i].IncentiveType__c = 'New Offer Construct Type';
            lIncentivesAdd[i].Merchant_Fulfillment_Detail__c = 'In-Store';
        }
        IMH_IncentiveTriggerHandler.isExecutedAfter = false;
        insert lIncentivesAdd;
		List<IMH_Incentive__c> lupdateIncentive = [SELECT Id,Communication__r.RequiredApprovers__c,Merchant_Fulfillment_Detail__c
        	                                      FROM IMH_Incentive__c
              		                              WHERE Id IN:lincentives
                    	                          LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
        Test.startTest();
		List<IMH_Incentive__c> lDeleteIncentive = [SELECT Id FROM IMH_Incentive__c WHERE Id IN:lIncentivesAdd
                    	                          LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		IMH_IncentiveTriggerHandler.isExecutedAfter = false;
		IMH_CommunicationTriggerHandler.iscreatedAnswerSet = false;
        IMH_CommunicationTriggerHandler.isExecutedAfter = false;   
		delete lDeleteIncentive;            
		Test.stopTest();
		System.debug('Incetive After Delete_____________________>>: '+lupdateIncentive);       
        System.assertEquals('Central Offer Governance',lupdateIncentive.get(0).Communication__r.RequiredApprovers__c);    
        }  
    }
}