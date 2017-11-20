/**
* @author Accenture IDC 
* @date 03/22/2016
* @group Asset
* @group-content N/A
* @description Trigger on Final Creative object which looks for the after insert event
*/
trigger IMH_AssetTrigger on IMH_Asset__c (after insert) {
    //HANDLER METHOD CALLED TO UPDATE THE CREATIVE RECORD IF FINAL CREATIVE RECORD IS CREATED.
    IMH_AssetTriggerHandler.updateFinalCreativeId(Trigger.New);
}