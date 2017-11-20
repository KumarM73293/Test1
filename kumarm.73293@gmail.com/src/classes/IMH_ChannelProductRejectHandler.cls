/**
* @author Accenture IDC 
* @date 01/12/2016
* @group Answer
* @group-content N/A
* @description Trigger Handler on Targeted Channel/Product that handles rejection/recall of 
*              Creative/Targeted Channel/Targeted Product
*/ 
public without sharing class IMH_ChannelProductRejectHandler {
    private static final String CREATIVE_API          = 'Creative__c';
    private static final String COMMUNICATION_API          = 'Communication__c';
    public static Boolean isExecutedAfter             = false;
	/*****************************************************************************
    * @description: Method to Rollup Field Required Fields to Creative from Product/Channel
    * @param: Trigger.New/Trigger.Old,Trigger.NewMap,Trigger.OldMap
    * @return: void
   */ 
	public  static void updateRequiredApproversOnCreative(List<sObject> ltrigger,Set<Id> sCreativeIds){
        
		List<sObject> lChannelsAndProducts = new List<sObject>();
		List<IMH_CommCreative__c> lCreativesToUpdate = new List<IMH_CommCreative__c>();                                                
        for(sObject sObj :ltrigger){
            sCreativeIds.add(String.valueOf(sObj.get(CREATIVE_API)));
        }
        Set<String> sRequiredApprovers = new Set<String>();
	    for(IMH_CommCreative__c commCreative : [SELECT Id,RequiredApprovers__c,
                                                (SELECT Id,TargetedProduct__r.Product__r.RequiredApprovers__c FROM Targeted_Products__r 
                                                                                            WHERE TargetedProduct__r.Product__r.RequiredApprovers__c != NULL),
                                                (SELECT Id,TargetedChannel__r.Channel__r.RequiredApprovers__c FROM Targeted_Channels__r 
                                                                                            WHERE TargetedChannel__r.Channel__r.RequiredApprovers__c != NULL) 
                                                FROM IMH_CommCreative__c WHERE ID IN :sCreativeIds]){
			sRequiredApprovers = new Set<String>(); 
			commCreative.RequiredApprovers__c = IMH_UtilityConstants.EMPTY_STRING;
                                                    
            for(IMH_CreativeProduct__c tarProduct : commCreative.Targeted_Products__r){
                sRequiredApprovers.addAll(tarProduct.TargetedProduct__r.Product__r.RequiredApprovers__c.split(IMH_UtilityConstants.SEMI_COLON));
            }
            for(IMH_CreativeChannel__c tarChannel : commCreative.Targeted_Channels__r){
                sRequiredApprovers.addAll(tarChannel.TargetedChannel__r.Channel__r.RequiredApprovers__c.split(IMH_UtilityConstants.SEMI_COLON));
            }
			
           	for(String reqApp : sRequiredApprovers){
                if(String.isBlank(commCreative.RequiredApprovers__c)){
                    commCreative.RequiredApprovers__c = reqApp;
                }else{
                    commCreative.RequiredApprovers__c = commCreative.RequiredApprovers__c + IMH_UtilityConstants.SEMI_COLON + reqApp;
                }
            }  
            lCreativesToUpdate.add(commCreative);                                                    
			                                                   
        }
		if(!lCreativesToUpdate.isEmpty()){
            Database.update(lCreativesToUpdate,true);
        }									
	}
    
    /*****************************************************************************
    * @description: Method to Rollup Field Required Fields to Communication from Product/Channel
    * @param: Trigger.New/Trigger.Old,Trigger.NewMap,Trigger.OldMap
    * @return: void
   */ 
	public  static void updateRequiredApproversOnCommunication(List<sObject> ltrigger){
        Set<Id> communicationIds = new Set<Id>();
		List<IMH_Communication__c> lCommunicationsToUpdate = new List<IMH_Communication__c>();                                                
        for(sObject sObj :ltrigger){
            communicationIds.add(String.valueOf(sObj.get(COMMUNICATION_API)));
        }
        Set<String> sRequiredApprovers = new Set<String>();
	    for(IMH_Communication__c commObj : [SELECT Id,RequiredApprovers__c,
                                                (SELECT Id,Product__r.RequiredApprovers__c FROM CommunicationProducts__r 
                                                                                            WHERE Product__r.RequiredApprovers__c != NULL),
                                                (SELECT Id,Channel__r.RequiredApprovers__c FROM CommunicationChannel__r 
                                                                                            WHERE Channel__r.RequiredApprovers__c != NULL) 
                                                FROM IMH_Communication__c WHERE ID IN :communicationIds]){
			sRequiredApprovers = new Set<String>(); 
			                                                    
            if(commObj.RequiredApprovers__c!=NULL){
                sRequiredApprovers.addAll(commObj.RequiredApprovers__c.split(IMH_UtilityConstants.SEMI_COLON));
            }                                                    
            commObj.RequiredApprovers__c = IMH_UtilityConstants.EMPTY_STRING;
                                                    
            for(IMH_CommProducts__c tarProduct : commObj.CommunicationProducts__r){
                sRequiredApprovers.add(tarProduct.Product__r.RequiredApprovers__c);
            }
            for(IMH_CommChannels__c tarChannel : commObj.CommunicationChannel__r){
                sRequiredApprovers.add(tarChannel.Channel__r.RequiredApprovers__c);
            }
			
           	for(String reqApp : sRequiredApprovers){
                if(String.isBlank(commObj.RequiredApprovers__c)){
                    commObj.RequiredApprovers__c = reqApp;
                }else{
                    commObj.RequiredApprovers__c = commObj.RequiredApprovers__c + IMH_UtilityConstants.SEMI_COLON + reqApp;
                }
            }  
            lCommunicationsToUpdate.add(commObj);                                                    
			                                                   
        }
		if(!lCommunicationsToUpdate.isEmpty()){
            Database.update(lCommunicationsToUpdate,true);
        }									
	}
}