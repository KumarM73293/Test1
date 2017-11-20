/**
* @author Accenture IDC 
* @date 07/28/2015
* @group Answer
* @group-content N/A
* @description: iMH Release 1 (Sprint 5) - Test Class for GlobalApplicationUtility which looks for the Execution of button Logic.
*/
@istest
private class IMH_GlobalApplicationUtilityTest {

    private static final String STAGE_NAME                    = 'Concept';
    private static final String CAMPAIGN_CREATIVE_STAGE       = 'Creative';
    private static final String CAMPAIGN_RECALLED_STAGE       = 'Recalled';
    private static final String CREATIVE_API_NAME             = 'IMH_CommCreative__c';
    private static final String CREATE_NAME                   = 'Creative';
    private static final String STATUS_NAME                   = 'In Progress';
    private static final String MARKET_NAME                   = 'Australia';
    private static final String EMPTY_STRING                  = ''; 
    private static final String OFFER_INREVIEW_STATUS         = 'In Review';
    private static final String OFFER_APPROVED_STATUS         = 'Approved';
    private static final String CREATIVE_INREVIEW_STATUS      = 'In Review';
    private static final String CREATIVE_APPROVED_STATUS      = 'Approved';
    private static final String CAMPAIGN_APPROVED_STATUS      = 'Approved';
    private static final String CONFIRM_CREATIVE              = 'Confirm to Creative';
    private static final String CONFIRM_PREEXECUTION          = 'Confirm to PreExecution';
    private static final String CONFIRM_READY_FOR_EXECUTION   = 'Confirm to Ready For Execution';
    private static final String SUCCESS_RESPONSE              = 'success';
    private static final String CAMPAIGN_SUBMITTER_PROFILE    = 'iMH Campaign Submitter';
    private static final String CAMPAIGN_CENTRALSUBMITTER     = 'Marketing User';
    private static final String RUNNING_USER                  = 'RunningUser';
    private static final String CHANNEL_NAME                  = 'Facebook';
    private static final String OTHER_CHANNEL                 = 'Other Channel';
    private static final String CONFIRM_TO_CONCEPT_APPROVAL     = 'Confirm to Concept Approval';
    private static final String BLANKVALIDATIONOFINCENTIVEDATE     = 'Please be advised that one or more Incentive Dates are blank, you will need to update these before you can proceed.';
    private static final String CONFIRM_TO_CREATVE_COMPLETE     = 'Confirm to Creative Complete';
    private static final String REVIEW_AND_APPROVAL             = 'Creative in Review';
     private static final String PRODUCT_NAME                = 'ProdTest';
    
    
           /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    *               Concept Design to Concept Approval
    * @param: none
    * @return: void
    */
    static testMethod void nextStageConceptDesignApproval() {
        String responseReturned = EMPTY_STRING;

        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser) {
            Test.startTest();            
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
            lcommunication.ReviewStage__c = 'Design';
            Database.insert(lcommunication,false);
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, false,'');
            //Assert to Check whether the response returned is "Confirm to Concept Approval".    
            system.assertEquals(CONFIRM_TO_CONCEPT_APPROVAL, responseReturned);
            String updateResponseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, true,lcommunication.ProcessStage__c);
            system.assertEquals(SUCCESS_RESPONSE, updateResponseReturned);
            Test.stopTest();  
        }
    }
   
  /*****************************************************************************
    * @description: Method used for covering the case when We Click on Next Step Button.
    * @param: none
    * @return: void
    */
   static testMethod void ReadyForNextStageCreativeDesign() {
        String responseReturned = EMPTY_STRING;
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            Test.startTest();   
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
            lcommunication.ProcessStage__c = 'Creative';
            lcommunication.ReviewStage__c = 'Design';
            lcommunication.ReviewStatus__c = 'In Progress';
            Database.insert(lcommunication,false);
            
            
         //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<1;i++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_NAME,true,'Gold'));
                prodList[i].Name=PRODUCT_NAME+i;
                prodList[i].RequiredApprovers__c = 'Lending';
            } 
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer i=0;i<1;i++) {
                channelList.add(IMH_TestClassUtility.createChannel(MARKET_NAME,'JAPA','AMEX'));
                channelList[i].Name='AMEX'+i;
            }
            channelList[0].RequiredApprovers__c = 'Brand and Advertising';
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer i=0;i<1;i++){
                  lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication.ID,prodList[0].Id,MARKET_NAME));
             }
             
          
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<1;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication.ID,channelList[0].Id));
        }
        Database.insert(lCommtargetedChannel,true);
            
            
            
            
            
            //TestData for Creative Object 
            IMH_CommCreative__c lcreative = new IMH_CommCreative__c();
            lcreative = IMH_TestClassUtility.createFinalCreative(lcommunication.ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            //lcreative.SYSOpenAnswerSets__c = 0;
            Database.insert(lcreative,false);
            
            System.debug('<<<Communication>>>>'+lcommunication);
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, false,lcommunication.ProcessStage__c);
            //Assert to Check whether the response returned is "Creative(s) still pending approval. Please ensure all Creatives have been approved before proceeding to the Pre-Execution Testing stage".    
            system.assertEquals('Creative(s) still pending approval. Please ensure all Creatives have been approved before proceeding to the Pre-Execution Testing stage', responseReturned);
            String responseUpdateReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, true,lcommunication.ProcessStage__c);
            system.assertEquals(SUCCESS_RESPONSE, responseUpdateReturned);          
            Test.stopTest(); 
        }
    } 
    /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
    */
   static testMethod void readyForNextStageCompleted() {
       String responseReturned = EMPTY_STRING;

       //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            Test.startTest();            
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
            lcommunication.ProcessStage__c = 'Creative';
            lcommunication.ReviewStage__c = 'Review & Approval';
            Database.insert(lcommunication,false);
        
            //TestData for Creative Object 
            IMH_CommCreative__c lcreative = new IMH_CommCreative__c();
            lcreative = IMH_TestClassUtility.createFinalCreative(lcommunication.ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            lcreative.SYSOpenAnswerSets__c = 0;       
            Database.insert(lcreative,false);
                
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, false,'');
            //Assert to Check whether the response returned is "Success".    
            String responseUpdateReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, true,lcommunication.ProcessStage__c);
            system.assertEquals(SUCCESS_RESPONSE, responseUpdateReturned);      
        Test.stopTest();  
        }  
   }
   
       /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
    */
   static testMethod void readyForNextStagePreExecution() {
       String responseReturned = EMPTY_STRING;

       //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            Test.startTest();            
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
            lcommunication.ProcessStage__c = 'Pre-Execution Testing';
            lcommunication.ReviewStage__c = 'Design';
            lcommunication.ReviewStatus__c = 'In Progress';
            lcommunication.SYSOpenAnswerSets__c = 0;
            Database.insert(lcommunication,false);
        
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, false,'');
            //Assert to Check whether the response returned is "Confirm to Ready For Execution".    
            system.assertEquals('Confirm to Ready For Execution', responseReturned);
            String responseUpdateReady = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, true,lcommunication.ProcessStage__c);
            system.assertEquals(SUCCESS_RESPONSE, responseUpdateReady); 
       Test.stopTest();  
        }
   }
    
    
 /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
    */
   static testMethod void readyForNextStagePostExecution() {
       String responseReturned = EMPTY_STRING;

       //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            Test.startTest();            
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,'Canada');
            lcommunication.ProcessStage__c = 'Ready for Execution';
            lcommunication.ReviewStage__c = 'Complete';
            lcommunication.ReviewStatus__c = 'Approved';
            lcommunication.SYSOpenAnswerSetsForReadyForExecution__c = 0;
            Database.insert(lcommunication,false);
        
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, false,'');
            //Assert to Check whether the response returned is "Confirm to Ready For Execution".    
            system.assertEquals('Confirm to Post Execution', responseReturned);
            String responseUpdateReady = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, true,lcommunication.ProcessStage__c);
            system.assertEquals(SUCCESS_RESPONSE, responseUpdateReady); 
       Test.stopTest();  
        }
   }
 /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
    */
   static testMethod void ReadyForNextStageCreativeDesignWithoutProduct() {
        String responseReturned = EMPTY_STRING;
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            Test.startTest();   
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
            lcommunication.ProcessStage__c = 'Creative';
            lcommunication.ReviewStage__c = 'Design';
            lcommunication.ReviewStatus__c = 'In Progress';
            Database.insert(lcommunication,false);
            //Database.update(lcommunication,false);            
            
            
            
             //                                 //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<1;i++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_NAME,true,'Gold'));
                prodList[i].Name=PRODUCT_NAME+i;
                prodList[i].RequiredApprovers__c = 'Lending';
            } 
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer i=0;i<1;i++) {
                channelList.add(IMH_TestClassUtility.createChannel(MARKET_NAME,'JAPA','AMEX'));
                channelList[i].Name='AMEX'+i;
            }
            channelList[0].RequiredApprovers__c = 'Brand and Advertising';
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer i=0;i<1;i++){
                  lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication.ID,prodList[0].Id,MARKET_NAME));
             }
             
          
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<1;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication.ID,channelList[0].Id));
        }
        Database.insert(lCommtargetedChannel,true);
            
            //TestData for Creative Object 
            IMH_CommCreative__c lcreative = new IMH_CommCreative__c();
            lcreative = IMH_TestClassUtility.createFinalCreative(lcommunication.ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            //lcreative.SYSOpenAnswerSets__c = 0;
            Database.insert(lcreative,false);
            
             List<IMH_CreativeProduct__c> lproducts = [SELECT Id FROM IMH_CreativeProduct__c WHERE Creative__c =:lcreative.Id LIMIT 50000];
           
            Database.delete(lproducts,false);
            
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, false,'');
            //Assert to Check whether the response returned is "You have not yet added a Targeted Product. You will need to do this before submitting for approval.".    
            system.assertEquals(Label.IMH_AlertIfNoTargetedProducts, responseReturned);
            Test.stopTest(); 
        }
    }   
    
 /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
    */
   static testMethod void ReadyForNextStageCreativeDesignWithoutCreative() {
        String responseReturned = EMPTY_STRING;
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            Test.startTest();   
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
            lcommunication.ProcessStage__c = 'Creative';
            lcommunication.ReviewStage__c = 'Design';
            lcommunication.ReviewStatus__c = 'In Progress';
            Database.insert(lcommunication,false);
            //Database.update(lcommunication,false);
            //
            //            
            //                                 //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<1;i++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_NAME,true,'Gold'));
                prodList[i].Name=PRODUCT_NAME+i;
                prodList[i].RequiredApprovers__c = 'Lending';
            } 
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer i=0;i<1;i++) {
                channelList.add(IMH_TestClassUtility.createChannel(MARKET_NAME,'JAPA','AMEX'));
                channelList[i].Name='AMEX'+i;
            }
            channelList[0].RequiredApprovers__c = 'Brand and Advertising';
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer i=0;i<1;i++){
                  lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication.ID,prodList[0].Id,MARKET_NAME));
             }
             
          
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<1;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication.ID,channelList[0].Id));
        }
        Database.insert(lCommtargetedChannel,true);
                        
        
            //TestData for Creative Object 
            IMH_CommCreative__c lcreative = new IMH_CommCreative__c();
            lcreative = IMH_TestClassUtility.createFinalCreative(lcommunication.ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            Database.insert(lcreative,false);
            
            List<IMH_CreativeChannel__c> lchannels = [SELECT Id FROM IMH_CreativeChannel__c WHERE Creative__c =:lcreative.Id LIMIT 50000];
           
            Database.delete(lchannels,false);
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, false,'');
            //Assert to Check whether the response returned is "You have not yet added a Targeted Product. You will need to do this before submitting for approval.".    
            system.assertEquals(Label.IMH_AlertIfNoChannel, responseReturned);
            Test.stopTest(); 
        }
    }

       /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
    */
   static testMethod void readyForNextStageCancelled() {
       String responseReturned = EMPTY_STRING;

       //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            Test.startTest();            
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
            lcommunication.ProcessStage__c = 'Pre-Execution Testing';
            lcommunication.ReviewStage__c = 'Design';
            lcommunication.ReviewStatus__c = 'Cancelled';
            lcommunication.CommunicationCancellationReason__c = 'Submission made in error';
            Database.insert(lcommunication,false);
        
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, false,'');
        Test.stopTest();  
        }
   }

    /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
    */
   static testMethod void readyForNextStageWithInSufficientPrivelage() {
       String responseReturned = EMPTY_STRING;

       //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('Standard User',RUNNING_USER,null);     
         system.runAs(runningUser){       
       //TestData for Campaign Object
        IMH_Communication__c lcommunication = new IMH_Communication__c();
        
        lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        
        Database.insert(lcommunication,false);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     

         Test.startTest(); 
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.id, false,'');
            //Assert to Check whether the response returned is "There are no offers created for this campaign".    
            
         Test.stopTest();    
        }
      
   }
    /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
   */ 
   static testMethod void Recall() { 
    String responseReturned = EMPTY_STRING;
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
         Test.startTest();      
       //TestData for Campaign Object
        IMH_Communication__c lcommunication = new IMH_Communication__c();
        
        lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
       
        Database.insert(lcommunication,false);
        
        lcommunication.ProcessStage__c = CAMPAIGN_CREATIVE_STAGE;
        lcommunication.ReviewStatus__c= CAMPAIGN_RECALLED_STAGE;
        lcommunication.LifecycleStage__c = 'Plan';   
       
        Database.update(lcommunication,false);
        responseReturned = IMH_GlobalApplicationUtility.updateCampaignOnRecall(lcommunication.Id);
        Test.stopTest();    
        }
        //Assert to Check whether the response returned is success.
        system.assertEquals(SUCCESS_RESPONSE, responseReturned);
   }
        /*****************************************************************************
    * @description: Method used for covering the case when We Click on Back To Previous Stage button.
    * @param: none
    * @return: void
    */
   static testMethod void recallLocalcommunication() { 
    String responseReturned = EMPTY_STRING;
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
         Test.startTest();      
       //TestData for Campaign Object
        IMH_Communication__c lcommunication = new IMH_Communication__c();
        
        lcommunication = IMH_TestClassUtility.createCommunication(CAMPAIGN_CREATIVE_STAGE,STATUS_NAME,MARKET_NAME);
        lcommunication.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketingCommunication_Creative').Id;
        Database.insert(lcommunication,false);
        
        lcommunication.ProcessStage__c = 'Pre-Execution Testing';
        lcommunication.ReviewStatus__c= STATUS_NAME;
         lcommunication.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketingCommunication_PreExecution').Id;    
        lcommunication.LifecycleStage__c = IMH_UtilityConstants.CAMPAIGN_LIFECYCLE_PLAN_STAGE;
        lcommunication.SYSReinitiateRecallCheck__c= true;          
        Database.update(lcommunication,false);
        responseReturned = IMH_GlobalApplicationUtility.updateCampaignOnRecall(lcommunication.Id);
        Test.stopTest();    
        }
        //Assert to Check whether the response returned is success.
        system.assertEquals(SUCCESS_RESPONSE, responseReturned);
   }
       /*****************************************************************************
    * @description: Method used for covering the negative case when Reviewer Click on Back To Previous Stage button.
    * @param: none
    * @return: void
    */
   static testMethod void recallLocalcommunicationreviewer() { 
    String responseReturned = EMPTY_STRING;
    String responseReturned1 = EMPTY_STRING;
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_CENTRALSUBMITTER,RUNNING_USER,null);
       insert runningUser;
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
         Test.startTest();      
       //TestData for Campaign Object
        IMH_Communication__c lcommunication = new IMH_Communication__c();
        
         lcommunication = IMH_TestClassUtility.createCommunication(CAMPAIGN_CREATIVE_STAGE,STATUS_NAME,MARKET_NAME);
        lcommunication.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketingCommunication_Creative').Id;
        Database.insert(lcommunication,false);
        
        lcommunication.ProcessStage__c = 'Pre-Execution Testing';
        lcommunication.ReviewStatus__c= STATUS_NAME;
         lcommunication.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketingCommunication_PreExecution').Id;    
        lcommunication.LifecycleStage__c = IMH_UtilityConstants.CAMPAIGN_LIFECYCLE_PLAN_STAGE;
       
        Database.update(lcommunication,false);
        responseReturned = IMH_GlobalApplicationUtility.updateCampaignOnRecall(lcommunication.Id);  
        Test.stopTest();    
        }
        //Assert to Check whether the response returned is success.
        system.assertEquals('success', responseReturned);
   }
    /*****************************************************************************
    * @description: Method used for covering the case when We Click on ReinitiateCreativeProcess Button.
    * @param: none
    * @return: void
*/
   static testMethod void ReinitiateCreativeProcess() { 
     String responseReturned = EMPTY_STRING;
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
          Test.startTest();    
       //TestData for Campaign Object
        IMH_Communication__c lcommunication = new IMH_Communication__c();
        
        lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        
        Database.insert(lcommunication,false);
        
        lcommunication.ProcessStage__c = CAMPAIGN_CREATIVE_STAGE;
        lcommunication.ReviewStatus__c= STATUS_NAME;
        lcommunication.LifecycleStage__c = IMH_UtilityConstants.CAMPAIGN_LIFECYCLE_STAGE;
       
        Database.update(lcommunication,false);
        responseReturned = IMH_GlobalApplicationUtility.updateCampaignOnReInitiate(lcommunication.Id);
           Test.stopTest();    
        }
        //Assert to Check whether the response returned is success.
        system.assertEquals(SUCCESS_RESPONSE, responseReturned);
   } 
    
    /*****************************************************************************
    * @description: Method used for covering the case when We Click on submitForApproval Button On Communication.
    * @param: none
    * @return: void
    */
    static testMethod void submitForApprovalOnCommunication() { 
        String responseReturned = EMPTY_STRING;
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
        Test.startTest();   
        //Test data for Campaign Object  
        IMH_Communication__c lcommunication = new IMH_Communication__c();
        lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(lcommunication,false);     
       
        responseReturned = IMH_GlobalApplicationUtility.submitForApproval(lcommunication.Id,1);
        Test.stopTest();    
        }
        //Assert to Check whether the response returned is success. 
        system.assertEquals(SUCCESS_RESPONSE, responseReturned); 
    }
     
    /*****************************************************************************
    * @description: Method used for covering the case when We Click on submitForApproval Button On Creative.
    * @param: none
    * @return: void
    */
    static testMethod void submitForApprovalOnCreative() { 
        String responseReturned = EMPTY_STRING;
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
        Test.startTest();   
        //Test data for Campaign Object  
        IMH_Communication__c lcommunication = new IMH_Communication__c();
        lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(lcommunication,false);     
       
        //Test data for Creative Object 
        IMH_CommCreative__c lcreative = new IMH_CommCreative__c();
        lcreative = IMH_TestClassUtility.createFinalCreative(lcommunication.ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
        lcreative.SYSOpenAnswerSets__c= 0;
        Database.insert(lcreative,false);  
        
        responseReturned = IMH_GlobalApplicationUtility.submitForApproval(lcreative.Id,1);
        Test.stopTest();    
        }
        //Assert to Check whether the response returned is success. 
        system.assertEquals(SUCCESS_RESPONSE, responseReturned); 
    }
    
    /*****************************************************************************
    * @description: Method used for covering the case when We Click on submitForApproval Button On Benefit.
    * @param: none
    * @return: void
    */
    static testMethod void submitForApprovalOnBenefit() { 
        String responseReturned = EMPTY_STRING;
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
        Test.startTest();   
        //Test data for Benefit Object  
        IMH_Benefits__c lbenefits = new IMH_Benefits__c();
        lbenefits = IMH_TestClassUtility.createBenefits('Local','ONE India','ONE India');
        Database.insert(lbenefits,false);     
        
        responseReturned = IMH_GlobalApplicationUtility.submitForApproval(lbenefits.Id,1);
        Test.stopTest();    
        }
        //Assert to Check whether the response returned is success. 
        system.assertEquals(SUCCESS_RESPONSE, responseReturned); 
    }
    /*****************************************************************************
    * @description: Method used for covering the negative case when We Click on recall Button.
    * @param: none
    * @return: void
    */
    static testMethod void recallWithInSufficientPrivelage() {
       String responseReturned = EMPTY_STRING;
        
       //TestData for Campaign Object
        IMH_Communication__c lcommunication = new IMH_Communication__c();
        
        lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        
        Database.insert(lcommunication,false);
       //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('Standard User',RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
         Test.startTest(); 
            responseReturned = IMH_GlobalApplicationUtility.updateCampaignOnRecall(lcommunication.Id);
         
         Test.stopTest();    
        }
        
   }
   
   /*****************************************************************************
    * @description: Method used for covering the case when We Click on ReinitiateCreativeProcess Button.
    * @param: none
    * @return: void
   */ 
   static testMethod void reInitiateWithInSufficientPrivelage() {
       String responseReturned = EMPTY_STRING;
        
       //TestData for Campaign Object
        IMH_Communication__c lcommunication = new IMH_Communication__c();
        
        lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        
        Database.insert(lcommunication,false);
       //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser('Standard User',RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
         Test.startTest(); 
            responseReturned = IMH_GlobalApplicationUtility.updateCampaignOnReInitiate(lcommunication.Id);
         Test.stopTest();    
        }       
   }   
        
    /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
    */
   static testMethod void ReadyForNextStageCreativeDesignWithoutCreativeExp() {
        String responseReturned = EMPTY_STRING;
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            Test.startTest();   
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
            lcommunication.ProcessStage__c = 'Creative';
            lcommunication.ReviewStage__c = 'Design';
            lcommunication.ReviewStatus__c = 'In Progress';
            Database.insert(lcommunication,false);
            //Database.update(lcommunication,false);            
        
            //TestData for Creative Object 
            IMH_CommCreative__c lcreative = new IMH_CommCreative__c();
            lcreative = IMH_TestClassUtility.createFinalCreative(lcommunication.ID,'Expired',IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            //lcreative.SYSOpenAnswerSets__c = 0;
            Database.insert(lcreative,false);
            
            IMH_CommCreative__c lcreative1 = new IMH_CommCreative__c();
            lcreative = IMH_TestClassUtility.createFinalCreative(lcommunication.ID,'Cancelled',IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
            //lcreative.SYSOpenAnswerSets__c = 0;
            Database.insert(lcreative1,false);          

            Test.stopTest(); 
        }
    }

    /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
   */ 
   static testMethod void readyForNextStageAttesstation() {
       String responseReturned = EMPTY_STRING;

       //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            Test.startTest();            
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
            lcommunication.ProcessStage__c = 'CREATIVE';
            lcommunication.ReviewStage__c = 'Attestation';
            lcommunication.ReviewStatus__c = 'In Progress';
            lcommunication.SYSOpenAnswerSets__c = 0;
            Database.insert(lcommunication,false);
        
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, false,'');
        Test.stopTest();  
        }
   }    
   
       /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
    */
   static testMethod void readyForNextStageReviewApproval() {
       String responseReturned = EMPTY_STRING;

       //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            Test.startTest();            
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
            lcommunication.ProcessStage__c = CAMPAIGN_CREATIVE_STAGE;
            lcommunication.ReviewStage__c = REVIEW_AND_APPROVAL;
            lcommunication.ReviewStatus__c = 'In Progress';
            lcommunication.SYSOpenAnswerSets__c = 0;
            Database.insert(lcommunication,false);
        
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, false,'');
            //Assert to Check whether the response returned is "Confirm to Ready For Execution".    
            system.assertEquals(Label.IMH_CreativeUnderReview, responseReturned);
        Test.stopTest();  
        }
   }   
   
          /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
    */
   static testMethod void readyForNextStageConceptRej() {
       String responseReturned = EMPTY_STRING;

       //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            Test.startTest();            
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
            lcommunication.ProcessStage__c = 'CONCEPT';
            lcommunication.ReviewStage__c = 'Design';
            lcommunication.ReviewStatus__c = 'In Progress (Following Rejection)';
            lcommunication.SYSOpenAnswerSets__c = 0;
            Database.insert(lcommunication,false);
        
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, false,'');
        Test.stopTest();  
        }
   }  
          /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
    */
   static testMethod void readyForNextStageConceptRecalled() {
       String responseReturned = EMPTY_STRING;

       //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            Test.startTest();            
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
            lcommunication.ProcessStage__c = 'CONCEPT';
            lcommunication.ReviewStage__c = 'Design';
            lcommunication.ReviewStatus__c = 'Recalled';
            lcommunication.SYSOpenAnswerSets__c = 0;
            Database.insert(lcommunication,false);
        
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, false,'');
        Test.stopTest();  
        }
   }    
   
       /*****************************************************************************
    * @description: Method used for covering the case when We Click on Ready For Next Stage Button.
    * @param: none
    * @return: void
    */
   static testMethod void readyForNextStagePreExecutionSkip() {
       String responseReturned = EMPTY_STRING;

       //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){
            Test.startTest();            
            //TestData for Campaign Object
            IMH_Communication__c lcommunication = new IMH_Communication__c();
            lcommunication = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
            lcommunication.ProcessStage__c = 'Pre-Execution Testing';
            lcommunication.ReviewStage__c = 'Attestation';
            lcommunication.ReviewStatus__c = 'In Progress';
            lcommunication.SYSOpenAnswerSets__c = 0;
            Database.insert(lcommunication,false);
        
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, false,'');
            responseReturned = IMH_GlobalApplicationUtility.updateCampaignOnReInitiate(lcommunication.Id);
            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication.Id, true,'Skip_Creative');         
            Test.stopTest();  
        }
   }
    
    
    
     /*****************************************************************************
    * @description: Method for concept approval (One Step Concurrent)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve
    * @param: none
    * @return: void
    */
    static testMethod void ConceptSimpleOneStepConcurrent() {
         String responseReturned = EMPTY_STRING;
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
            // Insert Approval Matrix
            List<IMH_ApprovalGroup__c> lApprovalgrp = new List <IMH_ApprovalGroup__c>();
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance','Central Offer Governance'));
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand','Central Brand'));
            insert lApprovalgrp;
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Offer Governance',
                                                                            'Thailand',
                                                                            'JAPA',
                                                                            24,
                                                                            'STANDARD',
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            'Incentivised Offer', 
                                                                            'Central Offer Governance', 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            lApprovalgrp[0].ID));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Central Brand',
                                                                            'Thailand',
                                                                            'JAPA',
                                                                            24,
                                                                             'STANDARD',
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralBrand',
                                                                            1,
                                                                            'Incentivised Offer', 
                                                                            'Central Brand', 
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
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication( 'Concept','In Progress', 'Thailand'));
                lcommunication[i].RequiredApprovers__c = 'Central Offer Governance;Central Brand';
                lcommunication[i].Communication_Type__c = 'Incentivised Offer';
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress',lcommunication[0].Id));
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
            System.assertEquals(lApptrack.size(),2);
            System.assertEquals(lApptrack[0].Status__c,'Pending');            
            System.assertEquals(lApptrack[1].Status__c,'Pending');            
           // System.assertEquals(lApptrack[0].Owner__c,'Central Offer Governance');            
            //System.assertEquals(lApptrack[1].Owner__c,'Central Brand');  
            responseReturned=IMH_GlobalApplicationUtility.recallApprovalProcess(lcommunication[0].Id);                
        }
        Test.stopTest();
           lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:lcommunication[0].Id
                          LIMIT 50000];
            System.assertEquals(lApptrack[0].Status__c,'Recalled (Submitter)');
            System.assertEquals(lApptrack[1].Status__c,'Recalled (Submitter)');
            System.assertEquals(responseReturned, 'success');
            List<IMH_Communication__c>  commList = new List<IMH_Communication__c>();
            commList = [SELECT Id,ProcessStage__c FROM IMH_Communication__c WHERE Id =: insertedCommunicationId LIMIT 1];
            System.assertEquals('Concept',commList[0].ProcessStage__c);
    }
    /*****************************************************************************
    * @description: Negative Method for concept approval (One Step Concurrent)
    *               1. Central Offer Governance Approval - Approve
    *               2. Central Brand Approval - Approve where an exception occurs and error is thrown
    * @param: none
    * @return: void
    */ 
    static testMethod void NegativeSimpleOneStepConcurrent() {
         String responseReturned = EMPTY_STRING;
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
             List<IMH_ApprovalGroup__c> lApprovalgrp = new List <IMH_ApprovalGroup__c>();
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralOfferGovernance','Central Offer Governance'));
             lApprovalgrp.add(IMH_TestClassUtility.createApprovalGroup('IMH_CentralBrand','Central Brand'));
            insert lApprovalgrp;
            // Insert Approval Matrix
            List<IMH_StepApprovalGroup__c> lApprovalmat = new List <IMH_StepApprovalGroup__c>();
            for(Integer i=0;i<1;i++) {
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Offer Governance',
                                                                            'Thailand',
                                                                            'JAPA',
                                                                            24,
                                                                            'STANDARD',
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralOfferGovernance',
                                                                            1,
                                                                            'Incentivised Offer', 
                                                                            'Central Offer Governance', 
                                                                            'Communication',
                                                                            'Communication__c',
                                                                            'IMH',
                                                                            false,
                                                                            lApprovalgrp[0].ID));
                lApprovalmat.add(IMH_TestClassUtility.createApprovalMatrix('Central Brand',
                                                                            'Thailand',
                                                                            'JAPA',
                                                                            24,
                                                                             'STANDARD',
                                                                            IMH_TestClassUtility.mRecordType.get('IMH_StepApprovalGroup__c').get('Approval').Id,
                                                                            'IMH_CentralBrand',
                                                                            1,
                                                                            'Incentivised Offer', 
                                                                            'Central Brand', 
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
        system.runAs(runningUserSubmitter) { 
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication( 'Concept','In Progress', 'Thailand'));
                lcommunication[i].RequiredApprovers__c = 'Central Offer Governance;Central Brand';
                lcommunication[i].Communication_Type__c = 'Incentivised Offer';
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();       
            
            // INSERT INCENTIVE
            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress',lcommunication[0].Id));
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
            System.assertEquals(lApptrack.size(),2);
            System.assertEquals(lApptrack[0].Status__c,'Pending');            
            System.assertEquals(lApptrack[1].Status__c,'Pending');            
           // System.assertEquals(lApptrack[0].Owner__c,'Central Offer Governance');            
            //System.assertEquals(lApptrack[1].Owner__c,'Central Brand');  
                      
        }

           responseReturned=IMH_GlobalApplicationUtility.recallApprovalProcess(null);   
            //System.debug('___3333 Tracker___::'+lApptrack);
            //System.debug('___3333 TrackerSIZE___::'+lApptrack.size());
            //lApptrack[0].Status__c = 'Approved';
           // update lApptrack;
             
        //}
        Test.stopTest();
           lApptrack = [Select Id, Communication__c, Status__c, OwnerId, Approval_Group__c
                          FROM IMH_SLATracker__c WHERE Communication__c =:lcommunication[0].Id
                          LIMIT 50000];
            System.assertNotEquals(lApptrack[0].Status__c,'Recalled (Submitter)');
            System.assertNotEquals(lApptrack[1].Status__c,'Recalled (Submitter)');
            System.assertEquals(responseReturned, System.Label.IMH_AlertOnDobleClick);
            List<IMH_Communication__c>  commList = new List<IMH_Communication__c>();
            commList = [SELECT Id,ProcessStage__c FROM IMH_Communication__c WHERE Id =: insertedCommunicationId LIMIT 1];
            System.assertEquals('Concept',commList[0].ProcessStage__c);
    }  

           /*****************************************************************************
    * @description: Method used for covering the case for incentive Start date and End date.
    * @param: none
    * @return: void
    */
    static testMethod void CommunicationIncentive() {
        String responseReturned = EMPTY_STRING;

        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
        //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE 
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId;            
        system.runAs(runningUser) {
            Test.startTest();     
            //Insert Communication
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication( 'Concept','In Progress', 'Thailand'));
                lcommunication[i].RequiredApprovers__c = 'Central Offer Governance;Central Brand';
                lcommunication[i].Communication_Type__c = 'Incentivised Offer';
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();  

            List<IMH_Incentive__c> imhIncentiveList = new List<IMH_Incentive__c>();
            for(Integer i=0; i<1; i++) {
                imhIncentiveList.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id, 'In Progress',lcommunication[0].Id));
                imhIncentiveList[i].IncentiveType__c = 'Incentive';
                imhIncentiveList[i].StartDate__c = NULL;
                imhIncentiveList[i].EndDate__c = NULL;
            }
            IMH_IncentiveTriggerHandler.isExecutedAfter = false;
            Database.insert(imhIncentiveList,false);             

            responseReturned = IMH_GlobalApplicationUtility.moveNextStep(lcommunication[0].Id, false,'');
            //Assert to Check whether the response returned is "BLANKVALIDATIONOFINCENTIVEDATE".    
            system.assertEquals(BLANKVALIDATIONOFINCENTIVEDATE, responseReturned);
            Test.stopTest();  
        }
    } 
}