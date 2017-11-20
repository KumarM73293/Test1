/**
* @author Accenture IDC 
* @date 05/27/2015
* @group Answer
* @group-content N/A
* @description: iMH Release 1 (Sprint 1) - Test Class for Trigger on Answer object which looks for the after insert and after update event 
* logic has been triggered on particular event of an object.
*/
@isTest(SeeAllData=false)
private class IMH_CommunicationTriggerTest {
   private static final String STAGE_NAME = 'Concept';
   private static final String STATUS_NAME = 'In Progress';
   private static final String MARKET_NAME = 'Hong Kong';
   private static final String OBJECT_NAME = 'Communication';
   private static final String CANCEL_STATUS = 'Cancelled';
   private static final String CANCEL_REASON = 'Submission made in error';
    private static Final String NEW_STAGE = 'Creative';
    private static Final String NEW_STATUS = 'In Review';
    private static Final String READY_STATUS = 'Ready For Review';
    private static Final String PRE_EXECUTION = 'Pre-Execution Testing';
    
    private static final String CAMPAIGN_SUBMITTER_PROFILE = 'iMH Campaign Submitter';
    private static final String RUNNING_USER = 'RunningUser';
  
    /*****************************************************************************
    * @description: Method used for covering the case when cancelling the communication cancel all its  creatives and offer
    *                which are in approval process.
    * @param: none
    * @return: void
    */ 
    static testMethod void updateSubmittedIncentiveCreativeOnCommunicationCancel() {
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
 
        List<IMH_Incentive__c> loffers = new List<IMH_Incentive__c>();
        for(Integer i=0;i<5;i++)
        {
            loffers.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id,STATUS_NAME,lcommunication[0].ID));
            loffers[i].SYSOpenAnswerSets__c = 0;
           // loffers[i].SYSAdditionalInformation__c = false;
            
        }
        Database.insert(loffers,false);
        
        //List<IMH_Incentive__c> lsubmittedoffer = new List<IMH_Incentive__c>();
         
        Test.startTest();
        
        
         List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<5;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
            lcreative[0].SYSOpenAnswerSets__c = 0;
        }
        Database.insert(lcreative,false);
        
        
        lcommunication[0].ProcessStage__c = NEW_STAGE;
         IMH_CommunicationTriggerHandler.isExecutedAfter = false;
        Database.update(lcommunication[0],false);
        

        
       List<IMH_CommCreative__c> lsubmittedcreative = new List<IMH_CommCreative__c>();
         
        Integer i=0;
        for(IMH_CommCreative__c imh:[SELECT Id,
                                  CreativeStatus__c,
                                 RequiredApprovers__c
                           FROM IMH_CommCreative__c
                           WHERE ID IN:lcreative
                           LIMIT 50000])
        {
           
               imh.CreativeStatus__c = NEW_STATUS;
               imh.RequiredApprovers__c = 'Local Brand;Compliance';
               lsubmittedcreative.add(imh);
           
        }
        Database.update(lsubmittedcreative,false);
             
        lcommunication[0].ReviewStatus__c = CANCEL_STATUS;
        lcommunication[0].CommunicationCancellationReason__c = CANCEL_REASON;
         IMH_CommunicationTriggerHandler.isExecutedAfter = false;
        Database.update(lcommunication[0],false);
               
       
        List<IMH_CommCreative__c> lupcreative = [SELECT ID,
                                                    CreativeStatus__c
                                             FROM IMH_CommCreative__c
                                             WHERE Communication__c = :lcommunication[0].ID
                                             AND CreativeStatus__c =:CANCEL_STATUS
                                            LIMIT 50000];
       Test.stopTest(); 
       
        }
    }
         /*****************************************************************************
    * @description: Method used for covering the case when cancelling the communication cancel all its  creatives and offer
    *                which are partially in  approval process and partially In Progress status.
    * @param: none
    * @return: void
    */ 
    static testMethod void submittedIncentiveCreativeOnCommunicationCancel() {
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
         Test.startTest();       
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<5;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert(lcommunication,false);
 
        List<IMH_Incentive__c> loffers = new List<IMH_Incentive__c>();
        for(Integer i=0;i<5;i++)
        {
            loffers.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id,STATUS_NAME,lcommunication[0].ID));
            loffers[i].SYSOpenAnswerSets__c = 0;
            
            
        }
        Database.insert(loffers,false);
        
       
         
       Integer cnt=0; 
       
        
         List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<5;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
            lcreative[0].SYSOpenAnswerSets__c = 0;
        }
        Database.insert(lcreative,false);
        
        
        lcommunication[0].ProcessStage__c = NEW_STAGE;
         IMH_CommunicationTriggerHandler.isExecutedAfter = false;
        Database.update(lcommunication[0],false);
        
        Integer countCreative = 0;
        
       List<IMH_CommCreative__c> lsubmittedcreative = new List<IMH_CommCreative__c>();
         
      
        for(IMH_CommCreative__c imh:[SELECT Id,
                                  CreativeStatus__c,
                                 RequiredApprovers__c
                           FROM IMH_CommCreative__c
                           WHERE ID IN:lcreative LIMIT 50000])
        {
           if(countCreative < 3)
           {
               imh.CreativeStatus__c = 'Ready For Review';
               imh.RequiredApprovers__c = 'Local Brand;Compliance';
               lsubmittedcreative.add(imh);
           }
           countCreative++;
        }
        Database.update(lsubmittedcreative,false);
        
        
            
        lcommunication[0].ReviewStatus__c = CANCEL_STATUS;
        lcommunication[0].CommunicationCancellationReason__c = CANCEL_REASON;
         IMH_CommunicationTriggerHandler.isExecutedAfter = false;
        Database.update(lcommunication[0],false);
        
        
        List<IMH_CommCreative__c> lupcreative = [SELECT ID,
                                                    CreativeStatus__c
                                             FROM IMH_CommCreative__c
                                             WHERE Communication__c = :lcommunication[0].ID
                                             AND CreativeStatus__c =:CANCEL_STATUS
                                            LIMIT 50000];
       Test.stopTest(); 
        
        }
    } 
  /*****************************************************************************
    * @description: Method used for covering the case when cancelling the communication cancel all its associated offers.
    * @param: none
    * @return: void
    */ 
    
 
     /*****************************************************************************
    * @description: Method used for covering the negative case when we cancel the communication but it doesn't has the offers associated
    * @param: none
    * @return: void
    */  
    static testMethod void negUpdateIncentiveOnCommunicationCancel() {
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
          Test.startTest();      
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<5;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert(lcommunication,false);
      
         
       //The communication is submitted for approval and the stage changes 
        lcommunication[0].ReviewStatus__c = CANCEL_STATUS;
        lcommunication[0].CommunicationCancellationReason__c = CANCEL_REASON;
         IMH_CommunicationTriggerHandler.isExecutedAfter = false;
        Database.update(lcommunication[0],false);
        
        }
    }
  

    
 
    /*****************************************************************************
    * @description: Method used for covering the case when we have the Question Set is created for Pre Execution Questionnaire
    * @param: none
    * @return: void
    */
    static testMethod void createPreExecutionQuestion() {
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
         //TestData for QuestionSet Object
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        for(Integer i=0; i<1; i++)
        {
            lquestionset.add(IMH_TestClassUtility.createQuestionSet(OBJECT_NAME));
        }
            IMH_CommunicationTriggerHandler.isExecutedAfter = false;
       Database.insert (lquestionset,false);
        //Entry Criteria Logics
        List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','TargetMarket__c',MARKET_NAME));     
         
        insert lentrycriteria;    
            
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<5;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(PRE_EXECUTION,STATUS_NAME,MARKET_NAME));
        }
        Database.insert(lcommunication,false);
            IMH_CommunicationTriggerHandler.isExecutedAfter = false;
        Test.startTest();        
         List<IMH_AnswerSet__c> lansset = [SELECT Id,
                                                  Status__c,
                                                  Communication__c,
                                                  CompletionPercentage__c
                                           FROM IMH_AnswerSet__c 
                                           WHERE Communication__c IN :lcommunication
                                          LIMIT 50000];
        Test.stopTest();
        //Assert to Check whether Answer Set for Communication are  created with proper status and completion percentage      
        System.assertEquals(0, lansset[0].CompletionPercentage__c);
        system.assertEquals(5,lansset.size());
        } 
    }
    /*****************************************************************************
    * @description: Method used for covering the negative case when we have the Question Set 
    *               but communication is on differnt status
    * @param: none
    * @return: void
    */
    static testMethod void createNegPreExecutionQuestion() {
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
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Communication','ProcessStage__c','Pre-Execution Testing'));         
        lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'Incentive','IncentiveType__c','Incentive'));
         
        insert lentrycriteria;          

            
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<5;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert(lcommunication,false);
       IMH_CommunicationTriggerHandler.isExecutedAfter = false;
        Test.startTest();        
         List<IMH_AnswerSet__c> lansset = [SELECT Id,
                                                  Status__c,
                                                   Communication__c,
                                                  CompletionPercentage__c
                                           FROM IMH_AnswerSet__c 
                                           WHERE Communication__c IN :lcommunication
                                          LIMIT 50000];
        Test.stopTest();
        //Assert to Check whether Answer Set for Communication is not created
        system.assertEquals(0,lansset.size());
         
    }
    }
     /*****************************************************************************
    * @description: Method used for covering the mandatory approval process.
    * @param: none
    * @return: void
    */ 
    static testMethod void stampMandatoryApproversOnCommunication() {
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        runningUser.IMH_User_Team__c = 'Team A';
        IMH_Mandatory_Approval_Matrix__c mamRec1 = new IMH_Mandatory_Approval_Matrix__c();
        mamRec1.name              = 'Team A_Hong Kong1';
        mamRec1.Team__c           = 'Team A';
        mamRec1.Market__c         = 'Hong Kong';
        mamRec1.Approval_Group__c = 'Central Offer Governance';
        mamRec1.Is_Mandatory__c   = True;
        insert mamRec1;
        IMH_Mandatory_Approval_Matrix__c mamRec2 = new IMH_Mandatory_Approval_Matrix__c();
        mamRec2.name              = 'Team A_Hong Kong2';
        mamRec2.Team__c           = 'Team A';
        mamRec2.Market__c         = 'Hong Kong';
        mamRec2.Approval_Group__c = 'Local Offer Governance';
        mamRec2.Is_Mandatory__c   = False;
        insert mamRec2;
        IMH_Mandatory_Approval_Matrix__c mamRec3 = new IMH_Mandatory_Approval_Matrix__c();
        mamRec3.name              = 'Team A_Hong Kong3';
        mamRec3.Team__c           = 'Team A';
        mamRec3.Market__c         = 'Hong Kong';
        mamRec3.Approval_Group__c = 'Central Band';
        mamRec3.Is_Mandatory__c   = True;
        insert mamRec3;
        
        system.runAs(runningUser) { 
            List<IMH_Communication__c> lCommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<50;i++) {
                lCommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
            }
            Database.SaveResult[] communicationInsList = Database.insert(lCommunication,false);
            id insertedCommunicationId;
            for(Database.SaveResult sr: communicationInsList){    
                if(sr.isSuccess()){
                    insertedCommunicationId = sr.getId();
                }
            }
            IMH_Communication__c insertedcommunicationRec = [SELECT Id, Name, Mandatory_Approvers__c FROM IMH_Communication__c 
                                                        WHERE Id =: insertedCommunicationId LIMIT 1];
            System.assertEquals(true, insertedcommunicationRec.Mandatory_Approvers__c.contains('Central Offer Governance'));
            System.assertEquals(true, insertedcommunicationRec.Mandatory_Approvers__c.contains('Central Band'));
            System.assertEquals(false, insertedcommunicationRec.Mandatory_Approvers__c.contains('Local Offer Governance'));
        }
    }
    /*****************************************************************************
    * @description: Method used for covering the scenarios where Central Benefits Pre approved benefits is selected.
    * @param: none
    * @return: void
    */ 
    static testmethod void generationOfCentralPreapproved(){
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
         User adminUser = new User(Alias = 'standt', Email='standarduserbenfits@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduserbenfits@amextest.com');
        
        System.runAs(adminUser){
            List<IMH_Communication__c> lcommunication;
            Id insertedCommunicationId;     
            List<IMH_SLATracker__c> lApptrack;
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<5;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
                lcommunication[i].Communication_Type__c = 'Pre-Approved Benefit';
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.insert(lcommunication,false); 
            
            List<IMH_Benefits__c> lBenefits  = new List<IMH_Benefits__c>();
            for(Integer i=0;i<5;i++) {
                lBenefits.add(IMH_TestClassUtility.createBenefits('Central','Global','Global'));
                lBenefits[i].BenefitStage__c = 'Complete';
                lBenefits[i].ApprovalStage__c = 'Accepted';
            }
            Database.insert(lBenefits,false);
            Test.startTest();
            List<IMH_PreApprovedBenefits__c> lpreapproved = new List<IMH_PreApprovedBenefits__c>();
            for(Integer i=0;i<5;i++){
                lpreapproved.add(IMH_TestClassUtility.createPreApprovedBenefits(lcommunication[i].Id,lBenefits[i].Id));
            }
            Database.insert(lpreapproved,false);
            Test.stopTest();
            List<IMH_Communication__c> lupdatedcomms = new List<IMH_Communication__c>();
            lupdatedcomms = [SELECT id
                             ,RequiredApprovers__c
                             FROM IMH_Communication__c
                             WHERE ID IN:lcommunication
                            LIMIT 50000];
            System.assertEquals(lupdatedcomms[0].RequiredApprovers__c, 'Benefits Team');
        }
    }
     /*****************************************************************************
    * @description: Method used for covering the scenarios where Central Benefits Pre approved benefits is selected.
    *               and there are already few groups present
    * @param: none
    * @return: void
    */ 
    static testmethod void generationofBeneftisTeamwithRev(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduserbenfits@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduserbenfits@amextest.com');
        
        System.runAs(adminUser){
            List<IMH_Communication__c> lcommunication;
            Id insertedCommunicationId;     
            List<IMH_SLATracker__c> lApptrack;
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<5;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
                lcommunication[i].Communication_Type__c = 'Pre-Approved Benefit';
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].RequiredApprovers__c = 'Central Brand;Central Offer Governance';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.insert(lcommunication,false); 
            
            List<IMH_Benefits__c> lBenefits  = new List<IMH_Benefits__c>();
            for(Integer i=0;i<5;i++) {
                lBenefits.add(IMH_TestClassUtility.createBenefits('Central','Global','Global'));
                lBenefits[i].BenefitStage__c = 'Complete';
                lBenefits[i].ApprovalStage__c = 'Accepted';
            }
            Database.insert(lBenefits,false);
            Test.startTest();
            List<IMH_PreApprovedBenefits__c> lpreapproved = new List<IMH_PreApprovedBenefits__c>();
            for(Integer i=0;i<5;i++){
                lpreapproved.add(IMH_TestClassUtility.createPreApprovedBenefits(lcommunication[i].Id,lBenefits[i].Id));
            }
            Database.insert(lpreapproved,false);
            Test.stopTest();
            List<IMH_Communication__c> lupdatedcomms = new List<IMH_Communication__c>();
            lupdatedcomms = [SELECT id
                             ,RequiredApprovers__c
                             FROM IMH_Communication__c
                             WHERE ID IN:lcommunication 
                            LIMIT 50000];
            System.assertEquals(lupdatedcomms[0].RequiredApprovers__c.contains('Benefits Team'),true );
        }
    }
    /*****************************************************************************
    * @description: Method used for covering the scenarios where Central Benefits Pre approved benefits is removed.
    * @param: none
    * @return: void
    */ 
    static testmethod void removalofBeneftisTeamwithRev(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduserbenfits@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduserbenfits@amextest.com');
        
        System.runAs(adminUser){
            List<IMH_Communication__c> lcommunication;
            Id insertedCommunicationId;     
            List<IMH_SLATracker__c> lApptrack;
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<5;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
                lcommunication[i].Communication_Type__c = 'Pre-Approved Benefit';
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].RequiredApprovers__c = 'Central Brand;Central Offer Governance';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.insert(lcommunication,false); 
            
            List<IMH_Benefits__c> lBenefits  = new List<IMH_Benefits__c>();
            for(Integer i=0;i<5;i++) {
                lBenefits.add(IMH_TestClassUtility.createBenefits('Central','Global','Global'));
                lBenefits[i].BenefitStage__c = 'Complete';
                lBenefits[i].ApprovalStage__c = 'Accepted';
            }
            Database.insert(lBenefits,false);
            Test.startTest();
            List<IMH_PreApprovedBenefits__c> lpreapproved = new List<IMH_PreApprovedBenefits__c>();
            for(Integer i=0;i<5;i++){
                lpreapproved.add(IMH_TestClassUtility.createPreApprovedBenefits(lcommunication[i].Id,lBenefits[i].Id));
            }
            Database.insert(lpreapproved,false);
            
            List<IMH_Communication__c> lupdatedcomms = new List<IMH_Communication__c>();
            Integer i=0;
            for(IMH_Communication__c comms:[SELECT id
                                            ,RequiredApprovers__c
                                            ,Communication_Type__c
                                            FROM IMH_Communication__c
                                            WHERE ID IN:lcommunication 
                                            LIMIT 50000]){
                                                if(i==0){
                                                    lcommunication[i].Communication_Type__c = 'Marketing Message'; 
                                                    lupdatedcomms.add(lcommunication[i]);
                                                }                              
                                                i++;                              
                                            }
            List<IMH_Communication__c> lprecount = [Select id,(Select id From PreApprovedBenefits__r) FROM IMH_Communication__c
                                                    WHERE ID IN:lupdatedcomms LIMIT 50000];
            Database.delete(lprecount[0].PreApprovedBenefits__r);
            Database.update(lupdatedcomms,false);
            Test.stopTest();
            System.assertEquals(lupdatedcomms[0].RequiredApprovers__c.contains('Benefits Team'),false );
            System.assertEquals([SELECT id,RequiredApprovers__c FROM IMH_Communication__c where ID IN:lcommunication LIMIT 50000].get(4).RequiredApprovers__c.contains('Benefits Team'),true );
        }
    }
}