/**
    * @author Accenture IDC 
    * @date 11/03/2015
    * @group Answer
    * @group-content N/A
    * @description: iMH Release 1.2 (Sprint 10) - Test Class for adding products on Communication object.
*/
@isTest
private class IMH_AddChildItemsOnParentControllerTest{
    private static final String     PRODUCT_OBJECT_API     = 'IMH_Product__c';
    private static final String     CHANNEL_OBJECT_API     = 'IMH_ChannelREF__c';
    private static final String     CREATIVE_API_NAME      = 'IMH_CommCreative__c';
    private static final String     CP_CHANNEL_OBJECT_API  = 'IMH_CreativeChannel__c';
    private static final String     CREATE_NAME            = 'CreativeDesign';
    private static final String     RULE_INDEX             = 'ruleRowIndex';
    private static final String     STAGE_NAME             = 'Concept';
    private static final String     CREATIVE_STAGE         = 'Creative';
    private static final String     STATUS_NAME            = 'In Progress';
    private static final String     MARKET_THAILAND        = 'Thailand';
    private static final String     MARKET_TAIWAN          = 'Taiwan';
    private static final String     MARKET_ONEINDIA        = 'ONE India';
    private static final String     REGION_JAPA            = 'JAPA';
    private static final String     AMEX_TEXT              = 'AMEX';
    private static final String     PRODUCT_NAME           = 'ProdTest';
    private static final Boolean    ACTIVE                 = true;
    private static final String     COLOUR_BLUE            = 'Blue';
    private static final String     COLOUR_GREEN           = 'Green';
    private static final String     COLOUR_GOLD            = 'Gold';
    private static final String     NAME_TEXT              = 'Name';
    private static final String     CONTAINS_TEXT          = 'Contains';
    private static final String     EQUALS_TEXT            = '=';
    private static final String     BOOLEAN_TRUE           = 'TRUE'; 
    private static final String     BOOLEAN_FALSE          = 'FALSE';
    private static final String     STARTS_WITH_TEXT       = 'Starts with';
    private static final String     PROD_TEXT              = 'Prod';
    private static final String     ACTIVE_FIELD_API       = 'Active__c';
    private static final String     TODAY_TEXT             = 'Today';
    private static final String     CREATED_DATE           = 'CreatedDate';
    private static final String     NO_TEXT                = 'No';
    private static final String     COLOUR_FIELD_API       = 'Colour__c';
    private static final String     VALUE_ONE              = '1';
    private static final String     BLANK_SPACE            = '';
    private static final String     PROD_REGION_API        = 'Region__c';
    private static final String     PR_TEXT                = 'PR';
    private static final String     EMBEDDED_BENE_REC      = 'EmbeddedBenefits';
    private static final String     IP_START_DATE          = '10/12/2015';
    private static final String     IP_END_DATE            = '10/13/2015';
    private static final String     COMPLETE               = 'Complete';
    private static final String     IN_REVIEW              = 'In Review';
    private static final String     PREAPPROVEDBENEFIT     = 'Pre-Approved Benefit';
    private static final String     LOCAL                  = 'Local';
    private static final String     ACCEPTED               = 'Accepted';
    private static final String     BENEFIT_API            = 'IMH_Benefits__c';
    private static final String     MARKET_FIELD_API       = 'Market__c';
    private static final String     INCLUDES               = 'Includes';
    private static final String     CONCEPT_ATTESTAION     = 'Concept-Attestation';
    
    

