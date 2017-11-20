/**
* @author Accenture IDC 
* @date 05/29/2015
* @group Incentive
* @group-content N/A
* @description: iMH Release 1 (Sprint 1) - Test Class for Validation Rule on Incentive object  
* 
*/
@isTest
private class IMH_IncentiveValidationTest {
    
     private static Final String EMPTY_STRING = '';
     private static final String STAGE_NAME = 'Concept';
     private static final String STATUS_NAME = 'In Progress';
     private static final String MARKET_NAME = 'Hong Kong';
     private static final String INCENTIVE_TYPE = 'Message';
     private static final String INCENTIVE_STATUS = 'In Progress';
     
     
    /****************** 
    * TestMethod of the Validation rule for  "SE Number" field on Communication Object
    *
    *****************/
    static testMethod void incentiveValidationTestMethod1() {
        // Variable is declared hold the "SE Number" field value for validation error message
        String senoerrormsg = EMPTY_STRING;
        IMH_Incentive__c incentive1 = new IMH_Incentive__c();
        incentive1.Name = 'IncentiveTest1';
        incentive1.IncentiveType__c = 'Message';
        //incentive1.Channel__c = 'Twiter';
        incentive1.IncentiveOccurence__c= 'limited';
        //incentive1.Objective__c = 'Reach';
        incentive1.ConstructFulfilmentType__c = 'AMEX Fulfilled';
        incentive1.ConstructType__c = 'Membership rewards';
        incentive1.IncentiveStatus__c = 'Inprogress';
        incentive1.StartDate__c = Date.today();
        incentive1.EndDate__c = Date.today().addDays(2);
        incentive1.Description__c = 'Incentive1 details';
        incentive1.IncentiveDetails__c = 'Incentive4';
        incentive1.CustomerCalltoAction__c = 'Test3';
        incentive1.NetworkLevelIncentive__c = 'No';
        incentive1.IncentivePCTs__c = 'TestPCT';
        incentive1.MRIncentiveParameterRequests__c = 3;
        incentive1.SpecificSENumbersIncluded__c = 'Yes';
        incentive1.SENumbers__c = EMPTY_STRING;
        
        try{
            insert incentive1;
        }
        catch(Exception e){
            senoerrormsg = e.getMessage();
        }
    }
    
