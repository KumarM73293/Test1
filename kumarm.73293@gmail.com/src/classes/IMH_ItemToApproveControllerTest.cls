/**
* @author Accenture IDC 
* @date 07/04/2016
* @group-content N/A
* @description: iMH Release 1.5 (Sprint 39) - Test Class for Items To Approve Controller 
*/
@isTest
private class IMH_ItemToApproveControllerTest {
    private static final String CONCEPT_STAGE               = 'Concept';
    private static final String STATUS_NAME                 = 'In Progress';
    private static final String THAILAND_MARKET             = 'Thailand';
    private static final String JAPA_REGION                 = 'JAPA';
    private static final String OBJECT_NAME                 = 'Communication';
    private static final String CAMPAIGN_REVIEWER_PROFILE   = 'iMH Campaign Reviewer';    
    private static final String SUBMITTER_THAI              = 'Thailand Submitter';
    private static final String REVIEWER_THAI               = 'Thailand Reviewer'; 
    private static final String SUBMITTER_RUNNING_USER      = 'RunningUserSubmitter';
    private static final String REVIEWER_RUNNING_USER       = 'RunningUserReviewer';
    private static final String RUNNING_USER                = 'RunningUser';
    private static final String COG_REVIEW_STAGE            = 'Offer Governance';
    private static final String CB_REVIEW_STAGE             = 'Central Brand';
	private static final String PRODUCT_NAME                = 'ProdTest';
    private static final String CAMPAIGN_SUBMITTER_PROFILE  = 'iMH Campaign Submitter';
    private static final String STD_PRIORITY                = 'STANDARD';
    private static final String INCENTIVE_STATUS            = 'In Progress';     
    private static final String INCENTIVISED_OFFER          = 'Incentivised Offer'; 
    private static final String REQ_MANDAPPROVERS_COG       = 'Central Offer Governance';
    private static final String REQ_MANDAPPROVERS_CB        = 'Central Brand';
    private static final String REQ_MANDAPPROVERS_COG_CB    = 'Central Offer Governance;Central Brand';    
    
