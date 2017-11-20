/**
* @author Accenture IDC 
* @date 01/13/2016
* @group Answer - ***************** PEER REVIEW 05/04/2016 - CORRECT GROUP
* @group-content N/A
* @description Trigger Handler on Targeted Channel/Product that handles deletion of
*			   Targeted Channel/Targeted Product at specific stage of Creative
*/ 
public without sharing class IMH_ChannelsProductsPreventDelete {
    //PEER REVIEW 05/04/2016 - PUT THE ERROR MESSAGE IN CUSTOM LABEL
    private static final String COMPLETE = 'Complete';
    private static final String CREATIVE_API = 'Creative__c';
    
    /*****************************************************************************
    * @description -  Used to prevent deletion of Products and Channels when Creative is in Review or Approved state
    * @param - Trigger.Old(TargetedProduct/TargetedChannel)
    * @return - void
    */ 
    public static void checkRecordStatus(List<Sobject> ltriggerOld) {
        List<IMH_CommCreative__c> creativeList = new List<IMH_CommCreative__c>();
        Set<Id> creativeIdSet = new Set<Id>();
        for(Sobject sobj: ltriggerOld) {
            creativeIdSet.add(String.valueOf(sobj.get(CREATIVE_API)));
        }
         //PEER REVIEW 05/04/2016 - USE LIMIT KEYWORD
        creativeList = [SELECT Id, CreativeStatus__c, CreativeStage__c FROM IMH_CommCreative__c where Id =: creativeIdSet];
        // PEER REVIEW 05/04/2016 -  LOGIC SHOULD BE MODIFIED TO ENSURE WE ARE CHECKING ONLY THE RESPECTIVE CREATIVE 
        // USE MAP<ID,IMH_COMMCREATIVE__C> AND USE MAP.GET(CREATIVE)
        //  WHEN WE ITERATE THROUGH THE SOBJECT LOOP TO AVOID THE INNER FOR LOOP
        for(Sobject sobj: ltriggerOld) {
            for(IMH_CommCreative__c cr: creativeList) {
                //PEER REVIEW 05/04/2016 - USE STRING METHODS TO CEHCK AGAINST THE CONSTANTS 
                //AND USE CONSTANTS TO AVOID NULL POINTER
                if(cr.CreativeStatus__c == IMH_UtilityConstants.COM_INREVIEW_REQ_STATUS || 
                  cr.CreativeStatus__c == IMH_UtilityConstants.CAMPAIGN_APP_REQ_STATUS) {
                       sobj.addError(Label.IMH_PreventDeletionOfProductChannel);
                }
                else if (cr.CreativeStage__c == COMPLETE){
                    sobj.addError(Label.IMH_PreventDeletionProductChannelInCompleted);
                }
                 
            }
        }
	}
}