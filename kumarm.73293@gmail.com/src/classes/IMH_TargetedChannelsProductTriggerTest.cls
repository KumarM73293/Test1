/**
    * @author Accenture IDC 
    * @date 01/13/2015
    * @group Answer
    * @group-content N/A
    * @description: iMH Release 1.3 (Sprint 14) - Test Class for rejecting creative on channel/Product reject.
*/
@isTest
private class IMH_TargetedChannelsProductTriggerTest  {
      private static final String CONCEPT_STAGE               = 'Concept';
      private static final String STATUS_NAME                 = 'In Progress';
      private static final String INCENTIVISED_OFFER          = 'Incentivised Offer';
      private static final String PRODUCT_NAME                = 'ProdTest';
      private static final String THAILAND_NAME               = 'Thailand';
	  private static final String CAMPAIGN_SUBMITTER_PROFILE  = 'iMH Campaign Submitter';
      private static final String RUNNING_USER 				  = 'RunningUser';    
    /**
    * @description: Test Method used to check if the CreativeChannel and Creative Products are created on insertion of 
    *                Targeted Channel and Targeted Products.
    * @param: none
    * @return: void
    */
    static testMethod void createCreativeProductChannel() {
       List<IMH_Communication__c> lcommunication;
         List<IMH_CommProducts__c> CommtargetedProd ;
             List<IMH_CommChannels__c> CommtargetedChannel ;
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
            for(Integer t=0;t<3;t++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Canada',true,'Gold'));
                prodList[t].Name=PRODUCT_NAME+t;
            } 
             prodList[0].RequiredApprovers__c = 'Charge';
            prodList[1].RequiredApprovers__c = 'SBS';
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer t=0;t<3;t++) {
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
             CommtargetedProd = new  List<IMH_CommProducts__c>();
             CommtargetedChannel = new List<IMH_CommChannels__c>();
          Test.startTest(); 
             //Inserting Additional Targeted Products
            for(Integer i=0;i<10;i++){
             CommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[2].Id,'Canada'));
             }
        Database.insert(CommtargetedProd); 
        
           //Inserting Additional Targeted Channel
           for(Integer i=0;i<10;i++){  
            CommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[2].Id));
           }
            Database.insert(CommtargetedChannel,true);
        
          Test.StopTest();
        }
          List<IMH_CreativeProduct__c> lcreativeprods = [SELECT Id,TargetedProduct__c From IMH_CreativeProduct__c WHERE Creative__c =:creativeRecordId LIMIT 50000];  
          System.assertEquals(12, lcreativeprods.size()); // Asserting the size ofCreative Products
          System.assertEquals(lcreativeprods[2].TargetedProduct__c, CommtargetedProd[0].Id); // Asserting the id of third Creative Product with newly inserted Targeted Products
         
           List<IMH_CreativeChannel__c> lcreativechannel = [SELECT Id,TargetedChannel__c From IMH_CreativeChannel__c WHERE Creative__c =:creativeRecordId LIMIT 50000];  
           System.assertEquals(12, lcreativechannel.size()); // Asserting the size ofCreative Channels
           System.assertEquals(lcreativechannel[2].TargetedChannel__c, CommtargetedChannel[0].Id); // Asserting the id of third Creative Product with newly inserted Targeted Channel
    }
    
   /**
    * @description: Test Method used to check if the Required Approver is inline of Products and Channels.
    * @param: none
    * @return: void
    */
    static testMethod void updateRequiredApproveronDeletion() {
       List<IMH_Communication__c> lcommunication;
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
            for(Integer t=0;t<3;t++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Canada',true,'Gold'));
                prodList[t].Name=PRODUCT_NAME+t;
            } 
             prodList[0].RequiredApprovers__c = 'Charge';
            prodList[1].RequiredApprovers__c = 'SBS';
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer t=0;t<3;t++) {
                channelList.add(IMH_TestClassUtility.createChannel('Canada','LACC','AMEX'));
                channelList[t].Name='AMEX'+t;
                channelList[0].RequiredApprovers__c = 'Customer Management';
            }
            
            channelList[2].RequiredApprovers__c = 'Brand Management';
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer t=0;t<2;t++){
            lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[t].Id,'Canada'));
             
         }  
           
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[i].Id));
        }
        Database.insert(lCommtargetedChannel,true);
            
          IMH_Communication__c comms = [Select id,RequiredApprovers__c FROM IMH_Communication__c WHERE Id =:insertedCommunicationId LIMIT 50000];  
          System.assertEquals(comms.RequiredApprovers__c.contains('Charge'), true);
          System.assertEquals(comms.RequiredApprovers__c.contains('Brand Management'), true);
         Test.startTest(); 
           Database.delete(lCommtargetedProd[0].Id);
          Database.delete(lCommtargetedChannel[2].Id);
         Test.stopTest();
        }
        //Assert To Check if the Required Approver field is updated on deletion of Products
         IMH_Communication__c commsafterdalete = [Select id,RequiredApprovers__c FROM IMH_Communication__c WHERE Id =:insertedCommunicationId LIMIT 50000];  
          System.assertEquals(commsafterdalete.RequiredApprovers__c.contains('Charge'), false);
         System.assertEquals(commsafterdalete.RequiredApprovers__c.contains('SBS'), true);
         //Assert To Check if the Required Approver field is updated on deletion of Channels
        System.assertEquals(commsafterdalete.RequiredApprovers__c.contains('Customer Management'), true);
        System.assertEquals(commsafterdalete.RequiredApprovers__c.contains('Brand Management'), false);
     }
    
      /**
    * @description: Test Method used to check if the Required Approver is inline of Products and Channels
    *               after Undeletion.
    * @param: none
    * @return: void
    */
    static testMethod void updateRequiredApproveronUnDeletion() {
       List<IMH_Communication__c> lcommunication;
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
            for(Integer t=0;t<3;t++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Canada',true,'Gold'));
                prodList[t].Name=PRODUCT_NAME+t;
            } 
             prodList[0].RequiredApprovers__c = 'Charge';
            prodList[1].RequiredApprovers__c = 'SBS';
        Database.insert(prodList,true);
        
        //Channel Insertion
         //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer t=0;t<3;t++) {
                channelList.add(IMH_TestClassUtility.createChannel('Canada','LACC','AMEX'));
                channelList[t].Name='AMEX'+t;
                channelList[0].RequiredApprovers__c = 'Customer Management';
            }
            
            channelList[2].RequiredApprovers__c = 'Brand Management';
            
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer t=0;t<2;t++){
            lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[t].Id,'Canada'));
             
         }  
           
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[i].Id));
        }
        Database.insert(lCommtargetedChannel,true);
            
          IMH_Communication__c comms = [Select id,RequiredApprovers__c FROM IMH_Communication__c WHERE Id =:insertedCommunicationId LIMIT 50000];  
          System.assertEquals(comms.RequiredApprovers__c.contains('Charge'), true);
          System.assertEquals(comms.RequiredApprovers__c.contains('Brand Management'), true);
         Test.startTest(); 
           Database.delete(lCommtargetedProd[0].Id);
           Database.delete(lCommtargetedChannel[2].Id);
        //Assert To Check if the Required Approver field is updated on deletion of Products
          IMH_Communication__c commsafterdelete = [Select id,RequiredApprovers__c FROM IMH_Communication__c WHERE Id =:insertedCommunicationId LIMIT 50000];  
          System.assertEquals(commsafterdelete.RequiredApprovers__c.contains('Charge'), false);
           System.assertEquals(commsafterdelete.RequiredApprovers__c.contains('Brand Management'), false);
        
          Database.undelete(lCommtargetedProd[0].Id);
          Database.undelete(lCommtargetedChannel[2].Id);
        Test.stopTest();
        }
        //Assert To Check if the Required Approver field is updated on deletion of Products
          IMH_Communication__c commsafterundelete = [Select id,RequiredApprovers__c FROM IMH_Communication__c WHERE Id =:insertedCommunicationId LIMIT 50000];  
          System.assertEquals(commsafterundelete.RequiredApprovers__c.contains('Charge'), true);
          System.assertEquals(commsafterundelete.RequiredApprovers__c.contains('Brand Management'), true);
     }
    
    /*****************************************************************************
    * @description: Method used for covering the case when Targeted Product and Channel is deleted by Submitter
    * @param: none
    * @return: void
    */
    static testMethod void TargetedProductNChannelDeleteSubmitter() {
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
         User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){  

        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId; 
        Id creativeRecordId;    
        
            //Insert Communication
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,THAILAND_NAME));
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();         
            
        
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer t=0;t<3;t++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,THAILAND_NAME,true,'Gold'));
                prodList[t].Name=PRODUCT_NAME+t;
            } 
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer t=0;t<3;t++) {
                channelList.add(IMH_TestClassUtility.createChannel(THAILAND_NAME,'JAPA','AMEX'));
                channelList[t].Name='AMEX'+t;
            }
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer t=0;t<3;t++){
            lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[t].Id,THAILAND_NAME));
             
         }  
           
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[i].Id));
        }
        Database.insert(lCommtargetedChannel,true);
            
          IMH_Communication__c comms = [Select id,RequiredApprovers__c FROM IMH_Communication__c WHERE Id =:insertedCommunicationId LIMIT 50000];

         Test.startTest(); 
         List<IMH_CommProducts__c> lCommtargetedProductDelList = new List<IMH_CommProducts__c>();  
         for(Integer i=0;i<2;i++){
                lCommtargetedProductDelList.add(lCommtargetedProd[i]);
         }
        //Deleting Targeted Product
           Database.delete(lCommtargetedProductDelList);

         List<IMH_CommChannels__c> lCommtargetedChannelDelList = new List<IMH_CommChannels__c>();  
         for(Integer i=0;i<2;i++){
                lCommtargetedChannelDelList.add(lCommtargetedChannel[i]);
         }
         //Deleting Targeted Channel
           Database.delete(lCommtargetedChannelDelList);

         Test.stopTest();  

        //Assert To Check if Targeted Products Deletion
        List<IMH_CommProducts__c> lCommtargetedProductAfterDelList = new List<IMH_CommProducts__c>();
        lCommtargetedProductAfterDelList = [SELECT id, communication__c from IMH_CommProducts__c 
                                        WHERE communication__c =: lcommunication[0].Id
                                            LIMIT 50000];
        System.assertEquals(lCommtargetedProductAfterDelList.size(),1);   

        //Assert To Check if Targeted Channel Deletion
        List<IMH_CommChannels__c> lCommtargetedChannelAfterDelList = new List<IMH_CommChannels__c>();
        lCommtargetedChannelAfterDelList = [SELECT id, communication__c from IMH_CommChannels__c 
                                        WHERE communication__c =: lcommunication[0].Id
                                            LIMIT 50000];
        System.assertEquals(lCommtargetedChannelAfterDelList.size(),1);    
            
        }    
    }
    /*****************************************************************************
    * @description: Method used for covering the case when Targeted Product and Channel is deleted by Submitter on Creative Stage
    * @param: none
    * @return: void
    */
    static testMethod void TargetedProductNChannelDeleteSubmitterCreative() {

        String responseReturned = '';        
        Boolean flag = False;         
        //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
         User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){  

        try {            
        List<IMH_Communication__c> lcommunication;
        Id insertedCommunicationId; 
        Id creativeRecordId;    
        
             //Insert Communication
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            lcommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<1;i++) {
                lcommunication.add(IMH_TestClassUtility.createCommunication(CONCEPT_STAGE,STATUS_NAME,THAILAND_NAME));
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].ReviewStatus__c = 'In Progress';                  
            }
            Database.SaveResult[] srListCommunication = Database.insert(lcommunication,false);
            insertedCommunicationId = srListCommunication[0].getId();         
            
        
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer t=0;t<3;t++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,THAILAND_NAME,true,'Gold'));
                prodList[t].Name=PRODUCT_NAME+t;
            } 
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer t=0;t<3;t++) {
                channelList.add(IMH_TestClassUtility.createChannel(THAILAND_NAME,'JAPA','AMEX'));
                channelList[t].Name='AMEX'+t;
            }
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer t=0;t<3;t++){
            lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[t].Id,THAILAND_NAME));
             
         }  
           
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[i].Id));
        }
        Database.insert(lCommtargetedChannel,true);
            
          IMH_Communication__c comms = [Select id,RequiredApprovers__c FROM IMH_Communication__c WHERE Id =:insertedCommunicationId LIMIT 50000];

         Test.startTest(); 

        lcommunication[0].ProcessStage__c = 'Creative';
        lcommunication[0].ReviewStatus__c = 'In Progress';
        Update lcommunication[0];

         List<IMH_CommProducts__c> lCommtargetedProductDelList = new List<IMH_CommProducts__c>();  
         for(Integer i=0;i<2;i++){
                lCommtargetedProductDelList.add(lCommtargetedProd[i]);
         }
        //Deleting Targeted Product
           Database.delete(lCommtargetedProductDelList);

         List<IMH_CommChannels__c> lCommtargetedChannelDelList = new List<IMH_CommChannels__c>();  
         for(Integer i=0;i<2;i++){
                lCommtargetedChannelDelList.add(lCommtargetedChannel[i]);
         }
         //Deleting Targeted Channel
           Database.delete(lCommtargetedChannelDelList);
    }  
         catch(Exception e){
         responseReturned = e.getMessage();
            }
        if(responseReturned.contains(Label.IMH_PreventDeletionOfTargetedProduct)){
            flag = True;
        }
        System.assertEquals(flag,true);           
        }    
         Test.stopTest();     
     } 
}