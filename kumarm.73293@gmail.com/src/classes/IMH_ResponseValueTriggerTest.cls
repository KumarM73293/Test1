/**
* @author Accenture IDC 
* @date 05/02/2016
* @group Response Value
* @group-content N/A
* @description: iMH Release 1 (Sprint 1) - Test Class for Validation Rule on Response Value object 
* 
*/
@isTest
private class IMH_ResponseValueTriggerTest {
    
 /*****************************************************************************
    * @description: Mehod used for  inserting unique response value while inserting
    * @param: none
    * @return: void
    */ 
    static testmethod void insertUniqueResponseValue(){
        String errormessage='';
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        lquestionset.add(IMH_TestClassUtility.createQuestionSet('Communication'));
        lquestionset[0].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').ID;
        insert lquestionset;
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lchildquestion = new List<IMH_Question__c>();
        
        lchildquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id,1,IMH_TestClassUtility.mRecordType.get('IMH_Question__c').get('Yes_No').ID));
        insert lchildquestion;
        List<IMH_ResponseValue__c> lwarning = new List<IMH_ResponseValue__c>();
        for(Integer i=0;i<2;i++){
            lwarning.add(IMH_TestClassUtility.createResponseValues(lchildquestion[0].Id,'Yes',1));
        }
        try{
            insert lwarning;
        }
        catch(Exception e){
            errormessage = e.getMessage();
        }
        System.assertEquals(errormessage.contains('There is already an active record at this order sequence.'),true);
    }
       /*****************************************************************************
    * @description: Mehod used for  unique response value while updating
    * @param: none
    * @return: void
    */ 
    static testmethod void updateUniqueResponseValue(){
        String errormessage='';
        List<IMH_QuestionSet__c> lquestionset = new List<IMH_QuestionSet__c>();
        lquestionset.add(IMH_TestClassUtility.createQuestionSet('Communication'));
        lquestionset[0].RecordTypeId = IMH_TestClassUtility.mRecordType.get('IMH_QuestionSet__c').get('Parent').ID;
        insert lquestionset;
        
        //CREATE QUESTION RECORDS FOR BULK TESTING
        List<IMH_Question__c> lchildquestion = new List<IMH_Question__c>();
        
        lchildquestion.add(IMH_TestClassUtility.createQuestion(lquestionset[0].Id,1,IMH_TestClassUtility.mRecordType.get('IMH_Question__c').get('Yes_No').ID));
        insert lchildquestion;
        List<IMH_ResponseValue__c> lwarning = new List<IMH_ResponseValue__c>();
        for(Integer i=0;i<2;i++){
            lwarning.add(IMH_TestClassUtility.createResponseValues(lchildquestion[0].Id,'Yes',i));
        }
        insert lwarning;
        List<IMH_ResponseValue__c> lupdatwarning = new List<IMH_ResponseValue__c>();
        for(IMH_ResponseValue__c warn:[Select id,OrderSequence__c
                                         FROM IMH_ResponseValue__c
                                         WHERE ID IN:lwarning
                                       LIMIT 50000]){
                                             warn.OrderSequence__c = 4;
                                             lupdatwarning.add(warn);
                                         }
        try{
            IMH_ResponseValueTriggerHandler.isExecutedBefore = false;
            update lupdatwarning;
        }
        catch(Exception e){
            errormessage = e.getMessage();
        }
        System.assertEquals(errormessage.contains('There is already an active record at this order sequence.'),true);
    }
}