/**
    * @author Accenture IDC 
    * @date 11/05/2015
    * @group Answer
    * @group-content N/A
    * @description: iMH Release 1.2 (Sprint 10) - Test Class for adding products on Communication object.
*/
@isTest
private class IMH_AddChannelsProductsControllerTest{

    private static final String     PRODUCT_NAME           = 'ProdTest';
    private static final String     STAGE_NAME             = 'Concept';
    private static final String     STATUS_NAME            = 'In Progress';
    private static final String     MARKET_NAME            = 'Thailand';    
    private static final String     OFFER_STATUS           = 'In Progress';
    private static final String     MARKET_THAILAND        = 'Thailand';
    private static final Boolean    ACTIVE                 = true;
    private static final String     COLOUR_GOLD            = 'Gold';
    private static final String     PRODUCT_API            = 'IMH_Product__c';
    private static final String     CHANNEL_API            = 'IMH_ChannelREF__c';
    private static final String     CREATIVE_API_NAME      = 'IMH_CommCreative__c';
    private static final String     CREATE_NAME            = 'CreativeDesign';
    private static final String     BENEFIT_API            = 'IMH_Benefits__c';
    private static final String     INIT_TEXT              = 'init';
    private static final String     ID_TEXT                = 'id';
    private static final String     COMM_NAME              = 'cname';
    private static final String     SAMPLE_COMM_NAME       = 'TESTABC';
    private static final String     ACCEPTED               = 'Accepted';
    private static final String     REGION_JAPA            = 'JAPA';
    private static final String     LOCAL_BENEFIT          = 'Local';
    private static final String     AMEX                   = 'AMEX';

