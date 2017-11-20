/**
* @author Accenture IDC 
* @date 03/22/2016
* @group Attachment
* @group-content N/A
* @description Trigger Handler on Attachment that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/ 
public without sharing class IMH_AttachmentTriggerHandler {
    
    private static final String ISATTESTED_API = 'Is_Attested__c';

    /*****************************************************************************
    * @description: Mehod called on after update of trigger event and used to update the final creative 
    * @param: Trigger.New
    * @return: void
    */
	public static void updateFinalCreative(List<Attachment> lTriggernew){
        Schema.DescribeSObjectResult assetObjDesc = IMH_Asset__c.sObjectType.getDescribe();
        List<sObject> lFinalCreativeToUpdate = new List<sObject>();
        IMH_Asset__c tempAsset = new IMH_Asset__c();
        for(Attachment att : lTriggernew){
            //CHECK FOR THE PARENT ID OF THE ATTACHMENT IS OF SOBJECT TYPE IMH_ASSET__C
            if(ID.valueOf(att.ParentId).getSobjectType() == Schema.IMH_Asset__c.SObjectType) {
                //CREATE THE INSTANCE OF SOBJECT WITH ID AND USING NEWSOBJECT METHOD
                sObject tempsObj = Schema.IMH_Asset__c.SObjectType.newSobject(ID.valueOf(att.ParentId)); 
                tempsObj.put(ISATTESTED_API,TRUE);
                lFinalCreativeToUpdate.add(tempsObj);
            }  
        }
        //UPDATE THE LIST OF FINAL CREATIVE IF THE LIST NOT EMPTY    
        if(!lFinalCreativeToUpdate.isEmpty()){
            Database.update(lFinalCreativeToUpdate,false);
        }
    }
    
 	/*****************************************************************************
    * @description: Mehod called on after update of Creative and Communication on Delete of Attachement on Asset 
    * @param: Trigger.New
    * @return: void
    */
	public static void updateCreativeAndCommunicationOnDelete(List<Attachment> lTriggerold) {
		Set<Id> assetIdSet = new Set<Id>();
        for(Attachment att : lTriggerold) {        
            if(ID.valueOf(att.ParentId).getSobjectType() == Schema.IMH_Asset__c.SObjectType) {
                assetIdSet.add(att.ParentId);
            }
        }
        List<Attachment> otherAttachmentsList = new List<Attachment>();
        otherAttachmentsList = [SELECT Id, ParentId FROM Attachment WHERE ParentId =: assetIdSet];
        if(otherAttachmentsList.isEmpty()) {
            updateAssetRecords(assetIdSet);
        }
        else {
            //Will be used for bulk scenario.
            Set<Id> assetRecsWithNoAttachments = new Set<Id>();
            for(Attachment record: otherAttachmentsList){
                assetIdSet.remove(record.ParentId);
                updateAssetRecords(assetIdSet);
            }
        }
	}
    
    /**
    * @description: Method used to update asset records
    * @param: none
    * @return: void
    */
    public static void updateAssetRecords(Set<Id> assetIdSet) {
        List<IMH_Asset__c> updateAssetRecs = new List<IMH_Asset__c>();
        for(IMH_Asset__c asset: [Select Id, Is_Attested__c, Creative__c 
                                 FROM IMH_Asset__c WHERE id=: assetIdSet]){
            asset.Is_Attested__c = false;
            updateAssetRecs.add(asset);
        }
        if(!updateAssetRecs.isEmpty()){
            Database.SaveResult[] sResult=  Database.update(updateAssetRecs);
        }
    }
    
    /**
    * @description: Method used to check and prevent deletion of attachment based on communication stage
    * @param: none
    * @return: void
    */
    public static void checkCommunicationStageonDelete(Map<Id,Attachment> TriggerOldMap) {
        Map<Id,Id> attachmentAssetIdMap = new Map<Id,Id>();
        for(Attachment att : TriggerOldMap.values()) {        
            if(att.OwnerId != UserInfo.getUserId() &&
               ((ID.valueOf(att.ParentId).getSobjectType() == Schema.IMH_Asset__c.SObjectType) || 
                (ID.valueOf(att.ParentId).getSobjectType() == Schema.IMH_CommCreative__c.SObjectType) ||
                (ID.valueOf(att.ParentId).getSobjectType() == Schema.IMH_Benefits__c.SObjectType))) {
                	att.addError(Label.IMH_MsgOnReviewerDeleteAttachment);
            }
			if(ID.valueOf(att.ParentId).getSobjectType() == Schema.IMH_Asset__c.SObjectType) {
                attachmentAssetIdMap.put(att.ParentId,att.Id);
            }
        }
        if(!attachmentAssetIdMap.isEmpty()) {
            for(IMH_Asset__c asset:[Select Id, 
                                           Communication__r.ProcessStage__c 
                                    FROM IMH_Asset__c 
                                    WHERE id =: attachmentAssetIdMap.keyset()]){
                if((IMH_UtilityConstants.READY_FOR_EXECUTION.equalsIgnoreCase(asset.Communication__r.ProcessStage__c))) {
                    //HAVE CUSTOM LABEL INSTEAD OF HARDCODING
                    TriggerOldMap.get(attachmentAssetIdMap.get(asset.Id)).addError(Label.IMH_PreventDeletionOfAttachment);
                }
			}
		}
    }
    
    /**
    * @description: Method used to prevent update on attachment by the reviewer
    * @param: none
    * @return: void
    */
    public static void preventUpdateByReviewer(List<Attachment> TriggerNew) {
        for(Attachment att : TriggerNew) {
            if(att.OwnerId != UserInfo.getUserId() &&
               ((ID.valueOf(att.ParentId).getSobjectType() == Schema.IMH_Asset__c.SObjectType) || 
                (ID.valueOf(att.ParentId).getSobjectType() == Schema.IMH_CommCreative__c.SObjectType) ||
                (ID.valueOf(att.ParentId).getSobjectType() == Schema.IMH_Benefits__c.SObjectType))) {
                	att.addError(Label.IMH_MsgOnReviewerEditAttachment);
            }
        }
    }
}