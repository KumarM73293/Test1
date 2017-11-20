/**
* @author Accenture IDC 
* @date 03/24/2016
* @group Answer
* @group-content N/A
* @description: iMH Release 1.4 (Sprint 32) - Test Class for Trigger on Communication Object to cover the scenarios for Deep Clone
* logic has been triggered on particular event of an object.
*/
@isTest(SeeAllData=false)
private class IMH_UserTriggerHandlerTest {
     private static final String CAMPAIGN_SUBMITTER_PROFILE  = 'iMH Campaign Submitter';
    private static final String SUBMITTER_RUNNING_USER      = 'RunningUserSubmitter';
     private static final String CAMPAIGN_REVIEWER_PROFILE  = 'iMH Campaign Reviewer';
    private static final String REVIEWERRUNNING_USER      = 'RunningUserReviewer';
    private static final String PUBLIC_GROUP_NAME = 'ChatterGroupCreationTest';
    private static final String DEVELOPER_NAME = 'IMH_TestClassDummy_UK';
    private static final String GROUP_TYPE = 'Regular';
    
     /**
    * @description: Test Method used for Creating USer with Public Group Membership and Permission Sets
    * @param: none
    * @return: void
    */    
    static testMethod void createUserandrelated(){
      List<User> lReviwers = new List<User>();
      List<User> lclonedReviwers = new List<User>();
    for(Integer i=0;i<1;i++){
            lReviwers.add(IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWERRUNNING_USER + i,null));
        }
      insert lReviwers;
        
        //User submitteruser = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWERRUNNING_USER,null);
    List<Group> lgroups = new List<Group>();
            for(Integer i=0;i<4;i++){
                lgroups.add((IMH_TestClassUtility.createPublicGroup(PUBLIC_GROUP_NAME + i, DEVELOPER_NAME + i, GROUP_TYPE)));
            }
            insert lgroups;
            
            List<GroupMember> lgroupmember = new List<GroupMember>();
            for(Integer i=0;i<4;i++){
                lgroupmember.add(IMH_TestClassUtility.createPublicGroupMember(lReviwers[0].Id,lgroups[i].Id));
            }
        Database.insert(lgroupmember);
        