    /****************** 
    * Test method for SEnumber field to accept only numbers
    *****************/
    static testMethod void seNumberIncentiveValidationTestMethod1() {
        // Variable is declared hold the "SE Number" field value for validation error message
        String senoerrormsg = EMPTY_STRING;
        IMH_Communication__c camp = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(camp,false);
        //TestData for Incentive Object        
        IMH_Incentive__c incentive1 = new IMH_Incentive__c();
        
        incentive1.Communication__c = camp.Id;
        incentive1.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('Merchant_Fulfilled').Id;
        incentive1.Name = 'IncentiveTest3';
        incentive1.IncentiveType__c = 'Message';
        //incentive1.Channel__c = 'Twiter';
       incentive1.IncentiveOccurence__c= 'limited';
        //incentive1.Objective__c = 'Reach';
        incentive1.ConstructFulfilmentType__c = 'AMEX Fulfilled';
        incentive1.ConstructType__c = 'Membership rewards';
        incentive1.IncentiveStatus__c = 'Inprogress';
        incentive1.StartDate__c = Date.today().addDays(6);
        incentive1.EndDate__c = Date.today().addDays(8);
        incentive1.Description__c = 'Incentive1 details';
        incentive1.TargetAudienceSize__c = 20;
        incentive1.IncentiveDetails__c = 'Incentive4';
        incentive1.CustomerCalltoAction__c = 'Test3';
        incentive1.NetworkLevelIncentive__c = 'No';
        incentive1.ProcessPlatformToFulfilIncentive_ANZ__c = 'OLET';
        incentive1.DetailsOfTheFulfilmentProcess_ANZ__c = 'Details';
        incentive1.IncentivesOfferedToCustomer__c = 'MR Bonus';
        incentive1.EligibilityDetails__c = 'Eligible';
        incentive1.QualificationDetails__c = 'Qualified';
        incentive1.MerchantName__c = 'Merchant';
        incentive1.MerchantIndustry__c = 'Industry';
        incentive1.TopOfChainMerchantNumber__c = 'Top';
        incentive1.TargetIndustryToEngageCustomer_ANZ__c = 'Target';
        //incentive1.IncentivePCTs__c = 'TestPCT';
        //incentive1.MRIncentiveParameterRequests__c = 3;
        incentive1.SpecificSENumbersIncluded__c = 'Yes';
        incentive1.SENumbers__c = 'acb';
        try{
          insert incentive1;
        }
        catch(Exception e){
            senoerrormsg = e.getMessage(); 
        }
        Boolean errorValidate = false;
        if(senoerrormsg.contains('An SE Number must be a numerical value.')){
            errorValidate = true;
        }
        system.assertEquals(errorValidate,true);
    }
       /******************
    * Negative Test method for SEnumber field to accept only numbers //
    *****************/
    static testMethod void negSeNumberIncentiveValidationTestMethod1() {
        // Variable is declared hold the "SE Number" field value for validation error message
        String senoerrormsg = EMPTY_STRING;
        
        //TestData for Incentive Object        
        IMH_Incentive__c incentive1 = new IMH_Incentive__c();
        incentive1.Name = 'IncentiveTest3';
        incentive1.IncentiveType__c = 'Message';
        //incentive1.Channel__c = 'Twiter';
       incentive1.IncentiveOccurence__c= 'limited';
        //incentive1.Objective__c = 'Reach';
        incentive1.ConstructFulfilmentType__c = 'AMEX Fulfilled';
        incentive1.ConstructType__c = 'Membership rewards';
        incentive1.IncentiveStatus__c = 'Inprogress';
        incentive1.StartDate__c = Date.today();
        incentive1.EndDate__c = Date.today().addDays(2);
        incentive1.Description__c = 'Incentive1 details';
        incentive1.IncentiveDetails__c = 'Incentive4';
        incentive1.CustomerCalltoAction__c = 'Test3';
        incentive1.NetworkLevelIncentive__c = 'No';
        incentive1.IncentivePCTs__c = 'TestPCT';
        incentive1.MRIncentiveParameterRequests__c = 3;
        incentive1.SpecificSENumbersIncluded__c = 'Yes';
        incentive1.SENumbers__c = '36';
        
        try{
           insert incentive1;
        }
        catch(Exception e){
            senoerrormsg = e.getMessage(); 
        }
        system.assertNotEquals('Please enter numbers only.','SE number field entered is correct');
    } 
      /****************** 
    * Negative TestMethod of the Validation rule for  "SE Number" field on Incentive Object
    * If Specific SE Numbers Included = Yes and SE Number is blank, restrict user from saving the record
    *****************/
    static testMethod void negativeIncentiveValidationTestMethod1() {
        // Variable is declared hold the "SE Number" field value for validation error message
        String senoerrormsg = EMPTY_STRING;
        
        //TestData for Incentive Object        
        IMH_Incentive__c incentive1 = new IMH_Incentive__c();
        incentive1.Name = 'IncentiveTest3';
        incentive1.IncentiveType__c = 'Message';
        //incentive1.Channel__c = 'Twiter';
        incentive1.IncentiveOccurence__c= 'limited';
        //incentive1.Objective__c = 'Reach';
        incentive1.ConstructFulfilmentType__c = 'AMEX Fulfilled';
        incentive1.ConstructType__c = 'Membership rewards';
        incentive1.IncentiveStatus__c = 'Inprogress';
        incentive1.StartDate__c = Date.today();
        incentive1.EndDate__c = Date.today().addDays(2);
        incentive1.Description__c = 'Incentive1 details';
        incentive1.IncentiveDetails__c = 'Incentive4';
        incentive1.CustomerCalltoAction__c = 'Test3';
        incentive1.NetworkLevelIncentive__c = 'No';
        incentive1.IncentivePCTs__c = 'TestPCT';
        incentive1.MRIncentiveParameterRequests__c = 3;
        incentive1.SpecificSENumbersIncluded__c = 'No';
        incentive1.SENumbers__c = '1234';
        
        try{
            Database.insert(incentive1,false);
        }
        catch(Exception e){
            senoerrormsg = e.getMessage(); 
        }
        system.assertNotEquals(' Please provide SE Number', 'SENumber can not be mandatory');
    }
     
   
    /****************** 
    * TestMethod of the Validation rule for  "OtherIncentiveOccurence" field on Communication Object
    * Trigger Error if "IncentiveOccurence" = "Other" and "OtherIncentiveOccurence" field is blank
    *****************/
    static testMethod void incentiveValidationTestMethod3() {
        // Variable is declared hold the "OtherIncentiveOccurence" field value for validation error message
        String offsuberrormsg = EMPTY_STRING;
        
        //TestData for Incentive Object        
        IMH_Incentive__c incentive3 = new IMH_Incentive__c();
        incentive3.Name = 'IncentiveTest5';
        incentive3.IncentiveType__c = 'Message';
        //incentive3.Channel__c = 'Twiter';
        incentive3.IncentiveOccurence__c= 'Other';
        //incentive3.Objective__c = 'Reach';
        incentive3.ConstructFulfilmentType__c = 'AMEX Fulfilled';
        incentive3.ConstructType__c = 'Membership rewards';
        incentive3.IncentiveStatus__c = 'Inprogress';
        incentive3.StartDate__c = Date.today();
        incentive3.EndDate__c = Date.today().addDays(2);
        incentive3.Description__c = 'Incentive1 details';
        incentive3.IncentiveDetails__c = 'Incentive6';
        incentive3.CustomerCalltoAction__c = 'Test5';
        incentive3.NetworkLevelIncentive__c = 'No';
        incentive3.IncentivePCTs__c = 'TestPCT';
        incentive3.MRIncentiveParameterRequests__c = 5;
        incentive3.SpecificSENumbersIncluded__c = 'Yes';
        incentive3.SENumbers__c = '52';
        incentive3.OtherIncentiveOccurence__c= null;
               
        try{
            insert incentive3;
        }
        catch(Exception e){
            offsuberrormsg = e.getMessage();
        }
        system.assert(offsuberrormsg.contains('Please provide details for Other incentive Occurence'));
    }
    
