/**
* @author Accenture IDC 
* @date 03/31/2016
* @group-content N/A
* @description: iMH Release 1.3.1 (Sprint 33) - Test Class for Trigger on Approval Matrix object which looks for the after insert and after update event 
*/
@isTest
private class IMH_CustomApprovalTest {
    private static final String CONCEPT_STAGE               = 'Concept';
    private static final String STATUS_NAME                 = 'In Progress';
    private static final String THAILAND_MARKET             = 'Thailand';
    private static final String UK_MARKET                   = 'UK';
    private static final String JAPA_REGION                 = 'JAPA';
    private static final String EMEA_REGION                 = 'EMEA';
    private static final String OBJECT_NAME                 = 'Communication';
    private static final String STD_PRIORITY                = 'STANDARD';
    private static final String INCENTIVE_STATUS            = 'In Progress';     
    private static final String INCENTIVISED_OFFER          = 'Incentivised Offer'; 
    private static final String REQ_MANDAPPROVERS_COG       = 'Central Offer Governance';
    private static final String REQ_MANDAPPROVERS_CB        = 'Central Brand';
    private static final String REQ_MANDAPPROVERS_COG_CB    = 'Central Offer Governance;Central Brand';    
    private static final String CAMPAIGN_SUBMITTER_PROFILE  = 'iMH Campaign Submitter';
    private static final String CAMPAIGN_REVIEWER_PROFILE   = 'iMH Campaign Reviewer';    
    private static final String SUBMITTER_THAI              = 'Thailand Submitter';
    private static final String REVIEWER_THAI               = 'Thailand Reviewer'; 
    private static final String SUBMITTER_CANADA            = 'Canada Submitter';
    private static final String REVIEWER_CANADA             = 'Canada Reviewer'; 
    private static final String SUBMITTER_UK                = 'UK Submitter';
    private static final String REVIEWER_UK                 = 'UK Reviewer';           
    private static final String SUBMITTER_RUNNING_USER      = 'RunningUserSubmitter';
    private static final String REVIEWER_RUNNING_USER       = 'RunningUserReviewer';
    private static final String RUNNING_USER                = 'RunningUser';
    private static final String COG_REVIEW_STAGE            = 'Offer Governance';
    private static final String CB_REVIEW_STAGE             = 'Central Brand';
    private static final String PRODUCT_NAME                = 'ProdTest';
    private static final String REQ_MANDAPPROVERS_BAND35    = 'Band 35';