    /**
    * @description: Test Method used to add products on Communication Object
    * @param: none
    * @return: void
    */
    static testMethod void generalTestForProduct(){
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
        for(Integer i=0;i<200;i++) {
            if(i<150) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GOLD));
                prodList[i].Name=PRODUCT_NAME+i;
                prodList[i].Region__c=REGION_JAPA;
            }
            else if(i<175) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GREEN));
                prodList[i].Name=PRODUCT_NAME+i;                         
            }   
            else {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_TAIWAN,ACTIVE,COLOUR_BLUE));
                prodList[i].Name=PRODUCT_NAME+i;
            }             
        }                         
        Database.SaveResult[] productList = Database.insert(prodList,false);
        String insertedproductId;
        insertedproductId = productList[0].getId();
        //ASSERT IF Product RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(200,prodList.size());
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.initiateSearch=BLANK_SPACE;
        controller.childObject = PRODUCT_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild=BOOLEAN_FALSE;
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.getListOfFields();
        controller.ListOfConditions();        
        IMH_AddChildItemsOnParentController.SearchFieldsWrapper sfWrapRecord;
        List<IMH_AddChildItemsOnParentController.SearchFieldsWrapper> fieldRuleWrapperList = new List<IMH_AddChildItemsOnParentController.SearchFieldsWrapper>();
        for(integer i=0; i<2; i++) {
            sfWrapRecord = new IMH_AddChildItemsOnParentController.SearchFieldsWrapper();
            sfWrapRecord.searchField = NAME_TEXT;
            sfWrapRecord.searchOperator = CONTAINS_TEXT;
            sfWrapRecord.searchParam = PRODUCT_NAME;    
            fieldRuleWrapperList.add(sfWrapRecord);
        }  
        System.assertEquals(2,fieldRuleWrapperList.size());
        IMH_AddChildItemsOnParentController.SearchFieldsWrapper sfWrapRecord4 = new IMH_AddChildItemsOnParentController.SearchFieldsWrapper();
        sfWrapRecord4.searchField = NAME_TEXT;
        sfWrapRecord4.searchOperator = STARTS_WITH_TEXT;
        sfWrapRecord4.searchParam = PR_TEXT;
        fieldRuleWrapperList.add(sfWrapRecord4);        
        controller.SearchFieldsWrapperList = fieldRuleWrapperList;
        IMH_AddChildItemsOnParentController.SearchFieldsWrapper sfWrapRecord5 = new IMH_AddChildItemsOnParentController.SearchFieldsWrapper();
        sfWrapRecord5.searchField = PROD_REGION_API;
        sfWrapRecord5.searchOperator = EQUALS_TEXT;
        sfWrapRecord5.searchParam = REGION_JAPA;
        fieldRuleWrapperList.add(sfWrapRecord5);        
        controller.SearchFieldsWrapperList = fieldRuleWrapperList;
        ApexPages.currentPage().getParameters().put(RULE_INDEX,VALUE_ONE); 
        controller.RemoveSearchRule();            
        controller.startSearch();
        controller.filteredSObjectWrapList();
        controller.getnxt();
        controller.getprev();
        controller.next();
        controller.beginning();
        controller.end();
        controller.previous();
        controller.sObjectWrapperList.get(0).isSelected = true; 
        controller.sObjectWrapperList.get(1).isSelected = true;  
        controller.processSelected();
        controller.cancelAdding();
        Test.stopTest();  
        System.assertNotEquals(0,controller.sObjectWrapperList.size());     
        List<IMH_CreativeProduct__c> CommunicationProdList = new List<IMH_CreativeProduct__c>();
        CommunicationProdList = [SELECT Id, Creative__c FROM IMH_CreativeProduct__c WHERE Creative__c=: insertedCreativeId LIMIT 50000];
        System.assertEquals(2,CommunicationProdList.size());
    }

    /**
    * @description: Test Method used to prevent product from adding through validation rule
    * @param: none
    * @return: void
    */
    static testMethod void productPreventAdd(){
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
        for(Integer i=0;i<1;i++) {
            prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,false,COLOUR_GOLD));
            prodList[i].Name=PRODUCT_NAME;
            prodList[i].Region__c=REGION_JAPA;
        }                         
        Database.SaveResult[] productList = Database.insert(prodList,false);
        String insertedproductId;
        insertedproductId = productList[0].getId();
        //ASSERT IF Product RECORDS ARE CREATED WITH EXPECTED RESULTS 
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.initiateSearch=BLANK_SPACE;
        controller.childObject = PRODUCT_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild=BOOLEAN_FALSE;
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.startSearch();
        controller.filteredSObjectWrapList();
        controller.sObjectWrapperList.get(0).isSelected = true; 
        controller.processSelected();
        Test.stopTest();  
        List<IMH_CreativeProduct__c> CommunicationProdList = new List<IMH_CreativeProduct__c>();
        CommunicationProdList = [SELECT Id, Creative__c FROM IMH_CreativeProduct__c WHERE Creative__c=: insertedCreativeId LIMIT 50000];
        System.assertEquals(0,CommunicationProdList.size());
    }
    
    
    /**
    * @description: Test Method used to delete already selected products on Creative Object
    * @param: none
    * @return: void
    */
    static testMethod void productAlreadyAddMoreAndDeleteTest(){
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
        //TestData for Product object
        List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
        for(Integer i=0;i<5;i++) {
            prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GOLD));
            prodList[i].Name=PRODUCT_NAME+i;
        }                         
        prodList[4].Active__c = false;
        Database.SaveResult[] productList = Database.insert(prodList,false);
        Id insertedproductId;
        insertedproductId = productList[0].getId();
        //ASSERT IF Product RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(5,prodList.size());
        //TestData for CommunicationProduct object
        List<IMH_CommProducts__c> commProdList = new List<IMH_CommProducts__c>();  
        commProdList.add(IMH_TestClassUtility.createCommTargetedProduct(insertedCommunicationID,insertedproductId,MARKET_THAILAND));
        Database.SaveResult[] commProdListSR = Database.insert(commProdList,false);
        Id insertedCommproductId = commProdListSR[0].getId();
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
        //TestData for TargetedProduct object
        List<IMH_CreativeProduct__c> targetedProdList = new List<IMH_CreativeProduct__c>();  
        targetedProdList.add(IMH_TestClassUtility.createTargetedProduct(insertedCreativeId,insertedCommproductId,MARKET_THAILAND));
        Database.insert(targetedProdList,false);
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = PRODUCT_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild=BOOLEAN_FALSE;
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.addedChildsList.add(insertedproductId);
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.startSearch();        
        System.assertEquals(false,controller.sObjectWrapperList.get(0).isSelected);
        controller.sObjectWrapperList.get(0).isSelected = false; 
        controller.sObjectWrapperList.get(1).isSelected = true; 
        controller.sObjectWrapperList.get(2).isSelected = true;  
        controller.sObjectWrapperList.get(4).isSelected = true;  
        controller.processSelected();
        Test.stopTest();  
        System.assertEquals(5,controller.sObjectWrapperList.size());     
        List<IMH_CreativeProduct__c> CommunicationProdList = new List<IMH_CreativeProduct__c>();
        CommunicationProdList = [SELECT Id, Creative__c FROM IMH_CreativeProduct__c WHERE Creative__c=: insertedCreativeId LIMIT 50000];
        System.assertEquals(2,CommunicationProdList.size());
    }
    
     /**
    * @description: Test Method used to delete already selected products on Creative Object
    * @param: none
    * @return: void
    */
    static testMethod void productPreventDelete(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
        }                        
        Database.SaveResult[] srList = Database.insert(CommunicationList,false);
        id insertedCommunicationID;
        for(Database.SaveResult sr: srList){    
            if(sr.isSuccess()){
                insertedCommunicationID = sr.getId();
            }
        }
        //TestData for Product object
        List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
        for(Integer i=0;i<5;i++) {
            prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GOLD));
            prodList[i].Name=PRODUCT_NAME+i;
        }                         
        prodList[4].Active__c = false;
        Database.SaveResult[] productList = Database.insert(prodList,false);
        Id insertedproductId;
        insertedproductId = productList[0].getId();
        //TestData for CommunicationProduct object
        List<IMH_CommProducts__c> commProdList = new List<IMH_CommProducts__c>();  
        commProdList.add(IMH_TestClassUtility.createCommTargetedProduct(insertedCommunicationID,insertedproductId,MARKET_THAILAND));
        Database.SaveResult[] commProdListSR = Database.insert(commProdList,false);
        Id insertedCommproductId = commProdListSR[0].getId();
        //Test Data for Creative
        List<IMH_CommCreative__c> creativeList = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<1;i++){            
            creativeList.add(IMH_TestClassUtility.createFinalCreative(insertedCommunicationID,STATUS_NAME,
                                                                      IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATE_NAME).Id));
            creativeList[i].CreativeStage__c = COMPLETE;
        }                        
        Database.SaveResult[] creativeInsList = Database.insert(creativeList,false);
        System.assertEquals(1,CommunicationList.size());
        id insertedCreativeId;
        for(Database.SaveResult sr: creativeInsList){    
            if(sr.isSuccess()){
                insertedCreativeId = sr.getId();
            }
        }
        //TestData for TargetedProduct object
        List<IMH_CreativeProduct__c> targetedProdList = new List<IMH_CreativeProduct__c>();  
        targetedProdList.add(IMH_TestClassUtility.createTargetedProduct(insertedCreativeId,insertedCommproductId,MARKET_THAILAND));
        Database.insert(targetedProdList,false);
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = PRODUCT_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild=BOOLEAN_FALSE;
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.addedChildsList.add(insertedproductId);
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.startSearch();        
        System.assertEquals(false,controller.sObjectWrapperList.get(0).isSelected);
        controller.sObjectWrapperList.get(0).isSelected = false; 
        controller.sObjectWrapperList.get(1).isSelected = true; 
        controller.sObjectWrapperList.get(2).isSelected = true;  
        controller.sObjectWrapperList.get(4).isSelected = true;  
        controller.processSelected();
        Test.stopTest();  
        List<IMH_CreativeProduct__c> CommunicationProdList = new List<IMH_CreativeProduct__c>();
        CommunicationProdList = [SELECT Id, Creative__c FROM IMH_CreativeProduct__c WHERE Creative__c=: insertedCreativeId LIMIT 50000];
        System.assertEquals(2,CommunicationProdList.size());
    }
    /**
    * @description: Test Method used to check the functionality when Product has no Market
    * @param: none
    * @return: void
    */
    static testMethod void NoMarketTestProduct(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
            CommunicationList[i].TargetRegion__c=REGION_JAPA;
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
                    
        for(Integer i=0;i<15;i++) {
            if(i<5) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GOLD));
                prodList[i].Name=PRODUCT_NAME+i;
                prodList[i].Region__c=REGION_JAPA;
            }
            else if(i<10) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GREEN));
                prodList[i].Name=PRODUCT_NAME+i;                         
            }   
            else {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_TAIWAN,ACTIVE,COLOUR_BLUE));
                prodList[i].Name=PRODUCT_NAME+i;
                
            }             
        }                         
        Database.SaveResult[] productList = Database.insert(prodList,false);
        System.assertEquals(15,prodList.size());
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = PRODUCT_OBJECT_API;
        controller.targetMarket=BLANK_SPACE;
        controller.targetRegion=REGION_JAPA;
        controller.captureInputOnChild=BOOLEAN_FALSE;
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.getListOfFields();
        controller.startSearch();
        Test.stopTest();
        System.assertEquals(5,controller.sObjectWrapperList.size());
    }
   /**
    * @description: Test Method used to check the functionality of key qord search functionality
    * @param: none
    * @return: void
    */ 
    static testMethod void keyWordSearchTestProduct(){
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
                    
        for(Integer i=0;i<15;i++) {
            if(i<5) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GOLD));
                prodList[i].Name=PRODUCT_NAME+i;
            }
            else if(i<10) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GREEN));
                prodList[i].Name=PRODUCT_NAME+i;                         
            }   
            else {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_TAIWAN,ACTIVE,COLOUR_BLUE));
                prodList[i].Name=PRODUCT_NAME+i;
            }             
        }                         
        Database.SaveResult[] productList = Database.insert(prodList,false);
        String insertedproductId;
        insertedproductId = productList[0].getId();
        //ASSERT IF Product RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertNotEquals(0,prodList.size());
        System.assertEquals(15,prodList.size());
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = PRODUCT_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild=BOOLEAN_FALSE;
        controller.keywordParam=PROD_TEXT;
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.getListOfFields();
        controller.startSearch();
        Test.stopTest();
        System.assertEquals(10,controller.sObjectWrapperList.size());
    }
   /**
    * @description: Test Method used to check the functionality when Creative Products are already present.
    * @param: none
    * @return: void
    */  
    static testMethod void NoSelectOrUnSelectTestProduct(){
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
                    
        for(Integer i=0;i<15;i++) {
            if(i<5) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GOLD));
                prodList[i].Name=PRODUCT_NAME+i;
            }
            else if(i<10) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GREEN));
                prodList[i].Name=PRODUCT_NAME+i;                         
            }   
            else {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_TAIWAN,ACTIVE,COLOUR_BLUE));
                prodList[i].Name=PRODUCT_NAME+i;
            }             
        }                         
        Database.SaveResult[] productList = Database.insert(prodList,false);
        String insertedproductId;
        insertedproductId = productList[0].getId();
        //ASSERT IF Product RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertNotEquals(0,prodList.size());
        System.assertEquals(15,prodList.size());
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = PRODUCT_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild=BOOLEAN_FALSE;
        controller.keywordParam=PROD_TEXT;
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.getListOfFields();
        controller.startSearch();
        controller.processSelected();
        Test.stopTest();
        System.assertEquals(10,controller.sObjectWrapperList.size());
    }
    /**
    * @description: Test Method used to check the functionality where no records are retrieved due to difference in Market.
    * @param: none
    * @return: void
    */ 
    static testMethod void noRecordsRetrievedTest(){
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
        for(Integer i=0;i<15;i++) {
            if(i<5) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GOLD));
                prodList[i].Name=PRODUCT_NAME+i;
            }
            else if(i<10) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GREEN));
                prodList[i].Name=PRODUCT_NAME+i;                         
            }   
            else {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_TAIWAN,ACTIVE,COLOUR_BLUE));
                prodList[i].Name=PRODUCT_NAME+i;
            }             
        }                         
        Database.SaveResult[] productList = Database.insert(prodList,false);
        String insertedproductId;
        insertedproductId = productList[0].getId();
        //ASSERT IF Product RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertNotEquals(0,prodList.size());
        System.assertEquals(15,prodList.size());
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = PRODUCT_OBJECT_API;
        controller.targetMarket = MARKET_ONEINDIA;
        controller.captureInputOnChild=BOOLEAN_FALSE;
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.startSearch();        
        Test.stopTest();  
        System.assertEquals(0,controller.sObjectWrapperList.size());     
    }
  /**
    * @description: Test Method used to check the functionality when Channels are added at Creative Stage.
    * @param: none
    * @return: void
    */   
    static testMethod void generalTestForChannel(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
        }                        
        Database.SaveResult[] srListCommunication = Database.insert(CommunicationList,false);
        //ASSERT IF Communication RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(1,CommunicationList.size());
        id insertedCommunicationID;
        for(Database.SaveResult sr: srListCommunication){    
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
        for(Integer i=0;i<15;i++) {
            if(i<5) {
                channelList.add(IMH_TestClassUtility.createChannel(MARKET_THAILAND,REGION_JAPA,AMEX_TEXT));
                channelList[i].Name=AMEX_TEXT+i;
            }
            else if(i<10) {
                channelList.add(IMH_TestClassUtility.createChannel(MARKET_THAILAND,REGION_JAPA,AMEX_TEXT));
                channelList[i].Name=AMEX_TEXT+i;                         
            }   
            else {
                channelList.add(IMH_TestClassUtility.createChannel(MARKET_TAIWAN,REGION_JAPA,AMEX_TEXT));
                channelList[i].Name=AMEX_TEXT+i;
            }             
        }
        insert channelList;
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = CHANNEL_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.childJunctionObject=CP_CHANNEL_OBJECT_API;
        controller.captureInputOnChild=BOOLEAN_TRUE;
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.getListOfFields();
        controller.ListOfConditions();        
        ApexPages.currentPage().getParameters().put(RULE_INDEX,VALUE_ONE); 
        controller.RemoveSearchRule();            
        controller.startSearch();        
        controller.sObjectWrapperList.get(0).isSelected = true; 
        controller.sObjectWrapperList.get(1).isSelected = true;  
        controller.processSelected();
        controller.cancelAdding();
        Test.stopTest();  
        System.assertNotEquals(0,controller.sObjectWrapperList.size());     
        List<IMH_CreativeChannel__c> CommunicationChannelList = new List<IMH_CreativeChannel__c>();
        CommunicationChannelList = [SELECT Id, Creative__c FROM IMH_CreativeChannel__c WHERE Creative__c =: insertedCreativeId LIMIT 50000];
        System.assertEquals(2,CommunicationChannelList.size());
    }

    /**
    * @description: Test Method used to cover channel prevent insert
    * @param: none
    * @return: void
    */
    static testMethod void channelPreventAdd(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
        }                        
        Database.SaveResult[] srListCommunication = Database.insert(CommunicationList,false);
        //ASSERT IF Communication RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(1,CommunicationList.size());
        id insertedCommunicationID;
        for(Database.SaveResult sr: srListCommunication){    
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
        for(Integer i=0;i<1;i++) {
            channelList.add(IMH_TestClassUtility.createChannel(MARKET_THAILAND,REGION_JAPA,AMEX_TEXT));
            channelList[i].Active__c = false;
        }
        insert channelList;
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = CHANNEL_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.childJunctionObject=CP_CHANNEL_OBJECT_API;
        controller.captureInputOnChild=BOOLEAN_TRUE;
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.startSearch();        
        controller.sObjectWrapperList.get(0).isSelected = true; 
        controller.processSelected();
        Test.stopTest();  
        List<IMH_CreativeChannel__c> CommunicationChannelList = new List<IMH_CreativeChannel__c>();
        CommunicationChannelList = [SELECT Id, Creative__c FROM IMH_CreativeChannel__c WHERE Creative__c =: insertedCreativeId LIMIT 50000];
        System.assertEquals(0,CommunicationChannelList.size());
    }
    /**
    * @description: Test Method used to check the functionality where Dates are defaulted from Communication.
    * @param: none
    * @return: void
    */ 
    static testMethod void populateDefaultDateTestChannel(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
        }                        
        Database.SaveResult[] srListCommunication = Database.insert(CommunicationList,false);
        //ASSERT IF Communication RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(1,CommunicationList.size());
        id insertedCommunicationID;
        for(Database.SaveResult sr: srListCommunication){    
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
        for(Integer i=0;i<15;i++) {
            if(i<5) {
                channelList.add(IMH_TestClassUtility.createChannel(MARKET_THAILAND,REGION_JAPA,AMEX_TEXT));
                channelList[i].Name=AMEX_TEXT+i;
            }
            else if(i<10) {
                channelList.add(IMH_TestClassUtility.createChannel(MARKET_THAILAND,REGION_JAPA,AMEX_TEXT));
                channelList[i].Name=AMEX_TEXT+i;                         
            }   
            else {
                channelList.add(IMH_TestClassUtility.createChannel(MARKET_TAIWAN,REGION_JAPA,AMEX_TEXT));
                channelList[i].Name=AMEX_TEXT+i;
            }             
        }
        insert channelList;
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = CHANNEL_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.childJunctionObject=CP_CHANNEL_OBJECT_API;
        controller.captureInputOnChild =BOOLEAN_TRUE;
        controller.inputStartDefaultDate = String.valueOf(System.today().addDays(6));
        controller.inputEndDefaultDate = String.valueOf(System.today().addDays(8));
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.startSearch();        
        controller.sObjectWrapperList.get(0).isSelected = true; 
        controller.sObjectWrapperList.get(1).isSelected = true;  
        controller.processSelected();
        controller.cancelAdding();
        Test.stopTest();  
        List<IMH_CreativeChannel__c> CommunicationChannelList = new List<IMH_CreativeChannel__c>();
        CommunicationChannelList = [SELECT Id, Creative__c FROM IMH_CreativeChannel__c WHERE Creative__c =: insertedCreativeId LIMIT 50000];
        System.assertEquals(2,CommunicationChannelList.size());
    }
    /**
    * @description: Test Method used to check the functionality to add additional channels to the existing list of Creative Channel.
    * @param: none
    * @return: void
    */   
    static testMethod void channelAlreadyAddMoreAndDeleteTest(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
        }                        
        Database.SaveResult[] srListCommunication = Database.insert(CommunicationList,false);
        //ASSERT IF Communication RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(1,CommunicationList.size());
        id insertedCommunicationID;
        for(Database.SaveResult sr: srListCommunication){    
            if(sr.isSuccess()){
                insertedCommunicationID = sr.getId();
            }
        }
        List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
        for(Integer i=0;i<5;i++) {
            channelList.add(IMH_TestClassUtility.createChannel(MARKET_THAILAND,REGION_JAPA,AMEX_TEXT));
            channelList[i].Name=AMEX_TEXT+i;
        }
        Database.SaveResult[] srListChannel = Database.insert(channelList,false);
        Id insertedChannelId;
        insertedChannelId = srListChannel[0].getId();
        //Test Data for CommChannel object
        List<IMH_CommChannels__c> commChannelList = new List<IMH_CommChannels__c>();  
        commChannelList.add(IMH_TestClassUtility.createCommTargetedChannel(insertedCommunicationID,insertedChannelId));
        Database.SaveResult[] srCommChannels = Database.insert(commChannelList,false);
        Id insertedCommChannelId = srCommChannels[0].getId();
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
        //Test Data for Creative Channel object
        List<IMH_CreativeChannel__c> creativeChannelList = new List<IMH_CreativeChannel__c>();  
        creativeChannelList.add(IMH_TestClassUtility.createTargetedChannel(insertedCreativeId,insertedCommChannelId));
        Database.insert(creativeChannelList,false);
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = CHANNEL_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.childJunctionObject=CP_CHANNEL_OBJECT_API;
        controller.captureInputOnChild=BOOLEAN_TRUE;
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.addedChildsList.add(insertedChannelId);
        controller.initiateSearch='';
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.inStateSelectedRecords.add(insertedChannelId);
        controller.startSearch();        
        controller.inStateSelectedRecords.remove(insertedChannelId);
        controller.sObjectWrapperList.get(0).isSelected = false; 
        controller.sObjectWrapperList.get(1).isSelected = true; 
        controller.sObjectWrapperList.get(2).isSelected = true;  
        controller.sObjectWrapperList.get(3).isSelected = true;  
        controller.sObjectWrapperList.get(4).isSelected = true;  
        controller.finalDeleteChildIdSet.add(insertedChannelId);
        controller.processSelected();
        System.assertEquals(5,controller.sObjectWrapperList.size());     
        Test.stopTest();  
        List<IMH_CreativeChannel__c> CommunicationChannelList = new List<IMH_CreativeChannel__c>();
        CommunicationChannelList = [SELECT Id, Creative__c FROM IMH_CreativeChannel__c WHERE Creative__c =: insertedCreativeId LIMIT 50000];
        System.debug('>>>>ooo>>>>>'+CommunicationChannelList.size());
        System.assertEquals(4,CommunicationChannelList.size());
    }
   /**
    * @description: Test Method used to check the functionality whether Products be restricted from deleting.
    * @param: none
    * @return: void
    */  
    static testMethod void channelPreventDelete(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
        }                        
        Database.SaveResult[] srListCommunication = Database.insert(CommunicationList,false);
        //ASSERT IF Communication RECORDS ARE CREATED WITH EXPECTED RESULTS 
        id insertedCommunicationID;
        for(Database.SaveResult sr: srListCommunication){    
            if(sr.isSuccess()){
                insertedCommunicationID = sr.getId();
            }
        }
        List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
        for(Integer i=0;i<5;i++) {
            channelList.add(IMH_TestClassUtility.createChannel(MARKET_THAILAND,REGION_JAPA,AMEX_TEXT));
            channelList[i].Name=AMEX_TEXT+i;
        }
        Database.SaveResult[] srListChannel = Database.insert(channelList,false);
        Id insertedChannelId;
        insertedChannelId = srListChannel[0].getId();
        //Test Data for Comm Product object
        List<IMH_CreativeChannel__c> commChannelList = new List<IMH_CreativeChannel__c>();  
        commChannelList.add(IMH_TestClassUtility.createTargetedChannel(insertedCommunicationID,insertedChannelId));
        Database.SaveResult[] srcommChannelList = Database.insert(commChannelList,false);
        Id insertedCommChannelId = srcommChannelList[0].getId();
        //Test Data for Creative
        List<IMH_CommCreative__c> creativeList = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<1;i++){            
            creativeList.add(IMH_TestClassUtility.createFinalCreative(insertedCommunicationID,STATUS_NAME,
                             IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATE_NAME).Id));
        }                        
        Database.SaveResult[] creativeInsList = Database.insert(creativeList,false);
        id insertedCreativeId;
        for(Database.SaveResult sr: creativeInsList){    
            if(sr.isSuccess()){
                insertedCreativeId = sr.getId();
            }
        }
        //Test Data for TargetedProduct object
        List<IMH_CreativeChannel__c> targetedChannelList = new List<IMH_CreativeChannel__c>();  
        targetedChannelList.add(IMH_TestClassUtility.createTargetedChannel(insertedCreativeId,insertedCommChannelId));
        Database.insert(targetedChannelList,false);
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = CHANNEL_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.childJunctionObject=CP_CHANNEL_OBJECT_API;
        controller.captureInputOnChild=BOOLEAN_TRUE;
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.addedChildsList.add(insertedChannelId);
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.startSearch(); 
        System.assertEquals(false,controller.sObjectWrapperList.get(0).isSelected);
        controller.sObjectWrapperList.get(0).isSelected = false; 
        controller.processSelected();
        Test.stopTest();  
        List<IMH_CreativeChannel__c> CommunicationChannelList = new List<IMH_CreativeChannel__c>();
        CommunicationChannelList = [SELECT Id, Creative__c FROM IMH_CreativeChannel__c WHERE 
                                    Creative__c =: insertedCreativeId LIMIT 50000];
        System.assertEquals(0,CommunicationChannelList.size());
    }
 /**
    * @description: Test Method used to check the functionality for Pagination.
    * @param: none
    * @return: void
    */ 
    static testMethod void paginationTest(){
        
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
        for(Integer i=0;i<200;i++) {
            if(i<150) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GOLD));
                prodList[i].Name=PRODUCT_NAME+i;
                prodList[i].Region__c=REGION_JAPA;
            }
            else if(i<175) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GREEN));
                prodList[i].Name=PRODUCT_NAME+i;                         
            }   
            else {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_TAIWAN,ACTIVE,COLOUR_BLUE));
                prodList[i].Name=PRODUCT_NAME+i;
            }             
        }                         
        Database.SaveResult[] productList = Database.insert(prodList,false);
        String insertedproductId;
        insertedproductId = productList[0].getId();
        //ASSERT IF Product RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(200,prodList.size());
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = PRODUCT_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild=BOOLEAN_FALSE;
        controller.selectedsObjectRecordId = insertedCreativeId;
        controller.getListOfFields();
        controller.ListOfConditions(); 
        controller.startSearch();
        controller.index=10;
        controller.blockSize=15;
        controller.totalRecs=15;       
        controller.getprev();
        controller.getnxt();
        controller.end();
        Test.stopTest();  
    }

    /**
    * @description: Test Method used to add benefits on Communication Object
    * @param: none
    * @return: void
    */
    static testMethod void generalTestForBenefit(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
            CommunicationList[i].Communication_Type__c = PREAPPROVEDBENEFIT;
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
        //TestData for Benefit object
        List<IMH_Benefits__c> benefitList=new List<IMH_Benefits__c>();          
        for(Integer i=0;i<10;i++) {
            benefitList.add(IMH_TestClassUtility.createBenefits(LOCAL,REGION_JAPA,MARKET_THAILAND));
            benefitList[i].ApprovalStage__c = ACCEPTED;
        }                         
        Database.SaveResult[] srBenefitList = Database.insert(benefitList,false);
        String insertedBenefitId;
        insertedBenefitId = srBenefitList[0].getId();
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.initiateSearch=BLANK_SPACE;
        controller.childObject = BENEFIT_API;    
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild= BOOLEAN_FALSE;
        controller.selectedsObjectRecordId = insertedCommunicationID;
        controller.getListOfFields();
        controller.ListOfConditions();        
        IMH_AddChildItemsOnParentController.SearchFieldsWrapper sfWrapRecord;
        List<IMH_AddChildItemsOnParentController.SearchFieldsWrapper> fieldRuleWrapperList = new List<IMH_AddChildItemsOnParentController.SearchFieldsWrapper>();
        for(integer i=0; i<1; i++) {
            sfWrapRecord = new IMH_AddChildItemsOnParentController.SearchFieldsWrapper();
            sfWrapRecord.searchField = MARKET_FIELD_API;
            sfWrapRecord.searchOperator = INCLUDES;
            sfWrapRecord.searchParam = MARKET_THAILAND;    
            fieldRuleWrapperList.add(sfWrapRecord);
        }  
        controller.SearchFieldsWrapperList = fieldRuleWrapperList;
        ApexPages.currentPage().getParameters().put(RULE_INDEX,VALUE_ONE); 
        controller.startSearch();
        controller.filteredSObjectWrapList();
        controller.sObjectWrapperList.get(0).isSelected = true; 
        controller.sObjectWrapperList.get(1).isSelected = true;  
        controller.processSelected();
        Test.stopTest();  
        //Assert if 2 pre approved benefits are inserted.
        List<IMH_PreApprovedBenefits__c> preApprovedBeneList = new List<IMH_PreApprovedBenefits__c>();
        preApprovedBeneList = [SELECT Id, Name, Communication__c, BenefitOffers__c FROM IMH_PreApprovedBenefits__c WHERE Communication__c=: insertedCommunicationID LIMIT 50000];
        System.assertEquals(2,preApprovedBeneList.size());
    }
    
    /**
    * @description: Test Method used to add benefits on Communication Object and perform keyword search
    * @param: none
    * @return: void
    */
    static testMethod void keyWordSearchTestBenefit(){
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
        //TestData for Benefit object
        List<IMH_Benefits__c> benefitList=new List<IMH_Benefits__c>();          
        for(Integer i=0;i<1;i++) {
            benefitList.add(IMH_TestClassUtility.createBenefits(LOCAL,REGION_JAPA,MARKET_THAILAND));
        }                      
        Database.SaveResult[] srBenefitList = Database.insert(benefitList,false);
        String insertedBenefitId;
        insertedBenefitId = srBenefitList[0].getId();
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = BENEFIT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild = BOOLEAN_FALSE;
        controller.keywordParam = PROD_TEXT;
        controller.selectedsObjectRecordId = insertedCommunicationID;
        controller.getListOfFields();
        controller.startSearch();
        Test.stopTest();
        System.assertEquals(0,controller.sObjectWrapperList.size());
    }

    /**
    * @description: Test Method used to remove & add benefits on Communication Object
    * @param: none
    * @return: void
    */
    static testMethod void removeBenefitAndAddMore(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
            CommunicationList[i].Communication_Type__c = PREAPPROVEDBENEFIT;
        }                        
        Database.SaveResult[] srList = Database.insert(CommunicationList,false);
        id insertedCommunicationID = srList[0].getId();
        //TestData for Benefit object
        List<IMH_Benefits__c> benefitList=new List<IMH_Benefits__c>();          
        for(Integer i=0;i<2;i++) {
            benefitList.add(IMH_TestClassUtility.createBenefits(LOCAL,REGION_JAPA,MARKET_THAILAND));
            benefitList[i].ApprovalStage__c = ACCEPTED;
        }                         
        Database.SaveResult[] srBenefitList = Database.insert(benefitList,true);
        String insertedBenefitId;
        insertedBenefitId = srBenefitList[0].getId();
        //Test Data for Pre-Approved Benefit
        List<IMH_PreApprovedBenefits__c> preApprovedBeneInsertList = new List<IMH_PreApprovedBenefits__c>();
        preApprovedBeneInsertList.add(IMH_TestClassUtility.createPreApprovedBenefits(insertedCommunicationID,insertedBenefitId));
        Database.SaveResult[] srPreBenefitList = Database.insert(preApprovedBeneInsertList,true);
        Test.startTest();
        IMH_AddChildItemsOnParentController controller = new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = BENEFIT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild = BOOLEAN_FALSE;
        controller.selectedsObjectRecordId = insertedCommunicationID;
        controller.addedChildsList.add(insertedBenefitId);
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.startSearch();
        controller.filteredSObjectWrapList();
        controller.sObjectWrapperList.get(1).isSelected = true;  
        controller.processSelected();
        Test.stopTest();  
        //Assert if 2 pre approved benefits are inserted.
        List<IMH_PreApprovedBenefits__c> preApprovedBeneList = new List<IMH_PreApprovedBenefits__c>();
        preApprovedBeneList = [SELECT Id, Name, Communication__c, BenefitOffers__c FROM IMH_PreApprovedBenefits__c WHERE Communication__c=: insertedCommunicationID LIMIT 50000];
        System.assertEquals(2,preApprovedBeneList.size());
    }

    /**
    * @description: Test Method used to remove benefits on Communication Object when not in Concept-Design
    * @param: none
    * @return: void
    */
    static testMethod void benefitPreventDelete(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
            CommunicationList[i].Communication_Type__c = PREAPPROVEDBENEFIT;
        }                        
        Database.SaveResult[] srList = Database.insert(CommunicationList,false);
        id insertedCommunicationID = srList[0].getId();
        //TestData for Benefit object
        List<IMH_Benefits__c> benefitList=new List<IMH_Benefits__c>();          
        for(Integer i=0;i<2;i++) {
            benefitList.add(IMH_TestClassUtility.createBenefits(LOCAL,REGION_JAPA,MARKET_THAILAND));
            benefitList[i].ApprovalStage__c = ACCEPTED;
        }                         
        Database.SaveResult[] srBenefitList = Database.insert(benefitList,true);
        String insertedBenefitId;
        insertedBenefitId = srBenefitList[0].getId();
        //Test Data for Pre-Approved Benefit
        List<IMH_PreApprovedBenefits__c> preApprovedBeneInsertList = new List<IMH_PreApprovedBenefits__c>();
        preApprovedBeneInsertList.add(IMH_TestClassUtility.createPreApprovedBenefits(insertedCommunicationID,insertedBenefitId));
        Database.SaveResult[] srPreBenefitList = Database.insert(preApprovedBeneInsertList,true);
        IMH_Communication__c commRecToUpdate = [SELECT id, Stage__c FROM IMH_Communication__c WHERE
                                                id=: insertedCommunicationID LIMIT 50000];
        commRecToUpdate.Stage__c = CONCEPT_ATTESTAION;
        update commRecToUpdate;
        Test.startTest();
        IMH_AddChildItemsOnParentController controller = new IMH_AddChildItemsOnParentController();
        controller.initialState= true;
        controller.childObject = BENEFIT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild = BOOLEAN_FALSE;
        controller.selectedsObjectRecordId = insertedCommunicationID;
        controller.addedChildsList.add(insertedBenefitId);
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.startSearch();
        controller.filteredSObjectWrapList();
       // System.debug('#####MM1111>>> '+controller.sObjectWrapperList);
        //System.debug('#####MM22222>>> '+controller.sObjectWrapperList.size());
        System.assertEquals(false,controller.sObjectWrapperList.get(0).isSelected);
        controller.sObjectWrapperList.get(0).isSelected = false; 
        controller.processSelected();
        Test.stopTest();  
        List<IMH_PreApprovedBenefits__c> preApprovedBeneList = new List<IMH_PreApprovedBenefits__c>();
        preApprovedBeneList = [SELECT Id, Name, Communication__c, BenefitOffers__c FROM IMH_PreApprovedBenefits__c WHERE 
                                Communication__c=: insertedCommunicationID LIMIT 50000];
        System.assertEquals(1,preApprovedBeneList.size());
    }

    /**
    * @description: Test Method used to cover negative scenario - Error on Preapproved insert due to validation rule.
    * @param: none
    * @return: void
    */
    static testMethod void benefitPreventAdd(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(CREATIVE_STAGE,STATUS_NAME,MARKET_THAILAND));
        }                        
        Database.SaveResult[] srList = Database.insert(CommunicationList,false);
        id insertedCommunicationID = srList[0].getId();
        
        //TestData for Benefit object
        List<IMH_Benefits__c> benefitList=new List<IMH_Benefits__c>();          
        for(Integer i=0;i<10;i++) {
            benefitList.add(IMH_TestClassUtility.createBenefits(LOCAL,REGION_JAPA,MARKET_THAILAND));
            benefitList[i].ApprovalStage__c = ACCEPTED;
        }                         
        Database.SaveResult[] srBenefitList = Database.insert(benefitList,false);
        String insertedBenefitId;
        insertedBenefitId = srBenefitList[0].getId();
        
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = BENEFIT_API;    
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild= BOOLEAN_FALSE;
        controller.selectedsObjectRecordId = insertedCommunicationID;
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.startSearch();
        controller.filteredSObjectWrapList();
        controller.sObjectWrapperList.get(0).isSelected = true; 
        controller.processSelected();
        Test.stopTest();  
        //Assert if 2 pre approved benefits are inserted.
        List<IMH_PreApprovedBenefits__c> preApprovedBeneList = new List<IMH_PreApprovedBenefits__c>();
        preApprovedBeneList = [SELECT Id, Name, Communication__c, BenefitOffers__c,SYS_CommunicationStage__c
                               FROM IMH_PreApprovedBenefits__c WHERE Communication__c=: insertedCommunicationID LIMIT 50000];
        System.assertEquals(0,preApprovedBeneList.size());
    }
    /**
    * @description: Method to insert Communication Products (Targeted Products From the Easy Creation Page [Sprint 38])
    * @param: none
    * @return: void
    */
    static testMethod void insertCommProductsWithError(){
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
        //TestData for Product object
        List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
        for(Integer i=0;i<5;i++) {
            prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GOLD));
            prodList[i].Name=PRODUCT_NAME+i;
        }                         
        prodList[4].Active__c = false;
        Database.SaveResult[] productList = Database.insert(prodList,false);
        Id insertedproductId;
        insertedproductId = productList[0].getId();
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = PRODUCT_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild=BOOLEAN_FALSE;
        controller.selectedsObjectRecordId = insertedCommunicationID;
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.startSearch();        
        controller.sObjectWrapperList.get(1).isSelected = true; 
        controller.sObjectWrapperList.get(2).isSelected = true;  
        controller.sObjectWrapperList.get(4).isSelected = true;  
        controller.processSelected();
        Test.stopTest();  
        System.assertEquals(5,controller.sObjectWrapperList.size());     
        List<IMH_CommProducts__c> CommunicationProdList = new List<IMH_CommProducts__c>();
        CommunicationProdList = [SELECT Id, Communication__c FROM IMH_CommProducts__c 
                                 WHERE Communication__c=: insertedCommunicationID LIMIT 50000];
        System.assertEquals(0,CommunicationProdList.size());
    }
   
   /**
    * @description:  Method to insert Communication Products (Targeted Products From the Easy Creation Page [Sprint 38])
    * @param: none
    * @return: void
    */ 
    static testMethod void insertCommProductsWithoutError(){
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
        //TestData for Product object
        List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
        for(Integer i=0;i<5;i++) {
            prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,MARKET_THAILAND,ACTIVE,COLOUR_GOLD));
            prodList[i].Name=PRODUCT_NAME+i;
        }                         
        prodList[4].Active__c = false;
        Database.SaveResult[] productList = Database.insert(prodList,false);
        Id insertedproductId;
        insertedproductId = productList[0].getId();
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = PRODUCT_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.captureInputOnChild=BOOLEAN_FALSE;
        controller.selectedsObjectRecordId = insertedCommunicationID;
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.startSearch();        
        controller.sObjectWrapperList.get(1).isSelected = true; 
        controller.sObjectWrapperList.get(2).isSelected = true;  
        controller.processSelected();
        Test.stopTest();  
        System.assertEquals(5,controller.sObjectWrapperList.size());     
        List<IMH_CommProducts__c> CommunicationProdList = new List<IMH_CommProducts__c>();
        CommunicationProdList = [SELECT Id, Communication__c FROM IMH_CommProducts__c 
                                 WHERE Communication__c=: insertedCommunicationID LIMIT 50000];
        System.assertEquals(2,CommunicationProdList.size());
    }
     /**
    * @description:  Method to insert Communication Channel (Targeted Products From the Easy Creation Page [Sprint 38])
    * @param: none
    * @return: void
    */
    static testMethod void insertCommChannel(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_THAILAND));
        }                        
        Database.SaveResult[] srListCommunication = Database.insert(CommunicationList,false);
        //ASSERT IF Communication RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(1,CommunicationList.size());
        id insertedCommunicationID;
        for(Database.SaveResult sr: srListCommunication){    
            if(sr.isSuccess()){
                insertedCommunicationID = sr.getId();
            }
        }
        List<IMH_ChannelREF__c> channelList=new List<IMH_ChannelREF__c>();          
        for(Integer i=0;i<5;i++) {
            channelList.add(IMH_TestClassUtility.createChannel(MARKET_THAILAND,REGION_JAPA,AMEX_TEXT));
            channelList[i].Name=AMEX_TEXT+i;
        }
        Database.insert(channelList,false);
        Test.startTest();
        IMH_AddChildItemsOnParentController controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.childObject = CHANNEL_OBJECT_API;
        controller.targetMarket = MARKET_THAILAND;
        controller.childJunctionObject='IMH_CommChannels__c';
        controller.captureInputOnChild=BOOLEAN_TRUE;
        controller.selectedsObjectRecordId = insertedCommunicationID;
        controller.getListOfFields();
        controller.ListOfConditions();        
        controller.startSearch();        
        controller.sObjectWrapperList.get(0).isSelected = true; 
        controller.sObjectWrapperList.get(1).isSelected = true;  
        controller.processSelected();
        controller.cancelAdding();
        Test.stopTest();  
        System.assertEquals(5,controller.sObjectWrapperList.size());     
        List<IMH_CommChannels__c> CommunicationChannelList = new List<IMH_CommChannels__c>();
        CommunicationChannelList = [SELECT Id, Communication__c FROM IMH_CommChannels__c WHERE Communication__c =: insertedCommunicationID LIMIT 50000];
        System.assertEquals(2,CommunicationChannelList.size());
    }
    /**
    * @description: Test Method used to check the banking partner US related code
    * @param: none
    * @return: void
    */
    static testMethod void bankingPartnerTest(){
         User runningUserAdmin = IMH_TestClassUtility.createUser('iMH Bank Partner Submitter','BankingAadminUser',null);
        User runningUserBanking = IMH_TestClassUtility.createUser('iMH Bank Partner Submitter','SysAADmin',null);
        UserRole adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Thailand Submitter' LIMIT 1];
        runningUserBanking.UserRoleId= adminRole.Id;
        runningUserBanking.IMH_User_Team__c = 'Banking Partner';
        
         id insertedCommunicationID;
        List<IMH_CommCreative__c> lcreative;
         String insertedchannelId;
        Id insertedCommproductId;
         String insertedproductId;
        System.runAs(runningUserBanking){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,'Thailand'));
        }                        
        Database.SaveResult[] srList = Database.insert(CommunicationList,false);
        //ASSERT IF Communication RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(1,CommunicationList.size());
       
        for(Database.SaveResult sr: srList){    
            if(sr.isSuccess()){
                insertedCommunicationID = sr.getId();
            }
        }
        //TestData for Product object
        List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
        for(Integer i=0;i<20;i++) {
            if(i<15) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Other',ACTIVE,COLOUR_GOLD));
                prodList[i].Name=PRODUCT_NAME+i;
                prodList[i].Region__c='Other';
                prodList[i].User_Team__c='Banking Partner';
            }
            else {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Other',ACTIVE,COLOUR_BLUE));
                prodList[i].Name=PRODUCT_NAME+i;
            }             
        }                         
        Database.SaveResult[] productList = Database.insert(prodList,false);
       
        insertedproductId = productList[0].getId();
        //ASSERT IF Product RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(20,prodList.size());
        
          //Creative Insertion
       lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<2;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(insertedCommunicationID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,false);
        //TestData for CommunicationProduct object
        List<IMH_CommProducts__c> commProdList = new List<IMH_CommProducts__c>();  
        commProdList.add(IMH_TestClassUtility.createCommTargetedProduct(insertedCommunicationID,insertedproductId,MARKET_THAILAND));
        commProdList[0].Additional_Info__c = 'Test';
         IMH_TargetedProductTriggerHandler.isExecutionControl = false;
        Database.SaveResult[] commProdListSR = Database.insert(commProdList,false);
        
        List<IMH_CreativeProduct__c> lnewcreativeprods = new List<IMH_CreativeProduct__c>();
        for(Integer m=0;m<2;m++){
              lnewcreativeprods.add(IMH_TestClassUtility.createTargetedProduct(lcreative[0].Id,commProdList[0].Id,'Other'));
        }
        Database.insert(lnewcreativeprods,true);
        
        //Inserting a new Creative Product
        /*  List<IMH_ChannelREF__c> newchannelList=new List<IMH_ChannelREF__c>();          
            for(Integer i=0;i<3;i++) {
                newchannelList.add(IMH_TestClassUtility.createChannel('Other','Other','AMEX'));
                newchannelList[i].Name='AMEX'+i;
            }
            //newchannelList[0].RequiredApprovers__c = 'Brand and Advertising';
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
        Database.insert(lnewcreativechannel,true);*/
        
        
        insertedCommproductId = lnewcreativeprods[0].Id;
        }
        System.runAs(runningUserBanking){
        IMH_AddChildItemsOnParentController controller;
        Test.startTest();
        controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.initiateSearch=BLANK_SPACE;
        controller.childObject = PRODUCT_OBJECT_API;
        controller.targetMarket = 'Other';
        controller.captureInputOnChild=BOOLEAN_TRUE;
        controller.selectedsObjectRecordId = lcreative[0].Id;
        controller.childJunctionObject='IMH_CreativeProduct__c';
        controller.addedChildsList.add(insertedproductId);
        controller.getListOfFields();
        controller.ListOfConditions();        
        ApexPages.currentPage().getParameters().put(RULE_INDEX,VALUE_ONE); 
        controller.startSearch();
        controller.filteredSObjectWrapList();
        controller.sObjectWrapperList.get(0).isSelected = true; 
        controller.sObjectWrapperList.get(1).isSelected = true;  
        controller.processSelected();
        Test.stopTest();  
        System.assertNotEquals(0,controller.sObjectWrapperList.size());     
        List<IMH_CreativeProduct__c> creativeProdList = new List<IMH_CreativeProduct__c>();
        creativeProdList = [SELECT Id, Creative__c FROM IMH_CreativeProduct__c WHERE Creative__c=: lcreative[0].Id];
        System.assertEquals(3,creativeProdList.size());
        
        //Assert the captureInputCheckBox for products for Banking Partner Products
        System.assertEquals(true,Boolean.valueof(controller.captureInputOnChild));
            }
    }
    
    
        /**
    * @description: Test Method used to check the banking partner US related code with CreativeChannels
    * @param: none
    * @return: void
    */
    static testMethod void bankingPartnerTestCreativechan(){
         User runningUserAdmin = IMH_TestClassUtility.createUser('iMH Bank Partner Submitter','BankingAadminUser',null);
        User runningUserBanking = IMH_TestClassUtility.createUser('iMH Bank Partner Submitter','SysAADmin',null);
        UserRole adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Thailand Submitter' LIMIT 1];
        runningUserBanking.UserRoleId= adminRole.Id;
        runningUserBanking.IMH_User_Team__c = 'Banking Partner';
        //insert runningUserBanking;
        //TestData for Communication object
        id insertedCommunicationID;
        List<IMH_CommCreative__c> lcreative;
         String insertedchannelId;
        System.runAs(runningUserBanking){
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,'Thailand'));
        }                        
        Database.SaveResult[] srList = Database.insert(CommunicationList,false);
        //ASSERT IF Communication RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(1,CommunicationList.size());
       
        for(Database.SaveResult sr: srList){    
            if(sr.isSuccess()){
                insertedCommunicationID = sr.getId();
            }
        }
     
        //TestData for Product object
        List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
        for(Integer i=0;i<20;i++) {
            if(i<15) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Other',ACTIVE,COLOUR_GOLD));
                prodList[i].Name=PRODUCT_NAME+i;
                prodList[i].Region__c='Other';
                prodList[i].User_Team__c='Banking Partner';
            }
            else {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Other',ACTIVE,COLOUR_BLUE));
                prodList[i].Name=PRODUCT_NAME+i;
            }             
        }                         
        Database.SaveResult[] productList = Database.insert(prodList,false);
        String insertedproductId;
        insertedproductId = productList[0].getId();
        //ASSERT IF Product RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(20,prodList.size());
        
          //Creative Insertion
        lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<2;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(insertedCommunicationID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,false);
        //TestData for CommunicationProduct object
        List<IMH_CommProducts__c> commProdList = new List<IMH_CommProducts__c>();  
        commProdList.add(IMH_TestClassUtility.createCommTargetedProduct(insertedCommunicationID,insertedproductId,MARKET_THAILAND));
        commProdList[0].Additional_Info__c = 'Test';
         IMH_TargetedProductTriggerHandler.isExecutionControl = false;
        Database.SaveResult[] commProdListSR = Database.insert(commProdList,false);
        
        List<IMH_CreativeProduct__c> lnewcreativeprods = new List<IMH_CreativeProduct__c>();
        for(Integer m=0;m<2;m++){
              lnewcreativeprods.add(IMH_TestClassUtility.createTargetedProduct(lcreative[0].Id,commProdList[0].Id,'Other'));
        }
        Database.insert(lnewcreativeprods,true);
        
        //Inserting a new Creative Product
          List<IMH_ChannelREF__c> newchannelList=new List<IMH_ChannelREF__c>();          
            for(Integer i=0;i<3;i++) {
                newchannelList.add(IMH_TestClassUtility.createChannel('Other','Other','AMEX'));
                newchannelList[i].Name='AMEX'+i;
                newchannelList[i].User_Team__c='Banking Partner';
                 //newchannelList[i].Cature_Additional_Info__c=True;
            }
            //newchannelList[0].RequiredApprovers__c = 'Brand and Advertising';
            Database.SaveResult[] srnewListChannel = Database.insert(newchannelList,false);
       
        insertedchannelId = srnewListChannel[0].getId(); 
             
        List<IMH_CommChannels__c> lnewCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lnewCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(insertedCommunicationID,newchannelList[i].Id));
             lnewCommtargetedChannel[i].SYS_UICreated__c = true;  
        }
        IMH_TargetedChannelTriggerHandler.isExecutionControl = false;
        Database.insert(lnewCommtargetedChannel,true);
    }
        IMH_AddChildItemsOnParentController controller;
        system.runAs(runningUserBanking){ 
        Test.startTest();
            System.debug('***TEST Class Debug 1 '+runningUserBanking.IMH_User_Team__c);
         controller=new IMH_AddChildItemsOnParentController();
        controller.initialState= false;
        controller.initiateSearch=BLANK_SPACE;
        controller.childObject = 'IMH_ChannelREF__c';
        controller.targetMarket = 'Other';
        controller.captureInputOnChild=BOOLEAN_TRUE;
        controller.selectedsObjectRecordId = lcreative[0].Id;
        controller.childJunctionObject='IMH_CreativeChannel__c';
        controller.addedChildsList.add(insertedchannelId);
        controller.getListOfFields();
        controller.ListOfConditions();        
        ApexPages.currentPage().getParameters().put(RULE_INDEX,VALUE_ONE); 
        controller.startSearch();
        //controller.filteredSObjectWrapList();
        controller.sObjectWrapperList.get(0).isSelected = true; 
        controller.sObjectWrapperList.get(1).isSelected = true;   
        controller.processSelected();
        Test.stopTest(); 
            
        System.assertNotEquals(0,controller.sObjectWrapperList.size());     
        List<IMH_CreativeChannel__c> creativeChannelList = new List<IMH_CreativeChannel__c>();
        creativeChannelList = [SELECT Id, Creative__c FROM IMH_CreativeChannel__c WHERE Creative__c=: lcreative[0].Id];
        //Two Channels inserted since two were selected
        System.assertEquals(2,creativeChannelList.size());
            }
    }
    
    /**
    * @description: Negtive Test Method used to check the banking partner US related code with CreativeChannels and additional info as blank
    * @param: none
    * @return: void
    */
    static testMethod void negbankingPartnerTestCreativechan(){
        //TestData for Communication object
        List<IMH_Communication__c> CommunicationList = new List<IMH_Communication__c>();
        for(Integer i=0;i<1;i++){            
            CommunicationList.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,'Thailand'));
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
        //TestData for Product object
        List<IMH_Product__c> prodList=new List<IMH_Product__c>();          
        for(Integer i=0;i<20;i++) {
            if(i<15) {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Other',ACTIVE,COLOUR_GOLD));
                prodList[i].Name=PRODUCT_NAME+i;
                prodList[i].Region__c='Other';
                prodList[i].User_Team__c='Banking Partner';
            }
            else {
                prodList.add(IMH_TestClassUtility.createProduct(PRODUCT_NAME,'Other',ACTIVE,COLOUR_BLUE));
                prodList[i].Name=PRODUCT_NAME+i;
            }             
        }                         
        Database.SaveResult[] productList = Database.insert(prodList,false);
        String insertedproductId;
        insertedproductId = productList[0].getId();
        //ASSERT IF Product RECORDS ARE CREATED WITH EXPECTED RESULTS 
        System.assertEquals(20,prodList.size());
        
          //Creative Insertion
        List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
        for(Integer i=0;i<2;i++)
        {
            lcreative.add(IMH_TestClassUtility.createFinalCreative(insertedCommunicationID,STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id));
        }
        Database.insert(lcreative,false);
        //TestData for CommunicationProduct object
        List<IMH_CommProducts__c> commProdList = new List<IMH_CommProducts__c>();  
        commProdList.add(IMH_TestClassUtility.createCommTargetedProduct(insertedCommunicationID,insertedproductId,MARKET_THAILAND));
        commProdList[0].Additional_Info__c = 'Test';
         IMH_TargetedProductTriggerHandler.isExecutionControl = false;
        Database.SaveResult[] commProdListSR = Database.insert(commProdList,false);
        
        List<IMH_CreativeProduct__c> lnewcreativeprods = new List<IMH_CreativeProduct__c>();
        for(Integer m=0;m<2;m++){
              lnewcreativeprods.add(IMH_TestClassUtility.createTargetedProduct(lcreative[0].Id,commProdList[0].Id,'Other'));
        }
        Database.insert(lnewcreativeprods,true);
        
        //Inserting a new Creative Product
          List<IMH_ChannelREF__c> newchannelList=new List<IMH_ChannelREF__c>();          
            for(Integer i=0;i<3;i++) {
                newchannelList.add(IMH_TestClassUtility.createChannel('Other','Other','AMEX'));
                newchannelList[i].Name='AMEX'+i;
                newchannelList[i].User_Team__c='Banking Partner';
                 newchannelList[i].Cature_Additional_Info__c=True;
            }
            //newchannelList[0].RequiredApprovers__c = 'Brand and Advertising';
            Database.SaveResult[] srnewListChannel = Database.insert(newchannelList,false);
        String insertedchannelId;
        insertedchannelId = srnewListChannel[0].getId(); 
             
        List<IMH_CommChannels__c> lnewCommtargetedChannel = new List<IMH_CommChannels__c>();  
        for(Integer i=0;i<3;i++){
             lnewCommtargetedChannel.add(IMH_TestClassUtility.createCommTargetedChannel(insertedCommunicationID,newchannelList[i].Id));
             lnewCommtargetedChannel[i].SYS_UICreated__c = true;  
        }
        IMH_TargetedChannelTriggerHandler.isExecutionControl = false;
        Database.insert(lnewCommtargetedChannel,true);
             
             
        
        //Update on Communication to make it Approved.
        List<IMH_CreativeChannel__c> lnewcreativechannel = new List<IMH_CreativeChannel__c>();
        for(Integer m=0;m<3;m++){
              lnewcreativechannel.add(IMH_TestClassUtility.createTargetedChannel(lcreative[0].Id,lnewCommtargetedChannel[m].Id));
        }
        String errmessage = '';
        Test.startTest();
        
        try{
             insert lnewcreativechannel;
        }
        catch(Exception e){
           errmessage = e.getMessage(); 
        }
         
        Test.stopTest();
        System.assertEquals(true,errmessage.contains('Please provide additional information for the channel(s) highlighted'));
       /* List<IMH_CreativeChannel__c> creativeChannelList = new List<IMH_CreativeChannel__c>();
        creativeChannelList = [SELECT Id, Creative__c FROM IMH_CreativeChannel__c WHERE Creative__c=: lcreative[0].Id];
        System.assertEquals(3,creativeChannelList.size());*/
    }
}