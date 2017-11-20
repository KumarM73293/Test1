/**
* @author Accenture IDC 
* @date 03/22/2016
* @group Asset
* @group-content N/A
* @description Trigger Handler on Asset that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/
public without sharing class IMH_AssetTriggerHandler {
    private static final String SYSFINALCREATIVEAPI = 'SYS_FinalCreativeId__c';
    /*****************************************************************************
    * @description: Mehod called on after update of trigger event and 
    *               used to update the creative with final creative id in text field
    * @param: Trigger.New
    * @return: void
    */
    public static void updateFinalCreativeId(List<IMH_Asset__c> lTriggernew){
        List<sObject> lCreativeToUpdate = new List<sObject>();
        for(IMH_Asset__c asset : lTriggernew){
            //CREATE THE INSTANCE OF SOBJECT WITH ID AND USING NEWSOBJECT METHOD
            sObject tempsObj = Schema.IMH_CommCreative__c.SObjectType.newSobject(ID.valueOf(asset.Creative__c)); 
            tempsObj.put(SYSFINALCREATIVEAPI,String.valueOf(asset.Id));
            lCreativeToUpdate.add(tempsObj);
        }
        //UPDATE THE LIST OF FINAL CREATIVE IF THE LIST NOT EMPTY
        if(!lCreativeToUpdate.isEmpty()){
            Database.update(lCreativeToUpdate,false);
        }
    }
}