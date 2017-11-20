/**
* @author Accenture IDC 
* @date 08/26/2016
* @group Answer
* @group-content N/A
* @description: iMH Release 1.6 (Sprint 43) - Test Class for CRB Report Generation.
*/
@isTest
private class IMH_CRBReportTest {
   private static final String STAGE_NAME = 'Concept';
   private static final String STATUS_NAME = 'In Progress';
   private static final String MARKET_NAME = 'Australia';
   private static final String OBJECT_NAME = 'Communication';
   private static final String PRODUCT_NAME                = 'ProdTest';
   private static final String CAMPAIGN_SUBMITTER_PROFILE  = 'iMH Campaign Submitter';
   private static final String SUBMITTER_RUNNING_USER      = 'RunningUserSubmitter';
   private static final String SUBMITTER_THAI              = 'Australia Submitter';
   private static final PageReference CRBREPORT_PAGE = Page.IMH_CRBReportPdf; 
     /**
    * @description: Test Method used to cover the positive scenario where we generate the reports with all the components.
    * @param: none
    * @return: void
    */  
    static testmethod void generateReport(){
        IMH_CRBReport pagecontroller;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= MARKET_NAME;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        System.runAs(runningUserSubmitter){
            List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
            
            //Communication Insertion
            for(Integer i=0;i<1;i++)
            {
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
                lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
            }
            Database.insert(lcommunication,true);
            
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
            
            Test.startTest();
                Test.setCurrentPage(CRBREPORT_PAGE);
                ApexPages.currentPage().getParameters().put('Id',lcommunication[0].Id);
                pagecontroller = new IMH_CRBReport();
            Test.stopTest();
            System.assertEquals(pagecontroller.lincentives.size(), loffers.size());
            System.assertEquals(pagecontroller.lchannelInfo.size(), lCommtargetedChannel.size());
            System.assertEquals(pagecontroller.mproductsgroupprods.get('Lending').size(), lCommtargetedProd.size());
            System.assertEquals(pagecontroller.communication.Name, lcommunication[0].Name);
       }
    }
    
  /**
    * @description: Test Method used to cover the positive scenario where we generate the reports with all the components except Incentives.
    * @param: none
    * @return: void
    */  
    static testmethod void generateReportwithoutIncentives(){
        IMH_CRBReport pagecontroller;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= MARKET_NAME;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        System.runAs(runningUserSubmitter){
            List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
            
            //Communication Insertion
            for(Integer i=0;i<1;i++)
            {
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
                lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
            }
            Database.insert(lcommunication,true);
            
            
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
            
            Test.startTest();
                Test.setCurrentPage(CRBREPORT_PAGE);
                ApexPages.currentPage().getParameters().put('Id',lcommunication[0].Id);
                pagecontroller = new IMH_CRBReport();
            Test.stopTest();
            System.assertEquals(0,pagecontroller.lincentives.size());
            System.assertEquals(pagecontroller.lchannelInfo.size(), lCommtargetedChannel.size());
            System.assertEquals(pagecontroller.mproductsgroupprods.get('Lending').size(), lCommtargetedProd.size());
            System.assertEquals(pagecontroller.communication.Name, lcommunication[0].Name);
       }
    }
      /**
    * @description: Test Method used to cover the positive scenario where we generate the reports with all the components except Cahnnels and different Products.
    * @param: none
    * @return: void
    */  
    static testmethod void generateReportwithoutChannels(){
        IMH_CRBReport pagecontroller;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= MARKET_NAME;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        System.runAs(runningUserSubmitter){
            List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
            
            //Communication Insertion
            for(Integer i=0;i<1;i++)
            {
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
                lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
            }
            Database.insert(lcommunication,true);
            
            
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
                if(i==0)
                  prodList[i].RequiredApprovers__c = 'Lending';
                else
                  prodList[i].RequiredApprovers__c = 'Charge';  
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
            
            Test.startTest();
                Test.setCurrentPage(CRBREPORT_PAGE);
                ApexPages.currentPage().getParameters().put('Id',lcommunication[0].Id);
                pagecontroller = new IMH_CRBReport();
            Test.stopTest();
            System.assertEquals(pagecontroller.lincentives.size(),loffers.size());
            System.assertEquals(0,pagecontroller.lchannelInfo.size());
            System.assertEquals(pagecontroller.mproductsgroupprods.get('Lending').size(), 2);
            System.assertEquals(pagecontroller.mproductsgroupprods.get('Charge').size(),1);
            System.assertEquals(pagecontroller.communication.Name, lcommunication[0].Name);
       }
    }
  
    /**
    * @description: Test Method used to cover the positive scenario where we generate the reports with all the components except Cahnnels and different Products.
    * @param: none
    * @return: void
	*/  
    static testmethod void generateReportwithmultipleapprover(){
        IMH_CRBReport pagecontroller;
        
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        UserRole submitterRole = [SELECT Id, Name FROM UserRole WHERE Name =: SUBMITTER_THAI LIMIT 1];
        runningUserSubmitter.Market__c= MARKET_NAME;
        runningUserSubmitter.UserRoleId= submitterRole.Id;
        System.runAs(runningUserSubmitter){
            List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
            
            //Communication Insertion
            for(Integer i=0;i<1;i++)
            {
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
                lcommunication[i].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
            }
            Database.insert(lcommunication,true);
            
            
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
                if(i==0)
                  prodList[i].RequiredApprovers__c = 'Lending;AU Charge';
                else
                  prodList[i].RequiredApprovers__c = 'Charge';  
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
            
            Test.startTest();
                Test.setCurrentPage(CRBREPORT_PAGE);
                ApexPages.currentPage().getParameters().put('Id',lcommunication[0].Id);
                pagecontroller = new IMH_CRBReport();
            Test.stopTest();
            System.assertEquals(pagecontroller.lincentives.size(),loffers.size());
            System.assertEquals(0,pagecontroller.lchannelInfo.size());
            System.assertEquals(pagecontroller.mproductsgroupprods.get('Lending').size(), 2);
            System.assertEquals(pagecontroller.mproductsgroupprods.get('AU Charge').size(), 2);
            System.assertEquals(pagecontroller.mproductsgroupprods.get('Charge').size(),1);
            System.assertEquals(pagecontroller.communication.Name, lcommunication[0].Name);
       }
    }
}