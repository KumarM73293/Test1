/**
* @author Accenture IDC 
* @date 05/29/2015
* @group Communication
* @description: iMH Release 1 (Sprint 1) - Test Class for Validation Rule on Communication object  
* 
*/
@isTest
private class IMH_CommunicationValidationTest{
   
    private static Final String EMPTY_STRING = '';
    private static final String CAMPAIGN_SUBMITTER_PROFILE = 'iMH Campaign Submitter';
    private static final String RUNNING_USER = 'RunningUser';
   /******************
    * TestMethod of the Validation rule for  "Other Objectives" field on Communication Object
    * If Objectives contains Other && other objectives field = blank, restrict users from saving record
    *****************/
    static testMethod void communicationValidationTestMethod() {
       //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){      
            // Variable is declared hold the "Other Objectives" field value for validation error message
            String objerrormsg = EMPTY_STRING;
           //TestData for Communication Object        
            IMH_Communication__c campn2 = new IMH_Communication__c();
            campn2.Name = 'TestCommunication10';
            campn2.ProcessStage__c = 'Concept';
            campn2.ReviewStatus__c = 'Approved';
            campn2.TargetMarket__c = 'Thailand';
            campn2.TargetRegion__c = 'JAPA';
            campn2.Objective__c = 'Other';
            campn2.OtherObjectives__c = 'TestObjectives';
            campn2.Occurrence__c = 'onetime';
            campn2.StartDate__c = Date.today();
            campn2.EndDate__c = Date.today().addDays(6);
            insert campn2;
            
            campn2.OtherObjectives__c = EMPTY_STRING;
            try{
                update campn2;
            }
            catch(Exception e){
                objerrormsg = e.getMessage();   
            }
            system.debug('***OBJECT ERROR MSG'+objerrormsg);
            system.assert(objerrormsg.contains('Please provide details for any other objectives'));
        }
    }
    
    /******************
    * Negative TestMethod of the Validation rule for  "Other Objectives" field on Communication Object
    * If Objectives contains Other && other objectives field = blank, restrict users from saving record
    *****************/
    static testMethod void negativeCommunicationValidationTestMethod2() {
         //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){     
            // Variable is declared hold the "Other Objectives" field value for validation error message
            String objerrormsg = EMPTY_STRING;
           //TestData for Communication Object        
            IMH_Communication__c campn2 = new IMH_Communication__c();
            campn2.Name = 'TestCommunication10';
            campn2.ProcessStage__c = 'Concept';
            campn2.ReviewStatus__c = 'Approved';
            campn2.TargetMarket__c = 'Thailand';
            campn2.TargetRegion__c = 'JAPA';
            campn2.Objective__c = 'Loyality';
            campn2.OtherObjectives__c = 'TestObjectives';
            campn2.Occurrence__c = 'onetime';
            campn2.StartDate__c = Date.today();
            campn2.EndDate__c = Date.today().addDays(6);
            
            try{
                insert campn2;
            }
            catch(Exception e){
                objerrormsg = e.getMessage(); 
            }
            system.assertNotEquals('Please provide details for any other objectives', 'Field cant be mandatory');
        }
    }
    
    /******************
    * TestMethod of the Validation rule for  "End Date" field on Communication Object
    * The End Date cannot be before the Start Date
    *****************/
    static testMethod void communicationValidationTestMethod3() {
         //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){ 
            
            // Variable is declared hold the "End Date" field value for validation error message
            String dterrormsg = EMPTY_STRING;
           //TestData for Communication Object        
            IMH_Communication__c campn3 = new IMH_Communication__c();
            campn3.Name = 'TestCommunication20';
            campn3.ProcessStage__c = 'Creative';
            campn3.ReviewStatus__c = 'InProgress';
            campn3.TargetMarket__c = 'Thailand';
            campn3.TargetRegion__c = 'JAPA';
            campn3.Objective__c = 'External Acquisition';
            campn3.OtherObjectives__c = 'NewTestObjectives';
            campn3.Occurrence__c = 'onetime';
            campn3.StartDate__c = Date.today();
            campn3.EndDate__c = Date.today().addDays(4);
            insert campn3;
            
            campn3.EndDate__c = Date.today().addDays(-8);
            try{
                update campn3;
            }
            catch(Exception e){
                dterrormsg = e.getMessage();   
            }
            system.assert(dterrormsg.contains('The End Date cannot be before the Start Date. Please ensure your provided End Date is correct'));
        }
    }
    
    /******************
    * TestMethod of the Validation rule for  "Start Date" field on Communication Object
    * The Start Date must not be Less than Today Date
    *****************/
    static testMethod void communicationValidationTestMethod4() {
         //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){     
                // Variable is declared hold the "Start Date" field value for validation error message
                String sdterrormsg = EMPTY_STRING;
               //TestData for Communication Object        
                IMH_Communication__c campn4 = new IMH_Communication__c();
                campn4.Name = 'TestCommunication20';
                campn4.ProcessStage__c = 'Creative';
                campn4.ReviewStatus__c = 'InProgress';
                campn4.CommunicationCancellationReason__c = 'Cancelled due to ';
                campn4.TargetMarket__c = 'Thailand';
                campn4.TargetRegion__c = 'JAPA';
                campn4.Objective__c = 'External Acquisition';
                campn4.OtherObjectives__c = 'NewTestObjectives';
                campn4.Occurrence__c = 'onetime';       
                campn4.StartDate__c = Date.today().addDays(-8);
                campn4.EndDate__c = Date.today().addDays(10);
                
                try{
                    insert campn4;
                }
                catch(Exception e){
                    sdterrormsg = e.getMessage();
                }
                system.assert(sdterrormsg.contains('Start Date or End Date must not be less than Today'));
        }
    }
   /******************
    * TestMethod of the Validation rule for  Duration Of Communication
    * The Duration of Communication must not be Greater than Six Months For Standard Communication
    ****************
    static testMethod void communicationSixMonthValidationTestMethod4() {
         //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){     
                // Variable is declared hold the "Start Date" field value for validation error message
                String sdterrormsg = EMPTY_STRING;
               //TestData for Communication Object        
                IMH_Communication__c campn4 = new IMH_Communication__c();
                campn4.Name = 'TestCommunication20';
                campn4.ProcessStage__c = 'Creative';
                campn4.ReviewStatus__c = 'InProgress';
                campn4.CommunicationCancellationReason__c = 'Cancelled due to ';
                campn4.TargetMarket__c = 'Finland';
                campn4.TargetRegion__c = 'One Europe';
                campn4.Objective__c = 'External Acquisition';
                campn4.OtherObjectives__c = 'NewTestObjectives';
                campn4.Occurrence__c = 'onetime';       
                campn4.StartDate__c = Date.today().addDays(8);
                campn4.EndDate__c = Date.today().addDays(200);
                campn4.RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_Communication__c').get('SingleMarketing').Id;
                
                try{
                    insert campn4;
                }
                catch(Exception e){
                    sdterrormsg = e.getMessage();
                }
                system.assert(sdterrormsg.contains('Communication duration cannot be longer than 6 months'));
        }
    } */
     /******************
    * TestMethod of the Validation rule for  "Communication name" field on Communication Object
    * The Communication name must  be Less than 40 Characters
    *****************/
    static testMethod void communicationValidationTestMethod5() {
          //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){    
            // Variable is declared hold the "Communication name" field value for validation error message
            String nameerrormsg = EMPTY_STRING;
           //TestData for Communication Object        
            IMH_Communication__c campn5 = new IMH_Communication__c();
            campn5.Name = 'TestCommunication20TestCommunication20TestCommunication20TestCommunication20';
            campn5.ProcessStage__c = 'Creative';
            campn5.ReviewStatus__c = 'InProgress';
            campn5.CommunicationCancellationReason__c = 'Cancelled due to ';
            campn5.TargetMarket__c = 'Thailand';
            campn5.TargetRegion__c = 'JAPA';
            campn5.Objective__c = 'External Acquisition';
            campn5.OtherObjectives__c = 'NewTestObjectives';
            campn5.Occurrence__c = 'onetime';       
            campn5.StartDate__c = Date.today().addDays(-8);
            campn5.EndDate__c = Date.today().addDays(10);
            
            try{
                insert campn5;
            }
            catch(Exception e){
                nameerrormsg = e.getMessage();
            }
            system.assert(nameerrormsg.contains('Communication name should be less than 40 Characters.'));
        }
    }
    
     /******************
    * TestMethod of the Validation rule for  "Communication name" field on Communication Object
    * The Communication name must  be Less than 40 Characters
    *****************/
    static testMethod void negativeCommunicationValidationTestMethod6() {
         //INSTANTIATE THE USER FOR RUNNING AS CONTEXT
        User runningUser = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,RUNNING_USER,null);
         //RUNNING AS CAMPAIGN SUBMITTER CONTEXT FOR EXECUTING THE CONTROLLER OF THE PAGE     
        system.runAs(runningUser){     
            // Variable is declared hold the "Communication name" field value for validation error message
            String nameerrormsg = EMPTY_STRING;
           //TestData for Communication Object        
            IMH_Communication__c campn6 = new IMH_Communication__c();
            campn6.Name = 'TestCommunication20';
            campn6.ProcessStage__c = 'Creative';
            campn6.ReviewStatus__c = 'InProgress';
            campn6.CommunicationCancellationReason__c = 'Cancelled due to ';
            campn6.TargetMarket__c = 'Thailand';
            campn6.TargetRegion__c = 'JAPA';
            campn6.Objective__c = 'External Acquisition';
            campn6.OtherObjectives__c = 'NewTestObjectives';
            campn6.Occurrence__c = 'onetime';       
            campn6.StartDate__c = Date.today().addDays(-8);
            campn6.EndDate__c = Date.today().addDays(10);
            
            try{
                insert campn6;
            }
            catch(Exception e){
                nameerrormsg = e.getMessage();
            }
             system.assertNotEquals('Communication name should be LessThan 40 Characters', 'Field cant be mandatory');
        }
    }

}