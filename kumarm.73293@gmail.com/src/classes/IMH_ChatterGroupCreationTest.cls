/**
* @author Saravvanan Kandaswamy 
* @date 08/15/2016
* @group-content N/A
* @description: iMH Release 1.6 (Sprint 42) - Test Class for Chatter Group creation. 
*				This test is moved to separate test class as 'SeeAllData' should be enabled to run the test.
*/
@isTest(SeeAllData=true)
private class IMH_ChatterGroupCreationTest {
    private static final String CONCEPT_STAGE               = 'Concept';
    private static final String STATUS_NAME                 = 'In Progress';
    private static final String THAILAND_MARKET             = 'Thailand';
	private static final String UK_MARKET             		= 'UK';
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
    * @description: Method used to check whether the SYS_ChatterId__c is mapped on Approval or not
    * @param: none
    * @return: void
    */
    static testMethod void ChatterGroupIDInApproval() {

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
        
        // Collab group id for testing
        String collGroupId;
        system.runAs(adminUser) {    
            //COG Group
            Group groupCOG = [Select Id,Name, DeveloperName From Group WHERE DeveloperName = 'IMH_CentralOfferGovernance' LIMIT 1];
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
            
             // INSERT COLLABORATION GROUP (CHATTER GROUP)
             List<CollaborationGroup> lcolbgrp = new List<CollaborationGroup>([Select Id, Name from CollaborationGroup where Name= :groupCOG.Name LIMIT 1]);
            System.debug('coll group' + lcolbgrp);
            /*if(colbgrp != NULL){
                System.debug('Name of coll group' + colbgrp.name);
            }*/
            if(!lcolbgrp.isEmpty()){
                System.debug('Name of coll group' + lcolbgrp[0].name);
                collGroupId = lcolbgrp[0].id;  
            }
            else{
            	CollaborationGroup colbgrp  = new CollaborationGroup();
                colbgrp.Name = groupCOG.Name;
              	colbgrp.CollaborationType = 'Private';
         		insert colbgrp;
                collGroupId = colbgrp.id;  
      		}
			//collGroupId = colbgrp.id;  
            // Collabration group id should not be NULL
            System.assertNotEquals(NULL, collGroupId);
           //WS System.debug('Coll group id' + colbgrp.id);                 
            // Insert Approval Matrix
            List<IMH_ApprovalGroup__c> lApprovalgrp = new List <IMH_ApprovalGroup__c>();
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance',REQ_MANDAPPROVERS_COG));
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand',REQ_MANDAPPROVERS_CB));
            insert lApprovalgrp;
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
                                                                            2,
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
            lApptrack = [Select Communication__c, Status__c, OwnerId, Approval_Group__c, Owner__c, SYS_ChatterGroupId__c
                           FROM IMH_SLATracker__c WHERE Communication__c =: insertedCommunicationId
                           LIMIT 50000];
            System.assertEquals(1,lApptrack.size(),1);
            //Check for chatter group Id in communication.
            System.assertEquals(collGroupId,lApptrack[0].SYS_ChatterGroupId__c);
            System.assertEquals('Pending',lApptrack[0].Status__c);
            //System.assertEquals(REQ_MANDAPPROVERS_COG,lApptrack[0].Owner__c);
            
        }
		Test.stopTest();    
    }

}