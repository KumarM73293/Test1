/**
* @author Accenture IDC 
* @date 01/14/2016
* @group Creative
* @group-content N/A
* @description: iMH Release 1.3 (Sprint 14) - Test Class for Escalation Process
*/
@isTest
private class IMH_SoftEscalationHandlerTest {
    private static final String STATUS_NAME                     = 'In Progress';
    private static final String STAGE_NAME                      = 'Concept';
    private static final String ANZ_MARKET                      = 'Australia';
    private static final String COMPLICANCE_GROUP_CA           = 'IMH_Compliance_CA';
    private static final String GCO_GROUP_CA                   = 'IMH_GCO_CA';
    private static final String COMPLICANCE_GROUP_ANZ           = 'IMH_Compliance_ANZ';
    private static final String GCO_GROUP_ANZ                   = 'IMH_GCO_ANZ';
    private static final String SUBMITTER_ANZ                   = 'ANZ Submitter';
    private static final String REVIEWER_ANZ                    = 'ANZ Reviewer';
    private static final String IN_MARKET                       = 'India';  
    private static final String COMPLICANCE_GROUP_IN            = 'IMH_Compliance_IN';
    private static final String GCO_GROUP_IN                    = 'IMH_GCO_IN';
    private static final String COG_GROUP_IN                    = 'IMH_CentralOfferGovernance';
    private static final String SUBMITTER_IN                    = 'One India Submitter';
    private static final String REVIEWER_IN                     = 'One India Reviewer';
    private static final String CAMPAIGN_SUBMITTER_PROFILE      = 'iMH Campaign Submitter';
    private static final String CAMPAIGN_REVIEWER_PROFILE       = 'iMH Campaign Reviewer';
    private static final String SUBMITTER_RUNNING_USER          = 'RunningUserSubmitter';
    private static final String REVIEWER_RUNNING_USER           = 'RunningUserReviewer';
    private static final String CREATIVE_API                    = 'IMH_CommCreative__c';
    private static final String COMMUNICATION_API               = 'IMH_Communication__c';
    private static final String CREATIVE_RECTYPE                = 'CreativeDesign';
    private static final String ESCALATE_COMMENT                = 'Escalate Test';
    private static final String CREATIVE_STAGE                  = 'Creative';
    private static final String ERROR_MSG                       = 'Market should be specified on user record for escalation process. Please Contact system admin.';
    private static final String RUNNING_USER                = 'RunningUser';
    private static final String MARKET_CANADA               = 'Canada';
    private static Boolean isTargetedChannelsProductTriggerTest = false;
    private static final String ATTESTATION_STAGE           = 'Attestation'; 
    private static final String CENTRAL_OG                  = 'Central Offer Governance';  
    private static final String INPROGRESS_STATUS           = 'In Progress';
    private static final String CREATIVE_API_NAME           = 'IMH_CommCreative__c';
    private static final String CREATE_NAME                 = 'CreativeDesign';
    private static final String COUNTER_1                   = '1'; 
    private static final String REGION_LACC                 = 'LACC';
    private static final String AMEX_TEXT                   = 'AMEX';
    private static final String BRANDANDADVERTISING         = 'Brand and Advertising';   
    private static final String LENDING                     = 'Lending';
    private static final String SBS                         = 'SBS';  
    private static final String PRODUCT_NAME                = 'ProdTest';
    private static final String COLOUR_GOLD                 = 'Gold';
    
