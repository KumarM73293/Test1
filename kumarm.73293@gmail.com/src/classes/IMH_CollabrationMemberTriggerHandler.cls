/**
* @author Accenture IDC 
* @date 05/26/2015
* @group GeneralApplication Utility
* @group-content N/A
* @description:iMH Release 1.6 (Sprint 42) The class gets called from Collbration Member Trigger.
*/
public class IMH_CollabrationMemberTriggerHandler {
    private static final String REGULARGROUPTYPE = 'Regular';
    private static final String MEMBERID = 'MemberId';
    private static final String COLLABRATIONGROUPID = 'CollaborationGroupId';
    //private static final String LIKECONDITION = 'IMH%';
    /*****************************************************************************
    * @description -  Used to pass the Set of Ids/Maps to the methods
    * @param - Trigger.New(CollaborationGroupMember), Trigger.oldMap(CollaborationGroupMember),Trigger.NewMap(CollaborationGroupMember)
    * @return - void
    */ 
    public static void createSetIds(List<sObject> ltriggernew
                                               , Map<Id,sObject> mtriggerold
                                               , Map<Id,sObject> mtriggernew
                                               , Boolean isInsert){
      if(isInsert && !IMH_UserTriggerHandler.isDontExecuteColbTrigger){  
        IMH_CollabrationMemberTriggerHandler.createGroupMemeber(mtriggernew.keySet());
      }
      else if(!IMH_UserTriggerHandler.isDontExecuteColbTrigger){
           IMH_CollabrationMemberTriggerHandler.removeGroupMembers(mtriggerold);                                             
       }
    }
/*****************************************************************************
* @description -  Future Method which is used to create the Public Group Members if Chatter Group Members are added.
* @param - Set<Id> {CollaborationGroupMember Ids}
* @return - void
*/ 
   @future
    public static void createGroupMemeber(SET<Id> setColbMemberIds){
        Map<Id,List<Id>> mcgroupcgmember = new Map<Id,List<Id>>();
        List<Group> lgroups = new List<Group>();
        Map<Id,Id> mcolbgrppublicgrp = new Map<Id,Id>();
        Map<Id,List<Id>> mgrppublicgrp = new Map<Id,List<Id>>();                                           
        Map<String,Id> mpublicgrpNameId = new Map<String,Id>();
        SET<Id> setmemberIds;
        GroupMember grpmember;
        List<GroupMember> lnewgrpmembers = new List<GroupMember>();
        Map<Id,Id> mcolbgrpownerId = new Map<Id,Id>();
        //Creating Map of Collabration Group and CollbrationGroupMembers
          for(CollaborationGroupMember colabmember:[SELECT Id,
                                                           MemberId,
                                                           CollaborationGroupId
                                                   FROM CollaborationGroupMember
                                                   WHERE ID IN:setColbMemberIds]){
              if(mcgroupcgmember.containsKey(colabmember.CollaborationGroupId)){
                  List<Id> lmemberId = mcgroupcgmember.get(colabmember.CollaborationGroupId);
                  lmemberId.add(colabmember.MemberId);
                  mcgroupcgmember.put(colabmember.CollaborationGroupId,lmemberId);
              }
              else{
                  mcgroupcgmember.put(colabmember.CollaborationGroupId,new List<Id>{colabmember.MemberId}); 
              }
         }
        
         //Creating Map of Public Group and its memebers
        //Creating map of public group name and public group Id
         for(Group pgrp:[SELECT  Id, 
                                Name,
                                DeveloperName,
                                Type, 
                                (Select GroupId,
                                        UserOrGroupId
                                  FROM GroupMembers)
                         FROM Group 
                         WHERE  Type =: REGULARGROUPTYPE
                         AND DeveloperName LIKE 'IMH%']){
            for(GroupMember pgrpmember:pgrp.GroupMembers){
                if(mgrppublicgrp.containsKey(pgrpmember.GroupId)){
                    List<Id> lmembersids = mgrppublicgrp.get(pgrpmember.GroupId);
                    lmembersids.add(pgrpmember.UserOrGroupId);
                    mgrppublicgrp.put(pgrpmember.GroupId,lmembersids);
                }
                else{
                    mgrppublicgrp.put(pgrpmember.GroupId,new List<Id> {pgrpmember.UserOrGroupId});  
                }
            }
             // mgrppublicgrp.put(pgrp.Id,pgrp.GroupMembers);
              mpublicgrpNameId.put(pgrp.Name,pgrp.Id);               
          }                                          
         
         //Creating Map of Collabration Group Id and public GroupId
         for(CollaborationGroup cgrp:[Select Id
                                           ,Name
                                           ,OwnerId
                                     From CollaborationGroup
                                     WHERE Id IN:mcgroupcgmember.keySet()]){
                   for(String pgrpname:mpublicgrpNameId.keySet()){
                       if(cgrp.Name.equalsIgnoreCase(pgrpname)){
                           mcolbgrppublicgrp.put(cgrp.Id,mpublicgrpNameId.get(pgrpname));
                           mcolbgrpownerId.put(cgrp.Id,cgrp.OwnerId);
                       }                     
                   }                           
          }
         
        for(Id colbId:mcgroupcgmember.keySet()){
            setmemberIds = new SET<Id>();
            if(!mgrppublicgrp.isEmpty() && !mcolbgrppublicgrp.isEmpty() && mgrppublicgrp.get(mcolbgrppublicgrp.get(colbId))!= NULL){
                setmemberIds.addAll(mgrppublicgrp.get(mcolbgrppublicgrp.get(colbId)));
            }
            for(Id cgrpmembersId:mcgroupcgmember.get(colbId)){
                if(!setmemberIds.contains(cgrpmembersId) && !String.valueof(cgrpmembersId).equalsIgnoreCase(String.valueof(mcolbgrpownerId.get(colbId)))){
                   grpmember = new GroupMember();
                   grpmember.UserOrGroupId = cgrpmembersId;
                   grpmember.GroupId = mcolbgrppublicgrp.get(colbId);
                   lnewgrpmembers.add(grpmember);
                }
            }
        }                                          
                                                   
        if(!lnewgrpmembers.isEmpty()){
              insert lnewgrpmembers;                                         
       }                                            
    }
/*****************************************************************************
* @description -   Method which is used to generate the Public Group Members that needs to be deleted.
* @param - Trigger.OldMap {CollaborationGroupMember}
* @return - void
*/  
public static void removeGroupMembers(Map<Id,sObject> mtriggerold){
         Map<Sobject,Id> mcolbgrpngrpmember = new Map<Sobject,Id>();
         Map<Id,Id> mcolbgrppublicgrp = new Map<Id,Id>();
         Map<String,Id> mpublicgrpNameId = new Map<String,Id>();
         Map<GroupMember,Id> mgrppublicgrp = new Map<GroupMember,Id>();
         List<Group> lgroups = new List<Group>();
        
         Map<Id,String> mcolabidcolabName = new Map<Id,String>();
         Map<Id,String> mpublicgrpIdName = new Map<Id,String>();
         List<Id> ldeletegrpMember = new List<Id>();
        
        //System.debug('*****TEst 1 '+mtriggerold);
         //Creating Map of Collabration Group and CollbrationGroupMembers
          for(Sobject colabmember:mtriggerold.values()){
                  mcolbgrpngrpmember.put(colabmember,String.valueof(colabmember.get(COLLABRATIONGROUPID))); 
         }
       // System.debug('*****TEst 2 '+mcolbgrpngrpmember);
         lgroups = [SELECT Id
                           , Name
                           , DeveloperName
                           , Type 
                    FROM Group 
                    WHERE  Type =: REGULARGROUPTYPE
                    AND DeveloperName LIKE 'IMH%'];
                                                   
          //Creating Map of Collabration Group Id and public GroupId
         for(CollaborationGroup cgrp:[Select Id
                                           ,Name
                                           ,OwnerId
                                     From CollaborationGroup
                                     WHERE Id IN:mcolbgrpngrpmember.values()]){
                   for(Group pgrpname:lgroups){
                       if(cgrp.Name.equalsIgnoreCase(pgrpname.Name)){
                           mcolbgrppublicgrp.put(cgrp.Id,pgrpname.Id);
                           mcolabidcolabName.put(cgrp.Id,cgrp.Name);
                           mpublicgrpIdName.put(pgrpname.Id,pgrpname.Name);
                           //mcolbgrpownerId.put(cgrp.Id,cgrp.OwnerId);
                       }                     
                   }                           
          }
           //System.debug('*****TEst 3 '+mcolbgrppublicgrp);
         for(GroupMember gpmember:[Select GroupId,
                                        UserOrGroupId
                                  FROM GroupMember
                                   WHERE GroupId IN:mcolbgrppublicgrp.values()]){
                    mgrppublicgrp.put(gpmember,gpmember.GroupId);                          
          }
          //System.debug('*****TEst 4 '+mgrppublicgrp);                                         
        for(Sobject cgmember:mcolbgrpngrpmember.keyset()){
             //System.debug('*****TEst 5 '+cgmember);
            for(GroupMember gmember:mgrppublicgrp.keyset()){
               // System.debug('*****TEst 6 '+gmember);
                if(String.valueof(gmember.UserOrGroupId).equalsIgnoreCase(String.valueOf(cgmember.get(MEMBERID)))
                   && mcolabidcolabName.get(String.valueOf(cgmember.get(COLLABRATIONGROUPID))).equalsIgnoreCase(mpublicgrpIdName.get(gmember.GroupId))){
                       // System.debug('*****TEst 7 '+gmember);
                       ldeletegrpMember.add(gmember.Id);
                   }
            }
        }
        IMH_CollabrationMemberTriggerHandler.deleteMembers(ldeletegrpMember);
    }
/*****************************************************************************
* @description -   Method which is used to delete the Public Group Members.
* @param - List<Id> {PublicGroupMember}
* @return - void
*/
@future
public static void deleteMembers(List<Id> ldeleteIds){
       List<GroupMember> lgroupMemberstoDelete = new List<GroupMember>();
        for(GroupMember gm:[Select Id,GroupId FROM GroupMember WHERE ID IN:ldeleteIds]){
            lgroupMemberstoDelete.add(gm);
        }
         if(!lgroupMemberstoDelete.isEmpty()){
            delete lgroupMemberstoDelete;
        }
    }
}