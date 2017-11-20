/**
* @author Accenture IDC 
* @date 06/10/2016
* @group Easy Creation Channels/Products
* @group-content N/A
* @description Utility class that will be used in various scenario to make relation
*              with Creative Channels/Products with TargetedProducts/Channels
*/
public without sharing class IMH_EasyCreationUtility {
    
    private static final String  CHANNEL_START_DATE_API     = 'Channel_Start_Date__c';
    private static final String  CHANNEL_END_DATE_API       = 'Channel_End_Date__c';
	private static final String  PRODUCT_FIELD_API          = 'Product__c';
    private static final String  MARKET_FIELD_API           = 'MarketMultiSelect__c';
    private static final String  CHANNEL_FIELD_API          = 'Channel__c';
    public Map<Integer,Id>   mErrorCounterChildId                  {get;set;}
    public Set<Id>           selectedChannelsIdSet 				   {get;set;}	
    public Set<Id>           targetedChannelsIdSet 				   {get;set;}	
    public Map <String, Boolean>             easyStyleMap          {get; set;}
    public Boolean           errorOnTargetedInsert                 {get; set;}
    
    /*****************************************************************************
    * @description: Method to get communication Targeted Channel Id
    * @param: Id, Id
    * @return: void
    */
    public Map<Id,Id> retrieveTargetedChannelId(Id selectedsObjectRecordId,
                                               List<IMH_AddChildItemsOnParentController.SObjectWrapper> selectedSObjectsList) {
        IMH_CommCreative__c creativeRec = [SELECT Id, Name, Communication__c FROM IMH_CommCreative__c 
                                           WHERE Id =: selectedsObjectRecordId LIMIT 1];
		errorOnTargetedInsert = false;
		easyStyleMap = new Map <String, Boolean>();
        Map<Id,Id> targetedChannelIdMap = new Map<Id,Id>();
        selectedChannelsIdSet = new Set<Id>();
        targetedChannelsIdSet = new Set<Id>();
        Map<Id,Date> mChannelStartDate = new Map<Id,Date>();
        Map<Id,Date> mChannelEndDate = new Map<Id,Date>();
        for(IMH_AddChildItemsOnParentController.SObjectWrapper swrap : selectedSObjectsList)  {
            selectedChannelsIdSet.add(swrap.sObjectRecord.Id);
            mChannelStartDate.put(swrap.sObjectRecord.Id,Date.valueOf(swrap.junctionsObjectRec.get(CHANNEL_START_DATE_API)));
            mChannelEndDate.put(swrap.sObjectRecord.Id,Date.valueOf(swrap.junctionsObjectRec.get(CHANNEL_END_DATE_API)));
        }
		for(IMH_CommChannels__c comCh: [SELECT Id, Communication__c, Channel__c FROM IMH_CommChannels__c
                                        WHERE Communication__c =: creativeRec.Communication__c]){
            targetedChannelsIdSet.add(comCh.Channel__c);
        }
		List<IMH_CommChannels__c> lCommunicationChannelInsert = new List<IMH_CommChannels__c>();
        IMH_CommChannels__c commchannel;
        for(Id s : selectedChannelsIdSet){
            if(!(targetedChannelsIdSet.contains(s))){
                commchannel = new IMH_CommChannels__c();
                commchannel.Communication__c = creativeRec.Communication__c;
                commchannel.Channel__c = s;
                commchannel.Channel_Start_Date__c = mChannelStartDate.get(s);
                commchannel.Channel_End_Date__c = mChannelEndDate.get(s);
                commchannel.SYS_UICreated__c = true;
                lCommunicationChannelInsert.add(commchannel);
            }
        }
        Database.SaveResult[] targetedChannelInsertList =  Database.insert(lCommunicationChannelInsert, false);
		integer selectedCounter = 0;
		mErrorCounterChildId = new Map<Integer,Id>();
		for(Database.SaveResult sr: targetedChannelInsertList) {    
        	if(!sr.isSuccess()){
                if(!errorOnTargetedInsert){
                    errorOnTargetedInsert = true;
                }
                for(Database.Error err : sr.getErrors()) {
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,err.getMessage());
					ApexPages.addMessage(myMsg);
                    mErrorCounterChildId.put(selectedCounter,String.valueof(lCommunicationChannelInsert.get(selectedCounter).get(CHANNEL_FIELD_API)));
                    easyStyleMap.put((String)mErrorCounterChildId.get(selectedCounter),true);
                }
            }
            selectedCounter++;
        }
		for(IMH_CommChannels__c comCh: [SELECT Id, Communication__c, Channel__c FROM IMH_CommChannels__c
                                        WHERE Communication__c =: creativeRec.Communication__c]){
            targetedChannelIdMap.put(comCh.Channel__c, comCh.Id);
        }
        return targetedChannelIdMap;
    }
        
    /*****************************************************************************
    * @description: Method to get communication Targeted Product Id
    * @param: Id, Id
    * @return: void
    */
    public Map<Id,Id> retrieveTargetedProductId(Id selectedsObjectRecordId,
                                               List<IMH_AddChildItemsOnParentController.SObjectWrapper> selectedSObjectsList) {
        IMH_CommCreative__c creativeRec = [SELECT Id, Name, Communication__c FROM IMH_CommCreative__c 
                                           WHERE Id =: selectedsObjectRecordId LIMIT 1];
        errorOnTargetedInsert = false;
        easyStyleMap = new Map <String, Boolean>();
        Map<Id,Id> targetedProductIdMap = new Map<Id,Id>();
        Set<Id> selectedProductsIdSet = new Set<Id>();
        Set<Id> targetedProductsIdSet = new Set<Id>();
		Map<Id,String> mProductMarket = new Map<Id,String>();
        for(IMH_AddChildItemsOnParentController.SObjectWrapper swrap : selectedSObjectsList)  {
            selectedProductsIdSet.add(swrap.sObjectRecord.Id);
            mProductMarket.put(swrap.sObjectRecord.Id,String.valueof(swrap.sObjectRecord.get(MARKET_FIELD_API)));
        }                                                 
        for(IMH_CommProducts__c comCh: [SELECT Id, Communication__c, Product__c FROM IMH_CommProducts__c
                                        WHERE Communication__c =: creativeRec.Communication__c]){
            targetedProductsIdSet.add(comCh.Product__c);
        }
        List<IMH_CommProducts__c> lCommunicationProductInsert = new List<IMH_CommProducts__c>();
        IMH_CommProducts__c commproduct;
        for(Id s : selectedProductsIdSet){
            if(!(targetedProductsIdSet.contains(s))){
                commproduct = new IMH_CommProducts__c();
                commproduct.Communication__c = creativeRec.Communication__c;
                commproduct.Product__c = s;
                commproduct.Market__c  = mProductMarket.get(s);
                commproduct.SYS_UICreated__c = true;
                lCommunicationProductInsert.add(commproduct);
            }
        }
        Database.SaveResult[] targetedProdInsertList =  Database.insert(lCommunicationProductInsert, false);
		integer selectedCounter = 0;
		mErrorCounterChildId = new Map<Integer,Id>();
		for(Database.SaveResult sr: targetedProdInsertList) {    
        	if(!sr.isSuccess()){
            	if(!errorOnTargetedInsert){
                    errorOnTargetedInsert = true;
                }
                for(Database.Error err : sr.getErrors()) {
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,err.getMessage());
					ApexPages.addMessage(myMsg);
                    mErrorCounterChildId.put(selectedCounter,String.valueof(lCommunicationProductInsert.get(selectedCounter).get(PRODUCT_FIELD_API)));
                    easyStyleMap.put((String)mErrorCounterChildId.get(selectedCounter),true);
                }
            }
            selectedCounter++;
        }
        for(IMH_CommProducts__c comCh: [SELECT Id, Communication__c, Product__c FROM IMH_CommProducts__c
                                        WHERE Communication__c =: creativeRec.Communication__c]){
            targetedProductIdMap.put(comCh.Product__c, comCh.Id);
        }
        return targetedProductIdMap;
    }
}