        List<PermissionSet> lpermissionset = [SELECT ID,label From PermissionSet WHERE label = 'iMH - ANZ - Enable Non-Core Localisations'
                                                                     OR label = 'iMH - All Markets - Manage Support Requests'];
       // System.debug(')() Permisijoj '+lpermissionset);
        List<PermissionSetAssignment> lpermissionAssignment = new List<PermissionSetAssignment>();
        PermissionSetAssignment permissionassign;
        for(Integer i=0;i<lpermissionset.size();i++){
            permissionassign = new PermissionSetAssignment();
            permissionassign.AssigneeId = lReviwers[0].Id;
            permissionassign.PermissionSetId = lpermissionset[i].Id;
            lpermissionAssignment.add(permissionassign);
        }
        Database.insert(lpermissionAssignment);
        System.debug('****KKOP '+lpermissionAssignment);
         User clonedUser;
        Test.startTest();
            clonedUser = new User();
            lclonedReviwers = lReviwers.deepClone(false);
            clonedUser =  lclonedReviwers[0];
            clonedUser.UserName = 'abcTesterinimh=aexp@example.com';
            clonedUser.CommunityNickName = 'abcTester';
            System.debug(lReviwers[0].Id);
            clonedUser.SYS_FromCloneUserId__c	= String.valueof(lReviwers[0].Id).subString(0,15);
            insert clonedUser;
        Test.stopTest();
        //Asserting with Existing Group Members with New Users
         List<GroupMember> lexistinggrps = [Select Id From GroupMember Where UserOrGroupId =:lReviwers[0].Id] ;
        System.assertEquals(lexistinggrps.size(),[Select Id From GroupMember WHERE UserOrGroupId = :clonedUser.Id].size());
        //Asserting with number of Groups the user is associated to cloned user
        System.assertEquals(4,[Select Id From GroupMember WHERE UserOrGroupId = :clonedUser.Id].size());
         //Asserting with Existing Permisssion Set Assignments with New Users
         List<PermissionSetAssignment> lexistingpermissions = [Select Id From PermissionSetAssignment WHERE AssigneeId =:lReviwers[0].Id] ;
          System.assertEquals(lexistingpermissions.size(),[Select Id From PermissionSetAssignment WHERE AssigneeId = :clonedUser.Id].size());
       //Asserting with number of Permisssion Sets associated to cloned user
        System.assertEquals(2+1,[Select Id From PermissionSetAssignment WHERE AssigneeId = :clonedUser.Id].size());
        
    } 
     /**
    * @description: Test Method used for Creating USer with Collabration Group Membership and Permission Sets
    * @param: none
    * @return: void
    */
    static testMethod void createUserandrelatedColanMemeber(){
        User runningUserAdmin = IMH_TestClassUtility.createUser('System Administrator','SysAADmin',null);
        UserRole adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'iMH System Admin' LIMIT 1];
        runningUserAdmin.UserRoleId= adminRole.Id;
        //insert adminRole;
      List<User> lReviwers = new List<User>();
      List<User> lclonedReviwers = new List<User>();
    for(Integer i=0;i<1;i++){
            lReviwers.add(IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWERRUNNING_USER + i,null));
        }
      insert lReviwers;
        
        //User submitteruser = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWERRUNNING_USER,null);
    List<Group> lgroups = new List<Group>();
            for(Integer i=0;i<4;i++){
                lgroups.add((IMH_TestClassUtility.createPublicGroup(PUBLIC_GROUP_NAME + i, DEVELOPER_NAME + i, GROUP_TYPE)));
            }
            insert lgroups;
            
            List<GroupMember> lgroupmember = new List<GroupMember>();
            for(Integer i=0;i<4;i++){
                lgroupmember.add(IMH_TestClassUtility.createPublicGroupMember(lReviwers[0].Id,lgroups[i].Id));
            }
        Database.insert(lgroupmember);
        System.runAs(runningUserAdmin){
            IMH_GeneralApplicationUility.createChatterGroups('005a000000CL6ay');
            IMH_GeneralApplicationUility.addChatterGroupMembers();
        }
          
        List<PermissionSet> lpermissionset = [SELECT ID,label From PermissionSet WHERE label = 'iMH - ANZ - Enable Non-Core Localisations'
                                                                     OR label = 'iMH - All Markets - Manage Support Requests'];
       // System.debug(')() Permisijoj '+lpermissionset);
        List<PermissionSetAssignment> lpermissionAssignment = new List<PermissionSetAssignment>();
        PermissionSetAssignment permissionassign;
        for(Integer i=0;i<lpermissionset.size();i++){
            permissionassign = new PermissionSetAssignment();
            permissionassign.AssigneeId = lReviwers[0].Id;
            permissionassign.PermissionSetId = lpermissionset[i].Id;
            lpermissionAssignment.add(permissionassign);
        }
        Database.insert(lpermissionAssignment);
        //System.debug('****KKOP '+lpermissionAssignment);
         User clonedUser;
        Test.startTest();
        
            clonedUser = new User();
            lclonedReviwers = lReviwers.deepClone(false);
            clonedUser =  lclonedReviwers[0];
            clonedUser.UserName = 'abcTesterinimh=aexp@example.com';
            clonedUser.CommunityNickName = 'abcTester';
            System.debug(lReviwers[0].Id);
            clonedUser.SYS_FromCloneUserId__c	= String.valueof(lReviwers[0].Id).subString(0,15);
            insert clonedUser;
        Test.stopTest();
         //Asserting with Existing Group Members with cloned Users
         List<GroupMember> lexistinggrps = [Select Id From GroupMember Where UserOrGroupId =:lReviwers[0].Id] ;
        System.assertEquals(lexistinggrps.size(),[Select Id From GroupMember WHERE UserOrGroupId = :clonedUser.Id].size());
          //Asserting with number of Groups the user is associated to cloned user
        System.assertEquals(4,[Select Id From GroupMember WHERE UserOrGroupId = :clonedUser.Id].size());
        //Asserting with Existing Permisssion Set Assignments with cloned Users
         List<PermissionSetAssignment> lexistingpermissions = [Select Id From PermissionSetAssignment WHERE AssigneeId =:lReviwers[0].Id] ;
          System.assertEquals(lexistingpermissions.size(),[Select Id From PermissionSetAssignment WHERE AssigneeId = :clonedUser.Id].size());
       //Asserting with number of Permisssion Sets associated to cloned user
        System.assertEquals(2+1,[Select Id From PermissionSetAssignment WHERE AssigneeId = :clonedUser.Id].size());
         //Asserting with Existing Collabration Group Members with cloned Users
         List<CollaborationGroupMember> lexistingcolbs = [Select Id From CollaborationGroupMember Where MemberId =:lReviwers[0].Id] ;
        System.assertEquals(lexistinggrps.size(),[Select Id FROM CollaborationGroupMember Where MemberId =:clonedUser.Id].size());
         //Asserting with number of Collabration Groups associated to cloned user
        System.assertEquals(4,[Select Id FROM CollaborationGroupMember Where MemberId =:clonedUser.Id].size());
        
    }
    
