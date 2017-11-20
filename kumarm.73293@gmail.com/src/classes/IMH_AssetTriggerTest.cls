/**
    * @author Accenture IDC 
    * @date 03/24/2016
    * @group Asset (Final Creative)
    * @group-content N/A
    * @description: iMH Release 1.4 (Sprint 32) - Test Class for Asset Trigger
*/
@isTest
private class IMH_AssetTriggerTest {

    private static final String INPROGRESS_STATUS           = 'In Progress';
    private static final String MARKET_THAILAND             = 'Thailand';
    private static final String CREATIVE_API_NAME           = 'IMH_CommCreative__c';
    private static final String REGION_JAPA                 = 'JAPA';
    private static final String CAMPAIGN_SUBMITTER_PROFILE  = 'iMH Campaign Submitter';
    private static final String RUNNING_USER                = 'RunningUser';
    private static final String CREATIVE_RECTYPE            = 'CreativeDesign';
    private static final String SUBMITTER_RUNNING_USER      = 'RunningUserSubmitter';
    private static final String CREATIVE_STAGE              = 'Creative'; 
    private static final String ATTESTATION_STAGE           = 'Attestation'; 
    
    
    /**
    * @description: Test Method used to Approve Creative and create Asset
    * @param: none
    * @return: void
    */
    static testMethod void approveCreative() {
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        //Test Data for Communication
        Id creativeRecordId;
        System.runAs(runningUserSubmitter) {
            IMH_Communication__c communicationRec = new IMH_Communication__c();
            communicationRec = IMH_TestClassUtility.createCommunication(CREATIVE_STAGE,ATTESTATION_STAGE,MARKET_THAILAND);
            insert communicationRec;
            
            //Test Data for Creative
            IMH_CommCreative__c creativeRec = new IMH_CommCreative__c();
            creativeRec = IMH_TestClassUtility.createFinalCreative(communicationRec.Id,INPROGRESS_STATUS,
                           IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATIVE_RECTYPE).Id);
            creativeRec.CreativeStage__c = 'Design';
            creativeRec.SYSCreativeStep__c = 'COUNTER_1';
            insert creativeRec;
            creativeRecordId = creativeRec.Id;
        }
        Test.startTest();
        //Approve Creative
        IMH_CommCreative__c creativeRecUpdate  = [SELECT Id, SYS_Ready_For_Review__c FROM IMH_CommCreative__c 
                                                  WHERE Id =: creativeRecordId LIMIT 1];
        creativeRecUpdate.CreativeStage__c = 'Final Creative';  
        creativeRecUpdate.SYS_CreativeApproved__c = false;
        creativeRecUpdate.SYS_IsFinalCreativeCreated__c = true;
        System.runAs(runningUserSubmitter){
            update creativeRecUpdate;
        }
        IMH_CommCreative__c approvedCreative = [SELECT Id, SYS_FinalCreativeId__c, CreativeStatus__c,CreativeStage__c,SYSCreativeStep__c,
                                                SYS_Ready_For_Review__c,SYSInReview__c, SYS_CreativeApproved__c  FROM IMH_CommCreative__c 
                                                WHERE Id = : creativeRecordId LIMIT 1];
        IMH_Asset__c assetRec = [SELECT Id, Name, Creative__c, Communication__c FROM IMH_Asset__c WHERE Creative__c =: creativeRecordId LIMIT 1];
        
        //Check if the Final Creative record is created and its Id is stamped on Creative
        System.assertEquals(assetRec.Id,approvedCreative.SYS_FinalCreativeId__c);
        
        //Add Attachment to the final creative so that it becomes attested.
        Attachment attach;
        System.runAs(runningUserSubmitter) {
            attach = new Attachment();
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=assetRec.id;
            insert attach;
        }
        Test.stopTest();
        // Check if the the Final Creative record is attested after adding an attachment
        IMH_Asset__c attestedAssetRec = [SELECT Id, Name, Is_Attested__c, Creative__c FROM IMH_Asset__c 
                                         WHERE Creative__c =: creativeRecordId LIMIT 1];
        System.assertEquals(true,attestedAssetRec.Is_Attested__c);
 	}
}