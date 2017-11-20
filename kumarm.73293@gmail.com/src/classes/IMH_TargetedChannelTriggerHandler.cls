/**
* @author Accenture IDC 
* @date 09/06/2016
* @group TargetedChannels
* @group-content N/A
* @description Trigger Handler on TargetedChannles that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/ 
public class IMH_TargetedChannelTriggerHandler {
    public static Boolean  isExecutionControl = true;
    private static final String COMMUNICATION_R              = 'Communication__r';
    private static Final String SYS_COMMUNICATIONSTAGE_API = 'Stage__c';
    private static final String CONCEPT_DESIGN = 'Concept - Design';
    private static final String TARGETEDCHANNEL     = 'Targeted Channels';
    private static final String CHANNEL_FILED_API = 'Channel__c';
    
    /**
    * @description: Method performed after delete
    * @param: none
    * @return: void
    */
    public  static void processAfterDelete(Map<Id,IMH_CommChannels__c> moldtriggermap) { 
        IMH_GeneralApplicationUility.removeRequiredApprovers(moldtriggermap,CHANNEL_FILED_API);
    }
    
    /**
    * @description: Method performed before delete
    * @param: none
    * @return: void
    */
    public  static void processBeforeDelete(Map<Id,IMH_CommChannels__c> moldtriggermap) { 
        IMH_GeneralApplicationUility.preventDeletion(moldtriggermap,Label.IMH_PreventDeletionOfTargetedChannel,IMH_UtilityConstants.TARGETEDCOMMCHANNEL_OBJECT_API);
    }
    
    /**
    * @description: Method performed after undelete
    * @param: none
    * @return: void
    */
    public static void processAfterUndelete(List<IMH_CommChannels__c> ltriggernew) {
        //IMH_CommCreativeTriggerHandler.insertCreativeProdChannel(Trigger.new,Trigger.NewMap,Trigger.OldMap,TARGETEDCHANNEL);
        IMH_ChannelProductRejectHandler.updateRequiredApproversOnCommunication(ltriggernew); 
    } 
    
    /**
    * @description: Method performed after insert
    * @param: none
    * @return: void
    */
    public static void processAfterInsert(List<IMH_CommChannels__c> ltriggernew,Map<Id,IMH_CommChannels__c> mnewtriggermap,Map<Id,IMH_CommChannels__c> moldtriggermap) {  
        IMH_CommCreativeTriggerHandler.insertCreativeProdChannel(ltriggernew,mnewtriggermap,moldtriggermap,TARGETEDCHANNEL);
        IMH_ChannelProductRejectHandler.updateRequiredApproversOnCommunication(Trigger.New); 
    }
}