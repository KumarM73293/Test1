/**
* @author Accenture IDC 
* @date 08/06/2016
* @group TargetedProduct
* @group-content N/A
* @description Trigger Handler on TargetedProduct that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/ 
public class IMH_TargetedProductTriggerHandler{
     public static Boolean  isExecutionControl = true;
    private static final String COMMUNICATION_R              = 'Communication__r';
    private static Final String SYS_COMMUNICATIONSTAGE_API = 'Stage__c';
    private static final String CONCEPT_DESIGN = 'Concept - Design';
    private static final String COMMUNICATION_FIELD = 'Communication__c';
    private static final String TARGETEDPRODUCTS    = 'Targeted Product';
    private static final String PRODUCTAPI = 'Product__c';
    
    /*****************************************************************************
        * @description -  This method is handle the appropriate trigger context on TargetedProducts
        * @param - Trigger.New(Creative), Trigger.newMap(sObject),Trigger.OldMap(sObject)
        * @return - void
    */
    public static void handleAfterDelete(List<IMH_CommProducts__c>ltriggernew
                                                    , Map<Id,sObject> mtriggernew
                                                    , Map<Id,sObject> mtriggerold){
            IMH_GeneralApplicationUility.removeRequiredApprovers((Map<Id,IMH_CommProducts__c>)mtriggerold,PRODUCTAPI); 
    }
    
	/*****************************************************************************
        * @description -  This method is handle the appropriate trigger context on TargetedProducts
        * @param - Trigger.New(Creative), Trigger.newMap(sObject),Trigger.OldMap(sObject)
        * @return - void
    */
	public static void handleBeforeDelete(List<IMH_CommProducts__c>ltriggernew
                                                    , Map<Id,sObject> mtriggernew
                                                    , Map<Id,sObject> mtriggerold){
            IMH_GeneralApplicationUility.preventDeletion((Map<Id,IMH_CommProducts__c>)mtriggerold,Label.IMH_PreventDeletionOfTargetedProduct,IMH_UtilityConstants.TARGETEDCOMMPRODUCT_OBJECT_API); 
    }
	
	/*****************************************************************************
        * @description -  This method is handle the appropriate trigger context on TargetedProducts
        * @param - Trigger.New(Creative), Trigger.newMap(sObject),Trigger.OldMap(sObject)
        * @return - void
    */
	public static void handleAfterUndelete(List<IMH_CommProducts__c>ltriggernew
                                                    , Map<Id,sObject> mtriggernew
                                                    , Map<Id,sObject> mtriggerold){
            IMH_ChannelProductRejectHandler.updateRequiredApproversOnCommunication(ltriggernew); 
    }
	
	/*****************************************************************************
        * @description -  This method is handle the appropriate trigger context on TargetedProducts
        * @param - Trigger.New(Creative), Trigger.newMap(sObject),Trigger.OldMap(sObject)
        * @return - void
    */
	public static void handleAfterInsert(List<IMH_CommProducts__c>ltriggernew
                                                    , Map<Id,IMH_CommProducts__c> mtriggernew
                                                    , Map<Id,IMH_CommProducts__c> mtriggerold){
            IMH_CommCreativeTriggerHandler.insertCreativeProdChannel(ltriggernew,mtriggernew,mtriggerold,TARGETEDPRODUCTS); 
			IMH_ChannelProductRejectHandler.updateRequiredApproversOnCommunication(ltriggernew);  
    }
	
	
}