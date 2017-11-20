/**
    * @author Accenture IDC 
    * @date 03/29/2016
    * @group Attachment (Final Creative)
    * @group-content N/A
    * @description: iMH Release 1.4 (Sprint 32) - Test Class for Asset Trigger
*/
@isTest
private class IMH_AttachmentTriggerTest {

    private static final String INPROGRESS_STATUS           = 'In Progress';
    private static final String MARKET_THAILAND             = 'Thailand';
    private static final String CREATIVE_API_NAME           = 'IMH_CommCreative__c';
    private static final String REGION_JAPA                 = 'JAPA';
    private static final String CAMPAIGN_SUBMITTER_PROFILE  = 'iMH Campaign Submitter';
    private static final String RUNNING_USER                = 'RunningUser';
    private static final String CREATIVE_RECTYPE            = 'CreativeDesign';
    private static final String SUBMITTER_RUNNING_USER      = 'RunningUserSubmitter';
    private static final String CREATIVE_STAGE              = 'Creative'; 
    private static final String ATTESTATION_STAGE           = 'Design';
    
    /**
    * @description: Test Method used to Approve Creative and create Asset
    * @param: none
    * @return: void
    */
    static testMethod void addOneAttachmentAndDelete() {
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        //Test Data for Communication
        Id creativeRecordId;
        Id communicationRecordId;
        System.runAs(runningUserSubmitter) {
            IMH_Communication__c communicationRec = new IMH_Communication__c();
            communicationRec = IMH_TestClassUtility.createCommunication(CREATIVE_STAGE,ATTESTATION_STAGE,MARKET_THAILAND);
            insert communicationRec;
            communicationRecordId = communicationRec.Id; 
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
        //Update the Attachment
        List<Attachment> updateAttachList = new List<Attachment>();
        updateAttachList = [SELECT Id, ParentId FROM Attachment WHERE Id =: attach.Id 
                            AND ParentId =: assetRec.id LIMIT 1];
        updateAttachList[0].Name = 'New Name';
        Database.update(updateAttachList,false);
        // Check if the the Final Creative record is attested after adding an attachment
        IMH_Asset__c attestedAssetRec = [SELECT Id, Name, Is_Attested__c, Creative__c FROM IMH_Asset__c 
                                         WHERE Creative__c =: creativeRecordId LIMIT 1];
        System.assertEquals(true,attestedAssetRec.Is_Attested__c);
 		//Bring back the communication record to previous stage
        IMH_Communication__c commRec = [Select Id, ProcessStage__c,ReviewStage__c,ReviewStatus__c FROM 
                                        IMH_Communication__c WHERE id =: communicationRecordId LIMIT 1];
        commRec.ProcessStage__c   = IMH_UtilityConstants.CREATIVE;
        commRec.ReviewStage__c    = IMH_UtilityConstants.COM_REV_STAGE_DESIGN;
        commRec.ReviewStatus__c   = IMH_UtilityConstants.CAMPAIGN_INPROGRESS;
		update commRec;
        // Delete Attachment from the final creative so that it is non-attested.        
        System.runAs(runningUserSubmitter) {
        	Attachment	attachDelete = [SELECT id from Attachment 
                                    WHERE id =: attach.Id LIMIT 1];
        	Database.delete(attachDelete,true);
        }
        //Check if the the Final Creative record is non-attested after deleting an attachment
        IMH_Asset__c nonattestedAssetRec = [SELECT Id, Name, Is_Attested__c, Creative__c FROM IMH_Asset__c 
                                         WHERE Creative__c =: creativeRecordId LIMIT 1];
        System.assertEquals(false,nonattestedAssetRec.Is_Attested__c);
    }
    /* Description: Create 2 attachment and Delete 1 Attachment
    * @param: none
    * @return: void	
	*/
    static testMethod void multipleAttachmentandDeleteOne() {
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
		Attachment attach1;        
        System.runAs(runningUserSubmitter) {
            attach = new Attachment();
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=assetRec.id;
            insert attach;
			
            attach1 = new Attachment();
            attach1.Name='Unit Test Attachment 1';
            bodyBlob=Blob.valueOf('Unit Test Attachment 1 Body');
            attach1.body=bodyBlob;
            attach1.parentId=assetRec.id;
            insert attach1;			
        }
        Test.stopTest();
        ///Check if the the Final Creative record is attested after adding an attachment
        IMH_Asset__c attestedAssetRec = [SELECT Id, Name, Is_Attested__c, Creative__c FROM IMH_Asset__c 
                                         WHERE Creative__c =: creativeRecordId LIMIT 1];
        System.assertEquals(true,attestedAssetRec.Is_Attested__c);
 
        // Delete Attachment from the final creative so that it is non-attested.        
        Attachment	attachDelete = [SELECT id from Attachment 
                                    WHERE id =: attach.Id LIMIT 1];
        Database.delete(attachDelete,false);
        
        //Check if the the Final Creative record is attested after deleting an attachment
        attestedAssetRec = [SELECT Id, Name, Is_Attested__c, Creative__c FROM IMH_Asset__c 
                                         WHERE Creative__c =: creativeRecordId LIMIT 1];
        System.assertEquals(True,attestedAssetRec.Is_Attested__c);       	
	} 
    /**
    * @description: Undelete the deleted attachment.
    * @param: none
    * @return: void
    */
    static testMethod void unDeleteAttachment() {
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        //Test Data for Communication
        Id creativeRecordId;
        Id communicationRecordId;
        System.runAs(runningUserSubmitter) {
            IMH_Communication__c communicationRec = new IMH_Communication__c();
            communicationRec = IMH_TestClassUtility.createCommunication(CREATIVE_STAGE,ATTESTATION_STAGE,MARKET_THAILAND);
             IMH_CommunicationTriggerHandler.isExecutedAfter = true;
            insert communicationRec;
             IMH_CommunicationTriggerHandler.isExecutedAfter = false;
            communicationRecordId = communicationRec.Id;
            
            //Test Data for Creative
            IMH_CommCreative__c creativeRec = new IMH_CommCreative__c();
            creativeRec = IMH_TestClassUtility.createFinalCreative(communicationRec.Id,INPROGRESS_STATUS,
                           IMH_TestClassUtility.mRecordType.get(CREATIVE_API_NAME).get(CREATIVE_RECTYPE).Id);
            creativeRec.CreativeStage__c = 'Design';
            creativeRec.SYSCreativeStep__c = 'COUNTER_1';
            insert creativeRec;
            creativeRecordId = creativeRec.Id;
        }
       
        //Approve Creative
        IMH_CommCreative__c creativeRecUpdate  = [SELECT Id, SYS_Ready_For_Review__c,SYS_FinalCreativeId__c FROM IMH_CommCreative__c 
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
        IMH_Asset__c assetRec = [SELECT Id, Name, Is_Attested__c, Creative__c, Communication__c FROM IMH_Asset__c WHERE Creative__c =: creativeRecordId LIMIT 1];
        
        //Check if the Final Creative record is created and its Id is stamped on Creative
        System.assertEquals(assetRec.Id,approvedCreative.SYS_FinalCreativeId__c);
        
        //Add Attachment to the final creative so that it becomes attested.
        Attachment attach;
          Test.startTest();
        System.runAs(runningUserSubmitter) {
            attach = new Attachment();
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=assetRec.id;
            insert attach;
        //}
        //Test.stopTest();
        // Check if the the Final Creative record is attested after adding an attachment
        IMH_Asset__c attestedAssetRec = [SELECT Id, Name, Is_Attested__c, Creative__c FROM IMH_Asset__c 
                                         WHERE Creative__c =: creativeRecordId LIMIT 1];
        System.assertEquals(true,attestedAssetRec.Is_Attested__c);
 		//Bring back the communication record to previous stage
        IMH_Communication__c commRec = [Select Id, ProcessStage__c,ReviewStage__c,ReviewStatus__c FROM 
                                        IMH_Communication__c WHERE id =: communicationRecordId LIMIT 1];
        commRec.ProcessStage__c   = IMH_UtilityConstants.CREATIVE;
        commRec.ReviewStage__c    = IMH_UtilityConstants.COM_REV_STAGE_DESIGN;
        commRec.ReviewStatus__c   = IMH_UtilityConstants.CAMPAIGN_INPROGRESS;
            IMH_CommunicationTriggerHandler.isExecutedAfter = true;
		update commRec;
        // Delete Attachment from the final creative so that it is non-attested.        
        Attachment	attachDelete = [SELECT id from Attachment WHERE id =: attach.Id LIMIT 1];
        delete attachDelete;
           
        //Check if the the Final Creative record is non-attested after deleting an attachment
        IMH_Asset__c nonattestedAssetRec = [SELECT Id, Name, Is_Attested__c, Creative__c FROM IMH_Asset__c 
                                            WHERE Creative__c =: creativeRecordId LIMIT 1];
        //System.assertEquals(false,nonattestedAssetRec.Is_Attested__c);
        
        	undelete attachDelete;
        }
        Test.stopTest();
        IMH_Asset__c attestedAssetRecUndelete = [SELECT Id, Name, Is_Attested__c, Creative__c FROM IMH_Asset__c 
                                            WHERE Creative__c =: creativeRecordId LIMIT 1];
        System.assertEquals(true,attestedAssetRecUndelete.Is_Attested__c);
    }
}