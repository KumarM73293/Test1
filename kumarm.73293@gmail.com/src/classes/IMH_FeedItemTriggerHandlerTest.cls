/**
    * @author Accenture IDC 
    * @date 06/01/2015
    * @group Answer
    * @group-content N/A
    * @description:iMH Release 1 (Sprint 1) Test Class for FeedItemTriggerHandler covering both 
    *                 positive and negative test cases.
    */
    @isTest
    private class IMH_FeedItemTriggerHandlerTest {
        private static final String STAGE_NAME = 'Concept';
        private static final String STATUS_NAME = 'In Progress';
        private static final String MARKET_NAME = 'Thailand';
        private static final String EMPTY_STRING = '';
        private static final String IMH_CAMPAIGN_REVIEWER = 'iMH Campaign Reviewer';    
        private static final String SYSTEM_ADMIN = 'System Administrator';  
        private static final String RUNNING_USER = 'RunningUser';
        
        /*****************************************************************************
         * @description: Method used for covering the case when we have the feed items assigned 
         *               to the Communication and trying to delete the feed item with Standard User Profile
         * @param: none
         * @return: void
         */     
        static testmethod void deletefeed(){
            User runningUser = IMH_TestClassUtility.createUser(IMH_CAMPAIGN_REVIEWER,RUNNING_USER,null);     
            System.runas(runningUser){
            String perrormsg = EMPTY_STRING; 
            List<IMH_Communication__c> lCommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<5;i++)
            {
                 lCommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
            }
            Database.insert(lCommunication,false);
                List<FeedItem> lfeeditem = new List<FeedItem>();
                FeedItem post ;
                for(Integer i=0;i<5;i++){
                    post = new FeedItem();
                     post = IMH_TestClassUtility.createFeedItem(lCommunication[i].Id);
                    lfeeditem.add(post);
                }
                Database.insert(lfeeditem,false);
             
                Test.startTest();  
                  
                    try{
                        delete lfeeditem;
                    }
                    catch(Exception ex){
                        perrormsg = ex.getMessage();
                    }
                Test.stopTest(); 
                //System.assertEquals(perrormsg,System.Label.ErrorLabel);
                System.assertequals(perrormsg.contains(System.Label.ErrorLabel),true);
            }
        }
           /*****************************************************************************
    * @description: Mehod used for covering the case when we have the feed items assigned 
    *               to the Communication and final creative and trying to delete the feed item with Standard User Profile
    * @param: none
    * @return: void
    */        
     static TestMethod void deletefeedfinalcreative(){
        User runningUser = IMH_TestClassUtility.createUser(IMH_CAMPAIGN_REVIEWER,RUNNING_USER,null);     
                    system.runas(runningUser){
                    String perrormsg= EMPTY_STRING; 
                 List<IMH_Communication__c> lCommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<5;i++)
            {
                 lCommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
            }
            Database.insert(lCommunication,false);
                List<IMH_CommCreative__c> lfinalcreative = new List<IMH_CommCreative__c>();
                IMH_CommCreative__c finalcreate ;
                for(Integer i=0;i<5;i++){
                     finalcreate = new IMH_CommCreative__c();
                    finalcreate = IMH_TestClassUtility.createFinalCreative(lCommunication[i].id,
                                                STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
                    lfinalcreative.add(finalcreate);
                }
                Database.insert(lfinalcreative,false);  
                        
                List<FeedItem> lfeeditem = new List<FeedItem>();
                FeedItem post;
                for(Integer i=0;i<5;i++){
                    post = new FeedItem();
                    post = IMH_TestClassUtility.createFeedItem(lfinalcreative[i].Id);
                    lfeeditem.add(post);
                }
                Database.insert(lfeeditem,false);
                
                Test.StartTest();
                    
                    try{
                        delete lfeeditem;
                    }
                    catch(Exception ex){
                        perrormsg = ex.getMessage();
                    }
                Test.stopTest(); 
                System.assertequals(perrormsg.contains(System.Label.ErrorLabel),true);
            }
            
        }    

       /*****************************************************************************
    * @description: Method used for covering the Negative Scenarion when 
    *              Feed Item are  inserted with IMH_Communication_REVIEWER Profile
    * @param: none
    * @return: void
    */       
        static testmethod void negatedeletefeedfinalcreative(){
            //Negative Scenarion when Feed Item are not inserted
            User runningUser = IMH_TestClassUtility.createUser(IMH_CAMPAIGN_REVIEWER,RUNNING_USER,null);     
            System.runas(runningUser){
                String perrormsg= EMPTY_STRING; 
          List<IMH_Communication__c> lCommunication = new List<IMH_Communication__c>();
            for(Integer i=0;i<5;i++)
            {
                 lCommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
            }
            Database.insert(lCommunication,false);
                List<IMH_CommCreative__c> lfinalcreative = new List<IMH_CommCreative__c>();
                IMH_CommCreative__c finalcreate = null;
                for(Integer i=0;i<5;i++){
                    finalcreate = new IMH_CommCreative__c();
                    finalcreate = IMH_TestClassUtility.createFinalCreative(lCommunication[i].id,
                                            STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
                    lfinalcreative.add(finalcreate);
                }
                Database.insert(lfinalcreative,false);  
                
                List<FeedItem> lfeeditem = new List<FeedItem>();
                FeedItem post = null;
                for(Integer i=0;i<5;i++){
                    post = new FeedItem();
                    post = IMH_TestClassUtility.createFeedItem((String)lfinalcreative[i].Id);
                    lfeeditem.add(post);
                }
                Test.StartTest();
                   
                    try{
                        delete lfeeditem;
                    }
                    catch(Exception ex){
                        perrormsg = ex.getMessage();
                    }
                Test.stopTest(); 
                System.assertequals(perrormsg.contains(System.Label.ErrorLabel),false);
            }
            
        }  
        
     /*****************************************************************************
    * @description: Method used for covering the Negative Scenarion when Feed Item 
    *                are not being deleted by Communication Submitter profile
    * @param: none
    * @return: void
    */     
        static testmethod void negatedeletefeedcamsub(){
            //Negative Scenarion when Feed Item are not being deleted by Communication Submitter profile
            User runningUser = IMH_TestClassUtility.createUser(SYSTEM_ADMIN,RUNNING_USER,null);   
            System.runas(runningUser){
                String perrormsg = EMPTY_STRING; 
                List<IMH_Communication__c> lCommunication = new List<IMH_Communication__c>();
                IMH_Communication__c campn;
                for(Integer i=0;i<5;i++){
                    campn = new IMH_Communication__c();
                    campn = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME); 
                    lCommunication.add(campn);
                }
                Database.insert(lCommunication,false);
                List<IMH_CommCreative__c> lfinalcreative = new List<IMH_CommCreative__c>();
                IMH_CommCreative__c finalcreate  ;
                for(Integer i=0;i<5;i++){
                    finalcreate = new IMH_CommCreative__c();
                    finalcreate = IMH_TestClassUtility.createFinalCreative(lCommunication[i].id,
                                STATUS_NAME,IMH_TestClassUtility.mRecordType.get('IMH_CommCreative__c').get('CreativeDesign').Id);
                    lfinalcreative.add(finalcreate);
                }
                Database.insert(lfinalcreative,false);  
                List<FeedItem> lfeeditem = new List<FeedItem>();
                FeedItem post = new FeedItem();
                for(Integer i=0;i<5;i++){
                    post = new FeedItem();
                    post = IMH_TestClassUtility.createFeedItem((String)lfinalcreative[i].Id);
                    lfeeditem.add(post);
                   
                }
                Database.insert(lfeeditem,false);
                Test.StartTest();
                  
                    try{
                        delete lfeeditem;
                    }
                    catch(Exception ex){
                        perrormsg = ex.getMessage();
                    }
                Test.stopTest(); 
                System.assertequals(perrormsg.contains(System.Label.ErrorLabel),false);
            }        
        }
    }