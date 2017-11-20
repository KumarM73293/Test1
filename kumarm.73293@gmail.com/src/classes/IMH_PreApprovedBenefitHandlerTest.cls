/**
* @author Accenture IDC 
* @date 02/16/2016
* @group Answer
* @group-content N/A
* @description: iMH Release 1 (Sprint 1) - Test Class for Trigger on Pre Approved Benefit which looks for the before delete logic being triggered
*/
@isTest
private class IMH_PreApprovedBenefitHandlerTest {
 private static final String STAGE_NAME = 'Concept';
       private static final String STATUS_NAME = 'In Progress';
       private static final String MARKET_NAME = 'Hong Kong'; 
       private static final String SLA_TYPE = 'Standard';
       private static final String REGION = 'JAPA';
       private static final String APPROVAL_STAGE = 'ProcessStage__c';
        private static final String SYSTEMADMIN_PROFILE = 'iMH Campaign Submitter';
        private static final String RUNNING_USER = 'RunningUser';
    /*****************************************************************************
    * @description: Test Method to check for whether a record should  be deleted in Concept Design Stage
    * @return: void
    */ 
    static testmethod void avoidDeletion(){
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
         User adminUser = new User(Alias = 'standt', Email='standarduserbenfits@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduserbenfits@amextest.com');
        
        System.runAs(adminUser){
            
            List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
            List<IMH_Communication__c> lupdatedcommunication = new List<IMH_Communication__c>();
            List<IMH_Benefits__c> lbenefits = new List<IMH_Benefits__c>();
            List<IMH_PreApprovedBenefits__c> lpreapprovebenefits = new List<IMH_PreApprovedBenefits__c>();
            for(Integer i=0;i<5;i++)
            {
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
                lcommunication[i].ReviewApprovalSLAType__c = SLA_TYPE;
                lcommunication[i].TargetRegion__c = REGION;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].Stage__c = STAGE_NAME +  'Design';
                lcommunication[i].Communication_Type__c = 'Pre-Approved Benefit';
            }
            Database.insert(lcommunication,false);
            for(Integer i=0;i<5;i++)
            {
                lbenefits.add(IMH_TestClassUtility.createBenefits('Local',REGION,MARKET_NAME));
                lbenefits[i].ReviewApprovalSLAType__c = SLA_TYPE;
                lbenefits[i].BenefitStage__c = 'Leadership';
                lbenefits[i].ApprovalStage__c = 'Accepted';
            }
            Database.insert(lbenefits,false);
            IMH_PreApprovedBenefits__c preapp;
            for(Integer i=0;i<5;i++){
                preapp = new IMH_PreApprovedBenefits__c();
                preapp.BenefitOffers__c = lbenefits[i].Id;
                preapp.Communication__c = lcommunication[i].ID;
                lpreapprovebenefits.add(preapp);
            }
            Database.insert(lpreapprovebenefits,false);
            
            for(IMH_Communication__c com:[SELECT Id,ReviewStage__c 
                                          FROM IMH_Communication__c
                                          WHERE ID IN:lcommunication
                                          LIMIT 50000])
            {
                com.ReviewStage__c = 'Attestation';
                lupdatedcommunication.add(com);
            }
            Database.update(lupdatedcommunication,false);
            String error;
            try{
                Database.delete(lpreapprovebenefits[0].Id);
            }
            catch(Exception e){
                error = e.getMessage();
            }
            System.assertEquals(error.contains('Pre Approved Benefits can only be removed during Concept Design Stage'),true);
        }
 }
    
    
    /*****************************************************************************
    * @description: Test Method to check whether Benefits Pillar Owners are populated correctly
    * @return: void
    */ 
    static testmethod void addBenefitsPillars(){
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
         User adminUser = new User(Alias = 'standt', Email='standarduserbenfits@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduserbenfits@amextest.com');
        
        System.runAs(adminUser){
            List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
            List<IMH_Communication__c> lupdatedcommunication = new List<IMH_Communication__c>();
            List<IMH_Benefits__c> lbenefits = new List<IMH_Benefits__c>();
            List<IMH_PreApprovedBenefits__c> lpreapprovebenefits = new List<IMH_PreApprovedBenefits__c>();
            for(Integer i=0;i<1;i++)
            {
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
                lcommunication[i].ReviewApprovalSLAType__c = SLA_TYPE;
                lcommunication[i].TargetRegion__c = REGION;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].Stage__c = STAGE_NAME +  '- Design';
                lcommunication[i].Communication_Type__c = 'Pre-Approved Benefit';
            }
            Database.insert(lcommunication,true);
            for(Integer i=0;i<5;i++)
            {
                lbenefits.add(IMH_TestClassUtility.createBenefits('Central','Global','Global'));
                lbenefits[i].ReviewApprovalSLAType__c = SLA_TYPE;
                lbenefits[i].BenefitStage__c = 'Leadership';
                lbenefits[i].ApprovalStage__c = 'Accepted';
                if(i<1)
                    lbenefits[i].Benefit_Pillar__c = 'Retail';
                else if(i<2)
                    lbenefits[i].Benefit_Pillar__c = 'Lodging';
                else if(i<3)
                    lbenefits[i].Benefit_Pillar__c = 'Elite Tier';
                else if (i<4)
                    lbenefits[i].Benefit_Pillar__c = 'Dining';
                else
                    lbenefits[i].Benefit_Pillar__c = 'Entertainment';
            }
            Database.insert(lbenefits,false);
            IMH_PreApprovedBenefits__c preapp;
            for(Integer i=0;i<5;i++){
                preapp = new IMH_PreApprovedBenefits__c();
                preapp.BenefitOffers__c = lbenefits[i].Id;
                preapp.Communication__c = lcommunication[0].ID;
                lpreapprovebenefits.add(preapp);
            }
            test.startTest();
            Database.insert(lpreapprovebenefits,false);
            test.stopTest();
            System.assertEquals([SELECT ID,SYS_BenefitsPillarQueue__c FROM IMH_Communication__c WHERE ID IN:lcommunication LIMIT 50000].get(0).SYS_BenefitsPillarQueue__c,'Retail Airports;Premium;Travel;Dining;Entertainment');
        }
    }
    
        /*****************************************************************************
    * @description: Test Method to check whether Benefits Pillar Owners are populated correctly for multiple comunications
    * @return: void
    */ 
    static testmethod void addBenefitsPillarsMultipleComms(){
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
         User adminUser = new User(Alias = 'standt', Email='standarduserbenfits@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduserbenfits@amextest.com');
        
        System.runAs(adminUser){
            List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
            List<IMH_Communication__c> lupdatedcommunication = new List<IMH_Communication__c>();
            List<IMH_Benefits__c> lbenefits = new List<IMH_Benefits__c>();
            List<IMH_PreApprovedBenefits__c> lpreapprovebenefits = new List<IMH_PreApprovedBenefits__c>();
            for(Integer i=0;i<5;i++)
            {
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
                lcommunication[i].ReviewApprovalSLAType__c = SLA_TYPE;
                lcommunication[i].TargetRegion__c = REGION;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].Stage__c = STAGE_NAME +  'Design';
                lcommunication[i].Communication_Type__c = 'Pre-Approved Benefit';
            }
            Database.insert(lcommunication,false);
            for(Integer i=0;i<10;i++)
            {
                lbenefits.add(IMH_TestClassUtility.createBenefits('Central','Global','Global'));
                lbenefits[i].ReviewApprovalSLAType__c = SLA_TYPE;
                lbenefits[i].BenefitStage__c = 'Leadership';
                lbenefits[i].ApprovalStage__c = 'Accepted';
                if(i==0 || i==6)
                    lbenefits[i].Benefit_Pillar__c = 'Retail';
                else if(i==1 || i==5)
                    lbenefits[i].Benefit_Pillar__c = 'Lodging';
                else if(i==2 || i==8)
                    lbenefits[i].Benefit_Pillar__c = 'Elite Tier';
                else if (i==3 || i==7)
                    lbenefits[i].Benefit_Pillar__c = 'Dining';
                else
                    lbenefits[i].Benefit_Pillar__c = 'Entertainment';
            }
            Database.insert(lbenefits,false);
            IMH_PreApprovedBenefits__c preapp;
            for(Integer i=0;i<10;i++){
                preapp = new IMH_PreApprovedBenefits__c();
                preapp.BenefitOffers__c = lbenefits[i].Id;
                preapp.Communication__c = lcommunication[Math.mod(i,5)].ID;
                lpreapprovebenefits.add(preapp);
            }
            test.startTest();
            Database.insert(lpreapprovebenefits,false);
            test.stopTest();
            System.assertEquals([SELECT ID,SYS_BenefitsPillarQueue__c FROM IMH_Communication__c WHERE ID IN:lcommunication LIMIT 50000].get(0).SYS_BenefitsPillarQueue__c,'Retail Airports;Travel');
            System.assertEquals([SELECT ID,SYS_BenefitsPillarQueue__c FROM IMH_Communication__c WHERE ID IN:lcommunication LIMIT 50000].get(1).SYS_BenefitsPillarQueue__c,'Retail Airports;Travel');
            System.assertEquals([SELECT ID,SYS_BenefitsPillarQueue__c FROM IMH_Communication__c WHERE ID IN:lcommunication LIMIT 50000].get(2).SYS_BenefitsPillarQueue__c,'Premium;Dining');
            System.assertEquals([SELECT ID,SYS_BenefitsPillarQueue__c FROM IMH_Communication__c WHERE ID IN:lcommunication LIMIT 50000].get(3).SYS_BenefitsPillarQueue__c,'Premium;Dining');
            System.assertEquals([SELECT ID,SYS_BenefitsPillarQueue__c FROM IMH_Communication__c WHERE ID IN:lcommunication LIMIT 50000].get(4).SYS_BenefitsPillarQueue__c,'Entertainment');
        }
    }
            /*****************************************************************************
    * @description: Test Method to check whether Benefits Pillar Owners are populated correctly for multiple comunications
    * @return: void
    */ 
    static testmethod void deleteBenefitsPillarsMultipleComms(){
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
         User adminUser = new User(Alias = 'standt', Email='standarduserbenfits@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduserbenfits@amextest.com');
        
        System.runAs(adminUser){
            List<IMH_Communication__c> lcommunication = new List<IMH_Communication__c>();
            List<IMH_Communication__c> lupdatedcommunication = new List<IMH_Communication__c>();
            List<IMH_Benefits__c> lbenefits = new List<IMH_Benefits__c>();
            List<IMH_PreApprovedBenefits__c> lpreapprovebenefits = new List<IMH_PreApprovedBenefits__c>();
            for(Integer i=0;i<5;i++)
            {
                lcommunication.add(IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME));
                lcommunication[i].ReviewApprovalSLAType__c = SLA_TYPE;
                lcommunication[i].TargetRegion__c = REGION;
                lcommunication[i].ReviewStage__c = 'Design';
                lcommunication[i].Stage__c = STAGE_NAME +  'Design';
                lcommunication[i].Communication_Type__c = 'Pre-Approved Benefit';
            }
            Database.insert(lcommunication,false);
            for(Integer i=0;i<10;i++)
            {
                lbenefits.add(IMH_TestClassUtility.createBenefits('Central','Global','Global'));
                lbenefits[i].ReviewApprovalSLAType__c = SLA_TYPE;
                lbenefits[i].BenefitStage__c = 'Leadership';
                lbenefits[i].ApprovalStage__c = 'Accepted';
                if(i==0 || i==6)
                    lbenefits[i].Benefit_Pillar__c = 'Retail';
                else if(i==1 || i==5)
                    lbenefits[i].Benefit_Pillar__c = 'Lodging';
                else if(i==2 || i==8)
                    lbenefits[i].Benefit_Pillar__c = 'Elite Tier';
                else if (i==3 || i==7)
                    lbenefits[i].Benefit_Pillar__c = 'Dining';
                else
                    lbenefits[i].Benefit_Pillar__c = 'Entertainment';
            }
            Database.insert(lbenefits,false);
            IMH_PreApprovedBenefits__c preapp ;
            for(Integer i=0;i<10;i++){
                preapp = new IMH_PreApprovedBenefits__c();
                preapp.BenefitOffers__c = lbenefits[i].Id;
                preapp.Communication__c = lcommunication[Math.mod(i,5)].ID;
                lpreapprovebenefits.add(preapp);
            }
            test.startTest();
            Database.insert(lpreapprovebenefits,false);
            Database.delete(lpreapprovebenefits[0]);
            //test.stopTest();
            System.assertEquals([SELECT ID,SYS_BenefitsPillarQueue__c FROM IMH_Communication__c WHERE ID IN:lcommunication  LIMIT 50000].get(0).SYS_BenefitsPillarQueue__c,'Travel');
            //test.startTest();
            Database.undelete(lpreapprovebenefits[0]);
            Test.stopTest();
            System.assertEquals([SELECT ID,SYS_BenefitsPillarQueue__c FROM IMH_Communication__c WHERE ID IN:lcommunication LIMIT 50000].get(0).SYS_BenefitsPillarQueue__c,'Retail Airports;Travel');
            System.assertEquals([SELECT ID,SYS_BenefitsPillarQueue__c FROM IMH_Communication__c WHERE ID IN:lcommunication LIMIT 50000].get(1).SYS_BenefitsPillarQueue__c,'Retail Airports;Travel');
            System.assertEquals([SELECT ID,SYS_BenefitsPillarQueue__c FROM IMH_Communication__c WHERE ID IN:lcommunication LIMIT 50000].get(2).SYS_BenefitsPillarQueue__c,'Premium;Dining');
            System.assertEquals([SELECT ID,SYS_BenefitsPillarQueue__c FROM IMH_Communication__c WHERE ID IN:lcommunication LIMIT 50000].get(3).SYS_BenefitsPillarQueue__c,'Premium;Dining');
            System.assertEquals([SELECT ID,SYS_BenefitsPillarQueue__c FROM IMH_Communication__c WHERE ID IN:lcommunication LIMIT 50000].get(4).SYS_BenefitsPillarQueue__c,'Entertainment');
        }
    }
}