     /*****************************************************************************
    * @description: Method for concept approval (Two Step Sequential)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    *               used to assign both the records to a different assigned reviewer on home Page
    * @param: none
    * @return: void
    */ 
    static testmethod void displayRecords(){
        IMH_ItemToApproveController pagecontroller;
            
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningAssignReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        runningAssignReviewer.Market__c= THAILAND_MARKET;
        runningAssignReviewer.Username = 'testthai@imhrev.com';
        runningAssignReviewer.UserRoleId = reviewerRole.Id;
        insert runningAssignReviewer;
        
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
            //groupMemCOG.UserOrGroupId = runningAssignReviewer.Id;
            insert groupMemCOG;
            
            System.debug('**AAB '+[SELECT Id, UserOrGroupId, GroupId FROM GroupMember Where GroupId=:groupCOG.Id LIMIT 50000]);
            //Central Brand Group
            Group groupCB = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CentralBrand' LIMIT 1];
            GroupMember groupMemCB = new GroupMember();
            groupMemCB.GroupId = groupCB.Id;
            groupMemCB.UserOrGroupId = runningUserReviewer.Id;
            //groupMemCB.UserOrGroupId = runningAssignReviewer.Id;
            insert groupMemCB;
              List<IMH_ApprovalGroup__c> lApprovalgrp = new List <IMH_ApprovalGroup__c>();
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance',REQ_MANDAPPROVERS_COG));
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand',REQ_MANDAPPROVERS_CB));
            insert lApprovalgrp;
            //System.debug('**AAC '+[SELECT Id, UserOrGroupId, GroupId FROM GroupMember Where GroupId=:groupCOG.Id]);
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
                                                                            lApprovalgrp[0].Id));
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
                                                                            lApprovalgrp[1].Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        List<IMH_SLATracker__c> lupdatedApptrack;
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
            
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],false);
      
            //Query expected approval record related the above communciation.
          
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            Test.startTest();
             Test.setCurrentPage(Page.IMH_ItemToApprovaPage);
             pagecontroller = new IMH_ItemToApproveController();
             pagecontroller.lwrapper[0].isSelected = true;
             pagecontroller.lwrapper[1].isSelected = true;
             pagecontroller.assignedReviewerLookup[0].AssignedApprover__c = runningAssignReviewer.Id;
             pagecontroller.assignReveiwer();
            Test.stopTest();
            //Assert To check The size od the List inserted and Wrapper size
              lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
             System.assertEquals(lApptrack.size(), pagecontroller.lwrapper.size());
            
             lupdatedApptrack = [Select Communication__c, AssignedApprover__c,Status__c, OwnerId, Approval_Group__c, Owner__c
                                   FROM IMH_SLATracker__c WHERE AssignedApprover__c =:  runningAssignReviewer.Id
                                   LIMIT 50000];
           System.assertEquals(lApptrack.size(), lupdatedApptrack.size());
           System.assertEquals(runningAssignReviewer.Id, lupdatedApptrack[0].AssignedApprover__c);
        }
         
    }
    
      /*****************************************************************************
    * @description: Method for concept approval (Two Step Sequential)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    *               used to assign both the records to a different assigned reviewer on Common Page
    * @param: none
    * @return: void
    */ 
    static testmethod void displayRecordsonDetailPage(){
        IMH_ItemToApproveController pagecontroller;
            
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningAssignReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        runningAssignReviewer.Market__c= THAILAND_MARKET;
        runningAssignReviewer.Username = 'testthai@imhrev.com';
        runningAssignReviewer.UserRoleId = reviewerRole.Id;
        insert runningAssignReviewer;
        
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
            //groupMemCOG.UserOrGroupId = runningAssignReviewer.Id;
            insert groupMemCOG;
            
            System.debug('**AAB '+[SELECT Id, UserOrGroupId, GroupId FROM GroupMember Where GroupId=:groupCOG.Id LIMIT 50000]);
            //Central Brand Group
            Group groupCB = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CentralBrand' LIMIT 1];
            GroupMember groupMemCB = new GroupMember();
            groupMemCB.GroupId = groupCB.Id;
            groupMemCB.UserOrGroupId = runningUserReviewer.Id;
            //groupMemCB.UserOrGroupId = runningAssignReviewer.Id;
            insert groupMemCB;
              List<IMH_ApprovalGroup__c> lApprovalgrp = new List <IMH_ApprovalGroup__c>();
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance',REQ_MANDAPPROVERS_COG));
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand',REQ_MANDAPPROVERS_CB));
            insert lApprovalgrp;
            System.debug('**AAC '+[SELECT Id, UserOrGroupId, GroupId FROM GroupMember Where GroupId=:groupCOG.Id LIMIT 50000]);
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
                                                                            lApprovalgrp[0].Id));
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
                                                                           lApprovalgrp[1].Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        List<IMH_SLATracker__c> lupdatedApptrack;
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
            
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],false);
      
            //Query expected approval record related the above communciation.
          
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            Test.startTest();
             Test.setCurrentPage(Page.IMH_ItemToApprovaPage);
             ApexPages.currentPage().getParameters().put('param','1');
             pagecontroller = new IMH_ItemToApproveController();
             pagecontroller.lwrapper[0].isSelected = true;
             pagecontroller.lwrapper[1].isSelected = true;
             pagecontroller.assignedReviewerLookup[0].AssignedApprover__c = runningAssignReviewer.Id;
             pagecontroller.assignReveiwer();
            Test.stopTest();
            
            //Assert To check Common Page Heading
            System.assertEquals('Results', pagecontroller.ResultHeading);
            
            //Assert To check The size od the List inserted and Wrapper size
              lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
             System.assertEquals(lApptrack.size(), pagecontroller.lwrapper.size());
            
            //Assert To check The size of the List updated with Assigned Reviewer and Checking the assignment of Assigned Approver
             lupdatedApptrack = [Select Communication__c, AssignedApprover__c,Status__c, OwnerId, Approval_Group__c, Owner__c
                                   FROM IMH_SLATracker__c WHERE AssignedApprover__c =:  runningAssignReviewer.Id
                                   LIMIT 50000];
           System.assertEquals(lApptrack.size(), lupdatedApptrack.size());
           System.assertEquals(runningAssignReviewer.Id, lupdatedApptrack[0].AssignedApprover__c);
        }
         
    }
    
         /*****************************************************************************
    * @description: Method for concept approval (Two Step Sequential)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    *               used to assign one of the records to a different assigned reviewer
    * @param: none
    * @return: void
    */ 
    static testmethod void displayoneRecords(){
        IMH_ItemToApproveController pagecontroller;
            
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningAssignReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        runningAssignReviewer.Market__c= THAILAND_MARKET;
        runningAssignReviewer.Username = 'testthai@imhrev.com';
        runningAssignReviewer.UserRoleId = reviewerRole.Id;
        insert runningAssignReviewer;
        
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
            //groupMemCOG.UserOrGroupId = runningAssignReviewer.Id;
            insert groupMemCOG;
            
            System.debug('**AAB '+[SELECT Id, UserOrGroupId, GroupId FROM GroupMember Where GroupId=:groupCOG.Id LIMIT 50000]);
            //Central Brand Group
            Group groupCB = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CentralBrand' LIMIT 1];
            GroupMember groupMemCB = new GroupMember();
            groupMemCB.GroupId = groupCB.Id;
            groupMemCB.UserOrGroupId = runningUserReviewer.Id;
            //groupMemCB.UserOrGroupId = runningAssignReviewer.Id;
            insert groupMemCB;
              List<IMH_ApprovalGroup__c> lApprovalgrp = new List <IMH_ApprovalGroup__c>();
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance',REQ_MANDAPPROVERS_COG));
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand',REQ_MANDAPPROVERS_CB));
            insert lApprovalgrp;
            //System.debug('**AAC '+[SELECT Id, UserOrGroupId, GroupId FROM GroupMember Where GroupId=:groupCOG.Id LIMIT 1]);
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
                                                                            lApprovalgrp[0].ID));
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
                                                                            lApprovalgrp[1].Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        List<IMH_SLATracker__c> lupdatedApptrack;
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
            
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],false);
      
            //Query expected approval record related the above communciation.
          
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            Test.startTest();
             Test.setCurrentPage(Page.IMH_ItemToApprovaPage);
             pagecontroller = new IMH_ItemToApproveController();
             pagecontroller.lwrapper[0].isSelected = true;
             pagecontroller.assignedReviewerLookup[0].AssignedApprover__c = runningAssignReviewer.Id;
             pagecontroller.assignReveiwer();
            Test.stopTest();
              lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
            
             lupdatedApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE AssignedApprover__c =:  runningAssignReviewer.Id
                           LIMIT 50000];
            System.assertEquals(lApptrack.size(), pagecontroller.lwrapper.size());
            System.assertnotEquals(lApptrack.size(), lupdatedApptrack.size());
            System.assertEquals(lupdatedApptrack.size(), 1);
        }
         
    }
    
            /*****************************************************************************
    * @description: Method for concept approval (Two Step Sequential)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    *               used to cover a negative scenario where Assigned Approver is blank an you click on assign
    * @param: none
    * @return: void
    */ 
    static testmethod void displaynegNoReviewerAssigned(){
        IMH_ItemToApproveController pagecontroller;
            
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningAssignReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        runningAssignReviewer.Market__c= THAILAND_MARKET;
        runningAssignReviewer.Username = 'testthai@imhrev.com';
        runningAssignReviewer.UserRoleId = reviewerRole.Id;
        insert runningAssignReviewer;
        
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
            //groupMemCOG.UserOrGroupId = runningAssignReviewer.Id;
            insert groupMemCOG;
            
            System.debug('**AAB '+[SELECT Id, UserOrGroupId, GroupId FROM GroupMember Where GroupId=:groupCOG.Id LIMIT 50000]);
            //Central Brand Group
            Group groupCB = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CentralBrand' LIMIT 1];
            GroupMember groupMemCB = new GroupMember();
            groupMemCB.GroupId = groupCB.Id;
            groupMemCB.UserOrGroupId = runningUserReviewer.Id;
            //groupMemCB.UserOrGroupId = runningAssignReviewer.Id;
            insert groupMemCB;
              List<IMH_ApprovalGroup__c> lApprovalgrp = new List <IMH_ApprovalGroup__c>();
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance',REQ_MANDAPPROVERS_COG));
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand',REQ_MANDAPPROVERS_CB));
            insert lApprovalgrp;
            System.debug('**AAC '+[SELECT Id, UserOrGroupId, GroupId FROM GroupMember Where GroupId=:groupCOG.Id LIMIT 50000]);
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
                                                                            lApprovalgrp[0].Id));
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
                                                                            lApprovalgrp[1].Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        List<IMH_SLATracker__c> lupdatedApptrack;
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
            
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],false);
      
            //Query expected approval record related the above communciation.
          
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            Test.startTest();
             Test.setCurrentPage(Page.IMH_ItemToApprovaPage);
             pagecontroller = new IMH_ItemToApproveController();
             pagecontroller.lwrapper[0].isSelected = true;
             //pagecontroller.assignedReviewerLookup[0].AssignedApprover__c = runningAssignReviewer.Id;
             pagecontroller.assignReveiwer();
            Test.stopTest();
              lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
            System.assertEquals(lApptrack.size(), pagecontroller.lwrapper.size());
            
             lupdatedApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE AssignedApprover__c =:  runningAssignReviewer.Id
                           LIMIT 50000];
            
            System.assertEquals( lupdatedApptrack.size(), 0);
        }
         
    }
    
 /*****************************************************************************
    * @description: Method for concept approval (Two Step Sequential)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    *               used to cover a negative scenario where Assigned Approver is assigned 
    *              but no records records are selected and you click on Assign button
    * @param: none
    * @return: void
    */ 
    static testmethod void displaynegNorecordsSelected(){
        IMH_ItemToApproveController pagecontroller;
            
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningAssignReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        runningAssignReviewer.Market__c= THAILAND_MARKET;
        runningAssignReviewer.Username = 'testthai@imhrev.com';
        runningAssignReviewer.UserRoleId = reviewerRole.Id;
        insert runningAssignReviewer;
        
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
            //groupMemCOG.UserOrGroupId = runningAssignReviewer.Id;
            insert groupMemCOG;
            
           // System.debug('**AAB '+[SELECT Id, UserOrGroupId, GroupId FROM GroupMember Where GroupId=:groupCOG.Id]);
            //Central Brand Group
            Group groupCB = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CentralBrand' LIMIT 1];
            GroupMember groupMemCB = new GroupMember();
            groupMemCB.GroupId = groupCB.Id;
            groupMemCB.UserOrGroupId = runningUserReviewer.Id;
            //groupMemCB.UserOrGroupId = runningAssignReviewer.Id;
            insert groupMemCB;
               List<IMH_ApprovalGroup__c> lApprovalgrp = new List <IMH_ApprovalGroup__c>();
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance',REQ_MANDAPPROVERS_COG));
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand',REQ_MANDAPPROVERS_CB));
            insert lApprovalgrp;
            //System.debug('**AAC '+[SELECT Id, UserOrGroupId, GroupId FROM GroupMember Where GroupId=:groupCOG.Id]);
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
                                                                            lApprovalgrp[0].ID));
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
                                                                            lApprovalgrp[1].ID));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        List<IMH_SLATracker__c> lupdatedApptrack;
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
            
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],false);
      
            //Query expected approval record related the above communciation.
          
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            Test.startTest();
             Test.setCurrentPage(Page.IMH_ItemToApprovaPage);
             pagecontroller = new IMH_ItemToApproveController();
             pagecontroller.assignedReviewerLookup[0].AssignedApprover__c = runningAssignReviewer.Id;
             pagecontroller.assignReveiwer();
            Test.stopTest();
             //Assert To check The size od the List inserted and Wrapper size
              lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
            System.assertEquals(lApptrack.size(), pagecontroller.lwrapper.size());
            
             lupdatedApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE AssignedApprover__c =:  runningAssignReviewer.Id
                           LIMIT 50000];
             System.assertEquals( lupdatedApptrack.size(), 0);
        }
         
    }
    
 /*****************************************************************************
    * @description: Method for concept approval (Two Step Sequential)
    *               1. Leadership - Approve
    *               used to assign both the records to a different assigned reviewer adn get an error on Leadership record
    * @param: none
    * @return: void
    */ 
    static testmethod void displayLeadrshipRecords(){
        IMH_ItemToApproveController pagecontroller;
        String errormessage = '';   
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningAssignReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        runningAssignReviewer.Market__c= THAILAND_MARKET;
        runningAssignReviewer.Username = 'testthai@imhrev.com';
        runningAssignReviewer.UserRoleId = reviewerRole.Id;
        insert runningAssignReviewer;
        
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
             List<IMH_ApprovalGroup__c> lApprovalgrp = new List <IMH_ApprovalGroup__c>();
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('Leadership',''));
            insert lApprovalgrp;
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
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_CB, 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            lApprovalgrp[0].Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        List<IMH_SLATracker__c> lupdatedApptrack;
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
            
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],false);
      
            //Query expected approval record related the above communciation.
          
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
            Test.startTest();
             Test.setCurrentPage(Page.IMH_ItemToApprovaPage);
             pagecontroller = new IMH_ItemToApproveController();
             pagecontroller.lwrapper[0].isSelected = true;
             pagecontroller.assignedReviewerLookup[0].AssignedApprover__c = runningAssignReviewer.Id;
                pagecontroller.assignReveiwer();
            Test.stopTest();
             //Assert To check The size od the List inserted and Wrapper size
              lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
             System.assertEquals(lApptrack.size(), pagecontroller.lwrapper.size());
            
             lupdatedApptrack = [Select Communication__c, AssignedApprover__c,Status__c, OwnerId, Approval_Group__c, Owner__c
                                   FROM IMH_SLATracker__c WHERE AssignedApprover__c =:  runningAssignReviewer.Id
                                   LIMIT 50000];
           System.assertNotEquals(lApptrack.size(), lupdatedApptrack.size());
           System.assertEquals(0, lupdatedApptrack.size());
        }
         
    }
     /*****************************************************************************
    * @description: Method for ccovering a scenario when there are no approvals in pending state
    * @param: none
    * @return: void
    */ 
    static testmethod void displaynoLeadrshipRecords(){
        IMH_ItemToApproveController pagecontroller;
        String errormessage = '';   
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_THAI LIMIT 1];
        runningUserReviewer.Market__c= THAILAND_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        insert runningUserReviewer;
        
        User runningAssignReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        runningAssignReviewer.Market__c= THAILAND_MARKET;
        runningAssignReviewer.Username = 'testthai@imhrev.com';
        runningAssignReviewer.UserRoleId = reviewerRole.Id;
        insert runningAssignReviewer;
        
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
             List<IMH_ApprovalGroup__c> lApprovalgrp = new List <IMH_ApprovalGroup__c>();
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('Leadership',''));
            insert lApprovalgrp;
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
                                                                            INCENTIVISED_OFFER, 
                                                                            REQ_MANDAPPROVERS_CB, 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            lApprovalgrp[0].Id));
            }
            Database.insert(lApprovalmat,true);
        }
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;     
        List<IMH_SLATracker__c> lApptrack;
        List<IMH_SLATracker__c> lupdatedApptrack;
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
            
            // Update Communication
            lcommunication[0].SYS_ReadyForReview_New__c = True;
            Database.update(lcommunication[0],false);
      
            //Query expected approval record related the above communciation.
          
        }

        //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserReviewer){ 
             lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:insertedCommunicationId
                          AND Status__c = 'Pending' LIMIT 1];
            lApptrack[0].Status__c = 'Approved';
            update lApptrack;
            Test.startTest();
             Test.setCurrentPage(Page.IMH_ItemToApprovaPage);
             pagecontroller = new IMH_ItemToApproveController();
            Test.stopTest();
            //Assert to check whether there are any SLA records present
             System.assertNotEquals(lApptrack.size(), pagecontroller.lwrapper.size());
             System.assertEquals(0, pagecontroller.lwrapper.size());
        }
         
    }
      /*****************************************************************************
    * @description: Method for concept approval Where Leadership is engaged and The Delegated Approver
    *              tries to view the Items to Approve List. 
    * @param: none
    * @return: void
     */
    static testMethod void delegateApprovalStep() {
        IMH_ItemToApproveController pagecontroller;
         UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name ='UK Reviewer' LIMIT 1];
        
        User runningUserdelegate1  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER + 'Delegate1',null);
        runningUserdelegate1.Market__c= 'UK';
        runningUserdelegate1.UserRoleId = reviewerRole.Id;
        insert runningUserdelegate1;
        
        /*User runningUserdelegate2  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER +  'Delegate2',null);
        runningUserdelegate2.Market__c= UK_MARKET;
        runningUserdelegate2.UserRoleId = reviewerRole.Id;
        insert runningUserdelegate2;*/
        
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        runningUserReviewer.Market__c= 'UK';
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        runningUserReviewer.DelegatedApproverId = runningUserdelegate1.Id;
         runningUserReviewer.Band_CA__c = 'Band 40';
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name ='UK Submitter'];
        runningUserSubmitter.Market__c= 'UK';
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
             List<IMH_ApprovalGroup__c> lApprovalgrp = new List <IMH_ApprovalGroup__c>();
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('Leadership','Leader'));
            insert lApprovalgrp;
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
                                                                            lApprovalgrp[0].Id));
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
        //Test.startTest();
        //Changing the delegated Approver for the reviewer
        /*runningUserReviewer.DelegatedApproverId = runningUserdelegate2.Id;
        update runningUserReviewer;*/
       // Test.stopTest(); 
        
         lApptrack = [Select Id, CommCreative__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE CommCreative__c =:creativeRecordId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
        System.assertEquals(1,lApptrack.size());
        List<IMH_SLATracker__Share> lappshare = [SELECT Id, 
                                                        ParentId, 
                                                        UserOrGroupId, 
                                                        AccessLevel 
                                                 FROM IMH_SLATracker__Share
                                                 WHERE ParentId =:lApptrack[0].Id
                                                AND UserOrGroupId =:runningUserdelegate1.Id
                                                LIMIT 50000];
        System.assertEquals(1,lappshare.size());
        System.assertEquals('Edit',lappshare[0].AccessLevel);
        
        
         //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserdelegate1){ 
            Test.startTest();
             Test.setCurrentPage(Page.IMH_ItemToApprovaPage);
             pagecontroller = new IMH_ItemToApproveController();
            Test.stopTest();
            //Assert to check whether there are any SLA records present
             System.assertEquals(lApptrack.size(), pagecontroller.lwrapper.size());
             System.assertEquals(1, pagecontroller.lwrapper.size());
        }
    }
