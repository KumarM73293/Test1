/**
* @author Accenture IDC 
* @date 08/09/2016
* @group CollaborationGroupMember
* @group-content N/A
* @description Trigger on CollaborationGroupMember object which looks for the after insert and before delete event
*/
trigger IMH_CollabrationGrpMemberTrigger on CollaborationGroupMember (after insert,before Delete) {
    System.debug('***ABC 0.0 '+IMH_GeneralApplicationUility.isAvoidEntryinTrigger);
    if(!IMH_GeneralApplicationUility.isAvoidEntryinTrigger){
        System.debug('***ABC 0.1 '+IMH_GeneralApplicationUility.isAvoidEntryinTrigger);
        if(Trigger.isAfter){
             System.debug('***ABC 0.2 '+IMH_GeneralApplicationUility.isAvoidEntryinTrigger);
        if(Trigger.isInsert){
            IMH_CollabrationMemberTriggerHandler.createSetIds(Trigger.new,
                                                                    Trigger.oldMap,
                                                                    Trigger.newMap,
                                                                true);
        }
       
      }
    }
    if(Trigger.isBefore){
         if(Trigger.isDelete){
            IMH_CollabrationMemberTriggerHandler.createSetIds(Trigger.new,
                                                                    Trigger.oldMap,
                                                                    Trigger.newMap,
                                                               false);
        }
    }
}