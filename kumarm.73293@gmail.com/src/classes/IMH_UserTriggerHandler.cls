/**
    * @author Accenture IDC 
    * @date 05/26/2015
    * @group User
    * @group-content N/A
    * @description Trigger Handler on User that handles ensuring the correct system 
    * logic has been triggered on particular event of an object.
    */ 
    public class IMH_UserTriggerHandler {
        public static  Boolean isDontExecuteColbTrigger = false; 
        private static final String B35_INS_UK = 'B35 Ins (UK)';
        private static final String B40_INS_UK = 'B40 Ins (UK)';  
        private static final String GROUP_TYPE_REGULAR = 'Regular'; 
        private static final String GROUP_TYPE_QUEUE = 'Queue'; 
        private static final String APPROVALSTTAUS_PENIDNG = 'Pending'; 
        private static final String APPROVALSTTAUS_PENIDNG_CHANGES  = 'Pending Approval – Changes/Information Required'; 
        private static final String ACCESSLEVEL_EDIT = 'Edit';
        private static final String ROWCAUSE_MANUAL = 'Manual';
        private static final String EMAILTEMPLATE_APPROVALREQUEST = 'iMH_DelegatedApprover';
        private static final String ORGWIDE_DISPLAYNAME_IMH_NOTIFICATIONS = 'iMH Notifications';
        private static final String USERROLE_REVIEWER = 'Reviewer';
        
        //Clone User Story
        private static final String SYSCLONEID_API = 'SYS_FromCloneUserId__c'; 
        /*****************************************************************************
        * @description: Mehod called on before insert of trigger event
        * @param: Trigger.New,Trigger.OldMap
        * @return: void
        */
        public static void handleAfterUpdate(List<User> ltriggernew
                                             , Map<Id,User> mtriggerOld){
                                                Set<String> approvalStatus = new Set<String>{APPROVALSTTAUS_PENIDNG,APPROVALSTTAUS_PENIDNG_CHANGES};                                               
            Map<Id,Id> newDelegatedApproverByUserId = new Map<Id,Id>(); 
            Map<Id,Set<Id>> groupMembersByQueueId = new Map<Id,Set<Id>>();     
                                                List<IMH_SLATracker__Share> lApprovalTrackerShare = new List<IMH_SLATracker__Share>();    
            IMH_SLATracker__Share approvalShare = new IMH_SLATracker__Share();                                                    
            Set<Id> userIdsToRevoketheAccess = new Set<Id>();
            for(User userObj:ltriggernew) {
                //CHECK FOR A CHANGE IN THE DELEGATED APPROVER
                if(userObj.DelegatedApproverId != mtriggerOld.get(userObj.Id).DelegatedApproverId
                                && userObj.IMH_UserRoleTypeNew__c!=NULL){
                    if(mtriggerOld.get(userObj.Id).DelegatedApproverId != NULL){
                        userIdsToRevoketheAccess.add(mtriggerOld.get(userObj.Id).DelegatedApproverId);
                    }
                    if(userObj.DelegatedApproverId!=NULL){
                        newDelegatedApproverByUserId.put(userObj.Id,userObj.DelegatedApproverId);
                    }
                }
            }
                                                Set<Id> tempSet = new Set<Id>(); 
                                                Map<Id,Id> mapQueueIdByGroupId = new Map<Id,Id>();                                                 
                                                Id correspondingQueueId = NULL;
                                                if(!newDelegatedApproverByUserId.isEmpty()){
               for(Group grp : [SELECT Id,DeveloperName,Type,(SELECT Id,GroupId,UserOrGroupId FROM GroupMembers) 
                                                                                                FROM Group WHERE (Type = :GROUP_TYPE_REGULAR OR Type = :GROUP_TYPE_QUEUE)
                                            AND (Name = :B35_INS_UK OR Name = :B40_INS_UK) ORDER BY Type ASC
                               LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
                                                                                                  
                                                                                correspondingQueueId = NULL;     
                                                                                tempSet = new Set<Id>();                                    
                    for(GroupMember grpMember : grp.GroupMembers){
                        if(GROUP_TYPE_QUEUE.equalsIgnoreCase(grp.Type)){
                           mapQueueIdByGroupId.put(grpMember.UserOrGroupId,grpMember.GroupId); 
                        }else{
                          tempSet.add(grpMember.UserOrGroupId);
                          correspondingQueueId = mapQueueIdByGroupId.get(grpMember.GroupId);  
                        }
                    }
                                                                                if(correspondingQueueId!=NULL
                                && !tempSet.isEmpty()){
                                groupMembersByQueueId.put(correspondingQueueId,tempSet);    
                    }                                                
                                                                }
                //System.debug('*****DELEGATE 1 '+newDelegatedApproverByUserId.keySet() + '  **DEL '+groupMembersByQueueId);
                /*System.debug('*****DELEGATE 2 '+[SELECT Id,OwnerId FROM IMH_SLATracker__c 
                                                WHERE Status__c IN :approvalStatus
                                                  LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]);*/
                /* System.debug('*****DELEGATE 3 '+[SELECT Id,OwnerId FROM IMH_SLATracker__c 
                                                            WHERE (OwnerId IN :groupMembersByQueueId.keySet() 
                                                                   OR OwnerId IN : newDelegatedApproverByUserId.keySet()) 
                                                AND Status__c IN :approvalStatus
                                                  LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]);*/
                                                                for(IMH_SLATracker__c approvals : [SELECT Id,OwnerId FROM IMH_SLATracker__c 
                                                            WHERE (OwnerId IN :groupMembersByQueueId.keySet() 
                                                                   OR OwnerId IN : newDelegatedApproverByUserId.keySet()) 
                                                AND Status__c IN :approvalStatus
                                                  LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
                     approvalShare = new IMH_SLATracker__Share();
                     approvalShare.ParentId = approvals.Id;
                     approvalShare.AccessLevel = ACCESSLEVEL_EDIT;                                                
                     if(groupMembersByQueueId.containsKey(approvals.OwnerId)){
                         for(Id groupMembersId : groupMembersByQueueId.get(approvals.OwnerId)){
                             if(newDelegatedApproverByUserId.containsKey(groupMembersId)){
                              // CANNOT BE COVERED WITH TEST CLASS SINCE GROUP MEMBER CREATED IN TEST CLASS IS NOT RETRIVED  
                                approvalShare.UserOrGroupId = newDelegatedApproverByUserId.get(groupMembersId);
                                lApprovalTrackerShare.add(approvalShare);
                             }
                         }
                     }else{
                         // CANNOT BE COVERED WITH TEST CLASS SINCE GROUP MEMBER CREATED IN TEST CLASS IS NOT RETRIVED  
                         if(newDelegatedApproverByUserId.get(approvals.OwnerId)!=NULL){
                            approvalShare.UserOrGroupId = newDelegatedApproverByUserId.get(approvals.OwnerId);
                            lApprovalTrackerShare.add(approvalShare);
                         }
                     }                                   
                }  
            }                                                 
             
                                                if(!userIdsToRevoketheAccess.isEmpty()){
                Database.delete([SELECT Id FROM IMH_SLATracker__Share WHERE UserOrGroupId IN :userIdsToRevoketheAccess 
                                                                                                AND RowCause = :ROWCAUSE_MANUAL 
                                 LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())], false);
            }                                                 
            if(!lApprovalTrackerShare.isEmpty()){
               Database.insert(lApprovalTrackerShare,false); 
                   sendApprovalEmailNotificationsForDelApprovers(lApprovalTrackerShare);  
            }                                              
        }
        
        /*****************************************************************************
        * @description: Mehod called to send the notifications to the delegated approvers
        * @param: List<Approvalshare>, EmailTemplateId
        * @return: void
        */
        public static void sendApprovalEmailNotificationsForDelApprovers(List<IMH_SLATracker__Share> lApprovalTrackerShare){  
            List<EmailTemplate> emailTemplate  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :EMAILTEMPLATE_APPROVALREQUEST]; 
            List<OrgWideEmailAddress> orgWideAdress = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress 
                                                                                                                                                WHERE DisplayName = :ORGWIDE_DISPLAYNAME_IMH_NOTIFICATIONS
                                                                LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
            List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
                                                for(IMH_SLATracker__Share shareRec : lApprovalTrackerShare){
                if(!emailTemplate.isEmpty()
                                && !orgWideAdress.isEmpty()){
                    allMails.add(constructEmailNotification(shareRec.UserOrGroupId,shareRec.ParentId,emailTemplate[0].Id,orgWideAdress[0].Id));
                }
            }
            if(!allMails.isEmpty()){
               Messaging.sendEmail(allMails);
                                               }
                                }
        
        
        /*****************************************************************************
        * @description: Mehod to construct a singlemessage 
        * @param: targetId(User),RelatedToId,TemmplateId
        * @return: Messaging.SingleEmailMessage
        */
        public static Messaging.SingleEmailMessage constructEmailNotification(String targetObjectId
                                                                              ,String whatId
                                                                              ,String templateId
                                                                              ,String OrgWideId){  
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(targetObjectId);
            mail.setTemplateId(templateId);
            mail.setWhatId(whatId);
            mail.setOrgWideEmailAddressId(OrgWideId);
            mail.setsaveAsActivity(false);
            return mail;                                  
                                }
        
        /*****************************************************************************
        * @description: Mehod called on before insert of trigger event
        * @param: Trigger.New,Trigger.OldMap,Trigger.NewMap
        * @return: void
        */
        /*public static void handleBeforeUpdate(List<User> ltriggernew
                                             , Map<Id,User> mtriggerOld
                                             , Map<Id,User> mtriggerNew){                                     
            Map<Id,Id> UserIdByDelegatedApproverId = new Map<Id,Id>();
            for(User userObj:ltriggernew) {
                if(userObj.DelegatedApproverId != mtriggerOld.get(userObj.Id).DelegatedApproverId){
                    if(userObj.DelegatedApproverId!=NULL){
                        UserIdByDelegatedApproverId.put(userObj.DelegatedApproverId,userObj.Id);
                    }
                }
            }
                                                for(User delegatedApprover : [SELECT Id,IMH_UserRoleTypeNew__c FROM User 
                                                                WHERE Id IN :UserIdByDelegatedApproverId.keySet()
                                                LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
                if(!USERROLE_REVIEWER.equalsIgnoreCase(delegatedApprover.IMH_UserRoleTypeNew__c)){
                    mtriggerNew.get(UserIdByDelegatedApproverId.get(delegatedApprover.Id)).addError(Label.iMH_DelegatedApproverValidation);
                }
            }                                                 
      }*/
      /*****************************************************************************
        * @description: Mehod called on before insert of trigger event
        * @param: Trigger.New,Trigger.OldMap,Trigger.NewMap
        * @return: void
        */
        public static void handleAfterInsert(List<User> ltriggernew
                                             , Map<Id,User> mtriggerOld
                                              , Map<Id,User> mtriggerNew){
                      //System.debug('***A3 '+ltriggernew);
                       Map<String,Id> mexistUsernewUser = new Map<String,Id>();
                       Map<Id,String> mnewUserexistUser = new Map<Id,String>();
                       for(Sobject sobj:mtriggerNew.values()) {
                             
                             System.debug('***A4 '+sobj);
                         if(sobj.get(SYSCLONEID_API) != NULL){
                              //System.debug('***A5 '+sobj);
                             mexistUsernewUser.put(String.valueof(sobj.get(SYSCLONEID_API)),sobj.Id);
                             mnewUserexistUser.put(sobj.Id,String.valueof(sobj.get(SYSCLONEID_API)));
                             
                           }
        }
        if(!mexistUsernewUser.isEmpty()){
                IMH_UserTriggerHandler.createUserRecords(mexistUsernewUser,mnewUserexistUser);
                
           }                                          
     }    
        /*****************************************************************************
        * @description: Mehod called on before insert of trigger event
        * @param: Trigger.New,Trigger.OldMap,Trigger.NewMap
        * @return: void
        */
        public static void createUserRecords(Map<String,ID> mexistUsernewUser,Map<Id,String>mnewUserexistUser){
             System.debug('***A6 '+mexistUsernewUser);
            
           
             
            /* List<PermissionSetLicenseAssign> lpermissonlicenseassignment = new List<PermissionSetLicenseAssign>();
             List<User> lupdateusers = new List<User>();
            //Permission Set License Assignment
              for(PermissionSetLicenseAssign existPermissionlicense:[SELECT AssigneeId, 
                                                                             PermissionSetLicenseId, 
                                                                             Id 
                                                                      FROM PermissionSetLicenseAssign
                                                                      WHERE AssigneeId IN:mexistUsernewUser.keySet()]){
                      String userIds = String.valueof(existPermissionlicense.AssigneeId).subString(0,15);
                      newPermissionlicense = new PermissionSetLicenseAssign();
                      newPermissionlicense.PermissionSetLicenseId = existPermissionlicense.PermissionSetLicenseId;
                      newPermissionlicense.AssigneeId = mexistUsernewUser.get(userIds);
                      lpermissonlicenseassignment.add(newPermissionlicense);                                                    
               }
            System.debug('***** A8 '+lpermissonlicenseassignment);
            
            
             if(!lpermissonlicenseassignment.isEmpty()){
                Database.insert(lpermissonlicenseassignment);
            }*/
            IMH_UserTriggerHandler.insertGrpMemAssignment(mexistUsernewUser);
            IMH_UserTriggerHandler.insertColaGrpMemAssignment(mexistUsernewUser);
            IMH_UserTriggerHandler.insertPermissionSet(mexistUsernewUser);
        }
        /*****************************************************************************
        * @description: Mehod called for assigning the collabration Group Member for the user
        * @param: Map<Id,Id>
        * @return: void
        */
        @future
        public static void insertColaGrpMemAssignment(Map<String,ID> mexistUsernewUser){
            //System.debug('*****UserCloner '+mexistUsernewUser);
            List<CollaborationGroupMember> lcolabgrpMemberassignment = new List<CollaborationGroupMember>();
            CollaborationGroupMember newcolabmember;
            for(CollaborationGroupMember existcolabmember:[SELECT Id,
                                                               MemberId,
                                                               CollaborationGroupId
                                                          FROM CollaborationGroupMember
                                                          WHERE MemberId IN:mexistUsernewUser.keySet()]){
                     //System.debug('***FOR 1 '+existcolabmember.MemberId);
                     String userIds = String.valueof(existcolabmember.MemberId).subString(0,15);
                     newcolabmember = new CollaborationGroupMember();
                     newcolabmember.CollaborationGroupId = existcolabmember.CollaborationGroupId;
                     newcolabmember.MemberId = mexistUsernewUser.get(userIds);
                      System.debug('***FOR 2 '+newcolabmember);
                     lcolabgrpMemberassignment.add(newcolabmember);
             }
            //System.debug('***** A10 '+lcolabgrpMemberassignment);
           if(!lcolabgrpMemberassignment.isEmpty()){
                System.debug('***** A10.1 '+lcolabgrpMemberassignment);
                IMH_UserTriggerHandler.isDontExecuteColbTrigger = true; // It is used to avoid calling the future method on CollabrationMemberTrigger
                Database.insert(lcolabgrpMemberassignment);
            } 
        }
        /*****************************************************************************
        * @description: Mehod called for assigning the Group Membership for the USer
        * @param: Map<String,Id>
        * @return: void
        */
  @future
        public static void insertGrpMemAssignment(Map<String,ID> mexistUsernewUser){
           // System.debug('*****UserCloner '+mexistUsernewUser);
            List<GroupMember> lgrpMemberassignment = new List<GroupMember>();
            GroupMember newgrpbmember;
            for(GroupMember existgrpbmember:  [SELECT Id, 
                                                       GroupId, 
                                                       UserOrGroupId 
                                                FROM GroupMember
                                                WHERE UserOrGroupId IN:mexistUsernewUser.keySet()]){
                     //System.debug('***FOR 1 '+existgrpbmember.UserOrGroupId);
                     String userIds = String.valueof(existgrpbmember.UserOrGroupId).subString(0,15);
                     newgrpbmember = new GroupMember();
                     newgrpbmember.GroupId = existgrpbmember.GroupId;
                     newgrpbmember.UserOrGroupId = mexistUsernewUser.get(userIds);
                     //System.debug('***FOR 2 '+mexistUsernewUser.get(userIds));
                     lgrpMemberassignment.add(newgrpbmember);
             }
           // System.debug('***** A10 '+lgrpMemberassignment);
           if(!lgrpMemberassignment.isEmpty()){
               // System.debug('***** A10.1 '+lgrpMemberassignment);
                Database.insert(lgrpMemberassignment);
            } 
        }
        /*****************************************************************************
        * @description: Mehod called for assigning the Permission Set for the Users
        * @param: Map<String,Id>
        * @return: void
        */
        @future
        public static void insertPermissionSet(Map<String,ID> mexistUsernewUser){
               PermissionSetAssignment newpermission;
              List<PermissionSetAssignment> lpermissonassignment = new List<PermissionSetAssignment>();
            System.debug('***** A7.1 '+mexistUsernewUser);
           //Integer i = 0;
             for(PermissionSetAssignment existpermission:[SELECT Id, 
                                                            PermissionSetId, 
                                                            AssigneeId,
                                                            PermissionSet.ProfileId
                                                     FROM PermissionSetAssignment
                                                     WHERE AssigneeId IN :mexistUsernewUser.keySet()]){
                                  if(existpermission.PermissionSet.ProfileId == NULL)  { 
                                 String userIds = String.valueof(existpermission.AssigneeId).subString(0,15);
                                 newpermission = new PermissionSetAssignment();
                                 newpermission.AssigneeId =  mexistUsernewUser.get(userIds);
                                 newpermission.PermissionSetId =  existpermission.PermissionSetId;
                                 lpermissonassignment.add(newpermission); 
                                } 
                                                       //  i++;
                     }
                System.debug('***** A7.2 '+lpermissonassignment);
             if(!lpermissonassignment.isEmpty()){
                Database.insert(lpermissonassignment);
            }
        } 
    }