/**
    * @description: Test Method used for Creating User with Collabration Group Membership but no Permission Sets
    * @param: none
    * @return: void
    */
    static testMethod void createUserandrelatedColanMemeberwPerm(){
        User runningUserAdmin = IMH_TestClassUtility.createUser('System Administrator','SysAADmin',null);
        UserRole adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'iMH System Admin' LIMIT 1];
        runningUserAdmin.UserRoleId= adminRole.Id;
      //  insert adminRole;
      List<User> lReviwers = new List<User>();
      List<User> lclonedReviwers = new List<User>();
    for(Integer i=0;i<1;i++){
            lReviwers.add(IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWERRUNNING_USER + i,null));
        }
      insert lReviwers;
        
        //User submitteruser = IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWERRUNNING_USER,null);
    List<Group> lgroups = new List<Group>();
            for(Integer i=0;i<4;i++){
                lgroups.add((IMH_TestClassUtility.createPublicGroup(PUBLIC_GROUP_NAME + i, DEVELOPER_NAME + i, GROUP_TYPE)));
            }
            insert lgroups;
            
            List<GroupMember> lgroupmember = new List<GroupMember>();
            for(Integer i=0;i<4;i++){
                lgroupmember.add(IMH_TestClassUtility.createPublicGroupMember(lReviwers[0].Id,lgroups[i].Id));
            }
        Database.insert(lgroupmember);
        System.runAs(runningUserAdmin){
            IMH_GeneralApplicationUility.createChatterGroups('005a000000CL6ay');
            IMH_GeneralApplicationUility.addChatterGroupMembers();
        }
       
         User clonedUser;
        Test.startTest();
        
            clonedUser = new User();
            lclonedReviwers = lReviwers.deepClone(false);
            clonedUser =  lclonedReviwers[0];
            clonedUser.UserName = 'abcTesterinimh=aexp@example.com';
            clonedUser.CommunityNickName = 'abcTester';
            System.debug(lReviwers[0].Id);
            clonedUser.SYS_FromCloneUserId__c	= String.valueof(lReviwers[0].Id).subString(0,15);
            insert clonedUser;
        Test.stopTest();
          
       //Asserting with Existing Group Members with cloned Users
         List<GroupMember> lexistinggrps = [Select Id From GroupMember Where UserOrGroupId =:lReviwers[0].Id] ;
        System.assertEquals(lexistinggrps.size(),[Select Id From GroupMember WHERE UserOrGroupId = :clonedUser.Id].size());
          //Asserting with number of Groups the user is associated to cloned user
        System.assertEquals(4,[Select Id From GroupMember WHERE UserOrGroupId = :clonedUser.Id].size());
        //Asserting with Existing Permisssion Set Assignments with cloned Users
         List<PermissionSetAssignment> lexistingpermissions = [Select Id From PermissionSetAssignment WHERE AssigneeId =:lReviwers[0].Id] ;
          System.assertEquals(lexistingpermissions.size(),[Select Id From PermissionSetAssignment WHERE AssigneeId = :clonedUser.Id].size());
       //Asserting with number of Permisssion Sets associated to cloned user
        System.assertEquals(1,[Select Id From PermissionSetAssignment WHERE AssigneeId = :clonedUser.Id].size());
         //Asserting with Existing Collabration Group Members with cloned Users
         List<CollaborationGroupMember> lexistingcolbs = [Select Id From CollaborationGroupMember Where MemberId =:lReviwers[0].Id] ;
        System.assertEquals(lexistinggrps.size(),[Select Id FROM CollaborationGroupMember Where MemberId =:clonedUser.Id].size());
         //Asserting with number of Collabration Groups associated to cloned user
        System.assertEquals(4,[Select Id FROM CollaborationGroupMember Where MemberId =:clonedUser.Id].size());
        
    }
    
    /**
    * @description: Test Method used for Creating User with Collabration Group Membership but no Permission Sets
    * @param: none
    * @return: void
    */
    static testMethod void createawithoutColbarationandGroup(){
              User runningUserAdmin = IMH_TestClassUtility.createUser('System Administrator','SysAADmin',null);
        UserRole adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'iMH System Admin' LIMIT 1];
        runningUserAdmin.UserRoleId= adminRole.Id;
        
      List<User> lReviwers = new List<User>();
      List<User> lclonedReviwers = new List<User>();
    for(Integer i=0;i<1;i++){
            lReviwers.add(IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWERRUNNING_USER + i,null));
        }
      insert lReviwers;
        
     List<PermissionSet> lpermissionset = [SELECT ID,label From PermissionSet WHERE label = 'iMH - ANZ - Enable Non-Core Localisations'
                                                                     OR label = 'iMH - All Markets - Manage Support Requests'];
       // System.debug(')() Permisijoj '+lpermissionset);
        List<PermissionSetAssignment> lpermissionAssignment = new List<PermissionSetAssignment>();
        PermissionSetAssignment permissionassign;
        for(Integer i=0;i<lpermissionset.size();i++){
            permissionassign = new PermissionSetAssignment();
            permissionassign.AssigneeId = lReviwers[0].Id;
            permissionassign.PermissionSetId = lpermissionset[i].Id;
            lpermissionAssignment.add(permissionassign);
        }
        Database.insert(lpermissionAssignment);
        //System.debug('****KKOP '+lpermissionAssignment);
         User clonedUser;
        Test.startTest();
        
            clonedUser = new User();
            lclonedReviwers = lReviwers.deepClone(false);
            clonedUser =  lclonedReviwers[0];
            clonedUser.UserName = 'abcTesterinimh=aexp@example.com';
            clonedUser.CommunityNickName = 'abcTester';
            System.debug(lReviwers[0].Id);
            clonedUser.SYS_FromCloneUserId__c	= String.valueof(lReviwers[0].Id).subString(0,15);
            insert clonedUser;
        Test.stopTest();
          
        System.assertEquals(0,[Select Id From GroupMember WHERE UserOrGroupId = :clonedUser.Id].size());
        System.assertEquals(3,[Select Id From PermissionSetAssignment WHERE AssigneeId = :clonedUser.Id].size());
        System.assertEquals(0,[Select Id FROM CollaborationGroupMember Where MemberId =:clonedUser.Id].size());
        
    } 
}