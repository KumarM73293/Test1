/**
* @author Accenture IDC 
* @date 06/29/2015
* @group Answer
* @group-content N/A
* @description: iMH Release 1 (Sprint 1) - Test Class for Trigger on Creative object which looks for the after insert and after update event 
* logic has been triggered on particular event of an object.
*/
@isTest
private class IMH_CommCreativeTriggerTest {
    private static final String STATUS_NAME = 'In Progress';
    private static Final String CREATE_NAME = 'CreativeDesign';
    private static final String STAGE_NAME = 'Concept';
    private static final String MARKET_NAME = 'Thailand';  
    private static final String NEW_STATUS = 'In Review';
     private static final String CONCEPT_STAGE               = 'Concept';
      private static final String INCENTIVISED_OFFER          = 'Incentivised Offer';
      private static final String PRODUCT_NAME                = 'ProdTest';
    
    private static final String CAMPAIGN_SUBMITTER_PROFILE = 'iMH Campaign Submitter';
    private static final String RUNNING_USER = 'RunningUser';
    /*****************************************************************************
    * @description: Method used for covering the case when we have the Question Set And Creative
    *               and the Answer Set gets created.
    * @param: none
    * @return: void
    */
    static testMethod void creativeTriggerTestMethod() {
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
            lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_Communication__c','TargetMarket__c',MARKET_NAME));   
            lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_CommCreative__c','IMH_RequiredProductOwnerEngagement__c','Lending'));
            
            insert lentrycriteria;    
        
            List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<10;i++)
            {
                lcommunication.add(IMH_TestClassUtility.createCampaign(STAGE_NAME,STATUS_NAME,MARKET_NAME));
            }
            Database.insert(lcommunication,false);
            
            Test.startTest();        
            List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
            for(Integer i=0;i<10;i++)
            {
                
                lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[i].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
                lcreative[i].IMH_RequiredProductOwnerEngagement__c = 'Lending';
            }
            Database.insert(lcreative,false);
            
            
            SET<ID> imhOffList = new SET<ID>();        
            for(IMH_CommCreative__c imh: lcreative){
                imh.CreativeStatus__c = 'Approved';
                imhOffList.add(imh.ID);
            }
            Database.update(lcreative,false);
          