    /*****************************************************************************
    * @description: Method for concept approval (Two Step Sequential)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    * @param: none
    * @return: void
    */ 
  static testMethod void ConceptSimpleTwoStepSequential() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= THAILAND_MARKET;
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
            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            //M.Wheeler - 13.10.2016 - R1.7 - US566199
            // mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
        
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(COG_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_COG, 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(CB_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralBrand',
                                                                            2,
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_CB, 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralBrand').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,THAILAND_MARKET));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            Test.startTest();
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],false);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
            System.assertEquals(1,lApptrack.size(),1);
            System.assertEquals('Pending',lApptrack[0].Status__c);
            Boolean verifyVar = lApptrack[0].Owner__c.contains(REQ_MANDAPPROVERS_COG)?true:false;
            System.assertEquals(true,verifyVar);            
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;  
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending'
                         LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            
            List<IMH_Communication__c>  commList = new List<IMH_Communication__c>();
            commList = [SELECT Id,ProcessStage__c FROM IMH_Communication__c WHERE Id =: insertedCommunicationId LIMIT 1];
            System.assertEquals('Creative',commList[0].ProcessStage__c);   
        }
        Test.stopTest();    
    }
    /*****************************************************************************
    * @description: Method for concept approval (One Step Concurrent)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    * @param: none
    * @return: void
     */
    static testMethod void ConceptSimpleOneStepConcurrent() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= THAILAND_MARKET;
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
            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            //M.Wheeler - 13.10.2016 - R1.7 - US566199
            // mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
        
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(COG_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_COG, 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(CB_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralBrand',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_CB, 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralBrand').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,THAILAND_MARKET));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            Test.startTest();
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],false);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           ORDER BY Owner__c
                          LIMIT 50000];
            System.assertEquals(2,lApptrack.size());
            System.assertEquals('Pending',lApptrack[0].Status__c);            
            System.assertEquals('Pending',lApptrack[1].Status__c);            
        }

        
        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending'
                          LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending'
                         LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            
            List<IMH_Communication__c>  commList = new List<IMH_Communication__c>();
            commList = [SELECT Id,ProcessStage__c FROM IMH_Communication__c WHERE Id =: insertedCommunicationId LIMIT 1];
            System.assertEquals('Creative',commList[0].ProcessStage__c);   
        }
        Test.stopTest();    
    }   
    /*****************************************************************************
    * @description: Method for concept approval (One Step Concurrent)
    *               1. Central Offer Governance Approval - Reject
    *               2. Central Brand Approval - Auto Reject
    * @param: none
    * @return: void
    */ 
    static testMethod void ConceptSequentialRejectFirst() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= THAILAND_MARKET;
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
            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
        
            //M.Wheeler - 13.10.2016 - R1.7 - US566199
            // mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));

            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));

            
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(COG_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_COG, 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(CB_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralBrand',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_CB, 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralBrand').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,THAILAND_MARKET));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            Test.startTest();
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],false);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           ORDER BY Owner__c
                           LIMIT 50000];
            System.assertEquals(2,lApptrack.size());
            System.assertEquals('Pending',lApptrack[0].Status__c);            
            System.assertEquals('Pending',lApptrack[1].Status__c);            
        }

        
        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending' AND Owner__c LIKE '%Central Offer Governance%'
                          LIMIT 1];
            System.debug('#####222>: '+lApptrack.size());
            lApptrack[0].Status__c = 'Rejected';
            update lApptrack;
            
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Owner__c LIKE '%Central Brand%' LIMIT 1];
            System.assertEquals('Recalled (Rejection)',lApptrack[0].Status__c);
            
            List<IMH_Communication__c>  commList = new List<IMH_Communication__c>();
            commList = [SELECT Id,ProcessStage__c FROM IMH_Communication__c WHERE Id =: insertedCommunicationId LIMIT 1];
            System.assertEquals('Concept',commList[0].ProcessStage__c);   
        }
        Test.stopTest();    
    }
    /*****************************************************************************
    * @description: Method for concept approval (Leadership) [Only Seqential]
    *               1. Leadership - Approve
    * @param: none
    * @return: void
    */
    static testMethod void ConceptLeadershipApprove() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= THAILAND_MARKET;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        runningUserSubmitter.ManagerId= runningUserReviewer.Id;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');
        Insert adminUser;
        system.runAs(adminUser) {    
            // Insert Approval Matrix
            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            //M.Wheeler - 13.10.2016 - US566199 - Enforced Picklist Value Fix
            mapOwnerNameByApprovalGroup.put('Leadership', IMH_TestClassUtility.createApprovalGroup('Leadership', 'Leader' ));
            //END CHANGE
        
            insert mapOwnerNameByApprovalGroup.values();
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Leadership',
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'Leadership',
                                                                            2,
                                                                            INCENTIVISED_OFFER, 
                                                                            '', 
                                                                            'Communication',
                                                                            '',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('Leadership').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,THAILAND_MARKET));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            Test.startTest();
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],false);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
            System.assertEquals(1,lApptrack.size());
            System.assertEquals('Pending',lApptrack[0].Status__c);            
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending' LIMIT 1];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            
            List<IMH_Communication__c>  commList = new List<IMH_Communication__c>();
            commList = [SELECT Id,ProcessStage__c FROM IMH_Communication__c WHERE Id =: insertedCommunicationId LIMIT 1];
            System.assertEquals('Creative',commList[0].ProcessStage__c);   
        }
        Test.stopTest();    
    }   

    /*****************************************************************************
    * @description: Method for concept approval (Leadership) [Approval Matrix is Mandatory]
    *               1. Leadership - Approve
    * @param: none
    * @return: void
   */ 
    static testMethod void ConceptLeadershipMandatory() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= THAILAND_MARKET;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        runningUserSubmitter.ManagerId= runningUserReviewer.Id;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');
        Insert adminUser;
        system.runAs(adminUser) {    
            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('Leadership', IMH_TestClassUtility.createApprovalGroup('Leadership', 'Leader'));
        
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Leadership',
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'Leadership',
                                                                            1,
                                                                            '', 
                                                                            '', 
                                                                            'Communication',
                                                                            '',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('Leadership').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,THAILAND_MARKET));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            Test.startTest();
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],false);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
            System.assertEquals(1,lApptrack.size());
            System.assertEquals('Pending',lApptrack[0].Status__c);            
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending' LIMIT 1];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            
            List<IMH_Communication__c>  commList = new List<IMH_Communication__c>();
            commList = [SELECT Id,ProcessStage__c FROM IMH_Communication__c WHERE Id =: insertedCommunicationId LIMIT 1];
            System.assertEquals('Creative',commList[0].ProcessStage__c);   
        }
        Test.stopTest();    
    }

    /*****************************************************************************
    * @description: Method for concept approval.
    *               1. COG - Mandatory - Approve
    *               2. Central Band - Mandatory -Approve
    *               3. Leadership - Mandatory -Approve
    * @param: none
    * @return: void
    */ 
    static testMethod void ConceptMandatoryGroupsAndLeadership() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= THAILAND_MARKET;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        runningUserSubmitter.ManagerId= runningUserReviewer.Id;
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
            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            //M.Wheeler - 13.10.2016 - US566199 - Enforced Picklist Value Fix
            mapOwnerNameByApprovalGroup.put('Leadership', IMH_TestClassUtility.createApprovalGroup('Leadership', 'Leader' ));
            //END CHANGE
                    
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(COG_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            '', 
                                                                            '', 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(CB_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralBrand',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            '', 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralBrand').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Leadership',
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'Leadership',
                                                                            3,
                                                                            '', 
                                                                            '', 
                                                                            'Communication',
                                                                            '',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('Leadership').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,THAILAND_MARKET));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            Test.startTest();
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],true);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
            System.assertEquals(2,lApptrack.size(),2);
            System.assertEquals('Pending',lApptrack[0].Status__c);            
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer) { 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending' LIMIT 1];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending'
                          LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending'
                          LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            
            List<IMH_Communication__c>  commList = new List<IMH_Communication__c>();
            commList = [SELECT Id,ProcessStage__c FROM IMH_Communication__c WHERE Id =: insertedCommunicationId LIMIT 1];
            System.assertEquals('Creative',commList[0].ProcessStage__c);   
        }
        Test.stopTest();    
    }

    /*****************************************************************************
    * @description: Method for concept approval.
    *               1. COG - No matrix Component
    *               2. Central Band - No matrix Component
    *               3. Leadership - No matrix Component
    * @param: none
    * @return: void
   */ 
    static testMethod void ConceptNoMatrixCompGroupsLeadership() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= THAILAND_MARKET;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        runningUserSubmitter.ManagerId= runningUserReviewer.Id;
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
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            //M.Wheeler - 13.10.2016 - US566199 - Enforced Picklist Value Fix
            mapOwnerNameByApprovalGroup.put('Leadership', IMH_TestClassUtility.createApprovalGroup('Leadership', 'Leader' ));
            //END CHANGE
                    
            insert mapOwnerNameByApprovalGroup.values();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(COG_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            '', 
                                                                            '', 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(CB_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralBrand',
                                                                            1,
                                                                            '', 
                                                                            '', 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralBrand').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Leadership',
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'Leadership',
                                                                            3,
                                                                            '', 
                                                                            '', 
                                                                            'Communication',
                                                                            '',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('Leadership').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,THAILAND_MARKET));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
             IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            Test.startTest();
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],true);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
            System.assertEquals(2,lApptrack.size());
            System.assertEquals('Pending',lApptrack[0].Status__c);            
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer) { 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending' LIMIT 1];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending'
                          LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending'
                         LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            
            List<IMH_Communication__c>  commList = new List<IMH_Communication__c>();
            commList = [SELECT Id,ProcessStage__c FROM IMH_Communication__c WHERE Id =: insertedCommunicationId LIMIT 1];
            System.assertEquals('Creative',commList[0].ProcessStage__c);   
        }
        Test.stopTest();    
    }

    /*****************************************************************************
    * @description: Method for concept approval (Two Step Sequential)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Won't be engaged as Communication Component doesn't have Central Brand
    * @param: none
    * @return: void
    */
    static testMethod void ConceptSimpleOneStepSequential() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= THAILAND_MARKET;
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
            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            //M.Wheeler - 13.10.2016 - US566199 - Enforced Picklist Value Fix
            mapOwnerNameByApprovalGroup.put('Leadership', IMH_TestClassUtility.createApprovalGroup('Leadership', 'Leader' ));
            //END CHANGE
                    
            insert mapOwnerNameByApprovalGroup.values();
        
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(COG_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            '', 
                                                                            '', 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(CB_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralBrand',
                                                                            2,
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_CB, 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralBrand').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,THAILAND_MARKET));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            Test.startTest();
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],false);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
                                                System.debug('**Approval**'+lApptrack.size());
            System.assertEquals(1,lApptrack.size(),1);
            System.assertEquals('Pending',lApptrack[0].Status__c);
        }

        
        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
                                                System.debug('**ApprovalList**'+lApptrack);
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;  
            
            List<IMH_Communication__c>  commList = new List<IMH_Communication__c>();
            commList = [SELECT Id,ProcessStage__c FROM IMH_Communication__c WHERE Id =: insertedCommunicationId LIMIT 1]; 
                                                // System.assertEquals('Creative',commList[0].ProcessStage__c); // Sprint 46
        }
        Test.stopTest();    
    }

    /*****************************************************************************
    * @description: Method for concept approval (Two Step Sequential)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    * @param: none
    * @return: void
     */
    static testMethod void CreativeSimpleTwoStepSequential() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI  LIMIT 1];
        runningUserSubmitter.Market__c= THAILAND_MARKET;
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

            //SBS Group
            Group groupSBS = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_SBS_CA' LIMIT 1];
            GroupMember groupMemSBS = new GroupMember();
            groupMemSBS.GroupId = groupSBS.Id;
            groupMemSBS.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemSBS;
            //Charge Group
            Group groupCharge = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_Charge_CA' LIMIT 1];
            GroupMember groupMemCharge = new GroupMember();
            groupMemCharge.GroupId = groupCharge.Id;
            groupMemCharge.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCharge;
            //Custommer Management Group
            Group groupCusManage = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CustomerManagement_CA' LIMIT 1];
            GroupMember groupMemCusManage = new GroupMember();
            groupMemCusManage.GroupId = groupCusManage.Id;
            groupMemCusManage.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCusManage;
            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            mapOwnerNameByApprovalGroup.put('IMH_SBS_CA', IMH_TestClassUtility.createApprovalGroup('IMH_SBS_CA', 'SBS' ));
            mapOwnerNameByApprovalGroup.put('IMH_Charge_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Charge_CA', 'Charge' ));
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
                    
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_COG, 
                                                                            'Creative',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CustomerManagement_CA',
                                                                            2,
                                                                            INCENTIVISED_OFFER, 
                                                                            'Customer Management', 
                                                                            'Creative',
                                                                            'Creative__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CustomerManagement_CA').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_Charge_CA',
                                                                            2,
                                                                            INCENTIVISED_OFFER, 
                                                                            'Charge', 
                                                                            'Creative',
                                                                            'Creative__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_Charge_CA').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                           'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_SBS_CA',
                                                                            2,
                                                                            INCENTIVISED_OFFER, 
                                                                            'SBS', 
                                                                            'Creative',
                                                                            'Creative__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_SBS_CA').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId; 
        Id creativeRecordId;    
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,'Canada'));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);
            
            
            
            //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer t=0;t<2;t++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Canada',true,'Gold'));
                prodList[t].Name=PRODUCT_NAME+t;
            } 
             prodList[0].RequiredApprovers__c = 'Charge';
            prodList[1].RequiredApprovers__c = 'SBS';
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer t=0;t<2;t++) {
                channelList.add(IMH_TestClassUtility.createChannel('Canada','LACC','AMEX'));
                channelList[t].Name='AMEX'+t;
                channelList[t].RequiredApprovers__c = 'Customer Management';
            }
            
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer t=0;t<2;t++){
            lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[t].Id,'Canada'));
             
         }  
           
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<2;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[i].Id));
        }
        Database.insert(lCommtargetedChannel,true);
            
            
            
            
            //Test Data for Creative
            IMH_CommCreative__c creativeRec = new IMH_CommCreative__c();
            creativeRec = IMH_TestClassUtility.createFinalCreative(insertedCommunicationId,'In Progress',
                           IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            creativeRec.CreativeStage__c = 'Creative';
            creativeRec.SYSCreativeStep__c = '1';
            insert creativeRec;
            creativeRecordId = creativeRec.Id;
            
            // Update Creative
            IMH_CommCreative__c creativeRecUpdate  = [SELECT Id, SYS_Ready_For_Review__c,RequiredApprovers__c 
                                                      FROM IMH_CommCreative__c 
                                                      WHERE Id =: creativeRecordId LIMIT 1];
            creativeRecUpdate.SYS_ReadyForReview_New__c = true;
            update creativeRecUpdate;
      
            /*Query expected approval record related the above communciation.
            lApptrack = [Select CommCreative__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE CommCreative__c =: creativeRecordId
                           LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
            System.assertEquals(1,lApptrack.size());
            System.assertEquals('Pending',lApptrack[0].Status__c);
            */
        }

        
        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lApptrack = [Select Id, CommCreative__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE CommCreative__c =:creativeRecordId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;  
            Test.startTest();
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, CommCreative__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE CommCreative__c =:creativeRecordId
                          AND Status__c = 'Pending'
                         LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            lApptrack[1].Status__c = 'Approved';
            lApptrack[2].Status__c = 'Approved';
            update lApptrack;
            
            List<IMH_CommCreative__c>  commList = new List<IMH_CommCreative__c>();
            commList = [SELECT Id,CreativeStage__c FROM IMH_CommCreative__c WHERE Id =: creativeRecordId LIMIT 1];
            System.assertEquals('Final Creative',commList[0].CreativeStage__c);   
        }
        Test.stopTest();    
    }
    /*****************************************************************************
    * @description: Method for creative approval (Two Step Sequential) and we reject the record
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    * @param: none
    * @return: void
     */
    static testMethod void CreativeSimpleTwoStepSequentialRejection() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= THAILAND_MARKET;
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

            //SBS Group
            Group groupSBS = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_SBS_CA' LIMIT 1];
            GroupMember groupMemSBS = new GroupMember();
            groupMemSBS.GroupId = groupSBS.Id;
            groupMemSBS.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemSBS;
            //Charge Group
            Group groupCharge = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_Charge_CA' LIMIT 1];
            GroupMember groupMemCharge = new GroupMember();
            groupMemCharge.GroupId = groupCharge.Id;
            groupMemCharge.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCharge;
            //Custommer Management Group
            Group groupCusManage = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CustomerManagement_CA' LIMIT 1];
            GroupMember groupMemCusManage = new GroupMember();
            groupMemCusManage.GroupId = groupCusManage.Id;
            groupMemCusManage.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCusManage;

            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            mapOwnerNameByApprovalGroup.put('IMH_SBS_CA', IMH_TestClassUtility.createApprovalGroup('IMH_SBS_CA', 'SBS' ));
            mapOwnerNameByApprovalGroup.put('IMH_Charge_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Charge_CA', 'Charge' ));
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
                    
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_COG, 
                                                                            'Creative',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CustomerManagement_CA',
                                                                            2,
                                                                            INCENTIVISED_OFFER, 
                                                                            'Customer Management', 
                                                                            'Creative',
                                                                            'Creative__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CustomerManagement_CA').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_Charge_CA',
                                                                            2,
                                                                            INCENTIVISED_OFFER, 
                                                                            'Charge', 
                                                                            'Creative',
                                                                            'Creative__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_Charge_CA').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_SBS_CA',
                                                                            2,
                                                                            INCENTIVISED_OFFER, 
                                                                            'SBS', 
                                                                            'Creative',
                                                                            'Creative__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_SBS_CA').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId; 
        Id creativeRecordId;    
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,'Canada'));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            
            
            //Product Insertion
             List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
                for(Integer t=0;t<2;t++) {
                    prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Canada',true,'Gold'));
                    prodList[t].Name=PRODUCT_NAME+t;
                } 
                 prodList[0].RequiredApprovers__c = 'Charge';
                prodList[1].RequiredApprovers__c = 'SBS';
            Database.insert(prodList,true);
            
            //Channel Insertion
             List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
                for(Integer t=0;t<2;t++) {
                    channelList.add(IMH_TestClassUtility.createChannel('Canada','LACC','AMEX'));
                    channelList[t].Name='AMEX'+t;
                    channelList[t].RequiredApprovers__c = 'Customer Management';
                }
                
                Database.SaveResult[] srListChannel = Database.insert(channelList,true);
            
            
            //Targeted Products Insertion
            List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
             for(Integer t=0;t<2;t++){
                lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[t].Id,'Canada'));
                 
             }  
               
            Database.insert(lCommtargetedProd,true);
             //Targeted Channels Insertion
            List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
            for(Integer i=0;i<2;i++){
                 lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[i].Id));
            }
            Database.insert(lCommtargetedChannel,true);
            
            
            
            //Test Data for Creative
            IMH_CommCreative__c creativeRec = new IMH_CommCreative__c();
            creativeRec = IMH_TestClassUtility.createFinalCreative(insertedCommunicationId,'In Progress',
                           IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            creativeRec.CreativeStage__c = 'Creative';
            creativeRec.SYSCreativeStep__c = '1';
            insert creativeRec;
            creativeRecordId = creativeRec.Id;
            
            
            Test.startTest();
            // Update Creative
            IMH_CommCreative__c creativeRecUpdate  = [SELECT Id, SYS_Ready_For_Review__c,RequiredApprovers__c 
                                                      FROM IMH_CommCreative__c 
                                                      WHERE Id =: creativeRecordId LIMIT 1];
            creativeRecUpdate.SYS_ReadyForReview_New__c = true;
            update creativeRecUpdate;
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select CommCreative__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE CommCreative__c =: creativeRecordId
                           LIMIT 50000];
            System.assertEquals(1,lApptrack.size());
            System.assertEquals('Pending',lApptrack[0].Status__c);
        }

        
        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lApptrack = [Select Id, CommCreative__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE CommCreative__c =:creativeRecordId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
            lApptrack[0].Status__c = 'Rejected';
            lApptrack[0].Reason__c = 'GCO';
            lApptrack[0].ReasonSubCategory__c = 'Memo and/or Other';

            update lApptrack;  
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, CommCreative__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE CommCreative__c =:creativeRecordId
                          AND Status__c = 'Pending'
                          LIMIT 50000];
            
            List<IMH_CommCreative__c>  commList = new List<IMH_CommCreative__c>();
            commList = [SELECT Id,CreativeStage__c,CreativeStatus__c FROM IMH_CommCreative__c WHERE Id =: creativeRecordId LIMIT 1];
            System.assertEquals(lApptrack.isEmpty(),true);
            System.assertEquals('Design',commList[0].CreativeStage__c);
            System.assertEquals('In Progress (following rejection/recalled)',commList[0].CreativeStatus__c); 
        }
        Test.stopTest();    
    }
    /*****************************************************************************
    * @description: Method for concept approval (Two Step Sequential)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    * @param: none
    * @return: void
    */ 
    static testMethod void CreativeDeleteUndeleteChannelProduct() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
       runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= THAILAND_MARKET;
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

            //SBS Group
            Group groupSBS = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_SBS_CA' LIMIT 1];
            GroupMember groupMemSBS = new GroupMember();
            groupMemSBS.GroupId = groupSBS.Id;
            groupMemSBS.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemSBS;
            //Charge Group
            Group groupCharge = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_Charge_CA' LIMIT 1];
            GroupMember groupMemCharge = new GroupMember();
            groupMemCharge.GroupId = groupCharge.Id;
            groupMemCharge.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCharge;
            //Custommer Management Group
            Group groupCusManage = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CustomerManagement_CA' LIMIT 1];
            GroupMember groupMemCusManage = new GroupMember();
            groupMemCusManage.GroupId = groupCusManage.Id;
            groupMemCusManage.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCusManage;
            
            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            mapOwnerNameByApprovalGroup.put('IMH_SBS_CA', IMH_TestClassUtility.createApprovalGroup('IMH_SBS_CA', 'SBS' ));
            mapOwnerNameByApprovalGroup.put('IMH_Charge_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Charge_CA', 'Charge' ));
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
                    
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            48,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_COG, 
                                                                            'Creative',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            72,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CustomerManagement_CA',
                                                                            2,
                                                                            INCENTIVISED_OFFER, 
                                                                            'Customer Management', 
                                                                            'Creative',
                                                                            'Creative__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CustomerManagement_CA').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            72,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_Charge_CA',
                                                                            2,
                                                                            INCENTIVISED_OFFER, 
                                                                            'Charge', 
                                                                            'Creative',
                                                                            'Creative__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_Charge_CA').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            120,
                                                                            STD_PRIORITY,
                                                                           IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_SBS_CA',
                                                                            2,
                                                                            INCENTIVISED_OFFER, 
                                                                            'SBS', 
                                                                            'Creative',
                                                                            'Creative__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_SBS_CA').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId; 
        Id creativeRecordId;    
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            IMH_CommunicationTriggerHandler.iscreatedAnswerSet = true;
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,'Canada'));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
           insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);
            
            
                        //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer t=0;t<2;t++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Canada',true,'Gold'));
                prodList[t].Name=PRODUCT_NAME+t;
            } 
             prodList[0].RequiredApprovers__c = 'Charge';
            prodList[1].RequiredApprovers__c = 'SBS';
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer t=0;t<2;t++) {
                channelList.add(IMH_TestClassUtility.createChannel('Canada','LACC','AMEX'));
                channelList[t].Name='AMEX'+t;
                channelList[t].RequiredApprovers__c = 'Customer Management';
           }
            
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer t=0;t<2;t++){
            lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[t].Id,'Canada'));
             
         }  
           
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<2;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[i].Id));
        }
        Database.insert(lCommtargetedChannel,true);
            
            
            
            
            //Test Data for Creative
            IMH_CommCreativeTriggerHandler.isAfterInsertExecuted = true;
            IMH_CommCreative__c creativeRec = new IMH_CommCreative__c();
            creativeRec = IMH_TestClassUtility.createFinalCreative(insertedCommunicationId,'In Progress',
                           IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            creativeRec.CreativeStage__c = 'Creative';
            creativeRec.SYSCreativeStep__c = '1';
            insert creativeRec;
            creativeRecordId = creativeRec.Id;
            
            List<IMH_CreativeChannel__c> ltChannel = [SELECT Id FROM IMH_CreativeChannel__c WHERE Creative__c =: creativeRecordId LIMIT 50000];
            List<IMH_CreativeProduct__c> ltProduct = [SELECT Id FROM IMH_CreativeProduct__c WHERE Creative__c =: creativeRecordId LIMIT 50000];
            
            Id creativechannelId = ltchannel[0].Id;
            Id creativeproductId = ltProduct[0].Id;
            
            IMH_CreativeChannel__c tChannel = [SELECT Id FROM IMH_CreativeChannel__c WHERE Id =: creativechannelId LIMIT 1];
            delete tChannel;
            IMH_CreativeChannel__c deletedChannel = [SELECT Id FROM IMH_CreativeChannel__c WHERE Id =: creativechannelId ALL ROWS];
            undelete deletedChannel;

            IMH_CreativeProduct__c tProduct = [SELECT Id FROM IMH_CreativeProduct__c WHERE Id =: creativeproductId LIMIT 1];
            delete tProduct;
            IMH_CreativeProduct__c deletedProduct = [SELECT Id FROM IMH_CreativeProduct__c WHERE Id =: creativeproductId ALL ROWS];
            undelete deletedProduct;

            Test.startTest();
            // Update Creative
            IMH_CommCreative__c creativeRecUpdate  = [SELECT Id, SYS_Ready_For_Review__c,RequiredApprovers__c 
                                                      FROM IMH_CommCreative__c 
                                                      WHERE Id =: creativeRecordId LIMIT 1];
            creativeRecUpdate.SYS_ReadyForReview_New__c = true;
            update creativeRecUpdate;
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select CommCreative__c, Status__c, OwnerId, Approval_Group__c, Owner__c,Started__c,Threshold__c
                           FROM IMH_SLATracker__c WHERE CommCreative__c =: creativeRecordId
                           LIMIT 50000];
            System.assertEquals(1,lApptrack.size());
            System.assertEquals('Pending',lApptrack[0].Status__c);


        
        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            IMH_CommunicationTriggerHandler.iscreatedAnswerSet = true;
            lApptrack = [Select Id, CommCreative__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE CommCreative__c =:creativeRecordId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;  
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            IMH_CommCreativeTriggerHandler.isAfterUpdateExecuted = true;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, CommCreative__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE CommCreative__c =:creativeRecordId
                          AND Status__c = 'Pending'
                          LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            lApptrack[1].Status__c = 'Approved';
            lApptrack[2].Status__c = 'Approved';
            update lApptrack;
            
            List<IMH_CommCreative__c>  commList = new List<IMH_CommCreative__c>();
            commList = [SELECT Id,CreativeStage__c FROM IMH_CommCreative__c WHERE Id =: creativeRecordId LIMIT 1];
            System.assertEquals('Final Creative',commList[0].CreativeStage__c);   
        }
        Test.stopTest();    
            List<IMH_SLATracker__c> lDeltaTotaltrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c,
                                                       TotalHours__c,DeltaHours__c,Started__c,Threshold__c,Completed__c
                                                       FROM IMH_SLATracker__c WHERE CommCreative__c =: creativeRecordId
                                                       AND Status__c = 'Approved'
                                                       LIMIT 50000 ];
           //Threshold Checks for SLA's
           /*  if(lDeltaTotaltrack[0].Started__c.addHours(48).format('E').equalsIgnorecase('Sat')){
               System.assertEquals(lDeltaTotaltrack[0].Threshold__c,lDeltaTotaltrack[0].Started__c.addHours(96));
            }
            else if(lDeltaTotaltrack[0].Started__c.addHours(48).format('E').equalsIgnorecase('Sun')){
                 System.assertEquals(lDeltaTotaltrack[0].Threshold__c,lDeltaTotaltrack[0].Started__c.addHours(96));
            }
            else{
                System.assertEquals(lDeltaTotaltrack[0].Threshold__c,lDeltaTotaltrack[0].Started__c.addHours(48));
            }//System.assertEquals(lDeltaTotaltrack[0].Threshold__c,lDeltaTotaltrack[0].Started__c.addHours(48));
            if(lDeltaTotaltrack[1].Started__c.addHours(72).format('E').equalsIgnorecase('Sat')){
               System.assertEquals(lDeltaTotaltrack[1].Threshold__c,lDeltaTotaltrack[1].Started__c.addHours(120));
            }
            else if(lDeltaTotaltrack[1].Started__c.addHours(72).format('E').equalsIgnorecase('Sun')){
                 System.assertEquals(lDeltaTotaltrack[1].Threshold__c,lDeltaTotaltrack[1].Started__c.addHours(120));
            }
            else if(lDeltaTotaltrack[1].Started__c.addHours(72).format('E').equalsIgnorecase('Mon')){
                System.assertEquals(lDeltaTotaltrack[1].Threshold__c,lDeltaTotaltrack[1].Started__c.addHours(120));
            }
            else{
                System.assertEquals(lDeltaTotaltrack[1].Threshold__c,lDeltaTotaltrack[1].Started__c.addHours(72));
            }
            
            // Total and Delta Hours Asserts
            if(!lDeltaTotaltrack[0].Started__c.format('E').equalsIgnorecase('Sun') && !lDeltaTotaltrack[0].Started__c.format('E').equalsIgnorecase('Sat')){
                 
            System.assertEquals(lDeltaTotaltrack[0].DeltaHours__c, -47);
            System.assertEquals(lDeltaTotaltrack[0].TotalHours__c,0);
            System.assertEquals(lDeltaTotaltrack[1].DeltaHours__c, -71);
            System.assertEquals(lDeltaTotaltrack[1].TotalHours__c,0);
           } */ //Sprint 46
        }
    }

    /*****************************************************************************
    * @description: Method for benefit approval (Two Step Sequential)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    * @param: none
    * @return: void
    */ 
    static testMethod void BenefitSingleMarketMandatorySequential() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Japan Reviewer' LIMIT 1];
        runningUserReviewer.Market__c= 'Japan';
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Japan Submitter' LIMIT 1];
        runningUserSubmitter.Market__c= 'Japan';
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
            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            mapOwnerNameByApprovalGroup.put('IMH_Charge_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Charge_CA', 'Charge' ));
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
                    
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Offer Governance',
                                                                            'Japan',
                                                                            JAPA_REGION,
                                                                            48,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            '', 
                                                                            '', 
                                                                            'Benefits',
                                                                            '',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Central Brand',
                                                                            'Japan',
                                                                            'JAPA',
                                                                            72,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralBrand',
                                                                            2,
                                                                            '', 
                                                                            '', 
                                                                            'Benefits',
                                                                            '',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralBrand').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Benefits__c> lBenefits;
        Id insertedBenefitId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lBenefits = new List<IMH_Benefits__c>();
            for(Integer i=0;i<1;i++) {
                lBenefits.add(IMH_TestClassUtility.createBenefits('Local','JAPA','Japan'));
            }
            Database.SaveResult[] srListBenefit = Database.insert(lBenefits,false);
            insertedBenefitId = srListBenefit[0].getId();       
            
            Test.startTest();
            // Update Communication
            lBenefits[0].SYS_ReadyForReview_New__c = true;
            lBenefits[0].SequenceNumber__c = 1;
            Database.update(lBenefits[0],false);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Benefits__c, Status__c, OwnerId, Approval_Group__c, Owner__c,Threshold__c,Started__c
                           FROM IMH_SLATracker__c WHERE Benefits__c =: insertedBenefitId
                           LIMIT 50000];
           /*System.assertEquals(1,lApptrack.size());
           System.assertEquals('Pending',lApptrack[0].Status__c);
            //Threshold Checks for SLA's
            if(lApptrack[0].Started__c.addHours(48).format('E').equalsIgnorecase('Sat')){
               System.assertEquals(lApptrack[0].Threshold__c,lApptrack[0].Started__c.addHours(96));
            }
            else if(lApptrack[0].Started__c.addHours(48).format('E').equalsIgnorecase('Sun')){
                 System.assertEquals(lApptrack[0].Threshold__c,lApptrack[0].Started__c.addHours(96));
            }
            else{
                System.assertEquals(lApptrack[0].Threshold__c,lApptrack[0].Started__c.addHours(48));
            }*/ //Sprint 46
        }

        
        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        /*system.runAs(runningUserReviewer){ 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Benefits__c =:insertedBenefitId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;  
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Benefits__c =:insertedBenefitId
                          AND Status__c = 'Pending'
                          LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            
            List<IMH_Benefits__c>  beneList = new List<IMH_Benefits__c>();
            beneList = [SELECT Id,BenefitStage__c,ApprovalStage__c FROM IMH_Benefits__c WHERE Id =: insertedBenefitId LIMIT 1];
            System.assertEquals('Complete',beneList[0].BenefitStage__c);
            System.assertEquals('Accepted',beneList[0].ApprovalStage__c);
             List<IMH_SLATracker__c> lDeltaTotaltrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c,
                                                       TotalHours__c,DeltaHours__c,Started__c,Threshold__c,Completed__c
                                                       FROM IMH_SLATracker__c WHERE Benefits__c =:insertedBenefitId
                                                       AND Status__c = 'Approved'
                                                       LIMIT 50000 ];
            // Total and Delta Hours Asserts
           if(!lDeltaTotaltrack[0].Started__c.format('E').equalsIgnorecase('Sun') && !lDeltaTotaltrack[0].Started__c.format('E').equalsIgnorecase('Sat'))
           {   
               System.assertEquals(lDeltaTotaltrack[0].DeltaHours__c, -47);
               System.assertEquals(lDeltaTotaltrack[0].TotalHours__c,0);
           }
        } */ //Sprint 46
        Test.stopTest();    
    }

    /*****************************************************************************
    * @description: Method for beenfit approval (Two Step Sequential)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    * @param: none
    * @return: void
    */ 
    static testMethod void BenefitMultiMarketSequential() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Japan Reviewer' LIMIT 1];
        runningUserReviewer.Market__c= 'Japan';
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Japan Submitter' LIMIT 1];
        runningUserSubmitter.Market__c= 'Japan';
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
            
             Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            mapOwnerNameByApprovalGroup.put('IMH_Charge_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Charge_CA', 'Charge' ));
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
                    
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Offer Governance',
                                                                            'Thailand',
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            '', 
                                                                            '', 
                                                                            'Benefits',
                                                                            '',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Central Brand',
                                                                            'Japan',
                                                                            'JAPA',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralBrand',
                                                                            1,
                                                                            '', 
                                                                            'Central Brand', 
                                                                            'Benefits',
                                                                            '',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralBrand').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Benefits__c> lBenefits;
        Id insertedBenefitId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lBenefits = new List<IMH_Benefits__c>();
            for(Integer i=0;i<1;i++) {
                lBenefits.add(IMH_TestClassUtility.createBenefits('Local','JAPA','Japan;Thailand'));
                lBenefits[i].RequiredApprovers__c = 'Central Brand';
            }
            Database.SaveResult[] srListBenefit = Database.insert(lBenefits,false);
            insertedBenefitId = srListBenefit[0].getId();       
            
            Test.startTest();
            // Update Communication
            lBenefits[0].SYS_ReadyForReview_New__c = true;
            lBenefits[0].SequenceNumber__c = 1;
            IMH_BenefitTriggerHandler.isExecutedAfter = false;
            Database.update(lBenefits[0],false);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Benefits__c, Status__c, OwnerId, Approval_Group__c, Owner__c,Threshold__c,Started__c
                           FROM IMH_SLATracker__c WHERE Benefits__c =: insertedBenefitId
                           ORDER BY Owner__c
                           LIMIT 50000];
           /* System.assertEquals(2,lApptrack.size());
            System.assertEquals('Pending',lApptrack[0].Status__c);
            //Thereshold check for SLA's
             if(lApptrack[0].Started__c.addHours(24).format('E').equalsIgnorecase('Sat')){
               System.assertEquals(lApptrack[0].Threshold__c,lApptrack[0].Started__c.addHours(72));
            }
            else{
                System.assertEquals(lApptrack[0].Threshold__c,lApptrack[0].Started__c.addHours(24));
            }      */ //Sprint 46     
        }

        
        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        /*system.runAs(runningUserReviewer){ 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Benefits__c =:insertedBenefitId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
            lApptrack[0].Status__c = 'Approved';
            lApptrack[1].Status__c = 'Approved';
            update lApptrack;  
            
            List<IMH_Benefits__c>  beneList = new List<IMH_Benefits__c>();
            beneList = [SELECT Id,BenefitStage__c,ApprovalStage__c FROM IMH_Benefits__c WHERE Id =: insertedBenefitId LIMIT 1];
            System.assertEquals('Complete',beneList[0].BenefitStage__c);
            System.assertEquals('Accepted',beneList[0].ApprovalStage__c); 
             
            // Total and Delta Hours Asserts
           List<IMH_SLATracker__c> lDeltaTotaltrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c,
                                                       TotalHours__c,DeltaHours__c,Started__c,Threshold__c,Completed__c
                                                       FROM IMH_SLATracker__c WHERE Benefits__c =:insertedBenefitId
                                                       AND Status__c = 'Approved'
                                                       LIMIT 50000 ];
            // Total and Delta Hours Asserts
            if(!lDeltaTotaltrack[0].Started__c.format('E').equalsIgnorecase('Sun') && !lDeltaTotaltrack[0].Started__c.format('E').equalsIgnorecase('Sat')){
              System.assertEquals(lDeltaTotaltrack[0].DeltaHours__c, -23);
              System.assertEquals(lDeltaTotaltrack[0].TotalHours__c,0);  
            }
        } */ //Sprint 46
        Test.stopTest();    
    }
    
    
    /*****************************************************************************
    * @description: Method for beenfit approval (Two Step Sequential) for rejection
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    * @param: none
    * @return: void
    */ 
    static testMethod void rejectionBenefitMultiMarketSequential() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Japan Reviewer' LIMIT 1];
        runningUserReviewer.Market__c= 'Japan';
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Japan Submitter' LIMIT 1];
        runningUserSubmitter.Market__c= 'Japan';
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
            
            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            mapOwnerNameByApprovalGroup.put('IMH_Charge_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Charge_CA', 'Charge' ));
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
                    
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Offer Governance',
                                                                            'Japan',
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            '', 
                                                                            '', 
                                                                            'Benefits',
                                                                            '',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Central Brand',
                                                                            'Japan',
                                                                            'JAPA',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralBrand',
                                                                            1,
                                                                            '', 
                                                                            'Central Brand', 
                                                                            'Benefits',
                                                                            '',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralBrand').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Benefits__c> lBenefits;
        Id insertedBenefitId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lBenefits = new List<IMH_Benefits__c>();
            for(Integer i=0;i<1;i++) {
                lBenefits.add(IMH_TestClassUtility.createBenefits('Local','JAPA','Japan;Thailand'));
                lBenefits[i].RequiredApprovers__c = 'Central Brand';
            }
            Database.SaveResult[] srListBenefit = Database.insert(lBenefits,false);
            insertedBenefitId = srListBenefit[0].getId();       
            
            Test.startTest();
            // Update Communication
            lBenefits[0].SYS_ReadyForReview_New__c = true;
            lBenefits[0].SequenceNumber__c = 1;
                                                IMH_BenefitTriggerHandler.isExecutedAfter = false;
            Database.update(lBenefits[0],false);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Benefits__c, Status__c, OwnerId, Approval_Group__c, Owner__c,Threshold__c,Started__c
                           FROM IMH_SLATracker__c WHERE Benefits__c =: insertedBenefitId
                           ORDER BY Owner__c
                          LIMIT 50000];
            /*System.assertEquals(2,lApptrack.size());
            System.assertEquals('Pending',lApptrack[0].Status__c);
            //Thereshold check for SLA's
             if(lApptrack[0].Started__c.addHours(24).format('E').equalsIgnorecase('Sat')){
               System.assertEquals(lApptrack[0].Threshold__c,lApptrack[0].Started__c.addHours(72));
            }
            else{
                System.assertEquals(lApptrack[0].Threshold__c,lApptrack[0].Started__c.addHours(24));
            }    */ // Sprint 46
        }

        
        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        /*system.runAs(runningUserReviewer){ 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c,SYS_SendNotifications__c
                          FROM IMH_SLATracker__c WHERE Benefits__c =:insertedBenefitId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
            lApptrack[0].Status__c = 'Rejected';
           
            update lApptrack; 
            List<IMH_Benefits__c>  beneList = new List<IMH_Benefits__c>();
            beneList = [SELECT Id,BenefitStage__c,ApprovalStage__c FROM IMH_Benefits__c WHERE Id =: insertedBenefitId LIMIT 1];
            System.assertEquals('Design',beneList[0].BenefitStage__c);
            System.assertEquals('In Progress (following rejection/recalled)',beneList[0].ApprovalStage__c); 
               
        }*/ //Sprint 46
        Test.stopTest();    
    }
    
     /*****************************************************************************
    * @description: Method for concept approval (one Step Sequential) to check whether Director is populated or not
    *               1. Complaince Approval - Approve
    * @param: none
    * @return: void
     */
    static testMethod void CreativeReferToDirectorTwoStepSequential() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser('iMH Canada Reviewer',REVIEWER_RUNNING_USER,null);
        User directorReviewer  = IMH_TestClassUtility.createUser('iMH Canada Reviewer','DirectorUser',null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name ='Canada Reviewer' LIMIT 1];
        runningUserReviewer.Market__c= 'Canada';
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        runningUserReviewer.IMH_UserRoleTypeNew__c = 'Reviewer';
        insert runningUserReviewer;
        
         directorReviewer.Market__c = 'Canada';
         directorReviewer.UserRoleId = reviewerRole.Id;
         directorReviewer.IMH_UserRoleTypeNew__c = 'Reviewer';
         directorReviewer.Band_CA__c = 'Band 40';
          insert directorReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser('iMH Canada Submitter',SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name ='Canada Submitter' LIMIT 1];
        runningUserSubmitter.Market__c= 'Canada';
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        runningUserSubmitter.IMH_UserRoleTypeNew__c = 'Submitter';
        runningUserSubmitter.IMHDirector__c = directorReviewer.Id;
        runningUserSubmitter.Band_CA__c = 'Band 35';
         //insert runningUserSubmitter;
        //runningUserSubmitter.IMHDirector__c = 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');
        Insert adminUser;
          GroupMember groupMemCOG;
        system.runAs(adminUser) {    
            //COG Group
            Group groupCOG = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_Compliance_CA' LIMIT 1];
            groupMemCOG = new GroupMember();
            groupMemCOG.GroupId = groupCOG.Id;
            groupMemCOG.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCOG;
            
            //Central Brand Group
            Group groupCB = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_GCO_CA' LIMIT 1];
            GroupMember groupMemCB = new GroupMember();
            groupMemCB.GroupId = groupCB.Id;
            groupMemCB.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCB;

            //SBS Group
            Group groupSBS = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_SBS_CA' LIMIT 1];
            GroupMember groupMemSBS = new GroupMember();
            groupMemSBS.GroupId = groupSBS.Id;
            groupMemSBS.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemSBS;
            //Charge Group
            Group groupCharge = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_Charge_CA' LIMIT 1];
            GroupMember groupMemCharge = new GroupMember();
            groupMemCharge.GroupId = groupCharge.Id;
            groupMemCharge.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCharge;
            //Custommer Management Group
            Group groupCusManage = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CustomerManagement_CA' LIMIT 1];
            GroupMember groupMemCusManage = new GroupMember();
            groupMemCusManage.GroupId = groupCusManage.Id;
            groupMemCusManage.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCusManage;
             Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_Compliance_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Compliance_CA', 'Compliance' ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            mapOwnerNameByApprovalGroup.put('IMH_Charge_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Charge_CA', 'Charge' ));
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
                    
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_Compliance_CA',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            '', 
                                                                            'Creative',
                                                                            '',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_Compliance_CA').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId; 
        Id creativeRecordId;    
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,'Canada'));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            //Test Data for Creative
            IMH_CommCreative__c creativeRec = new IMH_CommCreative__c();
            creativeRec = IMH_TestClassUtility.createFinalCreative(insertedCommunicationId,'In Progress',
                           IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            creativeRec.CreativeStage__c = 'Creative';
            creativeRec.SYSCreativeStep__c = '1';
            insert creativeRec;
            creativeRecordId = creativeRec.Id;
            
            
            // Update Creative
            IMH_CommCreative__c creativeRecUpdate  = [SELECT Id, SYS_Ready_For_Review__c,RequiredApprovers__c 
                                                      FROM IMH_CommCreative__c 
                                                      WHERE Id =: creativeRecordId LIMIT 1];
            creativeRecUpdate.SYS_ReadyForReview_New__c = true;
            update creativeRecUpdate;
      
        }

        
        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lApptrack = [Select Id, CommCreative__c, Status__c, OwnerId, Approval_Group__c,Submitter__c
                         ,SYS_Director__c
                          FROM IMH_SLATracker__c WHERE CommCreative__c =:creativeRecordId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
            System.assertEquals(lApptrack[0].SYS_Director__c,directorReviewer.Id);
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;  
            Test.startTest();
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            List<IMH_CommCreative__c>  commList = new List<IMH_CommCreative__c>();
            commList = [SELECT Id,CreativeStage__c FROM IMH_CommCreative__c WHERE Id =: creativeRecordId LIMIT 1];
            System.assertEquals('Final Creative',commList[0].CreativeStage__c);   
        }
        Test.stopTest();    
    }
    
        /*****************************************************************************
    * @description: Method for Regional beenfit approval (Two Step Sequential)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    * @param: none
    * @return: void
     
    static testMethod void regionalBenefitMultiMarket() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Japan Reviewer'];
        runningUserReviewer.Market__c= 'Japan';
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Japan Submitter'];
        runningUserSubmitter.Market__c= 'Japan';
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
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
             Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            mapOwnerNameByApprovalGroup.put('IMH_Charge_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Charge_CA', 'Charge' ));
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
                    
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Offer Governance',
                                                                            '',
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            '', 
                                                                            '', 
                                                                            'Benefits',
                                                                            '',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat[i].Locale__c = 'Regional';
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Central Brand',
                                                                            '',
                                                                            'JAPA',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralBrand',
                                                                            1,
                                                                            '', 
                                                                            'Central Brand', 
                                                                            'Benefits',
                                                                            '',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralBrand').Id));
                 lApprovalmat[1].Locale__c = 'Regional';
            }
            System.debug('*(*(*(*  '+lApprovalmat);
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Benefits__c> lBenefits;
        Id insertedBenefitId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lBenefits = new List<IMH_Benefits__c>();
            for(Integer i=0;i<1;i++) {
                lBenefits.add(IMH_TestClassUtility.createBenefits('Regional','JAPA',''));
                lBenefits[i].RequiredApprovers__c = 'Central Brand';
            }
            Database.SaveResult[] srListBenefit = Database.insert(lBenefits,false);
            insertedBenefitId = srListBenefit[0].getId();       
            
            Test.startTest();
            // Update Communication
            lBenefits[0].SYS_ReadyForReview_New__c = true;
            lBenefits[0].SequenceNumber__c = 1;
            Database.update(lBenefits[0],false);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Benefits__c, Status__c, OwnerId, Approval_Group__c, Owner__c,Threshold__c,Started__c
                           FROM IMH_SLATracker__c WHERE Benefits__c =: insertedBenefitId
                           ORDER BY Owner__c
                           LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
            System.assertEquals(2,lApptrack.size());
            System.assertEquals('Pending',lApptrack[0].Status__c);
            System.assertEquals('Central Offer Governance',lApptrack[1].Owner__c);
            //Thereshold check for SLA's
             if(lApptrack[0].Started__c.addHours(24).format('E').equalsIgnorecase('Sat')){
               System.assertEquals(lApptrack[0].Threshold__c,lApptrack[0].Started__c.addHours(72));
            }
            else{
                System.assertEquals(lApptrack[0].Threshold__c,lApptrack[0].Started__c.addHours(24));
            }           
        }

        
        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Benefits__c =:insertedBenefitId
                          AND Status__c = 'Pending'
                          LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
            lApptrack[0].Status__c = 'Approved';
            lApptrack[1].Status__c = 'Approved';
            update lApptrack;  
            
            List<IMH_Benefits__c>  beneList = new List<IMH_Benefits__c>();
            beneList = [SELECT Id,BenefitStage__c,ApprovalStage__c FROM IMH_Benefits__c WHERE Id =: insertedBenefitId LIMIT 1];
            System.assertEquals('Complete',beneList[0].BenefitStage__c);
            System.assertEquals('Accepted',beneList[0].ApprovalStage__c); 
             
            // Total and Delta Hours Asserts
           List<IMH_SLATracker__c> lDeltaTotaltrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c,
                                                       TotalHours__c,DeltaHours__c,Started__c,Threshold__c,Completed__c
                                                       FROM IMH_SLATracker__c WHERE Benefits__c =:insertedBenefitId
                                                       AND Status__c = 'Approved'
                                                       LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
            // Total and Delta Hours Asserts
            if(!lDeltaTotaltrack[0].Started__c.format('E').equalsIgnorecase('Sun') && !lDeltaTotaltrack[0].Started__c.format('E').equalsIgnorecase('Sat')){
              System.assertEquals(lDeltaTotaltrack[0].DeltaHours__c, -23);
              System.assertEquals(lDeltaTotaltrack[0].TotalHours__c,0);  
            }
        }
        Test.stopTest();    
    }*/
   /*****************************************************************************
    * @description: Method for concept approval (Two Step Sequential) for NAC Insurance
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    * @param: none
    * @return: void
     */
    static testMethod void CreativeNacSimpleTwoStepSequential() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name ='UK Reviewer' LIMIT 1];
        runningUserReviewer.Market__c= 'UK';
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        runningUserReviewer.Band_CA__c = 'Band 40';
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name ='UK Submitter' LIMIT 1];
        runningUserSubmitter.Market__c=  'UK';
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        runningUserSubmitter.IMHDirector__c= runningUserReviewer.Id;
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

            //SBS Group
            Group groupSBS = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_SBS_CA' LIMIT 1];
            GroupMember groupMemSBS = new GroupMember();
            groupMemSBS.GroupId = groupSBS.Id;
            groupMemSBS.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemSBS;
            //Charge Group
            Group groupCharge = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_Charge_CA' LIMIT 1];
            GroupMember groupMemCharge = new GroupMember();
            groupMemCharge.GroupId = groupCharge.Id;
            groupMemCharge.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCharge;
            //Custommer Management Group
            Group groupCusManage = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CustomerManagement_CA' LIMIT 1];
            GroupMember groupMemCusManage = new GroupMember();
            groupMemCusManage.GroupId = groupCusManage.Id;
            groupMemCusManage.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCusManage;
            
             Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            mapOwnerNameByApprovalGroup.put('IMH_SBS_CA', IMH_TestClassUtility.createApprovalGroup('IMH_SBS_CA', 'SBS' ));
            mapOwnerNameByApprovalGroup.put('IMH_Charge_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Charge_CA', 'Charge' ));
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
                    
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_COG, 
                                                                            'Creative',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralOfferGovernance').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CustomerManagement_CA',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            'Customer Management', 
                                                                            'Creative',
                                                                            'Creative__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CustomerManagement_CA').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_Charge_CA',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            'Charge', 
                                                                            'Creative',
                                                                            'Creative__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_Charge_CA').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_SBS_CA',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            'SBS', 
                                                                            'Creative',
                                                                            'Creative__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_SBS_CA').Id));
            }
            lApprovalmat[3].SYS_ApprovalType__c = 'Product';
            lApprovalmat[2].SYS_ApprovalType__c = 'Product';
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId; 
        Id creativeRecordId;    
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,'Canada'));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            
            
             //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer t=0;t<2;t++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Canada',true,'Gold'));
                prodList[t].Name=PRODUCT_NAME+t;
            } 
             prodList[0].RequiredApprovers__c = 'Charge';
            prodList[1].RequiredApprovers__c = 'SBS';
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer t=0;t<2;t++) {
                channelList.add(IMH_TestClassUtility.createChannel('Canada','LACC','AMEX'));
                channelList[t].Name='AMEX'+t;
                channelList[t].RequiredApprovers__c = 'Customer Management';
            }
            
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer t=0;t<2;t++){
            lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[t].Id,'Canada'));
             
         }  
           
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<2;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[i].Id));
        }
        Database.insert(lCommtargetedChannel,true);
            
            
            //Test Data for Creative
            IMH_CommCreative__c creativeRec = new IMH_CommCreative__c();
            creativeRec = IMH_TestClassUtility.createFinalCreative(insertedCommunicationId,'In Progress',
                           IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            creativeRec.CreativeStage__c = 'Creative';
            creativeRec.SYSCreativeStep__c = '1';
            insert creativeRec;
            creativeRecordId = creativeRec.Id;
            
            
            
            // Update Creative
            IMH_CommCreative__c creativeRecUpdate  = [SELECT Id, SYS_Ready_For_Review__c,RequiredApprovers__c 
                                                      FROM IMH_CommCreative__c 
                                                      WHERE Id =: creativeRecordId LIMIT 1];
            creativeRecUpdate.SYS_ReadyForReview_New__c = true;
            update creativeRecUpdate;
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select CommCreative__c, Status__c, OwnerId, Approval_Matrix__r.SYS_ApprovalType__c, Owner__c ,SYS_IsProductOwnerApproval__c
                           FROM IMH_SLATracker__c WHERE CommCreative__c =: creativeRecordId
                           LIMIT 50000];
            System.assertEquals(4,lApptrack.size());
            System.assertEquals('Pending',lApptrack[0].Status__c);
             //Negative Case that Asserts the Prdouct Check
            System.assertNotEquals('Product',lApptrack[0].Approval_Matrix__r.SYS_ApprovalType__c);
            //Positive case that Asserts the Prdouct Check
            System.assertEquals('Product',lApptrack[3].Approval_Matrix__r.SYS_ApprovalType__c);
            
        }
    }
    
    /*****************************************************************************
    * @description: Method for concept approval.
    *               1. COG - Mandatory - Approve
    *               2. Central Band - Mandatory -Approve
    *               3. Leadership - Mandatory -Approve
    * @param: none
    * @return: void
    */ 
    static testMethod void ConceptMandatoryGroupsAndLeadershipDirector() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        runningUserReviewer.Band_CA__c = 'Band 40';
        insert runningUserReviewer;
        
        id ReviewerID = runningUserReviewer.id;

        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= THAILAND_MARKET;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        runningUserSubmitter.ManagerId= runningUserReviewer.Id;
        runningUserSubmitter.IMHDirector__c= runningUserReviewer.Id;
        runningUserSubmitter.Band_CA__c= 'Band 35';

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');
        Insert adminUser;
        system.runAs(adminUser) {    
            //COG Group
            Group groupCOG = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_Compliance_CA' LIMIT 1];
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

             Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            //M.Wheeler - 13.10.2016 - US566199 - Enforced Picklist Value Fix
            mapOwnerNameByApprovalGroup.put('Leadership', IMH_TestClassUtility.createApprovalGroup('Leadership', 'Leader' ));
            //END CHANGE
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
            mapOwnerNameByApprovalGroup.put('IMH_Compliance_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Compliance_CA', 'Compliance' ));

            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(COG_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_Compliance_CA',
                                                                            1,
                                                                            '', 
                                                                            '', 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_Compliance_CA').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(CB_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                           'IMH_CentralBrand',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            '', 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralBrand').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Leadership',
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'Leadership',
                                                                            3,
                                                                            '', 
                                                                            '', 
                                                                            'Communication',
                                                                            '',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('Leadership').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,THAILAND_MARKET));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            Test.startTest();
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],true);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
            System.assertEquals(2,lApptrack.size(),2);
            System.assertEquals('Pending',lApptrack[0].Status__c);            
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer) { 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending' LIMIT 1];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending'
                          LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending'
                          LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            
            List<IMH_Communication__c>  commList = new List<IMH_Communication__c>();
            commList = [SELECT Id,ProcessStage__c FROM IMH_Communication__c WHERE Id =: insertedCommunicationId LIMIT 1];
            System.assertEquals('Creative',commList[0].ProcessStage__c);   
        }
        Test.stopTest();    
    }
  	/*****************************************************************************
    * @description: Method for concept approval (Two Step Sequential)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    * @param: none
    * @return: void
     */
    static testMethod void CreativeBand35Band40Step() {
         UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_UK LIMIT 1];
        
        User runningUserdelegate1  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER + 'Delegate1',null);
        runningUserdelegate1.Market__c= UK_MARKET;
        runningUserdelegate1.UserRoleId = reviewerRole.Id;
        insert runningUserdelegate1;
        
        User runningUserdelegate2  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER +  'Delegate2',null);
        runningUserdelegate2.Market__c= UK_MARKET;
        runningUserdelegate2.UserRoleId = reviewerRole.Id;
        insert runningUserdelegate2;
        
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        runningUserReviewer.Market__c= UK_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        runningUserReviewer.DelegatedApproverId = runningUserdelegate1.Id;
        runningUserReviewer.Band_CA__c = 'Band 40';
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_UK];
        runningUserSubmitter.Market__c= UK_MARKET;
                                runningUserSubmitter.IMH_User_Team__c= 'Retail Insurance';
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        runningUserSubmitter.IMHDirector__c= runningUserReviewer.Id;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');
        Insert adminUser;
        system.runAs(adminUser) {    
            //B35 Group
            Group groupCOG = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_B35Ins_UK' LIMIT 1];
            GroupMember groupMemCOG = new GroupMember();
            groupMemCOG.GroupId = groupCOG.Id;
            groupMemCOG.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCOG;
            
            //B40 Group
            Group groupCB = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_B40Ins_UK' LIMIT 1];
            GroupMember groupMemCB = new GroupMember();
            groupMemCB.GroupId = groupCB.Id;
            groupMemCB.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCB;

             Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_B35Ins_UK', IMH_TestClassUtility.createApprovalGroup('IMH_B35Ins_UK', REQ_MANDAPPROVERS_BAND35 ));
            mapOwnerNameByApprovalGroup.put('IMH_B40Ins_UK', IMH_TestClassUtility.createApprovalGroup('IMH_B40Ins_UK', '' ));
            //M.Wheeler - 13.10.2016 - US566199 - Enforced Picklist Value Fix
            mapOwnerNameByApprovalGroup.put('Leadership', IMH_TestClassUtility.createApprovalGroup('Leadership', 'Leader' ));
            //END CHANGE
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
                    
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'UK',
                                                                            'EMEA',
                                                                            0,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_B35Ins_UK',
                                                                            1,
                                                                            'INS New/Material changes to Comms', 
                                                                            REQ_MANDAPPROVERS_BAND35, 
                                                                            'Creative',
                                                                            'Communication__c',
                                                                            'Retail Insurance',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_B35Ins_UK').Id));
                                                                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'UK',
                                                                            'EMEA',
                                                                            0,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_B40Ins_UK',
                                                                            2,
                                                                            'INS New/Material changes to Comms', 
                                                                            '', 
                                                                            'Creative',
                                                                            '',
                                                                            'Retail Insurance',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_B40Ins_UK').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId; 
        Id creativeRecordId;    
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,'UK'));
                lcommunication[i].RequiredApprovers__c = 'Band 35;Band 40';
                lcommunication[i].Communication_Type__c = 'INS New/Material changes to Comms';
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);
            
            
            
            //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer t=0;t<2;t++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'UK',true,'Gold'));
                prodList[t].Name=PRODUCT_NAME+t;
            } 
             //prodList[0].RequiredApprovers__c = 'Charge';
            //prodList[1].RequiredApprovers__c = 'SBS';
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer t=0;t<2;t++) {
                channelList.add(IMH_TestClassUtility.createChannel('UK','EMEA','AMEX'));
                channelList[t].Name='AMEX'+t;
                //channelList[t].RequiredApprovers__c = 'Customer Management';
            }
            
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer t=0;t<2;t++){
            lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[t].Id,'UK'));
             
         }  
           
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<2;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[i].Id));
        }
        Database.insert(lCommtargetedChannel,true);
        //Test Data for Creative
            IMH_CommCreative__c creativeRec = new IMH_CommCreative__c();
            creativeRec = IMH_TestClassUtility.createFinalCreative(insertedCommunicationId,'In Progress',
                           IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            creativeRec.CreativeStage__c = 'Creative';
            creativeRec.SYSCreativeStep__c = '1';
            insert creativeRec;
            creativeRecordId = creativeRec.Id;
            
            // Update Creative
            IMH_CommCreative__c creativeRecUpdate  = [SELECT Id, SYS_Ready_For_Review__c,RequiredApprovers__c 
                                                      FROM IMH_CommCreative__c 
                                                      WHERE Id =: creativeRecordId LIMIT 1];
            creativeRecUpdate.SYS_ReadyForReview_New__c = true;
            update creativeRecUpdate;
      
        }
        system.runAs(adminUser) {
        runningUserReviewer.DelegatedApproverId = runningUserdelegate2.Id;
        update runningUserReviewer;
        }
        
        
        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lApptrack = [Select Id, CommCreative__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE CommCreative__c =:creativeRecordId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;  
            Test.startTest();
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, CommCreative__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE CommCreative__c =:creativeRecordId
                          AND Status__c = 'Pending'
                          LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            
            List<IMH_CommCreative__c>  commList = new List<IMH_CommCreative__c>();
            commList = [SELECT Id,CreativeStage__c FROM IMH_CommCreative__c WHERE Id =: creativeRecordId LIMIT 1];
            //System.assertEquals('Final Creative',commList[0].CreativeStage__c);   
        }
        Test.stopTest();    
    }          
    /*****************************************************************************
    * @description: Method for concept approval (Two Step Sequential) with Approval Pause
    *               1. Compliance Approval - Pause
    *               2. Central Brand Approval - Approve
    * @param: none
    * @return: void
    */ 
    static testMethod void ConceptSimpleTwoStepSequentialWithPause() {
        Id creativeRecordId;
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_CANADA LIMIT 1];
        runningUserReviewer.Market__c= 'Canada';
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_CANADA LIMIT 1];
        runningUserSubmitter.Market__c= 'Canada';
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        runningUserSubmitter.IMH_User_Team__c = 'IMH';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');
        Insert adminUser;
        system.runAs(adminUser) {    
            //COG Group
            Group groupCOG = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_Compliance_CA' LIMIT 1];
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
            

            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_Compliance_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Compliance_CA', 'Compliance' ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            //M.Wheeler - 13.10.2016 - US566199 - Enforced Picklist Value Fix
            mapOwnerNameByApprovalGroup.put('Leadership', IMH_TestClassUtility.createApprovalGroup('Leadership', 'Leader' ));
            //END CHANGE
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
                    
            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_Compliance_CA',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            'Compliance', 
                                                                            'Creative',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_Compliance_CA').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Creative',
                                                                            'Canada',
                                                                            'LACC',
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralBrand',
                                                                            2,
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_CB, 
                                                                            'Creative',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralBrand').Id));
            }
            lApprovalmat[0].StatusToPauseApproval__c = 'Approved with Comments;Approved with Conditions;Approved with Changes';
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication('Concept',STATUS_NAME,'Canada'));
                lcommunication[i].RequiredApprovers__c = 'Compliance;Central Brand';
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';
                lcommunication[i].ReviewApprovalSLAType__c = STD_PRIORITY;
            }
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            //Test Data for Creative
            IMH_CommCreative__c creativeRec = new IMH_CommCreative__c();
            creativeRec = IMH_TestClassUtility.createFinalCreative(insertedCommunicationId,'In Progress',
                           IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            creativeRec.CreativeStage__c = 'Creative';
            //creativeRec.SYSCreativeStep__c = '1';
            insert creativeRec;
            creativeRecordId = creativeRec.Id;
            
            // Update Creative
            IMH_CommCreative__c creativeRecUpdate  = [SELECT Id, SYS_Ready_For_Review__c,RequiredApprovers__c 
                                                      FROM IMH_CommCreative__c 
                                                      WHERE Id =: creativeRecordId LIMIT 1];
            creativeRecUpdate.SYS_ReadyForReview_New__c = true;
            update creativeRecUpdate;

            Test.startTest();
            
            //Query expected approval record related the above communciation.
            lApptrack = [Select CommCreative__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE CommCreative__c =: creativeRecordId
                           LIMIT 50000];
            System.assertEquals(1,lApptrack.size());
            System.assertEquals('Pending',lApptrack[0].Status__c);
            Boolean verifyVar = lApptrack[0].Owner__c.contains('Compliance')?true:false;
            System.assertEquals(true,verifyVar);            
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            lApptrack = [Select Id, CommCreative__c, Status__c, OwnerId, Approval_Group__c,Comments__c
                          FROM IMH_SLATracker__c WHERE CommCreative__c =: creativeRecordId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
            lApptrack[0].Status__c = 'Approved with Comments';
            lApptrack[0].Comments__c = 'Test';
            update lApptrack;  
            List<IMH_CommCreative__c>  commList = new List<IMH_CommCreative__c>();
            commList = [SELECT Id,PauseApproval__c FROM IMH_CommCreative__c WHERE Id =: creativeRecordId LIMIT 1];
            System.assertEquals(true,commList[0].PauseApproval__c);   
        }
        Test.stopTest();    
    }
    
      /*****************************************************************************
    * @description: Method for concept approval Where Leadership is engaged and The Delegated Approver
    *              is changed for the Leader. 
    * @param: none
    * @return: void
     */
    static testMethod void delegateApprovalStep() {
         UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_UK LIMIT 1];
        
        User runningUserdelegate1  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER + 'Delegate1',null);
        runningUserdelegate1.Market__c= UK_MARKET;
        runningUserdelegate1.UserRoleId = reviewerRole.Id;
        insert runningUserdelegate1;
        
        User runningUserdelegate2  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER +  'Delegate2',null);
        runningUserdelegate2.Market__c= UK_MARKET;
        runningUserdelegate2.UserRoleId = reviewerRole.Id;
        insert runningUserdelegate2;
        
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        runningUserReviewer.Market__c= UK_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        runningUserReviewer.DelegatedApproverId = runningUserdelegate1.Id;
         runningUserReviewer.Band_CA__c = 'Band 40';
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_UK];
        runningUserSubmitter.Market__c= UK_MARKET;
                                runningUserSubmitter.IMH_User_Team__c= 'Retail Insurance';
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        runningUserSubmitter.IMHDirector__c= runningUserReviewer.Id;
        runningUserSubmitter.ManagerId = runningUserReviewer.Id;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');
        Insert adminUser;
        system.runAs(adminUser) {    
            Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_Compliance_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Compliance_CA', 'Compliance' ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            //M.Wheeler - 13.10.2016 - US566199 - Enforced Picklist Value Fix
            mapOwnerNameByApprovalGroup.put('Leadership', IMH_TestClassUtility.createApprovalGroup('Leadership', 'Leader' ));
            //END CHANGE
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
                    
            insert mapOwnerNameByApprovalGroup.values();
         // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                 lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Leadership',
                                                                            'UK',
                                                                            'EMEA',
                                                                            0,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                           'Leadership',
                                                                            1,
                                                                            'INS New/Material changes to Comms', 
                                                                            '', 
                                                                            'Creative',
                                                                            '',
                                                                            'Retail Insurance',
                                                                            false,
                                                                            mapOwnerNameByApprovalGroup.get('Leadership').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId; 
        Id creativeRecordId;    
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,'UK'));
                lcommunication[i].RequiredApprovers__c = 'Leadership';
               lcommunication[i].Communication_Type__c = 'INS New/Material changes to Comms';
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);
            
            
            
            //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer t=0;t<2;t++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'UK',true,'Gold'));
                prodList[t].Name=PRODUCT_NAME+t;
            } 
             //prodList[0].RequiredApprovers__c = 'Charge';
            //prodList[1].RequiredApprovers__c = 'SBS';
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer t=0;t<2;t++) {
                channelList.add(IMH_TestClassUtility.createChannel('UK','EMEA','AMEX'));
                channelList[t].Name='AMEX'+t;
                //channelList[t].RequiredApprovers__c = 'Customer Management';
            }
            
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer t=0;t<2;t++){
            lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[t].Id,'UK'));
             
         }  
           
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<2;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[i].Id));
        }
        Database.insert(lCommtargetedChannel,true);
        //Test Data for Creative
            IMH_CommCreative__c creativeRec = new IMH_CommCreative__c();
            creativeRec = IMH_TestClassUtility.createFinalCreative(insertedCommunicationId,'In Progress',
                           IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            creativeRec.CreativeStage__c = 'Creative';
            creativeRec.SYSCreativeStep__c = '1';
            insert creativeRec;
            creativeRecordId = creativeRec.Id;
            
            // Update Creative
            IMH_CommCreative__c creativeRecUpdate  = [SELECT Id, SYS_Ready_For_Review__c,RequiredApprovers__c 
                                                      FROM IMH_CommCreative__c 
                                                      WHERE Id =: creativeRecordId LIMIT 1];
            creativeRecUpdate.SYS_ReadyForReview_New__c = true;
            update creativeRecUpdate;
      
        }
        system.runAs(adminUser) {
        Test.startTest();
        //Changing the delegated Approver for the reviewer
        runningUserReviewer.DelegatedApproverId = runningUserdelegate2.Id;
        update runningUserReviewer;
        Test.stopTest(); 
        }
         lApptrack = [Select Id, CommCreative__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE CommCreative__c =:creativeRecordId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
        System.assertEquals(1,lApptrack.size());
        System.debug('*** DB 1 '+runningUserdelegate2.Id);
        System.debug('*** DB 2 '+runningUserdelegate1.Id);
        System.debug('***** 1 '+[SELECT Id, 
                                                        ParentId, 
                                                        UserOrGroupId, 
                                                        AccessLevel 
                                                 FROM IMH_SLATracker__Share
                                                 WHERE ParentId =:lApptrack[0].Id]);
        List<IMH_SLATracker__Share> lappshare = [SELECT Id, 
                                                        ParentId, 
                                                        UserOrGroupId, 
                                                        AccessLevel 
                                                 FROM IMH_SLATracker__Share
                                                 WHERE ParentId =:lApptrack[0].Id
                                                AND UserOrGroupId =:runningUserdelegate2.Id
                                                LIMIT 50000];
        
        System.assertEquals(1,lappshare.size());
        System.assertEquals('Edit',lappshare[0].AccessLevel);
    }
    
    /*****************************************************************************
    * @description: Method for concept approval.
    *               1. Compliance
    *               2. Central Band - Mandatory -Approve
    *               3. Leadership - Mandatory -Approve
    * @param: none
    * @return: void
    */ 
    static testMethod void conceptLeadershipAsConcurrent() {

        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        runningUserReviewer.Band_CA__c = 'Band 40';
        insert runningUserReviewer;
        
        id ReviewerID = runningUserReviewer.id;

        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= THAILAND_MARKET;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        runningUserSubmitter.ManagerId= runningUserReviewer.Id;
        runningUserSubmitter.IMHDirector__c= runningUserReviewer.Id;
        runningUserSubmitter.Band_CA__c= 'Band 35';

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');
        Insert adminUser;
        system.runAs(adminUser) {    
            //COG Group
            Group groupCOG = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_Compliance_CA' LIMIT 1];
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

             Map<String,IMH_ApprovalGroup__c> mapOwnerNameByApprovalGroup = new Map<String,IMH_ApprovalGroup__c>();
            mapOwnerNameByApprovalGroup.put('IMH_CentralOfferGovernance', IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance', REQ_MANDAPPROVERS_COG ));
            mapOwnerNameByApprovalGroup.put('IMH_CentralBrand', IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand', REQ_MANDAPPROVERS_CB ));
            //M.Wheeler - 13.10.2016 - US566199 - Enforced Picklist Value Fix
            mapOwnerNameByApprovalGroup.put('Leadership', IMH_TestClassUtility.createApprovalGroup('Leadership', 'Leader' ));
            //END CHANGE
            mapOwnerNameByApprovalGroup.put('IMH_CustomerManagement_CA', IMH_TestClassUtility.createApprovalGroup('IMH_CustomerManagement_CA', 'Customer Management' ));
            mapOwnerNameByApprovalGroup.put('IMH_Compliance_CA', IMH_TestClassUtility.createApprovalGroup('IMH_Compliance_CA', 'Compliance' ));

            insert mapOwnerNameByApprovalGroup.values();
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(COG_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_Compliance_CA',
                                                                            1,
                                                                            '', 
                                                                            '', 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_Compliance_CA').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix(CB_REVIEW_STAGE,
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                           'IMH_CentralBrand',
                                                                            1,
                                                                            INCENTIVISED_OFFER, 
                                                                            '', 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('IMH_CentralBrand').Id));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Leadership',
                                                                            THAILAND_MARKET,
                                                                            JAPA_REGION,
                                                                            24,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'Leadership',
                                                                            1,
                                                                            '', 
                                                                            '', 
                                                                            'Communication',
                                                                            '',
                                                                            'IMH',
                                                                            true,
                                                                            mapOwnerNameByApprovalGroup.get('Leadership').Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,THAILAND_MARKET));
                lcommunication[i].RequiredApprovers__c = REQ_MANDAPPROVERS_COG_CB;
                lcommunication[i].Communication_Type__c = INCENTIVISED_OFFER;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, INCENTIVE_STATUS,lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);   
            
            Test.startTest();
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],true);
      
            //Query expected approval record related the above communciation.
            lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId AND Status__c = 'Pending'
                           LIMIT 50000];
            System.assertEquals(3,lApptrack.size(),3);          
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer) { 
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending' LIMIT 1];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending'
                          LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            //Execution Controller set to false so as to simulate a different transaction
            IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
            lApptrack = new List<IMH_SLATracker__c>();
            lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending'
                          LIMIT 50000];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            
            List<IMH_Communication__c>  commList = new List<IMH_Communication__c>();
            commList = [SELECT Id,ProcessStage__c FROM IMH_Communication__c WHERE Id =: insertedCommunicationId LIMIT 1];
            System.assertEquals('Creative',commList[0].ProcessStage__c);   
        }
        Test.stopTest();    
    }
}