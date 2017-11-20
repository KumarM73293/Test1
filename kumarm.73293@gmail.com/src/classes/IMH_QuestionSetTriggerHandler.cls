/**
* @author Accenture IDC 
* @date 08/27/2015
* @group Question Set
* @group-content N/A
* @description Trigger Handler on Offer that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/
public without sharing class IMH_QuestionSetTriggerHandler {
	public static Boolean isExecutedBefore = false;
    /*****************************************************************************
    * @description: Mehod called on before update of trigger event
    * @param: Trigger.New,Trigger.OldMap
    * @return: void
    */
    public static void handleBeforeUpdate(List<sObject> ltriggernew
                                         , Map<Id,sObject> mtriggerold){
        IMH_GeneralApplicationUility.checkUniquenessOfRecord(ltriggernew,mtriggerold);
    }
    
    /*****************************************************************************
    * @description: Mehod called on before update of trigger event
    * @param: Trigger.New
    * @return: void
    */
    public static void handleBeforeInsert(List<sObject> ltriggernew){
        IMH_GeneralApplicationUility.checkUniquenessOfRecord(ltriggernew,new Map<Id,sObject>());
    }
}