            Test.stopTest();
            
        }
        
    }
       /*****************************************************************************
    * @description: Method used for covering the negative case when we have the Question Set has different status
    *               the Answer Set doesn't gets created for Creative.
    * @param: none
    * @return: void
    */
    static testMethod void negCrreativeTriggerTestMethod() {
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
            Database.insert(lquestionset,false);
            //Entry Criteria Logics
            List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
            lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_Communication__c','TargetMarket__c',MARKET_NAME));   
            lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_CommCreative__c','IMH_RequiredProductOwnerEngagement__c','SBS'));
            
            insert lentrycriteria; 
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<10;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCampaign(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert(lcommunication,false);
        
        Test.startTest();        
         List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<10;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[i].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
            lcreative[i].IMH_RequiredProductOwnerEngagement__c = 'Lending';
        }
        Database.insert(lcreative,false);
        
        Test.stopTest();
       
        }
    }
    /*****************************************************************************
    * @description: Method used for covering the case when we have the Question Set and Creative is Present
    *               the Answer Set  gets created for Creative ,but doesn't create it for twice if we come back to same status
    * @param: none
    * @return: void
    */
    static testMethod void creativeRepTriggerTestMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
        List<IMH_AnswerSet__c> lansset = new List<IMH_AnswerSet__c>();
          //TestData for QuestionSet Object
            List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
            for(Integer i=0; i<1; i++)
            {
                lquestionset.add(IMH_TestClassUtility.createQuestionSet(CREATE_NAME));
            }
            Database.insert(lquestionset,false);
            //Entry Criteria Logics
            List<IMH_EntryCriteria__c> lentrycriteria = new List<IMH_EntryCriteria__c>();
            lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_Communication__c','TargetMarket__c',MARKET_NAME));   
            lentrycriteria.add(IMH_TestClassUtility.createEntryCriteria(lquestionset[0].Id,'IMH_CommCreative__c','IMH_RequiredProductOwnerEngagement__c','SBS'));
            
            insert lentrycriteria; 
        
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<10;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCampaign(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert(lcommunication,false);
        
        Test.startTest();        
         List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<10;i++)
        {
            
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[i].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
            lcreative[i].IMH_RequiredProductOwnerEngagement__c = 'SBS';
        }
        Database.insert(lcreative,false);
        
        List<IMH_CommCreative__c> lsubcreate = new List<IMH_CommCreative__c>();
         for(IMH_CommCreative__c create:[SELECT Id,
                                  CreativeStatus__c,
                                 RequiredApprovers__c
                           FROM IMH_CommCreative__c
                           WHERE ID IN:lcreative
                             LIMIT 50000])
         {
             create.CreativeStatus__c = NEW_STATUS;
             lsubcreate.add(create);
         }
         Database.update(lsubcreate,false);
        
         
            
        List<IMH_CommCreative__c> lfinalcreate  = new List<IMH_CommCreative__c>();
        for(IMH_CommCreative__c create:[SELECT Id,
                                  CreativeStatus__c,
                                 RequiredApprovers__c
                           FROM IMH_CommCreative__c
                           WHERE ID IN:lcreative
                           LIMIT 50000])
         {
             create.CreativeStatus__c = STATUS_NAME;
             lfinalcreate.add(create);
         }
        Database.update(lfinalcreate,false);
        
       
        Test.stopTest();
       
        }
         
    }
     /*****************************************************************************
    * @description: Method used for covering the case when we don't have the Question Set and Creative is Present
    *               the Answer Set  doesn.t gets created for Creative 
    * @param: none
    * @return: void
    */
    static testMethod void noQuestionTriggerTestMethod() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
        List<IMH_AnswerSet__c> lansset = new List<IMH_AnswerSet__c>();

        
        List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
        for(Integer i=0;i<10;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCampaign(STAGE_NAME,STATUS_NAME,MARKET_NAME));
        }
        Database.insert(lcommunication,false);
        
        Test.startTest();        
         List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();

        for(Integer i=0;i<10;i++)
        {
            
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[i].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,false);
        
        Test.stopTest();
              
    }
    }
    
    
       /**
    * @description: Test Method used to check if the CreativeChannel and Creative Products are created on insertion of 
    *                Creative.
    * @param: none
    * @return: void
    */
    static testMethod void createCreativeProductChannel() {
       List<IMH_Communication__c> lcommunication;
       List<IMH_CommCreative__c> lcreativeRec;
       List<IMH_CommProducts__c> lCommtargetedProd;
       List<IMH_CommChannels__c> lCommtargetedChannel;
        Id insertedCommunicationId; 
        Id creativeRecordId;    
          User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
            //Insert Communication
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,'Canada'));
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();         
            
        
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer t=0;t<10;t++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Canada',true,'Gold'));
                prodList[t].Name=PRODUCT_NAME+t;
            } 
             prodList[0].RequiredApprovers__c = 'Charge';
            prodList[1].RequiredApprovers__c = 'SBS';
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer t=0;t<10;t++) {
                channelList.add(IMH_TestClassUtility.createChannel('Canada','LACC','AMEX'));
                channelList[t].Name='AMEX'+t;
                channelList[t].RequiredApprovers__c = 'Customer Management';
            }
            
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer t=0;t<10;t++){
            lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[t].Id,'Canada'));
             
         }  
           
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
         lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<10;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[i].Id));
        }
        Database.insert(lCommtargetedChannel,true);
            
            
          //Test Data for Creative
            lcreativeRec = new List<IMH_CommCreative__c>();  
          Test.startTest(); 
           
            for(Integer i=0;i<3;i++){
              lcreativeRec.add(IMH_TestClassUtility.createFinalCreative(insertedCommunicationId,'In Progress',
                                                                   IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
          
              lcreativeRec[i].CreativeStage__c = 'Creative';
              lcreativeRec[i].SYSCreativeStep__c = '1';
            }
             insert lcreativeRec;
        
          Test.StopTest();
        }
          List<IMH_CreativeProduct__c> lcreativeprods = [SELECT Id,TargetedProduct__c From IMH_CreativeProduct__c WHERE Creative__c IN:lcreativeRec LIMIT 50000];  
          System.assertEquals(30, lcreativeprods.size()); // Asserting the size ofCreative Products
          System.assertEquals(lcreativeprods[2].TargetedProduct__c, lCommtargetedProd[2].Id); // Asserting the id of third Creative Product with newly inserted Targeted Products
         
           List<IMH_CreativeChannel__c> lcreativechannel = [SELECT Id,TargetedChannel__c From IMH_CreativeChannel__c WHERE Creative__c IN :lcreativeRec LIMIT 50000];  
           System.assertEquals(30, lcreativechannel.size()); // Asserting the size ofCreative Channels
           System.assertEquals(lcreativechannel[2].TargetedChannel__c, lCommtargetedChannel[2].Id); // Asserting the id of third Creative Product with newly inserted Targeted Channel
    }
    
    /**
    * @description: Negative Test Method used to check if the CreativeChannel and Creative Products are created  but Targeted Product
    *               and Targeted Channel are not present
    * @param: none
    * @return: void
    */
    static testMethod void createCreativeProductChannelnoCreative() {
       List<IMH_Communication__c> lcommunication;
        List<IMH_CommCreative__c> lcreativeRec;
        Id insertedCommunicationId; 
        Id creativeRecordId;    
          User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
            //Insert Communication
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,'Canada'));
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();         
            
        
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer t=0;t<10;t++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Canada',true,'Gold'));
                prodList[t].Name=PRODUCT_NAME+t;
            } 
             prodList[0].RequiredApprovers__c = 'Charge';
            prodList[1].RequiredApprovers__c = 'SBS';
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer t=0;t<10;t++) {
                channelList.add(IMH_TestClassUtility.createChannel('Canada','LACC','AMEX'));
                channelList[t].Name='AMEX'+t;
                channelList[t].RequiredApprovers__c = 'Customer Management';
            }
            
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        //Test Data for Creative
          lcreativeRec = new List<IMH_CommCreative__c>();  
          Test.startTest(); 
           
            for(Integer i=0;i<3;i++){
              lcreativeRec.add(IMH_TestClassUtility.createFinalCreative(insertedCommunicationId,'In Progress',
                                                                   IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
          
              lcreativeRec[i].CreativeStage__c = 'Creative';
              lcreativeRec[i].SYSCreativeStep__c = '1';
            }
             insert lcreativeRec;
        
          Test.StopTest();
        }
          List<IMH_CreativeProduct__c> lcreativeprods = [SELECT Id,TargetedProduct__c From IMH_CreativeProduct__c WHERE Creative__c IN:lcreativeRec LIMIT 50000];  
          System.assertEquals(0, lcreativeprods.size()); // Asserting the size ofCreative Products 
         
           List<IMH_CreativeChannel__c> lcreativechannel = [SELECT Id,TargetedChannel__c From IMH_CreativeChannel__c WHERE Creative__c IN :lcreativeRec LIMIT 50000];  
           System.assertEquals(0, lcreativechannel.size()); // Asserting the size ofCreative Channels 
    }
}