    /**
    * @description: Method used to add products on Communication Object
    * @param: none
    * @return: void
    */
   static testMethod void addProductsTest(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
        }                        
        Database.SaveResult[] srList = Database.insert(CommunicationList,false);
        //ASSERT IF Communication RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(1,CommunicationList.size());
        id insertedCommunicationID;
        for(Database.SaveResult sr: srList){    
            if(sr.isSuccess()){
                insertedCommunicationID = sr.getId();
            }
        }
        //Test Data for Creative
        List<IMH_CommCreative__c> creativeList = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<1;i++){            
            creativeList.add(IMH_TestClassUtility.createFinalCreative(insertedCommunicationID,STATUS_NAME,
                                                                      IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATE_NAME).Id));
        }                        
        Database.SaveResult[] creativeInsList = Database.insert(creativeList,false);
        System.assertEquals(1,CommunicationList.size());
        id insertedCreativeId;
        for(Database.SaveResult sr: creativeInsList){    
            if(sr.isSuccess()){
                insertedCreativeId = sr.getId();
            }
        }
        //TestData for Product object
        List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
        for(Integer i=0;i<5;i++) {
            prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GOLD));
            prodList[i].Name=PRODUCT_NAME+i;
        }                         
        Database.SaveResult[] productList = Database.insert(prodList,false);
        Id insertedproductId;
        insertedproductId = productList[0].getId();
        //ASSERT IF Product RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(5,prodList.size());
        //TestData for TargetedProduct object
        List<IMH_CreativeProduct__c> targetedProdList = new List<IMH_CreativeProduct__c>();  
        targetedProdList.add(IMH_TestClassUtility.createTargetedProduct(insertedCreativeId,insertedproductId,MARKET_THAILAND));
        Database.insert(targetedProdList,false);
        String selectedSObject         = ApexPages.currentPage().getParameters().put('ea0','pr2');
        String selectedsObjectRecordId = ApexPages.currentPage().getParameters().put(ID_TEXT,insertedCreativeId);
        String CommunicationName            = ApexPages.currentPage().getParameters().put(COMM_NAME,SAMPLE_COMM_NAME);    
        Test.startTest();    
        IMH_AddChannelsProductsController product = new IMH_AddChannelsProductsController();   
        Test.stopTest();  
     }
  /**
    * @description: Method used to add channels on Communication Object
    * @param: none
    * @return: void
    */
    static testMethod void addChannelsTest(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
        }                        
        Database.SaveResult[] srList = Database.insert(CommunicationList,false);
        //ASSERT IF Communication RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(1,CommunicationList.size());
        id insertedCommunicationID;
        for(Database.SaveResult sr: srList){    
            if(sr.isSuccess()){
                insertedCommunicationID = sr.getId();
            }
        }
        //Test Data for Creative
        List<IMH_CommCreative__c> creativeList = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<1;i++){            
            creativeList.add(IMH_TestClassUtility.createFinalCreative(insertedCommunicationID,STATUS_NAME,
                                                                      IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATE_NAME).Id));
        }                        
        Database.SaveResult[] creativeInsList = Database.insert(creativeList,false);
        System.assertEquals(1,CommunicationList.size());
        id insertedCreativeId;
        for(Database.SaveResult sr: creativeInsList){    
            if(sr.isSuccess()){
                insertedCreativeId = sr.getId();
            }
        }
        List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
        for(Integer i=0;i<5;i++) {
            channelList.add(IMH_TestClassUtility.createChannel(MARKET_THAILAND,REGION_JAPA,AMEX));
            channelList[i].Name=AMEX+i;
        }
        Database.SaveResult[] srListChannel = Database.insert(channelList,false);
        Id insertedChannelId;
        insertedChannelId = srListChannel[0].getId();
        //TestData for TargetedProduct object
        List<IMH_CreativeChannel__c> targetedChannelList = new List<IMH_CreativeChannel__c>();  
        targetedChannelList.add(IMH_TestClassUtility.createTargetedChannel(insertedCreativeId,insertedChannelId));
        Database.insert(targetedChannelList,false);
        String selectedSObject         = ApexPages.currentPage().getParameters().put('ea0','ch2');
        String selectedsObjectRecordId = ApexPages.currentPage().getParameters().put(ID_TEXT,insertedCreativeId);     
        Test.startTest();
        IMH_AddChannelsProductsController channel = new IMH_AddChannelsProductsController();    
        Test.stopTest();      
    } 

    /**
    * @description: Method used to add benefits on Communication Object
    * @param: none
    * @return: void
    */
    static testMethod void addBenefitsTest(){
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
            CommunicationList[i].Communication_Type__c = 'Pre-Approved Benefit';
        }                        
        Database.SaveResult[] srList = Database.insert(CommunicationList,false);
        id insertedCommunicationID = srList[0].getId();
        //TestData for Benefit object
        List<IMH_Benefits__c> benefitList=new List<IMH_Benefits__c>();          
        for(Integer i=0;i<2;i++) {
            benefitList.add(IMH_TestClassUtility.createBenefits(LOCAL_BENEFIT,REGION_JAPA,MARKET_THAILAND));
            benefitList[i].ApprovalStage__c = ACCEPTED;
        }                         
        Database.SaveResult[] srBenefitList = Database.insert(benefitList,true);
        String insertedBenefitId;
        insertedBenefitId = srBenefitList[0].getId();
        //Test Data for Pre-Approved Benefit
        List<IMH_PreApprovedBenefits__c> preApprovedBeneInsertList = new List<IMH_PreApprovedBenefits__c>();
        preApprovedBeneInsertList.add(IMH_TestClassUtility.createPreApprovedBenefits(insertedCommunicationID,insertedBenefitId));
        Database.SaveResult[] srPreBenefitList = Database.insert(preApprovedBeneInsertList,true);
        String selectedSObject         = ApexPages.currentPage().getParameters().put('ea0','be1');
        String selectedsObjectRecordId = ApexPages.currentPage().getParameters().put(ID_TEXT,insertedCommunicationID);
        
        Test.startTest();    
        IMH_AddChannelsProductsController benefit = new IMH_AddChannelsProductsController();   
        Test.stopTest();  
     }
        /**
        * @description: Negative Method used to add products on Communication Object
        * @param: none
        * @return: void
        */
    static testMethod void bankingPartnerTest(){
        //TestData for Communication object
        RecordType bankingPatnerRecType = [SELECT DeveloperName,Id,SobjectType FROM RecordType 
                                           WHERE DeveloperName = 'MarketingCommunication_BP' 
                                           AND SobjectType = 'IMH_Communication__c' LIMIT 1];
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
            CommunicationList[0].RecordTypeId = bankingPatnerRecType.Id;
        }                        
        Database.SaveResult[] srList = Database.insert(CommunicationList,false);
        //ASSERT IF Communication RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(1,CommunicationList.size());
        id insertedCommunicationID;
        for(Database.SaveResult sr: srList){    
            if(sr.isSuccess()){
                insertedCommunicationID = sr.getId();
            }
        }
        /*//Test Data for Creative
        List<IMH_CommCreative__c> creativeList = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<1;i++){            
            creativeList.add(IMH_TestClassUtility.createFinalCreative(insertedCommunicationID,STATUS_NAME,
                                                                      IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATE_NAME).Id));
        }                        
        Database.SaveResult[] creativeInsList = Database.insert(creativeList,false);
        System.assertEquals(1,CommunicationList.size());
        id insertedCreativeId;
        for(Database.SaveResult sr: creativeInsList){    
            if(sr.isSuccess()){
                insertedCreativeId = sr.getId();
            }
        }
        //TestData for Product object
        */
		List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
        for(Integer i=0;i<5;i++) {
            prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GOLD));
            prodList[i].Name=PRODUCT_NAME+i;
        }                         
        Database.SaveResult[] productList = Database.insert(prodList,false);
        Id insertedproductId;
        insertedproductId = productList[0].getId();
        //ASSERT IF Product RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(5,prodList.size());
        //TestData for TargetedProduct object
        List<IMH_CommProducts__c> targetedProdList = new List<IMH_CommProducts__c>();  
        targetedProdList.add(IMH_TestClassUtility.createCommTargetedProduct(insertedCommunicationID,insertedproductId,MARKET_THAILAND));
        Database.insert(targetedProdList,false);
        String selectedSObject         = ApexPages.currentPage().getParameters().put('ea0','pr1');
        String selectedsObjectRecordId = ApexPages.currentPage().getParameters().put(ID_TEXT,insertedCommunicationID);
        String CommunicationName       = ApexPages.currentPage().getParameters().put(COMM_NAME,SAMPLE_COMM_NAME);    
        Test.startTest();    
        IMH_AddChannelsProductsController product = new IMH_AddChannelsProductsController();   
        Test.stopTest();  
        System.assertEquals(false,product.captureInputOnChild);
     }
             /**
        * @description: Positive Method used to add products on Creative Object
        * @param: none
        * @return: void
        */
    static testMethod void bankingPartnerCreativeTest(){
        //TestData for Communication object
        RecordType bankingPatnerRecType = [SELECT DeveloperName,Id,SobjectType FROM RecordType 
                                           WHERE DeveloperName = 'MarketingCommunication_BP' 
                                           AND SobjectType = 'IMH_Communication__c' LIMIT 1];
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
            CommunicationList[0].RecordTypeId = bankingPatnerRecType.Id;
        }                        
        Database.SaveResult[] srList = Database.insert(CommunicationList,false);
        //ASSERT IF Communication RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(1,CommunicationList.size());
        id insertedCommunicationID;
        for(Database.SaveResult sr: srList){    
            if(sr.isSuccess()){
                insertedCommunicationID = sr.getId();
            }
        }
        //Test Data for Creative
        List<IMH_CommCreative__c> creativeList = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<1;i++){            
            creativeList.add(IMH_TestClassUtility.createFinalCreative(insertedCommunicationID,STATUS_NAME,
                                                                      IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATE_NAME).Id));
        }                        
        Database.SaveResult[] creativeInsList = Database.insert(creativeList,false);
        System.assertEquals(1,CommunicationList.size());
        id insertedCreativeId;
        for(Database.SaveResult sr: creativeInsList){    
            if(sr.isSuccess()){
                insertedCreativeId = sr.getId();
            }
        }
        //TestData for Product object
        
		List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
        for(Integer i=0;i<5;i++) {
            prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GOLD));
            prodList[i].Name=PRODUCT_NAME+i;
        }                         
        Database.SaveResult[] productList = Database.insert(prodList,false);
        Id insertedproductId;
        insertedproductId = productList[0].getId();
        //ASSERT IF Product RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(5,prodList.size());
        //TestData for TargetedProduct object
        List<IMH_CommProducts__c> targetedProdList = new List<IMH_CommProducts__c>();  
        targetedProdList.add(IMH_TestClassUtility.createCommTargetedProduct(insertedCommunicationID,insertedproductId,MARKET_THAILAND));
        IMH_TargetedProductTriggerHandler.isExecutionControl = false;
        Database.insert(targetedProdList,false);
        
        //INserting the creative products
         List<IMH_CreativeProduct__c> lnewcreativeprods = new List<IMH_CreativeProduct__c>();
        for(Integer m=0;m<2;m++){
              lnewcreativeprods.add(IMH_TestClassUtility.createTargetedProduct(creativeInsList[0].Id,targetedProdList[0].Id,'Other'));
        }
        Database.insert(lnewcreativeprods,true);
        
        
        String selectedSObject         = ApexPages.currentPage().getParameters().put('ea0','pr1');
        String selectedsObjectRecordId = ApexPages.currentPage().getParameters().put(ID_TEXT,creativeInsList[0].Id);
        String CommunicationName       = ApexPages.currentPage().getParameters().put(COMM_NAME,SAMPLE_COMM_NAME);    
        Test.startTest();    
        IMH_AddChannelsProductsController product = new IMH_AddChannelsProductsController();   
        Test.stopTest();  
        System.assertEquals(true,product.captureInputOnChild);
     }
       
}