    /****************** 
    * Negative TestMethod of the Validation rule for  "OtherIncentiveOccurence" field on Communication Object
    * Trigger Error if "IncentiveOccurence" = "Other" and "OtherIncentiveOccurence" field is blank
    *****************/
    static testMethod void negativeIncentiveValidationTestMethod4() {
        // Variable is declared hold the "OtherIncentiveOccurence" field value for validation error message
        String offsuberrormsg = EMPTY_STRING;
        
        //TestData for Incentive Object        
        IMH_Incentive__c incentive3 = new IMH_Incentive__c();
        incentive3.Name = 'IncentiveTest3';
        incentive3.IncentiveType__c = 'Message';
        //incentive3.Channel__c = 'Twiter';
       incentive3.IncentiveOccurence__c= 'Ongoing';
        //incentive3.Objective__c = 'Reach';
        incentive3.ConstructFulfilmentType__c = 'AMEX Fulfilled';
        incentive3.ConstructType__c = 'Membership rewards';
        incentive3.IncentiveStatus__c = 'Inprogress';
        incentive3.StartDate__c = Date.today();
        incentive3.EndDate__c = Date.today().addDays(2);
        incentive3.Description__c = 'Incentive1 details';
        incentive3.IncentiveDetails__c = 'Incentive6';
        incentive3.CustomerCalltoAction__c = 'Test5';
        incentive3.NetworkLevelIncentive__c = 'No';
        incentive3.IncentivePCTs__c = 'TestPCT';
        incentive3.MRIncentiveParameterRequests__c = 5;
        incentive3.SpecificSENumbersIncluded__c = 'Yes';
        incentive3.SENumbers__c = '234';
        incentive3.OtherIncentiveOccurence__c= 'Test incentive';
               
        try{
            Database.insert(incentive3,false);
        }
        catch(Exception e){
            offsuberrormsg = e.getMessage();
        }
        system.assertNotEquals('Please provide details for Other Incentive Occurence', 'Field cant be mandatory');
    }
    
    
    /******************
    * Negative Test method for Communication Date should be between Communication Start and End Date
    *****************/
    static testMethod void negComDateDisplayValidationTestMethod() {
        String senoerrormsg = EMPTY_STRING;

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];         
        User adminUser = new User(Alias = 'standt', Email='standarduser@amextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@amextest.com');
        Insert adminUser;
        system.runAs(adminUser) {          
        IMH_Communication__c camp = IMH_TestClassUtility.createCommunication(STAGE_NAME,STATUS_NAME,MARKET_NAME);
        Database.insert(camp,true);
        //TestData for Incentive Object        
        IMH_Incentive__c incentive1 = new IMH_Incentive__c();
        
        incentive1.Communication__c = camp.Id;
        incentive1.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Incentive__c').get('AMEX_Fulfilled').Id;
        incentive1.Name = 'IncentiveTest3';
        incentive1.IncentiveType__c = 'Message';
        incentive1.IncentiveStatus__c = 'Inprogress';
        incentive1.Description__c = 'Incentive1 details';
        incentive1.TargetAudienceSize__c = 20;
        incentive1.CustomerCalltoAction__c = 'Test3';
        incentive1.CommunicationDate__c =  Date.today().addDays(7);
        try{
          insert incentive1;
        }
        catch(Exception e){
            senoerrormsg = e.getMessage(); 
        }
        system.assertNotEquals(incentive1.Id,null);
        }
    } 
}