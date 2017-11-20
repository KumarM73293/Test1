/**
    * @author Accenture IDC 
    * @date 03/29/2016
    * @group Attachment (Final Creative)
    * @group-content N/A
    * @description: iMH Release 1.4 (Sprint 32) - Test Class for Note Trigger
*/
@isTest
private class IMH_NoteTriggerTest {
    
    private static final String CAMPAIGN_SUBMITTER_PROFILE  = 'iMH Campaign Submitter';
    private static final String SUBMITTER_RUNNING_USER      = 'RunningUserSubmitter';
    private static final String CREATIVE_STAGE              = 'Creative'; 
    private static final String ATTESTATION_STAGE           = 'Design';
    private static final String MARKET_THAILAND             = 'Thailand';
    private static final String INPROGRESS_STATUS           = 'In Progress';
    private static final String CREATIVE_API_NAME           = 'IMH_CommCreative__c';
    private static final String CREATIVE_RECTYPE            = 'CreativeDesign';
    /*****************************************************************************
    * @description: Method used for covering the case where the Note/Atttachment cannot be updated/deleted by other user apart from owner
    * @param: none
    * @return: void
    */
    static testMethod void addOneNoteAndDelete() {
        User runningUserSubmitter = IMH_TestClassUtility.createUser(CAMPAIGN_SUBMITTER_PROFILE,SUBMITTER_RUNNING_USER,null);
        //Test Data for Communication
        Id creativeRecordId;
        Id communicationRecordId;
        Id insertedBenefitId;
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
            List<IMH_Benefits__c> lBenefits = new List<IMH_Benefits__c>();
            for(Integer i=0;i<1;i++) {
                lBenefits.add(IMH_TestClassUtility.createBenefits('Local','JAPA','Japan'));
            }
            Database.SaveResult[] srListBenefit = Database.insert(lBenefits,false);
            insertedBenefitId = srListBenefit[0].getId();       
        }
        Test.startTest();
        //Approve Creative
        IMH_CommCreative__c creativeRecUpdate  = [SELECT Id, SYS_Ready_For_Review__c FROM IMH_CommCreative__c 
                                                  WHERE Id =: creativeRecordId];
        creativeRecUpdate.CreativeStage__c = 'Final Creative';  
        creativeRecUpdate.SYS_CreativeApproved__c = false;
        creativeRecUpdate.SYS_IsFinalCreativeCreated__c = true;
        System.runAs(runningUserSubmitter){
            update creativeRecUpdate;
        }
        IMH_CommCreative__c approvedCreative = [SELECT Id, SYS_FinalCreativeId__c, CreativeStatus__c,CreativeStage__c,SYSCreativeStep__c,
                                                SYS_Ready_For_Review__c,SYSInReview__c, SYS_CreativeApproved__c  FROM IMH_CommCreative__c 
                                                WHERE Id = : creativeRecordId];
        IMH_Asset__c assetRec = [SELECT Id, Name, Creative__c, Communication__c FROM IMH_Asset__c WHERE Creative__c =: creativeRecordId];
        
        //Check if the Final Creative record is created and its Id is stamped on Creative
        System.assertEquals(assetRec.Id,approvedCreative.SYS_FinalCreativeId__c);
        //Add Attachment to the final creative so that it becomes attested.
        List<Note> newNotesList = new List<Note>();
        System.runAs(runningUserSubmitter) {
            Note newNote;
            for(integer i=0;i<=2;i++){
                newNote= new Note();
                newNote.Title='Test Note Title';
                newNote.Body='Test Note Body';
                if(i==0) {
                    newNote.ParentId = creativeRecordId;
                }
                if(i==1) {
                    newNote.ParentId = assetRec.Id;    
                }
                else {
                    newNote.ParentId = insertedBenefitId;    
                }
                newNotesList.add(newNote);
            }
            insert newNotesList;
            
        }
        Test.stopTest();
        //Update the Attachment
        List<Note> updateNoteList = new List<Note>();
        updateNoteList = [SELECT Id, ParentId FROM Note WHERE Id =: newNotesList];
        updateNoteList[0].Title = 'New Name1';
        updateNoteList[1].Title = 'New Name2';
        updateNoteList[2].Title = 'New Name3';
        Database.update(updateNoteList,false);
        Database.delete(updateNoteList,false);
    }
}