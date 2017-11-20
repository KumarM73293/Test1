/**
* @author Accenture IDC 
* @date 05/20/2016
* @group Note
* @group-content N/A
* @description Trigger Handler on Note that handles prevents a a user from deleting 
*               or updating an Note created by another user.
*/
public class IMH_NoteTriggerHandler {
     /*****************************************************************************
    * @description -  Used to prevent deletion of Note/Attachment by other user apart from Owner
    * @param -  Trigger.OldMap(Note)
    * @return - void
    */ 
    public static void preventDelete(Map<Id,Note> TriggerOldMap) {
        for(Note nt : TriggerOldMap.values()) {
            if(nt.OwnerId != UserInfo.getUserId() &&
               ((ID.valueOf(nt.ParentId).getSobjectType() == Schema.IMH_Asset__c.SObjectType) || 
                (ID.valueOf(nt.ParentId).getSobjectType() == Schema.IMH_CommCreative__c.SObjectType) ||
                (ID.valueOf(nt.ParentId).getSobjectType() == Schema.IMH_Benefits__c.SObjectType))) {
                nt.addError(Label.IMH_MsgOnReviewerEditDeleteNote);
            }
        }
    }
    /*****************************************************************************
    * @description -  Used to prevent update of Note by other user apart from Owner
    * @param -  Trigger.New(Note)
    * @return - void
    */ 
    public static void preventUpdate(List<Note> TriggerNew) {
        for(Note nt : TriggerNew) {
            if(nt.OwnerId != UserInfo.getUserId() &&
               ((ID.valueOf(nt.ParentId).getSobjectType() == Schema.IMH_Asset__c.SObjectType) || 
                (ID.valueOf(nt.ParentId).getSobjectType() == Schema.IMH_CommCreative__c.SObjectType) ||
                (ID.valueOf(nt.ParentId).getSobjectType() == Schema.IMH_Benefits__c.SObjectType))) {
                nt.addError(Label.IMH_MsgOnReviewerEditDeleteNote);
            }
        }
    }
}