/*****************************************************************************
    * @description: Method for concept approval Where B40 INS is engaged and The Delegated Approver
    *              tries to view the Items to Approve List. 
    * @param: none
    * @return: void
     */
    static testMethod void delegateApprovalStepB40() {
        IMH_ItemToApproveController pagecontroller;
         UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name ='UK Reviewer' LIMIT 1];
        
        User runningUserdelegate1  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER + 'Delegate1',null);
        runningUserdelegate1.Market__c= 'UK';
        runningUserdelegate1.UserRoleId = reviewerRole.Id;
        insert runningUserdelegate1;
        
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        runningUserReviewer.Market__c= 'UK';
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        runningUserReviewer.DelegatedApproverId = runningUserdelegate1.Id;
         runningUserReviewer.Band_CA__c = 'Band 40';
        insert runningUserReviewer;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name ='UK Submitter'];
        runningUserSubmitter.Market__c= 'UK';
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
              List<IMH_ApprovalGroup__c> lApprovalgrp = new List <IMH_ApprovalGroup__c>();
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_B40Ins_UK',''));
            insert lApprovalgrp;
             //COG Group
            Group groupCOG = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_B40Ins_UK' LIMIT 1];
            GroupMember groupMemCOG = new GroupMember();
            groupMemCOG.GroupId = groupCOG.Id;
            groupMemCOG.UserOrGroupId = runningUserReviewer.Id;
            insert groupMemCOG;
         // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                 lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Core Review Group',
                                                                            'UK',
                                                                            'EMEA',
                                                                            0,
                                                                            STD_PRIORITY,
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_B40Ins_UK',
                                                                            1,
                                                                            'INS New/Material changes to Comms', 
                                                                            '', 
                                                                            'Creative',
                                                                            '',
                                                                            'Retail Insurance',
                                                                            false,
                                                                            lApprovalgrp[0].Id));
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
        //Test.startTest();
        //Changing the delegated Approver for the reviewer
        /*runningUserReviewer.DelegatedApproverId = runningUserdelegate2.Id;
        update runningUserReviewer;*/
       // Test.stopTest(); 
        
         lApptrack = [Select Id, CommCreative__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE CommCreative__c =:creativeRecordId
                          AND Status__c = 'Pending'
                          LIMIT 50000 ];
        System.assertEquals(1,lApptrack.size());
        List<IMH_SLATracker__Share> lappshare = [SELECT Id, 
                                                        ParentId, 
                                                        UserOrGroupId, 
                                                        AccessLevel 
                                                 FROM IMH_SLATracker__Share
                                                 WHERE ParentId =:lApptrack[0].Id
                                                AND UserOrGroupId =:runningUserdelegate1.Id
                                                LIMIT 50000];
        System.assertEquals(1,lappshare.size());
        System.assertEquals('Edit',lappshare[0].AccessLevel);
        
        
         //RUNNING AS CAMPAIGN REVIEWER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUserdelegate1){ 
            Test.startTest();
             Test.setCurrentPage(Page.IMH_ItemToApprovaPage);
             pagecontroller = new IMH_ItemToApproveController();
            Test.stopTest();
            //Assert to check whether there are any SLA records present
             System.assertEquals(lApptrack.size(), pagecontroller.lwrapper.size());
             System.assertEquals(1, pagecontroller.lwrapper.size());
        }
    }	
}