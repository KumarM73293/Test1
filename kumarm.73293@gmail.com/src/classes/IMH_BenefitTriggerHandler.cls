/**
* @author Accenture IDC 
* @date 12/11/2015
* @group Benefit
* @group-content N/A
* @description Trigger Handler on Benefit that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/ 
public without sharing class IMH_BenefitTriggerHandler {
    public static Boolean isExecutedAfter = false;
    /*****************************************************************************
    * @description: Mehod called on after update of trigger event
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
    public static void handleAfterUpdate(List<sObject> ltriggernew
                                         , Map<Id,sObject> mtriggernew
                                         , Map<Id,sObject> mtriggerold){
        IMH_GeneralApplicationUility.createAnswerSet(ltriggernew,mtriggernew,mtriggerold);
    }
    
   /*****************************************************************************
    * @description: Mehod called on after insert of trigger event
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
     public static void handleAfterInsert(List<sObject>ltriggernew
                                          , Map<Id,sObject> mtriggernew
                                          , Map<Id,sObject> mtriggerold){
        IMH_GeneralApplicationUility.createAnswerSet(ltriggernew,mtriggernew
                                                     , new Map<Id,IMH_Benefits__c>());
    }
    
}