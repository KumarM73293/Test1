/**
* @author Accenture IDC 
* @date 03/24/2016
* @group Answer
* @group-content N/A
* @description: iMH Release 1.4 (Sprint 32) - Test Class for Trigger on Communication Object to cover the scenarios for Deep Clone
* logic has been triggered on particular event of an object.
*/
@isTest(SeeAllData=false)
private class IMH_DeepCloneTest {
   private static final String STAGE_NAME = 'Concept';
   private static final String STATUS_NAME = 'In Progress';
   private static final String MARKET_NAME = 'Hong Kong';
   private static final String OBJECT_NAME = 'Communication';
   private static final String PRODUCT_NAME                = 'ProdTest';
   private static final String CAMPAIGN_SUBMITTER_PROFILE  = 'iMH Campaign Submitter';
    private static final String SUBMITTER_RUNNING_USER      = 'RunningUserSubmitter';
    private static final String SUBMITTER_THAI              = 'Hong Kong Submitter';
    
  /**
    * @description: Test Method used to clone the Marketing Communciation with Incentives
    * @param: none
    * @return: void
    */     
    static testmethod void createIncentiveisedCommm(){
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= MARKET_NAME;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        
         List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
         List<IMH_Communication__c> lupdatecommunication = new List<IMH_Communication__c>();
        List<IMH_Communication__c> lclonedcommunication = new List<IMH_Communication__c>();
        
        System.RunAs(runningUserSubmitter){ 
        //Communication Insertion
        for(Integer i=0;i<1;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
             lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
        }
        Database.insert(lcommunication,true);
         IMH_CommunicationTriggerHandler.isExecutedAfter = true;
        //Incentive Insertion
         List<IMH_Incentive__c> loffers = new List<IMH_Incentive__c>();
        for(Integer i=0;i<3;i++)
        {
            loffers.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id,STATUS_NAME,lcommunication[0].ID));
            
        }
        Database.insert(loffers,true);
        
    
        