    /*****************************************************************************
    * @description: Method used for covering the soft escalation code on Creative for ANZ
    * @param: none
    * @return: void
    */
    static testMethod void CreativeSoftEscalationAndFollowANZ() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_ANZ LIMIT 1];
        runningUserReviewer.Market__c= ANZ_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_ANZ LIMIT 1];
        runningUserSubmitter.Market__c= ANZ_MARKET;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');
        Insert adminUser;
        system.runAs(adminUser) {    
            Group groupCompliance = [Select Id, DeveloperName From Group WHERE DeveloperName =: COMPLICANCE_GROUP_ANZ LIMIT 1];
            Group groupGCO = [Select Id, DeveloperName From Group WHERE DeveloperName =: GCO_GROUP_ANZ LIMIT 1];
            
            GroupMember gmemToCompliance = new GroupMember();
            gmemToCompliance.GroupId = groupCompliance.Id;
            gmemToCompliance.UserOrGroupId = adminUser.Id;
            insert gmemToCompliance;
            
            GroupMember gmemToGCO = new GroupMember();
            gmemToGCO.GroupId = groupGCO.Id;
            gmemToGCO.UserOrGroupId = adminUser.Id;
            insert gmemToGCO;
            
            IMH_Chatter_Auto_Follow__c cafGCO = new IMH_Chatter_Auto_Follow__c();
            cafGCO.Name = 'CommCreative'+'_'+ANZ_MARKET+'_GCO';
            cafGCO.Escalation_Group__c = 'GCO';
            cafGCO.Object__c = CREATIVE_API;
            cafGCO.Market__c = ANZ_MARKET;
            cafGCO.Active__c = true;
            insert cafGCO;
            
            IMH_Chatter_Auto_Follow__c cafCompliance = new IMH_Chatter_Auto_Follow__c();
            cafCompliance.Name = 'CommCreative'+'_'+ANZ_MARKET+'_Compliance';
            cafCompliance.Escalation_Group__c = 'Compliance';
            cafCompliance.Object__c = CREATIVE_API;
            cafCompliance.Market__c = ANZ_MARKET;
            cafCompliance.Active__c = true;
            insert cafCompliance;
            
            Group groupInsurance = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_Insurance_ANZ' LIMIT 1];
            GroupMember gmemToInsurance = new GroupMember();
            gmemToInsurance.GroupId = groupInsurance.Id;
            gmemToInsurance.UserOrGroupId = adminUser.Id;
            insert gmemToInsurance;
            
            IMH_Chatter_Auto_Follow__c cafInsurance= new IMH_Chatter_Auto_Follow__c();
            cafInsurance.Name = 'CommCreative'+'_'+MARKET_CANADA+'Ins';
            cafInsurance.Escalation_Group__c = 'Insurance';
            cafInsurance.Object__c = CREATIVE_API;
            cafInsurance.Market__c = ANZ_MARKET;
            cafInsurance.Active__c = true;
            insert cafInsurance;
            
            Group groupCOG = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CentralOfferGovernance' LIMIT 1];
            GroupMember gmemToCOG = new GroupMember();
            gmemToCOG.GroupId = groupCOG.Id;
            gmemToCOG.UserOrGroupId = adminUser.Id;
            insert gmemToCOG;
            
            IMH_Chatter_Auto_Follow__c cafCOG = new IMH_Chatter_Auto_Follow__c();
            cafCOG.Name = 'CommCreative'+'_'+MARKET_CANADA+'COG';
            cafCOG.Escalation_Group__c = 'Central Offer Governance';
            cafCOG.Object__c = CREATIVE_API;
            cafCOG.Market__c = ANZ_MARKET;
            cafCOG.Active__c = true;
            insert cafCOG;
        }
        Test.startTest();
        IMH_CommCreative__c creativeRec;
        system.runAs(runningUserSubmitter) {    
            List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<10;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,ANZ_MARKET));
                lcommunication[0].ProcessStage__c = CREATIVE_STAGE;
                lcommunication[0].RequiredApprovers__c = 'Compliance';
            }
            Database.insert(lcommunication,false);
            creativeRec = IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get(CREATIVE_API).get(CREATIVE_RECTYPE).Id);
            creativeRec.CreativeStage__c = 'Design';
            creativeRec.CreativeStatus__c = 'In Review';
            insert creativeRec;
            //Code for AutoFollow Creative
            IMH_CommCreative__c creativeRecToUpdate = [SELECT Id, Escalate_Comments__c, Escalate_to_GCO__c, SYS_ReadyForReview_New__c,
                                                        SequenceNumber__c, Escalate_to_Insurance_Compliance__c FROM 
                                                        IMH_CommCreative__c WHERE id=: creativeRec.Id LIMIT 1];
            creativeRecToUpdate.SYS_ReadyForReview_New__c = true;
			creativeRecToUpdate.SequenceNumber__c = 1;
			//update creativeRecToUpdate;

        }

        system.runAs(runningUserReviewer) { 
            IMH_CommCreativeTriggerHandler.isAfterUpdateExecuted = false;
            IMH_CommCreative__c creativeRecToUpdate = [SELECT Id, Escalate_Comments__c, Escalate_to_GCO__c, Escalate_to_Insurance_Compliance__c FROM 
                                                  IMH_CommCreative__c WHERE id=: creativeRec.Id LIMIT 1];
            creativeRecToUpdate.Escalate_Comments__c  = ESCALATE_COMMENT;
            creativeRecToUpdate.Escalate_to_GCO__c = true;
            creativeRecToUpdate.Escalate_to_Insurance_Compliance__c = true;
            creativeRecToUpdate.Escalate_to_Central_OG__c           = true;
            update creativeRecToUpdate;
        }
        Test.stopTest();
        //Code for Assert
        Set<Id> subscribedUserSet = new Set<Id>();
        for(EntitySubscription entitySubRec : [SELECT Id, ParentId, SubscriberId FROM EntitySubscription WHERE 
                                               ParentId =: creativeRec.Id LIMIT 50000]){
            subscribedUserSet.add(entitySubRec.SubscriberId);                                           
        }
        if(!subscribedUserSet.isEmpty()){
            for(GroupMember g : [Select UserorGroupId From GroupMember WHERE group.DeveloperName =: COMPLICANCE_GROUP_ANZ LIMIT 50000]) {
                if((g.UserOrGroupID.getsObjectType() == Schema.User.sObjectType) 
                    && (g.UserOrGroupID == adminUser.Id)){
                    System.assertEquals(true, subscribedUserSet.contains(g.UserOrGroupId));
                }
            }
            for(GroupMember g : [Select UserorGroupId From GroupMember WHERE group.DeveloperName =: GCO_GROUP_ANZ LIMIT 50000]) {
                if((g.UserOrGroupID.getsObjectType() == Schema.User.sObjectType) 
                    && (g.UserOrGroupID == adminUser.Id)){
                    System.assertEquals(true, subscribedUserSet.contains(g.UserOrGroupId));
                }
            }
            for(GroupMember g : [Select UserorGroupId From GroupMember WHERE group.DeveloperName = 'IMH_CentralOfferGovernance' LIMIT 50000]) {
                if((g.UserOrGroupID.getsObjectType() == Schema.User.sObjectType) 
                    && (g.UserOrGroupID == adminUser.Id)){
                    System.assertEquals(true, subscribedUserSet.contains(g.UserOrGroupId));
                }
            }
        }
    }
    
	/**
    * @description: Test Method used to check for creative escalation and unfollow
    * @param: none
    * @return: void
    */
    static testMethod void CreativeSoftEscalationAndUnFollowANZ() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');

        Insert adminUser;
        system.runAs(adminUser) { 
            Group groupCompliance = [Select Id, DeveloperName From Group WHERE DeveloperName =: COMPLICANCE_GROUP_ANZ LIMIT 1];
            Group groupGCO = [Select Id, DeveloperName From Group WHERE DeveloperName =: GCO_GROUP_ANZ LIMIT 1];
            GroupMember gmemToCompliance = new GroupMember();
            gmemToCompliance.GroupId = groupCompliance.Id;
            gmemToCompliance.UserOrGroupId = adminUser.Id;
            insert gmemToCompliance;
            GroupMember gmemToGCO = new GroupMember();
            gmemToGCO.GroupId = groupGCO.Id;
            gmemToGCO.UserOrGroupId = adminUser.Id;
            insert gmemToGCO;
        }
        Test.startTest();
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<10;i++) {
            lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,ANZ_MARKET));
            lcommunication[0].ProcessStage__c = CREATIVE_STAGE;
        }
        Database.insert(lcommunication,false);
        IMH_CommCreative__c creativeRec = IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get(CREATIVE_API).get(CREATIVE_RECTYPE).Id);
        creativeRec.CreativeStage__c = 'Design';
        creativeRec.CreativeStatus__c = 'In Progress';
        creativeRec.Escalate_to_GCO__c = true;
        creativeRec.Escalate_to_Insurance_Compliance__c = true;
        creativeRec.Escalate_Comments__c  = ESCALATE_COMMENT;
        insert creativeRec;
        IMH_CommCreative__c updateCreativeRec = [SELECT Id, CreativeStage__c, CreativeStatus__c FROM IMH_CommCreative__c
                                                 WHERE Id=: creativeRec.Id LIMIT 1];
        EntitySubscription es = new EntitySubscription();
        es.parentId = creativeRec.Id;
        es.subscriberid = adminUser.Id;
        insert es;
        updateCreativeRec.CreativeStage__c = 'Complete';
        updateCreativeRec.CreativeStatus__c = 'Approved';
        update updateCreativeRec;
        Test.stopTest();
        //Code for Assert
        List<EntitySubscription> esList = new List<EntitySubscription>([SELECT Id, ParentId, SubscriberId FROM 
                                                                        EntitySubscription WHERE 
                                                                        ParentId =: creativeRec.Id LIMIT 50000]);
        System.assertEquals(0, esList.size());
        
    }
    /**
    * @description: Test Method used to check for communication escalation and follow.
    * @param: none
    * @return: void
    */
    static testMethod void CommunicationSoftEscalationAndFollowIN() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        runningUserReviewer.Market__c = IN_MARKET   ;
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_IN LIMIT 1];
        runningUserReviewer.Market__c= IN_MARKET;
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_IN LIMIT 1];
        runningUserSubmitter.Market__c= IN_MARKET;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');
        Insert adminUser;
        Test.startTest();
        system.runAs(adminUser) {    
            Group groupCOG = [Select Id, DeveloperName From Group WHERE DeveloperName =: COG_GROUP_IN LIMIT 1];
            GroupMember gmemToCOG = new GroupMember();
            gmemToCOG.GroupId = groupCOG.Id;
            gmemToCOG.UserOrGroupId = adminUser.Id;
            insert gmemToCOG;
            IMH_Chatter_Auto_Follow__c cafCOG = new IMH_Chatter_Auto_Follow__c();
            cafCOG.Name = 'Communication'+'_'+IN_MARKET+'_COG';
            cafCOG.Escalation_Group__c = 'COG';
            cafCOG.Object__c = CREATIVE_API;
            cafCOG.Market__c = IN_MARKET;
            cafCOG.Active__c = true;
            insert cafCOG;
        }
        IMH_Communication__c communicationRec;
        system.runAs(runningUserSubmitter) { 
            communicationRec = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,ANZ_MARKET);
            communicationRec.ProcessStage__c = 'Concept';
            communicationRec.ReviewStage__c  = 'Design';
			communicationRec.ReviewStatus__c	  = 'In Review';
            communicationRec.Escalate_to_Central_OG__c = false;
            insert communicationRec;
        }
        system.runAs(runningUserReviewer) { 
            IMH_CommunicationTriggerHandler.isExecutedAfter = false;    
            IMH_Communication__c communicationRecToUpdate = [SELECT Id, Escalate_Comments__c, Escalate_to_Central_OG__c FROM 
                                                        IMH_Communication__c WHERE id=: communicationRec.Id LIMIT 1];
            communicationRecToUpdate.Escalate_Comments__c                = ESCALATE_COMMENT;
            communicationRecToUpdate.Escalate_to_Central_OG__c           = true;
            update communicationRecToUpdate;
        }
        Test.stopTest();
        //Code for Assert
        Set<Id> subscribedUserSet = new Set<Id>();
        for(EntitySubscription entitySubRec : [SELECT Id, ParentId, SubscriberId FROM EntitySubscription WHERE 
                                               ParentId =: communicationRec.Id LIMIT 50000]){
            subscribedUserSet.add(entitySubRec.SubscriberId);                                           
        }
        if(!subscribedUserSet.isEmpty()){
            for(GroupMember g : [Select UserorGroupId From GroupMember WHERE group.DeveloperName =: COG_GROUP_IN LIMIT 50000]) {
                if((g.UserOrGroupID.getsObjectType() == Schema.User.sObjectType) 
                    && (g.UserOrGroupID == adminUser.Id)) {
                    System.assertEquals(true, subscribedUserSet.contains(g.UserOrGroupId));
                }
            }
        }
        
    }
    /**
    * @description: Test Method used to check if unfollow happens on communication for one India
    * @param: none
    * @return: void
    */
    static testMethod void CommunicationUnFollowIN() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');

        Insert adminUser;
        system.runAs(adminUser) { 
            Group groupCOG = [Select Id, DeveloperName From Group WHERE DeveloperName =: COG_GROUP_IN LIMIT 1];
            GroupMember gmemToCOG = new GroupMember();
            gmemToCOG.GroupId = groupCOG.Id;
            gmemToCOG.UserOrGroupId = adminUser.Id;
            insert gmemToCOG;
        }
        Test.startTest();
        IMH_Communication__c communicationRec;
        system.runAs(adminUser) { 
            communicationRec = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,ANZ_MARKET);
            communicationRec.ProcessStage__c = 'Concept';
            communicationRec.ReviewStage__c  = 'Design';
            communicationRec.Escalate_to_Central_OG__c = false;
            insert communicationRec;
            EntitySubscription es = new EntitySubscription();
            es.parentId = communicationRec.Id;
            es.subscriberid = adminUser.Id;
            insert es;
            IMH_CommunicationTriggerHandler.isExecutedAfter = false;    
            IMH_Communication__c communicationRecToUpdate = [SELECT Id, ProcessStage__c,  ReviewStage__c FROM 
                                                                IMH_Communication__c WHERE id=: communicationRec.Id LIMIT 1];
            communicationRecToUpdate.ProcessStage__c        = 'Creative';
            communicationRecToUpdate.ReviewStage__c         = 'Design';
            update communicationRecToUpdate;
        }
        Test.stopTest();
        //Code for Assert Unfollow
        List<EntitySubscription> esList = new List<EntitySubscription>([SELECT Id, ParentId, SubscriberId FROM 
                                                                        EntitySubscription WHERE 
                                                                        ParentId =: communicationRec.Id LIMIT 50000]);
        System.assertEquals(0, esList.size());
    }
    
    /**
    * @description: Test Method used to check if there is no market on user
    * @param: none
    * @return: void
    */
    static testMethod void NoMarketOnUser() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUserReviewer  = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWER_RUNNING_USER,null);
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole reviewerRole = [SELECT Id, Name FROM UserRole WHERE Name =: REVIEWER_ANZ LIMIT 1];
        runningUserReviewer.UserRoleId = reviewerRole.Id;
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_ANZ LIMIT 1];
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        IMH_CommCreative__c creativeRec;
        system.runAs(runningUserSubmitter) {    
            List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<10;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,ANZ_MARKET));
                lcommunication[0].ProcessStage__c = CREATIVE_STAGE;
            }
            Database.insert(lcommunication,false);
            creativeRec = IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get(CREATIVE_API).get(CREATIVE_RECTYPE).Id);
            insert creativeRec;
        }
        try {
            system.runAs(runningUserReviewer) { 
                IMH_CommCreativeTriggerHandler.isAfterUpdateExecuted = false;   
                IMH_CommCreative__c creativeRecToUpdate = [SELECT Id, Escalate_Comments__c, Escalate_to_GCO__c, Escalate_to_Insurance_Compliance__c FROM 
                                                      IMH_CommCreative__c WHERE id=: creativeRec.Id LIMIT 1];
                creativeRecToUpdate.Escalate_Comments__c                = ESCALATE_COMMENT;
                creativeRecToUpdate.Escalate_to_GCO__c                  = true;
                creativeRecToUpdate.Escalate_to_Insurance_Compliance__c = true;
                update creativeRecToUpdate;
            }
        }
        catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(ERROR_MSG) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }

    }

    /**
    * @description: Creative Auto Follow on Creative Submit for Approval
    * @param: none
    * @return: void
    */
    static testMethod void  creativeSubmitApprovalAutoFollow () {
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        runningUser.Market__c= MARKET_CANADA;
        Id creativeRecordId1;
        Id creativeRecordId2;
        Id insertedTargetedProductId;
        Id insertedTargetedChannelId;
        
        isTargetedChannelsProductTriggerTest = true;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');
        Insert adminUser;
        system.runAs(adminUser) {    
            //Band 40
            Group groupband = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_LocalBand40_CA' LIMIT 1];
            GroupMember gmemToBand = new GroupMember();
            gmemToBand.GroupId = groupband.Id;
            gmemToBand.UserOrGroupId = adminUser.Id;
            insert gmemToBand;
            IMH_Chatter_Auto_Follow__c cafBand = new IMH_Chatter_Auto_Follow__c();
            cafBand.Name = 'CommCreative'+'_'+MARKET_CANADA+'_Band 40';
            cafBand.Escalation_Group__c = 'Band 40';
            cafBand.Object__c = CREATIVE_API;
            cafBand.Market__c = MARKET_CANADA;
            cafBand.Active__c = true;
            insert cafBand;

            /*//Calendarisation
            Group groupCalendar = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CalendarisationTeam_CA' LIMIT 1];
            GroupMember gmemToCalendar = new GroupMember();
            gmemToCalendar.GroupId = groupCalendar.Id;
            gmemToCalendar.UserOrGroupId = adminUser.Id;
            insert gmemToCalendar;
            IMH_Chatter_Auto_Follow__c cafCalendar = new IMH_Chatter_Auto_Follow__c();
            cafCalendar.Name = 'CommCreative'+'_'+MARKET_CANADA+'_Calendar';
            cafCalendar.Escalation_Group__c = 'Calendarisation';
            cafCalendar.Object__c = CREATIVE_API;
            cafCalendar.Market__c = MARKET_CANADA;
            cafCalendar.Active__c = true;
            insert cafCalendar;
            */
            //Central Brand
            Group groupCBand = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CentralBrand' LIMIT 1];
            GroupMember gmemToCBand= new GroupMember();
            gmemToCBand.GroupId = groupCBand.Id;
            gmemToCBand.UserOrGroupId = adminUser.Id;
            insert gmemToCBand;
            IMH_Chatter_Auto_Follow__c cafCBand = new IMH_Chatter_Auto_Follow__c();
            cafCBand.Name = 'CommCreative'+'_'+MARKET_CANADA+'Central_Brand';
            cafCBand.Escalation_Group__c = 'Central Brand';
            cafCBand.Object__c = CREATIVE_API;
            cafCBand.Market__c = MARKET_CANADA;
            cafCBand.Active__c = true;
            insert cafCBand;

            //Central Brand
            Group groupCOG = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_CentralOfferGovernance' LIMIT 1];
            GroupMember gmemToCOG= new GroupMember();
            gmemToCOG.GroupId = groupCOG.Id;
            gmemToCOG.UserOrGroupId = adminUser.Id;
            insert gmemToCOG;
            IMH_Chatter_Auto_Follow__c cafCOG = new IMH_Chatter_Auto_Follow__c();
            cafCOG.Name = 'CommCreative'+'_'+MARKET_CANADA+'COG';
            cafCOG.Escalation_Group__c = 'Central Offer Governance';
            cafCOG.Object__c = CREATIVE_API;
            cafCOG.Market__c = MARKET_CANADA;
            cafCOG.Active__c = true;
            insert cafCOG;

            /*//GMS Business
            Group groupGMS = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_GMSBusiness_CA' LIMIT 1];
            GroupMember gmemToGMS = new GroupMember();
            gmemToGMS.GroupId = groupGMS.Id;
            gmemToGMS.UserOrGroupId = adminUser.Id;
            insert gmemToGMS;
            IMH_Chatter_Auto_Follow__c cafGMS = new IMH_Chatter_Auto_Follow__c();
            cafGMS.Name = 'CommCreative'+'_'+MARKET_CANADA+'GMS';
            cafGMS.Escalation_Group__c = 'GMS Business';
            cafGMS.Object__c = CREATIVE_API;
            cafGMS.Market__c = MARKET_CANADA;
            cafGMS.Active__c = true;
            insert cafGMS;
            */
            //Insurance
            Group groupInsurance = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_Insurance_CA' LIMIT 1];
            GroupMember gmemToInsurance = new GroupMember();
            gmemToInsurance.GroupId = groupInsurance.Id;
            gmemToInsurance.UserOrGroupId = adminUser.Id;
            insert gmemToInsurance;
            IMH_Chatter_Auto_Follow__c cafInsurance= new IMH_Chatter_Auto_Follow__c();
            cafInsurance.Name = 'CommCreative'+'_'+MARKET_CANADA+'Ins';
            cafInsurance.Escalation_Group__c = 'Insurance';
            cafInsurance.Object__c = CREATIVE_API;
            cafInsurance.Market__c = MARKET_CANADA;
            cafInsurance.Active__c = true;
            insert cafInsurance;

            /*//Local Brand
            Group groupLB = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_LocalBrand_CA' LIMIT 1];
            GroupMember gmemToLB = new GroupMember();
            gmemToLB.GroupId = groupLB.Id;
            gmemToLB.UserOrGroupId = adminUser.Id;
            insert gmemToLB;
            IMH_Chatter_Auto_Follow__c cafLB = new IMH_Chatter_Auto_Follow__c();
            cafLB.Name = 'CommCreative'+'_'+MARKET_CANADA+'LB';
            cafLB.Escalation_Group__c = 'Local Brand';
            cafLB.Object__c = CREATIVE_API;
            cafLB.Market__c = MARKET_CANADA;
            cafLB.Active__c = true;
            insert cafLB;
            */

            //Local Offer Governance
            Group groupLOG = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_LocalOfferGovernance' LIMIT 1];
            GroupMember gmemToLOG = new GroupMember();
            gmemToLOG.GroupId = groupLOG.Id;
            gmemToLOG.UserOrGroupId = adminUser.Id;
            insert gmemToLOG;
            IMH_Chatter_Auto_Follow__c cafLOG = new IMH_Chatter_Auto_Follow__c();
            cafLOG.Name = 'CommCreative'+'_'+MARKET_CANADA+'LOG';
            cafLOG.Escalation_Group__c = 'Local Offer Governance';
            cafLOG.Object__c = CREATIVE_API;
            cafLOG.Market__c = MARKET_CANADA;
            cafLOG.Active__c = true;
            insert cafLOG;

            //MR Business Owner
            Group groupMRB = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_MRBusinessOwner_CA' LIMIT 1];
            GroupMember gmemToMRB = new GroupMember();
            gmemToMRB.GroupId = groupMRB.Id;
            gmemToMRB.UserOrGroupId = adminUser.Id;
            insert gmemToMRB;
            IMH_Chatter_Auto_Follow__c cafMRB = new IMH_Chatter_Auto_Follow__c();
            cafMRB.Name = 'CommCreative'+'_'+MARKET_CANADA+'MRB';
            cafMRB.Escalation_Group__c = 'MR Business Owner';
            cafMRB.Object__c = CREATIVE_API;
            cafMRB.Market__c = MARKET_CANADA;
            cafMRB.Active__c = true;
            insert cafMRB;

            /*//Operational Risk
            Group groupOpR = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_OperationalRisk_CA' LIMIT 1];
            GroupMember gmemToOpR = new GroupMember();
            gmemToOpR.GroupId = groupOpR.Id;
            gmemToOpR.UserOrGroupId = adminUser.Id;
            insert gmemToOpR;
            IMH_Chatter_Auto_Follow__c cafOpR= new IMH_Chatter_Auto_Follow__c();
            cafOpR.Name = 'CommCreative'+'_'+MARKET_CANADA+'OPR';
            cafOpR.Escalation_Group__c = 'Operational Risk';
            cafOpR.Object__c = CREATIVE_API;
            cafOpR.Market__c = MARKET_CANADA;
            cafOpR.Active__c = true;
            insert cafOpR;
            */

            /*//Public Affairs and Communications
            Group groupPAC = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_PublicAffairsCommunications_CA' LIMIT 1];
            GroupMember gmemToPAC = new GroupMember();
            gmemToPAC.GroupId = groupPAC.Id;
            gmemToPAC.UserOrGroupId = adminUser.Id;
            insert gmemToPAC;
            IMH_Chatter_Auto_Follow__c cafPAC = new IMH_Chatter_Auto_Follow__c();
            cafPAC.Name = 'CommCreative'+'_'+MARKET_CANADA+'PAC';
            cafPAC.Escalation_Group__c = 'Public Affairs and Communications';
            cafPAC.Object__c = CREATIVE_API;
            cafPAC.Market__c = MARKET_CANADA;
            cafPAC.Active__c = true;
            insert cafPAC;
            */
            //TLS/TLB
            Group groupTLS = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_TLSTLB_CA' LIMIT 1];
            GroupMember gmemToTLS = new GroupMember();
            gmemToTLS.GroupId = groupTLS.Id;
            gmemToTLS.UserOrGroupId = adminUser.Id;
            insert gmemToTLS;
            IMH_Chatter_Auto_Follow__c cafTLS = new IMH_Chatter_Auto_Follow__c();
            cafTLS.Name = 'CommCreative'+'_'+MARKET_CANADA+'TLS';
            cafTLS.Escalation_Group__c = 'TLS/TLB';
            cafTLS.Object__c = CREATIVE_API;
            cafTLS.Market__c = MARKET_CANADA;
            cafTLS.Active__c = true;
            insert cafTLS;

            /*//World Service
            Group groupWS = [Select Id, DeveloperName From Group WHERE DeveloperName = 'IMH_WorldServices_CA' LIMIT 1];
            GroupMember gmemToWS = new GroupMember();
            gmemToWS.GroupId = groupWS.Id;
            gmemToWS.UserOrGroupId = adminUser.Id;
            insert gmemToWS;
            IMH_Chatter_Auto_Follow__c cafWS = new IMH_Chatter_Auto_Follow__c();
            cafWS.Name = 'CommCreative'+'_'+MARKET_CANADA+'WS';
            cafWS.Escalation_Group__c = 'World Service';
            cafWS.Object__c = CREATIVE_API;
            cafWS.Market__c = MARKET_CANADA;
            cafWS.Active__c = true;
            insert cafWS;
            */
            //Compliance
            Group groupCompliance = [Select Id, DeveloperName From Group WHERE DeveloperName =: COMPLICANCE_GROUP_CA LIMIT 1];
            GroupMember gmemToCompliance = new GroupMember();
            gmemToCompliance.GroupId = groupCompliance.Id;
            gmemToCompliance.UserOrGroupId = adminUser.Id;
            insert gmemToCompliance;
            IMH_Chatter_Auto_Follow__c cafCompliance = new IMH_Chatter_Auto_Follow__c();
            cafCompliance.Name = 'CommCreative'+'_'+MARKET_CANADA+'_Compliance';
            cafCompliance.Escalation_Group__c = 'Compliance';
            cafCompliance.Object__c = CREATIVE_API;
            cafCompliance.Market__c = MARKET_CANADA;
            cafCompliance.Active__c = true;
            insert cafCompliance;
            //GCO
            Group groupGCO = [Select Id, DeveloperName From Group WHERE DeveloperName =: GCO_GROUP_CA LIMIT 1];
            GroupMember gmemToGCO = new GroupMember();
            gmemToGCO.GroupId = groupGCO.Id;
            gmemToGCO.UserOrGroupId = adminUser.Id;
            insert gmemToGCO;
            IMH_Chatter_Auto_Follow__c cafGCO = new IMH_Chatter_Auto_Follow__c();
            cafGCO.Name = 'CommCreative'+'_'+MARKET_CANADA+'_GCO';
            cafGCO.Escalation_Group__c = 'GCO';
            cafGCO.Object__c = CREATIVE_API;
            cafGCO.Market__c = MARKET_CANADA;
            cafGCO.Active__c = true;
            insert cafGCO;
        }
         Set<Id> creativeIdSet;
        Test.startTest();
        system.runAs(runningUser) { 
            //Test Data for Communication Canada
            IMH_Communication__c communicationRec = new IMH_Communication__c();
            communicationRec = IMH_TestClassUtility.createCommunication(CREATIVE_STAGE,ATTESTATION_STAGE,MARKET_CANADA);
            communicationRec.RequiredApprovers__c = 'Band 40;Calendarisation;Central Brand;Central Offer Governance;Compliance;GCO;GMS Business;Insurance;Local Brand;Local Offer Governance;Local Review Board;MR Business Owner;Operational Risk;Public Affairs and Communications;TLS/TLB;World Service;Leader;CE Governance;Communications';
            insert communicationRec;

            /*//Test Data for Communication ANZ
            IMH_Communication__c communicationRecANZ = new IMH_Communication__c();
            communicationRecANZ = IMH_TestClassUtility.createCommunication(STAGE_NAME,ATTESTATION_STAGE,ANZ_MARKET);
            communicationRecANZ.RequiredApprovers__c = 'Band 40;Calendarisation;Central Brand;Central Offer Governance;Compliance;GCO;GMS Business;Insurance;Local Brand;Local Offer Governance;Local Review Board;MR Business Owner;Operational Risk;Public Affairs and Communications;TLS/TLB;World Service;Leader;CE Governance;Communications';
            communicationRecANZ.ReviewStatus__c = 'In Progress';
            insert communicationRecANZ;
            IMH_Communication__c commRectoSubmit = [SELECT Id, SYS_Ready_For_Review__c FROM IMH_Communication__c 
                                                    WHERE Id=: communicationRecANZ.Id];
            commRectoSubmit.SYS_Ready_For_Review__c = true;
            update commRectoSubmit;

            //Assert
            IMH_Communication__c commRectoAssert = [SELECT Id, ReviewStatus__c FROM IMH_Communication__c 
                                                    WHERE Id=: communicationRecANZ.Id];
            System.assertEquals('In Review',commRectoAssert.ReviewStatus__c);
            */
            //Test Data for Creative
            List<IMH_CommCreative__c> creativeList = new List<IMH_CommCreative__c>();
            for(Integer i=0;i<1;i++) {
                creativeList.add(IMH_TestClassUtility.createFinalCreative(communicationRec.Id,INPROGRESS_STATUS,
                                              IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATE_NAME).Id));
                creativeList[i].CreativeStage__c = CREATIVE_STAGE;
                creativeList[i].SYSCreativeStep__c = COUNTER_1;
            }
            Database.SaveResult[] srListCreative = Database.insert(creativeList,false);
            creativeRecordId1 = srListCreative[0].getId();
            creativeIdSet = new Set<Id>();
            creativeIdSet.add(creativeRecordId1);
            
            //Insert channel record
            List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer i=0;i<1;i++) {
                channelList.add(IMH_TestClassUtility.createChannel(MARKET_CANADA,REGION_LACC,AMEX_TEXT));
                channelList[i].Name=AMEX_TEXT+i;
            }
            channelList[0].RequiredApprovers__c = BRANDANDADVERTISING;
            Database.SaveResult[] srListChannel = Database.insert(channelList,false);
            Id insertedChannelId = srListChannel[0].getId();
            
            //Inserted Targeted Channel
            List<IMH_CreativeChannel__c> targetedChannelList = new List<IMH_CreativeChannel__c>();  
            targetedChannelList.add(IMH_TestClassUtility.createTargetedChannel(creativeRecordId1,insertedChannelId));
            targetedChannelList.add(IMH_TestClassUtility.createTargetedChannel(creativeRecordId2,insertedChannelId));
            Database.SaveResult[] srListtargetedChannel = Database.insert(targetedChannelList,false);
            insertedTargetedChannelId = srListtargetedChannel[0].getId();
            
            //TestData for Product object
            List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<2;i++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_CANADA,true,COLOUR_GOLD));
                prodList[i].Name=PRODUCT_NAME+i;
                prodList[i].Active__c = true;
                prodList[i].CardType__c = 'Lending';
            }   
            prodList[0].CardMemberType__c = 'SBS';
            Database.SaveResult[] productList = Database.insert(prodList,true);
            Id insertedproductId = productList[0].getId();
            
            //TestData for TargetedProduct object
            List<IMH_CreativeProduct__c> targetedProdList = new List<IMH_CreativeProduct__c>();  
            targetedProdList.add(IMH_TestClassUtility.createTargetedProduct(creativeRecordId1,insertedproductId,MARKET_CANADA));
            targetedProdList.add(IMH_TestClassUtility.createTargetedProduct(creativeRecordId2,insertedproductId,MARKET_CANADA));
            Database.SaveResult[] srListtargetedProduct = Database.insert(targetedProdList,false);
            insertedTargetedProductId = srListtargetedProduct[0].getId();
            
            List<IMH_CommCreative__c> creativeSubmitForApprovalList = new List<IMH_CommCreative__c>();
            for(IMH_CommCreative__c cr: [SELECT Id, SequenceNumber__c, SYS_ReadyForReview_New__c FROM IMH_CommCreative__c 
                                         WHERE Id=: creativeIdSet LIMIT 50000]) {
                cr.SYS_ReadyForReview_New__c = true;
                cr.SequenceNumber__c = 1;
                creativeSubmitForApprovalList.add(cr);
            }
            //update creativeSubmitForApprovalList;
        }
        Test.stopTest();
        //Code for assert
        Set<Id> subscribedUserSet = new Set<Id>();
        for(EntitySubscription entitySubRec : [SELECT Id, ParentId, SubscriberId FROM EntitySubscription WHERE 
                                               ParentId =: creativeIdSet LIMIT 50000]){
            subscribedUserSet.add(entitySubRec.SubscriberId);                                           
        }
        if(!subscribedUserSet.isEmpty()){
            for(GroupMember g : [Select UserorGroupId From GroupMember WHERE group.DeveloperName = 'IMH_CentralBrand' LIMIT 50000]) {
                if((g.UserOrGroupID.getsObjectType() == Schema.User.sObjectType) 
                    && (g.UserOrGroupID == adminUser.Id)){
                    System.assertEquals(true, subscribedUserSet.contains(g.UserOrGroupId));
                }
            }
        }
    }
}