         //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<2;i++) {
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
         for(Integer i=0;i<3;i++){
             if( math.mod(i,2) == 0){
                 lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[0].Id,MARKET_NAME));
              }
             else{
                  lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[1].Id,MARKET_NAME));
             }
             
          } 
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[0].Id));
        }
        Database.insert(lCommtargetedChannel,true);
        
        
             //Creative Insertion
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<3;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,true);
        
        //Update Creatives to Approved
        List<IMH_CommCreative__c> lupdatecreative = new List<IMH_CommCreative__c>();
        for(IMH_CommCreative__c create:[SELECT CreativeStatus__c,
                                             CreativeStage__c,
                                             Id
                                      FROM IMH_CommCreative__c
                                      WHERE ID IN:lcreative
                                      LIMIT 50000]){
             create.CreativeStatus__c = 'Approved'; 
             create.CreativeStage__c = 'Complete';                             
             lupdatecreative.add(create);                             
         }
        Database.update(lupdatecreative,true);
        //Update on Communication to make it Approved.
        //
       
        for(IMH_Communication__c comms:[SELECT Id
                                              ,ProcessStage__c
                                              ,ReviewStatus__c
                                              ,ReviewStage__c
                                              ,RecordTypeId
                                              ,StartDate__c
                                              ,EndDate__c
                                              ,Submitter__c
                                              ,TargetMarket__c
                                        FROM IMH_Communication__c WHERE ID =:lcommunication[0].Id
                                         LIMIT 50000]){
            comms.ProcessStage__c = 'Ready for Execution';
            comms.ReviewStatus__c = 'Approved'; 
            comms.ReviewStage__c = 'Complete';
            comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
            lupdatecommunication.add(comms);                                
        }
        Database.update(lupdatecommunication);
             IMH_CommunicationTriggerHandler.isExecutedAfter = false;
          lclonedcommunication =lupdatecommunication.deepClone(false);
          //Update Communication Owner for Cloned Records
          for(IMH_Communication__c comms:[SELECT Submitter__c
                                        FROM IMH_Communication__c WHERE ID IN:lclonedcommunication
                                           LIMIT 50000]){
            comms.Submitter__c = UserInfo.getUserId();
            //comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketingCommunication_PreExecution').Id;
            lclonedcommunication.add(comms);                               
        }
         Test.startTest();
         Database.insert(lclonedcommunication,true);
        Test.stopTest();
      }
        //Assert The New Communiactions Created
        List<IMH_Communication__c> lcomms = [Select id,TargetMarket__c,ProcessStage__c,ReviewStage__c,StartDate__c,EndDate__c
                                             FROM IMH_Communication__c
                                             WHERE Id IN:lclonedcommunication
                                              LIMIT 50000];
        System.assertEquals(STAGE_NAME,lcomms[0].ProcessStage__c);
        System.assertEquals('Design',lcomms[0].ReviewStage__c);
        System.assertEquals(lcommunication.size(),lcomms.size());
        System.assertEquals(lcomms[0].TargetMarket__c,lcommunication[0].TargetMarket__c);
        //Asserting new Creatives Created
        List<IMH_CommCreative__c> lcreatives = [SELECT id
                                                       ,CreativeStatus__c
                                                       ,CreativeStage__c
                                                FROM IMH_CommCreative__c
                                                WHERE Communication__c IN:lclonedcommunication
                                                 LIMIT 50000];
        System.assertEquals('In Progress',lcreatives[0].CreativeStatus__c);
        System.assertEquals('Design',lcreatives[0].CreativeStage__c);
         
        
        //Asserting new Targeted Products Created
        List<IMH_CommProducts__c> lcommtargprod = [SELECT Id
                                                  FROM IMH_CommProducts__c
                                                  WHERE Communication__c IN:lcomms
                                                    LIMIT 50000];
        System.assertEquals(3, lcommtargprod.size());
        
        
          //Asserting new Targeted Channels Created
        List<IMH_CommChannels__c> lcommtargchannel = [SELECT Id,
                                                         Channel_End_Date__c,
                                                         Channel_Start_Date__c
                                                  FROM IMH_CommChannels__c
                                                  WHERE Communication__c IN:lcomms
                                                    LIMIT 50000];
         System.assertEquals(3, lcommtargchannel.size());
        System.assertEquals(lcommtargchannel[0].Channel_Start_Date__c,lcomms[0].StartDate__c);
        System.assertEquals(lcommtargchannel[0].Channel_End_Date__c,lcomms[0].EndDate__c);
        
        
        //Asserting new Creative Products Created
        List<IMH_CreativeProduct__c> ltargprod = [SELECT Id
                                                  FROM IMH_CreativeProduct__c
                                                  WHERE Creative__c IN:lcreatives
                                                   LIMIT 50000];
        System.assertEquals(9, ltargprod.size());
        
        //Asserting new Creative Channels Created
        List<IMH_CreativeChannel__c> ltargchannel = [SELECT Id,
                                                         Channel_End_Date__c,
                                                         Channel_Start_Date__c
                                                  FROM IMH_CreativeChannel__c
                                                  WHERE Creative__c IN:lcreatives
                                                    LIMIT 50000];
         System.assertEquals(9, ltargchannel.size());
        System.assertEquals(ltargchannel[0].Channel_Start_Date__c,lcomms[0].StartDate__c);
        System.assertEquals(ltargchannel[0].Channel_End_Date__c,lcomms[0].EndDate__c);
    }
    
    /**
    * @description: Test Method with PreApprovedBenefits In Mixed Communication Campaign     
    * @param: none
    * @return: void
    */
    static testmethod void createPreApprovedCommm(){
         User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI  LIMIT 1];
        runningUserSubmitter.Market__c= MARKET_NAME;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        
         List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
         List<IMH_Communication__c> lupdatecommunication = new List<IMH_Communication__c>();
        List<IMH_Communication__c> lclonedcommunication = new List<IMH_Communication__c>();
         List<IMH_PreApprovedBenefits__c> lpreApprovedBeneInsert = new List<IMH_PreApprovedBenefits__c>();
         System.RunAs(runningUserSubmitter){
        //Communication Insertion
        for(Integer i=0;i<3;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
             lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('Multiple').Id;
            lcommunication[i].Communication_Type__c = ' Pre-Approved Benefit';
        }
        Database.insert(lcommunication,false);
         IMH_CommunicationTriggerHandler.isExecutedAfter = true;
        //Benefits Insertion
        List<IMH_Benefits__c> lbenefits = new List<IMH_Benefits__c>();
         for(Integer i=0;i<3;i++)
            {
                 lbenefits.add(IMH_TestClassUtility.createBenefits('Local','JAPA',MARKET_NAME));
                 lbenefits[i].ApprovalStage__c = 'Accepted';
            }
         Database.insert(lbenefits,false);
        
        //Pre-Approved Benefits
       
        for(Integer i=0;i<3;i++){
            lpreApprovedBeneInsert.add(IMH_TestClassUtility.createPreApprovedBenefits(lcommunication[0].Id,lbenefits[i].Id));
        }
        Database.insert(lpreApprovedBeneInsert,true);
        
            //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<2;i++) {
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
         for(Integer i=0;i<3;i++){
             if( math.mod(i,2) == 0){
                 lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[0].Id,MARKET_NAME));
              }
             else{
                  lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[1].Id,MARKET_NAME));
             }
             
          } 
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[0].Id));
        }
        Database.insert(lCommtargetedChannel,true);
        
        
             //Creative Insertion
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<3;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,true);
        
        //Update Creatives to Approved
        List<IMH_CommCreative__c> lupdatecreative = new List<IMH_CommCreative__c>();
        for(IMH_CommCreative__c create:[SELECT CreativeStatus__c,
                                             CreativeStage__c,
                                             Id
                                      FROM IMH_CommCreative__c
                                      WHERE ID IN:lcreative
                                       LIMIT 50000]){
             create.CreativeStatus__c = 'Approved'; 
             create.CreativeStage__c = 'Complete';                             
             lupdatecreative.add(create);                             
         }
        Database.update(lupdatecreative,false);
        //Update on Communication to make it Approved.
        //
       
        for(IMH_Communication__c comms:[SELECT Id
                                              ,ProcessStage__c
                                              ,ReviewStatus__c
                                              ,ReviewStage__c
                                              ,RecordTypeId
                                              ,StartDate__c
                                              ,EndDate__c
                                              ,Submitter__c
                                              ,TargetMarket__c,
                                              Communication_Type__c
                                        FROM IMH_Communication__c WHERE ID IN:lcommunication
                                         LIMIT 50000]){
            comms.ProcessStage__c = 'Ready for Execution';
            comms.ReviewStatus__c = 'Approved'; 
            comms.ReviewStage__c = 'Complete';
            comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('Multiple').Id;
            lupdatecommunication.add(comms);                                
        }
        Database.update(lupdatecommunication);
        
          //ApexPages.currentPage().getParameters().put('clone','1'); 
          IMH_CommunicationTriggerHandler.isExecutedAfter = false;
          lclonedcommunication =lupdatecommunication.deepClone(false);
          //Update Communication Owner for Cloned Records
           for(IMH_Communication__c comms:[SELECT Submitter__c
                                        FROM IMH_Communication__c WHERE ID IN:lclonedcommunication
                                            LIMIT 50000]){
            comms.Submitter__c = UserInfo.getUserId();
            //comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketingCommunication_PreExecution').Id;
            lclonedcommunication.add(comms);                                
        }
         Test.startTest();
         Database.insert(lclonedcommunication,true);
        Test.stopTest();
         }
        //Assert The New Communiactions Created
        List<IMH_Communication__c> lcomms = [Select id,TargetMarket__c,ProcessStage__c,ReviewStage__c
                                                   ,StartDate__c,EndDate__c
                                             FROM IMH_Communication__c
                                             WHERE Id IN:lclonedcommunication
                                              LIMIT 50000];
        System.assertEquals(STAGE_NAME,lcomms[0].ProcessStage__c);
        System.assertEquals('Design',lcomms[0].ReviewStage__c);
        System.assertEquals(lcommunication.size(),lcomms.size());
        System.assertEquals(lcomms[0].TargetMarket__c,lcommunication[0].TargetMarket__c);
        
        //Asserting Pre Approved Benefits
        List<IMH_PreApprovedBenefits__c> lupdatepreApprovedBeneInsert = [SELECT Id FROM IMH_PreApprovedBenefits__c WHERE Communication__c IN:lclonedcommunication   LIMIT 50000];
        System.assertEquals(lupdatepreApprovedBeneInsert.size(),lpreApprovedBeneInsert.size());
       
        
        //Asserting new Creatives Created
        List<IMH_CommCreative__c> lcreatives = [SELECT id
                                                       ,CreativeStatus__c
                                                       ,CreativeStage__c
                                                FROM IMH_CommCreative__c
                                                WHERE Communication__c IN:lclonedcommunication
                                                 LIMIT 50000];
        System.assertEquals('In Progress',lcreatives[0].CreativeStatus__c);
        System.assertEquals('Design',lcreatives[0].CreativeStage__c);
        
         //Asserting new Targeted Products Created
        List<IMH_CommProducts__c> lcommtargprod = [SELECT Id
                                                  FROM IMH_CommProducts__c
                                                  WHERE Communication__c IN:lcomms
                                                    LIMIT 50000];
        System.assertEquals(9, lcommtargprod.size());
        
        
          //Asserting new Targeted Channels Created
        List<IMH_CommChannels__c> lcommtargchannel = [SELECT Id,
                                                         Channel_End_Date__c,
                                                         Channel_Start_Date__c
                                                  FROM IMH_CommChannels__c
                                                  WHERE Communication__c IN:lcomms
                                                    LIMIT 50000];
         System.assertEquals(9, lcommtargchannel.size());
        System.assertEquals(lcommtargchannel[0].Channel_Start_Date__c,lcomms[0].StartDate__c);
        System.assertEquals(lcommtargchannel[0].Channel_End_Date__c,lcomms[0].EndDate__c);
        
        
        //Asserting new Creative Products Created
        List<IMH_CreativeProduct__c> ltargprod = [SELECT Id
                                                  FROM IMH_CreativeProduct__c
                                                  WHERE Creative__c IN:lcreatives
                                                   LIMIT 50000];
        System.assertEquals(9, ltargprod.size());
        
        //Asserting new Creative Channels Created
        List<IMH_CreativeChannel__c> ltargchannel = [SELECT Id,
                                                         Channel_End_Date__c,
                                                         Channel_Start_Date__c
                                                  FROM IMH_CreativeChannel__c
                                                  WHERE Creative__c IN:lcreatives
                                                    LIMIT 50000];
         System.assertEquals(9, ltargchannel.size());
        System.assertEquals(ltargchannel[0].Channel_Start_Date__c,lcomms[0].StartDate__c);
        System.assertEquals(ltargchannel[0].Channel_End_Date__c,lcomms[0].EndDate__c);
    }
    /**
    * @description: Test Method with Servcing Communication     
    * @param: none
    * @return: void
    */      
    static testmethod void createServcingCommm(){
          User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI  LIMIT 1];
        runningUserSubmitter.Market__c= MARKET_NAME;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        
         List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
         List<IMH_Communication__c> lupdatecommunication = new List<IMH_Communication__c>();
        List<IMH_Communication__c> lclonedcommunication = new List<IMH_Communication__c>();
        
         System.RunAs(runningUserSubmitter){
        //Communication Insertion
        for(Integer i=0;i<1;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication('Creative',STATUS_NAME,MARKET_NAME));
             lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleServicing').Id;
             lcommunication[i].Communication_Type__c = 'Servicing';
        }
        Database.insert(lcommunication,true);
        IMH_CommunicationTriggerHandler.isExecutedAfter = true;
        
             //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<2;i++) {
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
         for(Integer i=0;i<3;i++){
             if( math.mod(i,2) == 0){
                 lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[0].Id,MARKET_NAME));
              }
             else{
                  lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[1].Id,MARKET_NAME));
             }
             
          } 
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[0].Id));
        }
        Database.insert(lCommtargetedChannel,true);
        
        
             //Creative Insertion
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<3;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,true);
        
        //Update Creatives to Approved
        List<IMH_CommCreative__c> lupdatecreative = new List<IMH_CommCreative__c>();
        for(IMH_CommCreative__c create:[SELECT CreativeStatus__c,
                                             CreativeStage__c,
                                             Id
                                      FROM IMH_CommCreative__c
                                      WHERE ID IN:lcreative
                                       LIMIT 50000]){
             create.CreativeStatus__c = 'Approved'; 
             create.CreativeStage__c = 'Complete';                             
             lupdatecreative.add(create);                             
         }
        Database.update(lupdatecreative,true);
        //Update on Communication to make it Approved.
        //
      
        for(IMH_Communication__c comms:[SELECT Id
                                              ,ProcessStage__c
                                              ,ReviewStatus__c
                                              ,ReviewStage__c
                                              ,RecordTypeId
                                              ,StartDate__c
                                              ,EndDate__c
                                              ,Submitter__c
                                              ,TargetMarket__c
                                        FROM IMH_Communication__c WHERE ID IN:lcommunication
                                         LIMIT 50000]){
            comms.ProcessStage__c = 'Ready for Execution';
            comms.ReviewStatus__c = 'Approved'; 
            comms.ReviewStage__c = 'Complete';
            comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('ServicingCommunicationConcept').Id;
            lupdatecommunication.add(comms);                                
        }
          
        Database.update(lupdatecommunication,true); 
          //ApexPages.currentPage().getParameters().put('clone','1'); 
           IMH_CommunicationTriggerHandler.isExecutedAfter = false;
          lclonedcommunication =lupdatecommunication.deepClone(false);
          //Update Communication Owner for Cloned Records
           for(IMH_Communication__c comms:[SELECT Submitter__c
                                        FROM IMH_Communication__c WHERE ID IN:lclonedcommunication
                                            LIMIT 50000]){
            comms.Submitter__c = UserInfo.getUserId();
            //comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketingCommunication_PreExecution').Id;
            lclonedcommunication.add(comms);                                
        }
        Test.startTest();
         Database.insert(lclonedcommunication,true);
        Test.stopTest();
         }
        //Assert The New Communiactions Created
        List<IMH_Communication__c> lcomms = [Select id,TargetMarket__c,ProcessStage__c,ReviewStage__c,StartDate__c,EndDate__C
                                             FROM IMH_Communication__c
                                             WHERE Id IN:lclonedcommunication
                                             LIMIT 50000];
        System.assertEquals('Creative',lcomms[0].ProcessStage__c);
        System.assertEquals('Design',lcomms[0].ReviewStage__c);
        System.assertEquals(lcommunication.size(),lcomms.size());
        System.assertEquals(lcomms[0].TargetMarket__c,lcommunication[0].TargetMarket__c);
        //Asserting new Creatives Created
        List<IMH_CommCreative__c> lcreatives = [SELECT id
                                                       ,CreativeStatus__c
                                                       ,CreativeStage__c
                                                FROM IMH_CommCreative__c
                                                WHERE Communication__c IN:lclonedcommunication
                                                 LIMIT 50000];
        System.assertEquals('In Progress',lcreatives[0].CreativeStatus__c);
        System.assertEquals('Design',lcreatives[0].CreativeStage__c);
         
        //Asserting new Targeted Products Created
        List<IMH_CommProducts__c> lcommtargprod = [SELECT Id,Product__c
                                                  FROM IMH_CommProducts__c
                                                  WHERE Communication__c IN:lcomms
                                                    LIMIT 50000];
        System.assertEquals(3, lcommtargprod.size());
        
        
          //Asserting new Targeted Channels Created
        List<IMH_CommChannels__c> lcommtargchannel = [SELECT Id,
                                                         Channel_End_Date__c,
                                                         Channel_Start_Date__c
                                                  FROM IMH_CommChannels__c
                                                  WHERE Communication__c IN:lcomms
                                                       LIMIT 50000];
         System.assertEquals(3, lcommtargchannel.size());
        System.assertEquals(lcommtargchannel[0].Channel_Start_Date__c,lcomms[0].StartDate__c);
        System.assertEquals(lcommtargchannel[0].Channel_End_Date__c,lcomms[0].EndDate__c);
        
        //Asserting new Targeted Products Created
        List<IMH_CreativeProduct__c> ltargprod = [SELECT Id,
                                                         Status__c,
                                                         TargetedProduct__r.Product__c
                                                  FROM IMH_CreativeProduct__c
                                                  WHERE Creative__c IN:lcreatives
                                                   LIMIT 50000];
        System.assertEquals(ltargprod[0].TargetedProduct__r.Product__c,lcommtargprod[0].Product__c);
        System.assertEquals(9, ltargprod.size());
        
        //Asserting new Targeted Channels Created
        List<IMH_CreativeChannel__c> ltargchannel = [SELECT Id,
                                                         Status__c
                                                  FROM IMH_CreativeChannel__c
                                                  WHERE Creative__c IN:lcreatives
                                                      LIMIT 50000];
         System.assertEquals(9, ltargchannel.size());
    }
       /**
    * @description: Test Method with Servcing Communication for ANZ Market     
    * @param: none
    * @return: void
    */      
    static testmethod void createServcingCommmANZ(){
          User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= MARKET_NAME;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        
         List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
         List<IMH_Communication__c> lupdatecommunication = new List<IMH_Communication__c>();
        List<IMH_Communication__c> lclonedcommunication = new List<IMH_Communication__c>();
        
         System.RunAs(runningUserSubmitter){
        //Communication Insertion
        for(Integer i=0;i<1;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication('Creative',STATUS_NAME,MARKET_NAME));
             lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('ServicingCommunicationConcept').Id;
              lcommunication[i].TargetMarket__c = 'Australia';
        }
        Database.insert(lcommunication,true);
         IMH_CommunicationTriggerHandler.isExecutedAfter = true;
        
        //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<2;i++) {
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
         for(Integer i=0;i<3;i++){
             if( math.mod(i,2) == 0){
                 lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[0].Id,MARKET_NAME));
              }
             else{
                  lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[1].Id,MARKET_NAME));
             }
             
          } 
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[0].Id));
        }
        Database.insert(lCommtargetedChannel,true);
        
        
             //Creative Insertion
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<3;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,true);
        
        //Update Creatives to Approved
        List<IMH_CommCreative__c> lupdatecreative = new List<IMH_CommCreative__c>();
        for(IMH_CommCreative__c create:[SELECT CreativeStatus__c,
                                             CreativeStage__c,
                                             Id
                                      FROM IMH_CommCreative__c
                                      WHERE ID IN:lcreative
                                       LIMIT 50000]){
             create.CreativeStatus__c = 'Approved'; 
             create.CreativeStage__c = 'Complete';                             
             lupdatecreative.add(create);                             
         }
        Database.update(lupdatecreative,true);
        //Update on Communication to make it Approved.
        //
      
        for(IMH_Communication__c comms:[SELECT Id
                                              ,ProcessStage__c
                                              ,ReviewStatus__c
                                              ,ReviewStage__c
                                              ,RecordTypeId
                                              ,StartDate__c
                                              ,EndDate__c
                                              ,Submitter__c
                                              ,TargetMarket__c
                                        FROM IMH_Communication__c WHERE ID IN:lcommunication
                                       LIMIT 50000]){
            comms.ProcessStage__c = 'Ready for Execution';
            comms.ReviewStatus__c = 'Approved'; 
            comms.ReviewStage__c = 'Complete';
            comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('ServicingCommunicationConcept').Id;
            lupdatecommunication.add(comms);                                
        }
          
        Database.update(lupdatecommunication,true); 
          //ApexPages.currentPage().getParameters().put('clone','1'); 
          IMH_CommunicationTriggerHandler.isExecutedAfter = false;
          lclonedcommunication =lupdatecommunication.deepClone(false);
          //Update Communication Owner for Cloned Records
           for(IMH_Communication__c comms:[SELECT Submitter__c
                                        FROM IMH_Communication__c WHERE ID IN:lclonedcommunication
                                          LIMIT 50000]){
            comms.Submitter__c = UserInfo.getUserId();
            //comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketingCommunication_PreExecution').Id;
            lclonedcommunication.add(comms);                                
        }
        Test.startTest();
         Database.insert(lclonedcommunication,true);
        Test.stopTest();
         }
        //Assert The New Communiactions Created
        List<IMH_Communication__c> lcomms = [Select id,TargetMarket__c,ProcessStage__c,ReviewStage__c,StartDate__c,EndDate__C
                                             FROM IMH_Communication__c
                                             WHERE Id IN:lclonedcommunication
                                            LIMIT 50000];
        System.assertEquals('Concept',lcomms[0].ProcessStage__c);
        System.assertEquals('Design',lcomms[0].ReviewStage__c);
        System.assertEquals(lcommunication.size(),lcomms.size());
        System.assertEquals(lcomms[0].TargetMarket__c,lcommunication[0].TargetMarket__c);
        //Asserting new Creatives Created
        List<IMH_CommCreative__c> lcreatives = [SELECT id
                                                       ,CreativeStatus__c
                                                       ,CreativeStage__c
                                                FROM IMH_CommCreative__c
                                                WHERE Communication__c IN:lclonedcommunication
                                               LIMIT 50000];
        System.assertEquals('In Progress',lcreatives[0].CreativeStatus__c);
        System.assertEquals('Design',lcreatives[0].CreativeStage__c);
         
        //Asserting new Targeted Products Created
        List<IMH_CommProducts__c> lcommtargprod = [SELECT Id,Product__c
                                                  FROM IMH_CommProducts__c
                                                  WHERE Communication__c IN:lcomms
                                                  LIMIT 50000];
        System.assertEquals(3, lcommtargprod.size());
        
        
          //Asserting new Targeted Channels Created
        List<IMH_CommChannels__c> lcommtargchannel = [SELECT Id,
                                                         Channel_End_Date__c,
                                                         Channel_Start_Date__c
                                                  FROM IMH_CommChannels__c
                                                  WHERE Communication__c IN:lcomms
                                                     LIMIT 50000];
         System.assertEquals(3, lcommtargchannel.size());
        System.assertEquals(lcommtargchannel[0].Channel_Start_Date__c,lcomms[0].StartDate__c);
        System.assertEquals(lcommtargchannel[0].Channel_End_Date__c,lcomms[0].EndDate__c);
        
        //Asserting new Targeted Products Created
        List<IMH_CreativeProduct__c> ltargprod = [SELECT Id,
                                                         Status__c,
                                                         TargetedProduct__r.Product__c
                                                  FROM IMH_CreativeProduct__c
                                                  WHERE Creative__c IN:lcreatives
                                                 LIMIT 50000];
        System.assertEquals(ltargprod[0].TargetedProduct__r.Product__c,lcommtargprod[0].Product__c);
        System.assertEquals(9, ltargprod.size());
        
        //Asserting new Targeted Channels Created
        List<IMH_CreativeChannel__c> ltargchannel = [SELECT Id,
                                                         Status__c
                                                  FROM IMH_CreativeChannel__c
                                                  WHERE Creative__c IN:lcreatives
                                                    LIMIT 50000];
         System.assertEquals(9, ltargchannel.size());
    }
    /**
    * @description: Test Method used to clone the Marketing Communciation while covering scenario where Cancelled creatives doesn't get cloned
    * @param: none
    * @return: void
    */    
    static testmethod void createCommunicationWithCancelledCreatives(){
         User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= MARKET_NAME;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        
         List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
         List<IMH_Communication__c> lupdatecommunication = new List<IMH_Communication__c>();
        List<IMH_Communication__c> lclonedcommunication = new List<IMH_Communication__c>();
        
         System.RunAs(runningUserSubmitter){
        //Communication Insertion
        for(Integer i=0;i<1;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
             lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
        }
        Database.insert(lcommunication,false);
           IMH_CommunicationTriggerHandler.isExecutedAfter = true;
        //Incentive Insertion
         List<IMH_Incentive__c> loffers = new List<IMH_Incentive__c>();
        for(Integer i=0;i<1;i++)
        {
            loffers.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id,STATUS_NAME,lcommunication[0].ID));
            
        }
        Database.insert(loffers,false);
        
        //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<2;i++) {
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
         for(Integer i=0;i<3;i++){
             if( math.mod(i,2) == 0){
                 lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[0].Id,MARKET_NAME));
              }
             else{
                  lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[1].Id,MARKET_NAME));
             }
             
          } 
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[0].Id));
        }
        Database.insert(lCommtargetedChannel,true);
        
        
             //Creative Insertion
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<3;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,true);
        //Update Creatives to Approved
        List<IMH_CommCreative__c> lupdatecreative = new List<IMH_CommCreative__c>();
        Integer k = 0;
        for(IMH_CommCreative__c create:[SELECT CreativeStatus__c,
                                             CreativeStage__c,
                                             Id
                                      FROM IMH_CommCreative__c
                                      WHERE ID IN:lcreative
                                       LIMIT 50000]){
             if( math.mod(k,2) == 0){                             
             create.CreativeStatus__c = 'Approved'; 
                 create.CreativeStage__c = 'Complete';
             }
             else{//Cancellation Logic Here
                     create.CreativeStatus__c = 'Cancelled'; 
                 create.CreativeStage__c = 'In Progress';                         
                }
                k++;
             lupdatecreative.add(create);                             
         }
        Database.update(lupdatecreative,false);
        //Update on Communication to make it Approved.
        //
        
        for(IMH_Communication__c comms:[SELECT Id
                                              ,ProcessStage__c
                                              ,ReviewStatus__c
                                              ,ReviewStage__c
                                              ,RecordTypeId
                                              ,StartDate__c
                                              ,EndDate__c
                                              ,Submitter__c
                                              ,TargetMarket__c
                                        FROM IMH_Communication__c WHERE ID IN:lcommunication
                                       LIMIT 50000]){
            comms.ProcessStage__c = 'Ready for Execution';
            comms.ReviewStatus__c = 'Approved'; 
            comms.ReviewStage__c = 'Complete';
            comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
            lupdatecommunication.add(comms);                                
        }
        Database.update(lupdatecommunication);
           IMH_CommunicationTriggerHandler.isExecutedAfter = false;
          //ApexPages.currentPage().getParameters().put('clone','1'); 
          lclonedcommunication =lupdatecommunication.deepClone(false);
          //Update Communication Owner for Cloned Records
           for(IMH_Communication__c comms:[SELECT Submitter__c
                                        FROM IMH_Communication__c WHERE ID IN:lclonedcommunication
                                          LIMIT 50000]){
            comms.Submitter__c = UserInfo.getUserId();
            //comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketingCommunication_PreExecution').Id;
            lclonedcommunication.add(comms);                                
        }
        Test.startTest();
         Database.insert(lclonedcommunication,true);
        Test.stopTest();
         }
        //Assert The New Communiactions Created
        List<IMH_Communication__c> lcomms = [Select id,TargetMarket__c,ProcessStage__c,ReviewStage__c
                                             FROM IMH_Communication__c
                                             WHERE Id IN:lclonedcommunication
                                            LIMIT 50000];
        System.assertEquals(STAGE_NAME,lcomms[0].ProcessStage__c);
        System.assertEquals('Design',lcomms[0].ReviewStage__c);
        System.assertEquals(lcommunication.size(),lcomms.size());
        System.assertEquals(lcomms[0].TargetMarket__c,lcommunication[0].TargetMarket__c);
        //Asserting new Creatives Created
        List<IMH_CommCreative__c> lcreatives = [SELECT id
                                                       ,CreativeStatus__c
                                                       ,CreativeStage__c
                                                FROM IMH_CommCreative__c
                                                WHERE Communication__c IN:lclonedcommunication
                                               LIMIT 50000];
        System.assertEquals(2,lcreatives.size());//Cancellation Check
        System.assertEquals('In Progress',lcreatives[0].CreativeStatus__c);
        System.assertEquals('Design',lcreatives[0].CreativeStage__c);
         
        //Asserting new Targeted Products Created
        List<IMH_CreativeProduct__c> ltargprod = [SELECT Id,
                                                         Status__c
                                                  FROM IMH_CreativeProduct__c
                                                  WHERE Creative__c IN:lcreatives
                                                 LIMIT 50000];
        System.assertEquals(6, ltargprod.size());
        System.assertEquals(null,ltargprod[0].Status__c);
        
        //Asserting new Targeted Channels Created
        List<IMH_CreativeChannel__c> ltargchannel = [SELECT Id,
                                                         Status__c
                                                  FROM IMH_CreativeChannel__c
                                                  WHERE Creative__c IN:lcreatives
                                                    LIMIT 50000];
         System.assertEquals(6, ltargchannel.size());
        System.assertEquals(null,ltargchannel[0].Status__c);
    }
         /**
    * @description: Test Method used to clone the Marketing Communciation while covering scenario where Rejected Products and Channels doesn't get cloned
    * @param: none
    * @return: void
    */     
    static testmethod void createCommunicationWithRejectedProdChann(){
           User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= MARKET_NAME;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        
         List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
         List<IMH_Communication__c> lupdatecommunication = new List<IMH_Communication__c>();
        List<IMH_Communication__c> lclonedcommunication = new List<IMH_Communication__c>();
        
         System.RunAs(runningUserSubmitter){
        //Communication Insertion
        for(Integer i=0;i<1;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
             lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
        }
        Database.insert(lcommunication,false);
         IMH_CommunicationTriggerHandler.isExecutedAfter = true;
        //Incentive Insertion
         List<IMH_Incentive__c> loffers = new List<IMH_Incentive__c>();
        for(Integer i=0;i<1;i++)
        {
            loffers.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id,STATUS_NAME,lcommunication[0].ID));
            
        }
        Database.insert(loffers,false);
        
       //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<2;i++) {
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
         for(Integer i=0;i<4;i++){
             if( math.mod(i,2) == 0){
                 lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[0].Id,MARKET_NAME));
              }
             else{
                  lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[1].Id,MARKET_NAME));
             }
             
          } 
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<4;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[0].Id));
        }
        Database.insert(lCommtargetedChannel,true);
        
        
             //Creative Insertion
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<3;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,true);
        
        //Update Creatives to Approved
        List<IMH_CommCreative__c> lupdatecreative = new List<IMH_CommCreative__c>();
        Integer k = 0;
        for(IMH_CommCreative__c create:[SELECT CreativeStatus__c,
                                             CreativeStage__c,
                                             Id
                                      FROM IMH_CommCreative__c
                                      WHERE ID IN:lcreative
                                       LIMIT 50000]){
                                        
             create.CreativeStatus__c = 'Approved'; 
                 create.CreativeStage__c = 'Complete';
             
             lupdatecreative.add(create);                             
         }
        Database.update(lupdatecreative,false);
        //Update on Communication to make it Approved.
        //
        
        for(IMH_Communication__c comms:[SELECT Id
                                              ,ProcessStage__c
                                              ,ReviewStatus__c
                                              ,ReviewStage__c
                                              ,RecordTypeId
                                              ,StartDate__c
                                              ,EndDate__c
                                              ,Submitter__c
                                              ,TargetMarket__c
                                        FROM IMH_Communication__c WHERE ID IN:lcommunication
                                       LIMIT 50000]){
            comms.ProcessStage__c = 'Ready for Execution';
            comms.ReviewStatus__c = 'Approved'; 
            comms.ReviewStage__c = 'Complete';
            comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
            lupdatecommunication.add(comms);                                
        }
        Database.update(lupdatecommunication);
        
          //ApexPages.currentPage().getParameters().put('clone','1'); 
          lclonedcommunication =lupdatecommunication.deepClone(false);
          //Update Communication Owner for Cloned Records
           for(IMH_Communication__c comms:[SELECT Submitter__c
                                        FROM IMH_Communication__c WHERE ID IN:lclonedcommunication
                                          LIMIT 50000]){
            comms.Submitter__c = UserInfo.getUserId();
            //comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketingCommunication_PreExecution').Id;
            lclonedcommunication.add(comms);                                
        }
        Test.startTest();
              IMH_CommunicationTriggerHandler.isExecutedAfter = false;
         Database.insert(lclonedcommunication,true);
        Test.stopTest();
         }
        //Assert The New Communiactions Created
        List<IMH_Communication__c> lcomms = [Select id,TargetMarket__c,ProcessStage__c,ReviewStage__c
                                             FROM IMH_Communication__c
                                             WHERE Id IN:lclonedcommunication
                                            LIMIT 50000];
        System.assertEquals(STAGE_NAME,lcomms[0].ProcessStage__c);
        System.assertEquals('Design',lcomms[0].ReviewStage__c);
        System.assertEquals(lcommunication.size(),lcomms.size());
        System.assertEquals(lcomms[0].TargetMarket__c,lcommunication[0].TargetMarket__c);
        //Asserting new Creatives Created
        List<IMH_CommCreative__c> lcreatives = [SELECT id
                                                       ,CreativeStatus__c
                                                       ,CreativeStage__c
                                                FROM IMH_CommCreative__c
                                                WHERE Communication__c IN:lclonedcommunication
                                               LIMIT 50000];
        System.assertEquals(3,lcreatives.size());//Cancellation Check
        System.assertEquals('In Progress',lcreatives[0].CreativeStatus__c);
        System.assertEquals('Design',lcreatives[0].CreativeStage__c);
         
        //Asserting new Targeted Products Created
        List<IMH_CreativeProduct__c> ltargprod = [SELECT Id,
                                                         Status__c
                                                  FROM IMH_CreativeProduct__c
                                                  WHERE Creative__c IN:lcreatives
                                                 LIMIT 50000];
        System.assertEquals(12, ltargprod.size());
        System.assertEquals(null,ltargprod[0].Status__c);
        
        //Asserting new Targeted Channels Created
        List<IMH_CreativeChannel__c> ltargchannel = [SELECT Id,
                                                         Status__c
                                                  FROM IMH_CreativeChannel__c
                                                  WHERE Creative__c IN:lcreatives
                                                    LIMIT 50000];
         System.assertEquals(12, ltargchannel.size());
        System.assertEquals(null,ltargchannel[0].Status__c);
    }
          /**
    * @description: Test Method used to clone the Marketing Communciation while covering scenario where only Cancelled Expire Creatives gets cloned
    *                and Inactive Products are not carry forwaded
    * @param: none
    * @return: void
    */     
    static testmethod void createCommunicationWithExpiredCreative(){
          User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI];
        runningUserSubmitter.Market__c= MARKET_NAME;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        
         List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
         List<IMH_Communication__c> lupdatecommunication = new List<IMH_Communication__c>();
        List<IMH_Communication__c> lclonedcommunication = new List<IMH_Communication__c>();
        
         System.RunAs(runningUserSubmitter){
        //Communication Insertion
        for(Integer i=0;i<1;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
             lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
        }
        Database.insert(lcommunication,false);
         IMH_CommunicationTriggerHandler.isExecutedAfter = true;
        //Incentive Insertion
         List<IMH_Incentive__c> loffers = new List<IMH_Incentive__c>();
        for(Integer i=0;i<1;i++)
        {
            loffers.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id,STATUS_NAME,lcommunication[0].ID));
            
        }
        Database.insert(loffers,false);
        
        
        
         //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<2;i++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_NAME,true,'Gold'));
                prodList[i].Name=PRODUCT_NAME+i;
                prodList[i].Active__c = true;
                prodList[i].RequiredApprovers__c = 'Lending';
            } 
        Database.insert(prodList,false);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer i=0;i<1;i++) {
                channelList.add(IMH_TestClassUtility.createChannel(MARKET_NAME,'JAPA','AMEX'));
                channelList[i].Name='AMEX'+i;
            }
            channelList[0].RequiredApprovers__c = 'Brand and Advertising';
            Database.SaveResult[] srListChannel = Database.insert(channelList,false);
        
       //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer i=0;i<3;i++){
             if( math.mod(i,2) == 0){
                 lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[0].Id,MARKET_NAME));
              }
             else{
                  lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[1].Id,MARKET_NAME));
             }
             
          } 
        Database.insert(lCommtargetedProd,true);
        System.assertEquals(lCommtargetedProd.size(),3);
        System.assertEquals(lCommtargetedProd[0].Communication__c,lcommunication[0].ID);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[0].Id));
        }
        Database.insert(lCommtargetedChannel,true);
        System.assertEquals(3,lCommtargetedChannel.size());
        System.assertEquals(lCommtargetedChannel[0].Communication__c,lcommunication[0].ID);
        
         //Creative Insertion
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<4;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,false);
        
        
        //Update Creatives to Approved
        List<IMH_CommCreative__c> lupdatecreative = new List<IMH_CommCreative__c>();
        Integer k = 0;
        for(IMH_CommCreative__c create:[SELECT CreativeStatus__c,
                                             CreativeStage__c,
                                             Id
                                      FROM IMH_CommCreative__c
                                      WHERE ID IN:lcreative
                                       LIMIT 50000]){
                                        
           if(math.mod(k,2) == 0){
                 create.CreativeStatus__c = 'Approved'; 
             create.CreativeStage__c = 'Complete';
           }
           else{
                     create.CreativeStatus__c = 'Cancelled'; 
                     create.CreativeReviewCancellationReason__c = 'Expired';
                }
             
             lupdatecreative.add(create);                             
         }
        Database.update(lupdatecreative,false);
        
        List<IMH_Product__c> upprodList=new List<IMH_Product__c>();
        upprodList = [Select Id,Active__c FROM IMH_Product__c
                      WHERE Id IN:prodList
                     LIMIT 50000];
                upprodList[0].Active__c = false;
        Database.update(upprodList,true);
        //Update on Communication to make it Approved.
        //
        
        for(IMH_Communication__c comms:[SELECT Id
                                              ,ProcessStage__c
                                              ,ReviewStatus__c
                                              ,ReviewStage__c
                                              ,RecordTypeId
                                              ,StartDate__c
                                              ,EndDate__c
                                              ,Submitter__c
                                              ,TargetMarket__c
                                        FROM IMH_Communication__c WHERE ID IN:lcommunication
                                       LIMIT 50000]){
            comms.ProcessStage__c = 'Ready for Execution';
            comms.ReviewStatus__c = 'Approved'; 
            comms.ReviewStage__c = 'Complete';
            comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
            lupdatecommunication.add(comms);                                
        }
        Database.update(lupdatecommunication);
        
          //ApexPages.currentPage().getParameters().put('clone','1'); 
          lclonedcommunication =lupdatecommunication.deepClone(false);
          //Update Communication Owner for Cloned Records
           for(IMH_Communication__c comms:[SELECT Submitter__c
                                        FROM IMH_Communication__c WHERE ID IN:lclonedcommunication
                                          LIMIT 50000]){
            comms.Submitter__c = UserInfo.getUserId();
            //comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketingCommunication_PreExecution').Id;
            lclonedcommunication.add(comms);                                
        }
        Test.startTest();
              IMH_CommunicationTriggerHandler.isExecutedAfter = false;
         Database.insert(lclonedcommunication,true);
        Test.stopTest();
         }
        //Assert The New Communiactions Created
        List<IMH_Communication__c> lcomms = [Select id,TargetMarket__c,ProcessStage__c,ReviewStage__c
                                             FROM IMH_Communication__c
                                             WHERE Id IN:lclonedcommunication
                                            LIMIT 50000];
        System.assertEquals(STAGE_NAME,lcomms[0].ProcessStage__c);
        System.assertEquals('Design',lcomms[0].ReviewStage__c);
        System.assertEquals(lcommunication.size(),lcomms.size());
        System.assertEquals(lcomms[0].TargetMarket__c,lcommunication[0].TargetMarket__c);
        //Asserting new Creatives Created
        List<IMH_CommCreative__c> lcreatives = [SELECT id
                                                       ,CreativeStatus__c
                                                       ,CreativeStage__c
                                                FROM IMH_CommCreative__c
                                                WHERE Communication__c IN:lclonedcommunication
                                               LIMIT 50000];
        System.assertEquals(4,lcreatives.size());//Cancellation Check
        System.assertEquals('In Progress',lcreatives[0].CreativeStatus__c);
        System.assertEquals('Design',lcreatives[0].CreativeStage__c);
         
        //Asserting new Targeted Products Created
        List<IMH_CreativeProduct__c> ltargprod = [SELECT Id,
                                                         Status__c
                                                  FROM IMH_CreativeProduct__c
                                                  WHERE Creative__c IN:lcreatives
                                                 LIMIT 50000];
        System.assertNotEquals(12, ltargprod.size());
         System.assertEquals(4, ltargprod.size());
        System.assertEquals(null,ltargprod[0].Status__c);
        
        //Asserting new Targeted Channels Created
        List<IMH_CreativeChannel__c> ltargchannel = [SELECT Id,
                                                         Status__c
                                                  FROM IMH_CreativeChannel__c
                                                  WHERE Creative__c IN:lcreatives
                                                 LIMIT 50000];
         System.assertEquals(12, ltargchannel.size());
        System.assertEquals(null,ltargchannel[0].Status__c);
    }
    
     /**
    * @description: Test Method with Other Communication     
    * @param: none
    * @return: void
    */      
    static testmethod void createOtherCommm(){
          User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= MARKET_NAME;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        
         List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
         List<IMH_Communication__c> lupdatecommunication = new List<IMH_Communication__c>();
        List<IMH_Communication__c> lclonedcommunication = new List<IMH_Communication__c>();
        
         System.RunAs(runningUserSubmitter){
        //Communication Insertion
        for(Integer i=0;i<1;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication('Creative',STATUS_NAME,'Canada'));
                 lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('Other_Communications').Id;
             lcommunication[i].Communication_Type__c = 'Servicing';
        }
        Database.insert(lcommunication,true);
        IMH_CommunicationTriggerHandler.isExecutedAfter = true;
        
             //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<2;i++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Canada',true,'Gold'));
                prodList[i].Name=PRODUCT_NAME+i;
                prodList[i].RequiredApprovers__c = 'Lending';
            } 
        Database.insert(prodList,true);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer i=0;i<1;i++) {
                channelList.add(IMH_TestClassUtility.createChannel('Canada','LACC','AMEX'));
                channelList[i].Name='AMEX'+i;
            }
            channelList[0].RequiredApprovers__c = 'Brand and Advertising';
            Database.SaveResult[] srListChannel = Database.insert(channelList,true);
        
        
        //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer i=0;i<3;i++){
             if( math.mod(i,2) == 0){
                 lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[0].Id,'Canada'));
              }
             else{
                  lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[1].Id,'Canada'));
             }
             
          } 
        Database.insert(lCommtargetedProd,true);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[0].Id));
        }
        Database.insert(lCommtargetedChannel,true);
        
        
             //Creative Insertion
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<3;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,true);
        
        //Update Creatives to Approved
        List<IMH_CommCreative__c> lupdatecreative = new List<IMH_CommCreative__c>();
        for(IMH_CommCreative__c create:[SELECT CreativeStatus__c,
                                             CreativeStage__c,
                                             Id
                                      FROM IMH_CommCreative__c
                                      WHERE ID IN:lcreative
                                       LIMIT 50000]){
             create.CreativeStatus__c = 'Approved'; 
             create.CreativeStage__c = 'Complete';                             
             lupdatecreative.add(create);                             
         }
        Database.update(lupdatecreative,true);
        //Update on Communication to make it Approved.
        //
      
        for(IMH_Communication__c comms:[SELECT Id
                                              ,ProcessStage__c
                                              ,ReviewStatus__c
                                              ,ReviewStage__c
                                              ,RecordTypeId
                                              ,StartDate__c
                                              ,EndDate__c
                                              ,Submitter__c
                                              ,TargetMarket__c
                                        FROM IMH_Communication__c WHERE ID IN:lcommunication
                                       LIMIT 50000]){
            comms.ProcessStage__c = 'Ready for Execution';
            comms.ReviewStatus__c = 'Approved'; 
            comms.ReviewStage__c = 'Complete';
            comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('Other_Communications').Id;
            lupdatecommunication.add(comms);                                
        }
          
        Database.update(lupdatecommunication,true); 
          //ApexPages.currentPage().getParameters().put('clone','1'); 
           IMH_CommunicationTriggerHandler.isExecutedAfter = false;
          lclonedcommunication =lupdatecommunication.deepClone(false);
          //Update Communication Owner for Cloned Records
           for(IMH_Communication__c comms:[SELECT Submitter__c
                                        FROM IMH_Communication__c WHERE ID IN:lclonedcommunication
                                          LIMIT 50000]){
            comms.Submitter__c = UserInfo.getUserId();
            //comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketingCommunication_PreExecution').Id;
            lclonedcommunication.add(comms);                                
        }
        Test.startTest();
         Database.insert(lclonedcommunication,true);
        Test.stopTest();
         }
        //Assert The New Communiactions Created
        List<IMH_Communication__c> lcomms = [Select id,TargetMarket__c,ProcessStage__c,ReviewStage__c,StartDate__c,EndDate__C
                                             FROM IMH_Communication__c
                                             WHERE Id IN:lclonedcommunication
                                            LIMIT 50000];
        System.assertEquals('Creative',lcomms[0].ProcessStage__c);
        System.assertEquals('Design',lcomms[0].ReviewStage__c);
        System.assertEquals(lcommunication.size(),lcomms.size());
        System.assertEquals(lcomms[0].TargetMarket__c,lcommunication[0].TargetMarket__c);
        //Asserting new Creatives Created
        List<IMH_CommCreative__c> lcreatives = [SELECT id
                                                       ,CreativeStatus__c
                                                       ,CreativeStage__c
                                                FROM IMH_CommCreative__c
                                                WHERE Communication__c IN:lclonedcommunication
                                               LIMIT 50000];
        System.assertEquals('In Progress',lcreatives[0].CreativeStatus__c);
        System.assertEquals('Design',lcreatives[0].CreativeStage__c);
         
        //Asserting new Targeted Products Created
        List<IMH_CommProducts__c> lcommtargprod = [SELECT Id,Product__c
                                                  FROM IMH_CommProducts__c
                                                  WHERE Communication__c IN:lcomms
                                                  LIMIT 50000];
        System.assertEquals(3, lcommtargprod.size());
        
        
          //Asserting new Targeted Channels Created
        List<IMH_CommChannels__c> lcommtargchannel = [SELECT Id,
                                                         Channel_End_Date__c,
                                                         Channel_Start_Date__c
                                                  FROM IMH_CommChannels__c
                                                  WHERE Communication__c IN:lcomms
                                                     LIMIT 50000];
         System.assertEquals(3, lcommtargchannel.size());
        System.assertEquals(lcommtargchannel[0].Channel_Start_Date__c,lcomms[0].StartDate__c);
        System.assertEquals(lcommtargchannel[0].Channel_End_Date__c,lcomms[0].EndDate__c);
        
        //Asserting new Targeted Products Created
        List<IMH_CreativeProduct__c> ltargprod = [SELECT Id,
                                                         Status__c,
                                                         TargetedProduct__r.Product__c
                                                  FROM IMH_CreativeProduct__c
                                                  WHERE Creative__c IN:lcreatives
                                                 LIMIT 50000];
        System.assertEquals(ltargprod[0].TargetedProduct__r.Product__c,lcommtargprod[0].Product__c);
        System.assertEquals(9, ltargprod.size());
        
        //Asserting new Targeted Channels Created
        List<IMH_CreativeChannel__c> ltargchannel = [SELECT Id,
                                                         Status__c
                                                  FROM IMH_CreativeChannel__c
                                                  WHERE Creative__c IN:lcreatives
                                                  LIMIT 50000];
         System.assertEquals(9, ltargchannel.size());
    }
 /**
    * @description: Test Method used to clone the Marketing Communciation while covering scenario where only Targeted Products assigned to Approved
    *                or Complete,Cancelled and Expired Creative gets carry forwaded
    * @param: none
    * @return: void
    */     
    static testmethod void cancelledExpiredCretives(){
          User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= MARKET_NAME;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        
         List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
         List<IMH_Communication__c> lupdatecommunication = new List<IMH_Communication__c>();
        List<IMH_Communication__c> lclonedcommunication = new List<IMH_Communication__c>();
        
         System.RunAs(runningUserSubmitter){
        //Communication Insertion
        for(Integer i=0;i<1;i++)
        {
             lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
             lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
        }
        Database.insert(lcommunication,false);
         IMH_CommunicationTriggerHandler.isExecutedAfter = true;
        //Incentive Insertion
         List<IMH_Incentive__c> loffers = new List<IMH_Incentive__c>();
        for(Integer i=0;i<1;i++)
        {
            loffers.add(IMH_TestClassUtility.createIncentive(IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id,STATUS_NAME,lcommunication[0].ID));
            
        }
        Database.insert(loffers,false);
        
        
        
         //Product Insertion
         List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<2;i++) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_NAME,true,'Gold'));
                prodList[i].Name=PRODUCT_NAME+i;
                prodList[i].Active__c = true;
                prodList[i].RequiredApprovers__c = 'Lending';
            } 
        Database.insert(prodList,false);
        
        //Channel Insertion
         List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
            for(Integer i=0;i<1;i++) {
                channelList.add(IMH_TestClassUtility.createChannel(MARKET_NAME,'JAPA','AMEX'));
                channelList[i].Name='AMEX'+i;
            }
            channelList[0].RequiredApprovers__c = 'Brand and Advertising';
            Database.SaveResult[] srListChannel = Database.insert(channelList,false);
        
       //Targeted Products Insertion
        List<IMH_CommProducts__c> lCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer i=0;i<3;i++){
             if( math.mod(i,2) == 0){
                 lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[0].Id,MARKET_NAME));
              }
             else{
                  lCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,prodList[1].Id,MARKET_NAME));
             }
             
          } 
        Database.insert(lCommtargetedProd,true);
        System.assertEquals(lCommtargetedProd.size(),3);
        System.assertEquals(lCommtargetedProd[0].Communication__c,lcommunication[0].ID);
         //Targeted Channels Insertion
        List<IMH_CommChannels__c> lCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,channelList[0].Id));
        }
        Database.insert(lCommtargetedChannel,true);
        System.assertEquals(3,lCommtargetedChannel.size());
        System.assertEquals(lCommtargetedChannel[0].Communication__c,lcommunication[0].ID);
        
         //Creative Insertion
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<2;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(lcommunication[0].ID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,false);
        
        

        
      //Inserting a new Creative Product
        List<IMH_Product__c> newprodList=new List<IMH_Product__c>();          
            for(Integer i=0;i<2;i++) {
                newprodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_NAME,true,'Platinum'));
                newprodList[i].Name=PRODUCT_NAME+i;
                newprodList[i].Active__c = true;
                newprodList[i].RequiredApprovers__c = 'SBS';
            } 
        Database.insert(newprodList,false);
             
         List<IMH_CommProducts__c> lnewCommtargetedProd = new List<IMH_CommProducts__c>();  
         for(Integer i=0;i<2;i++){
             lnewCommtargetedProd.add(IMH_TestClassUtility.createCommTargetedProduct(lcommunication[0].ID,newprodList[i].Id,MARKET_NAME));
             lnewCommtargetedProd[i].SYS_UICreated__c = true;    
         } 
        IMH_TargetedProductTriggerHandler.isExecutionControl = false;
        Database.insert(lnewCommtargetedProd,true);
        //Update on Communication to make it Approved.
        List<IMH_CreativeProduct__c> lnewcreativeprods = new List<IMH_CreativeProduct__c>();
        for(Integer m=0;m<2;m++){
              lnewcreativeprods.add(IMH_TestClassUtility.createTargetedProduct(lcreative[1].Id,lnewCommtargetedProd[m].Id,'ANZ'));
        }
        Database.insert(lnewcreativeprods,true);
        System.assertEquals(3,[Select id from IMH_CreativeProduct__c Where Creative__c =:lcreative[0].Id LIMIT 50000].size()); 
        System.assertEquals(5,[Select id from IMH_CreativeProduct__c Where Creative__c =:lcreative[1].Id LIMIT 50000].size());
              
      //Inserting a new Creative Product
          List<IMH_ChannelREF__c> newchannelList=new List<IMH_ChannelREF__c>();          
            for(Integer i=0;i<3;i++) {
                newchannelList.add(IMH_TestClassUtility.createChannel(MARKET_NAME,'JAPA','AMEX'));
                newchannelList[i].Name='AMEX'+i;
            }
            newchannelList[0].RequiredApprovers__c = 'Brand and Advertising';
            Database.SaveResult[] srnewListChannel = Database.insert(newchannelList,false);
             
             
        List<IMH_CommChannels__c> lnewCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lnewCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(lcommunication[0].ID,newchannelList[i].Id));
             lnewCommtargetedChannel[i].SYS_UICreated__c = true;  
        }
        IMH_TargetedChannelTriggerHandler.isExecutionControl = false;
        Database.insert(lnewCommtargetedChannel,true);
             
             
        
        //Update on Communication to make it Approved.
        List<IMH_CreativeChannel__c> lnewcreativechannel = new List<IMH_CreativeChannel__c>();
        for(Integer m=0;m<2;m++){
              lnewcreativechannel.add(IMH_TestClassUtility.createTargetedChannel(lcreative[1].Id,lnewCommtargetedChannel[m].Id));
        }
        Database.insert(lnewcreativechannel,true);
             
             
                 //Update Creatives to Approved
        List<IMH_CommCreative__c> lupdatecreative = new List<IMH_CommCreative__c>();
        Integer k = 0;
            /* for(IMH_CommCreative__c create:[SELECT CreativeStatus__c,
                                             CreativeStage__c,
                                             Id
                                      FROM IMH_CommCreative__c
                                      WHERE ID IN:lcreative
                                       LIMIT 50000]){*/
                                       
           //if(k==0) {
                   lcreative[1].CreativeStatus__c = 'Cancelled'; 
                   lcreative[1].CreativeReviewCancellationReason__c = 'Campaign funding withdrawan';                             
             // }
          //else if(k==1){
                 lcreative[0].CreativeStatus__c = 'Approved'; 
                 lcreative[0].CreativeStage__c = 'Complete';
           //}
           // k++;  
             lupdatecreative.add(lcreative[0]);  
              lupdatecreative.add(lcreative[1]);                              
         //}
        Database.update(lupdatecreative,true);
         System.assertEquals(3,[Select id from IMH_CreativeProduct__c Where Creative__c =:lcreative[0].Id LIMIT 50000].size()); 
        System.assertEquals(5,[Select id from IMH_CreativeProduct__c Where Creative__c =:lcreative[1].Id LIMIT 50000].size());    
        
        for(IMH_Communication__c comms:[SELECT Id
                                              ,ProcessStage__c
                                              ,ReviewStatus__c
                                              ,ReviewStage__c
                                              ,RecordTypeId
                                              ,StartDate__c
                                              ,EndDate__c
                                              ,Submitter__c
                                              ,TargetMarket__c
                                        FROM IMH_Communication__c WHERE ID IN:lcommunication
                                       LIMIT 50000]){
            comms.ProcessStage__c = 'Ready for Execution';
            comms.ReviewStatus__c = 'Approved'; 
            comms.ReviewStage__c = 'Complete';
            comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
            lupdatecommunication.add(comms);                                
        }
        Database.update(lupdatecommunication);
         
          //ApexPages.currentPage().getParameters().put('clone','1'); 
          lclonedcommunication =lupdatecommunication.deepClone(false);
          //Update Communication Owner for Cloned Records
           for(IMH_Communication__c comms:[SELECT Submitter__c
                                        FROM IMH_Communication__c WHERE ID IN:lclonedcommunication
                                          LIMIT 50000]){
            comms.Submitter__c = UserInfo.getUserId();
            //comms.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketingCommunication_PreExecution').Id;
            lclonedcommunication.add(comms);                                
        }
        Test.startTest();
         IMH_CommunicationTriggerHandler.isExecutedAfter = false;
         Database.insert(lclonedcommunication,true);
        Test.stopTest();
         }
        //Assert The New Communiactions Created
        List<IMH_Communication__c> lcomms = [Select id,TargetMarket__c,ProcessStage__c,ReviewStage__c
                                             FROM IMH_Communication__c
                                             WHERE Id IN:lclonedcommunication
                                            LIMIT 50000];
        System.assertEquals(STAGE_NAME,lcomms[0].ProcessStage__c);
        System.assertEquals('Design',lcomms[0].ReviewStage__c);
        System.assertEquals(lcommunication.size(),lcomms.size());
        System.assertEquals(lcomms[0].TargetMarket__c,lcommunication[0].TargetMarket__c);
        //Asserting new Creatives Created
        List<IMH_CommCreative__c> lcreatives = [SELECT id
                                                       ,CreativeStatus__c
                                                       ,CreativeStage__c
                                                     
                                                FROM IMH_CommCreative__c
                                                WHERE Communication__c IN:lclonedcommunication
                                               LIMIT 50000];
        System.assertEquals(1,lcreatives.size());//Cancellation Check
        System.assertEquals('In Progress',lcreatives[0].CreativeStatus__c);
        System.assertEquals('Design',lcreatives[0].CreativeStage__c);
         
                 //Asserting new Targeted Products Created
        List<IMH_CommProducts__c> loldcommtargprod = [SELECT Id
                                                  FROM IMH_CommProducts__c
                                                  WHERE Communication__c IN:lupdatecommunication
                                                  LIMIT 50000];
        System.assertEquals(2,[SELECT id from IMH_CommProducts__c WHERE SYS_UICreated__c = TRUE
                               AND Communication__c IN:lupdatecommunication LIMIT 50000].size());
        System.assertEquals(5, loldcommtargprod.size());
        System.assertNotEquals(3, loldcommtargprod.size());
         //Asserting new Targeted Products Created
        List<IMH_CommProducts__c> lcommtargprod = [SELECT Id
                                                  FROM IMH_CommProducts__c
                                                  WHERE Communication__c IN:lcomms
                                                  LIMIT 50000];
        System.assertNotEquals(5, lcommtargprod.size());
        System.assertEquals(3, lcommtargprod.size());
        
                   //Asserting old Targeted Channels Created
        List<IMH_CommChannels__c> loldcommtargchannel = [SELECT Id,
                                                         Channel_End_Date__c,
                                                         Channel_Start_Date__c
                                                  FROM IMH_CommChannels__c
                                                  WHERE Communication__c IN:lupdatecommunication
                                                     LIMIT 50000];
         System.assertEquals(6, loldcommtargchannel.size());
         System.assertNotEquals(3, loldcommtargchannel.size());
        
                 //Asserting new Targeted Channels Created 
        List<IMH_CommChannels__c> lcommtargchannel = [SELECT Id,
                                                         Channel_End_Date__c,
                                                         Channel_Start_Date__c
                                                  FROM IMH_CommChannels__c
                                                  WHERE Communication__c IN:lcomms
                                                     LIMIT 50000];
          System.assertNotEquals(6, lcommtargchannel.size());
         System.assertEquals(3, lcommtargchannel.size());
        
    }  
    
}