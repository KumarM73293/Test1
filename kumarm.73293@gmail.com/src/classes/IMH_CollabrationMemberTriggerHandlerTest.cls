/**
* @author Accenture IDC 
* @date 03/31/2016
* @group-content N/A
* @description: iMH Release 1.6 (Sprint 42) - Test Class for Trigger on Collabration Group Member object which looks for the after insert and before delete event 
*/
@isTest
private class IMH_CollabrationMemberTriggerHandlerTest {
    private static final String CAMPAIGN_REVIEWER_PROFILE  = 'iMH Campaign Reviewer';
    private static final String REVIEWERRUNNING_USER      = 'RunningUserReviewer';
    private static final String MARKET_NAME = 'Hong Kong';
    
    private static final String PUBLIC_GROUP_NAME = 'ChatterGroupCreationTest';
    private static final String DEVELOPER_NAME = 'IMH_TestClassDummy_UK';
    private static final String GROUP_TYPE = 'Regular';
    /*****************************************************************************
    * @description: Method Used to check whether on insertion of Collabration Group Member , the Public Groupm Member gets inserted
    * @param: none
    * @return: void
    */   
    static testmethod void addPubMemberonChatterMemberInsert(){
        List<User> lReviwers = new List<User>();
        
        for(Integer i=0;i<14;i++){
            lReviwers.add(IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWERRUNNING_USER + i,null));
        }
        
        Insert lReviwers;
        
        User runningUserAdmin = IMH_TestClassUtility.createUser('System Administrator','SysAADmin',null);
        UserRole adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'iMH System Admin' LIMIT 1];
        runningUserAdmin.UserRoleId= adminRole.Id;
        insert runningUserAdmin;
        System.runAs(runningUserAdmin){
             List<Group> lgroups = new List<Group>();
            for(Integer i=0;i<2;i++){
                lgroups.add((IMH_TestClassUtility.createPublicGroup(PUBLIC_GROUP_NAME + i, DEVELOPER_NAME + i, GROUP_TYPE)));
            }
            insert lgroups;
            
            List<GroupMember> lgroupmember = new List<GroupMember>();
            for(Integer i=0;i<4;i++){
                lgroupmember.add(IMH_TestClassUtility.createPublicGroupMember(lReviwers[10+i].Id,lgroups[math.mod(i,2)].Id));
            }
            
            insert lgroupmember;
            IMH_GeneralApplicationUility.createChatterGroups(runningUserAdmin.Id);
            
            //IMH_GeneralApplicationUility.addChatterGroupMembers();
            List<CollaborationGroup> lcobs = [Select Id,Name from CollaborationGroup LIMIT 50000];
            System.assertEquals(2, lcobs.size());
            Test.startTest();
            List<CollaborationGroupMember> lcolbmembers = new List<CollaborationGroupMember>();
            CollaborationGroupMember cgm;
            for(Integer i=0;i<10;i++){
                cgm = new CollaborationGroupMember();
                if(i<=5){
                    cgm.MemberId = lReviwers[i].Id;
                    cgm.CollaborationGroupId = lcobs[0].Id;
                }
                else{
                    cgm.MemberId = lReviwers[i].Id;
                    cgm.CollaborationGroupId = lcobs[1].Id;
                }
                lcolbmembers.add(cgm);
            }
            IMH_GeneralApplicationUility.isAvoidEntryinTrigger = false;
            insert lcolbmembers;
            Test.stopTest();
            List<GroupMember> lgroupmembers = [SELECT Id FROM GroupMember WHERE GroupId IN:lgroups LIMIT 50000];
            System.assertEquals(14, lgroupmembers.size());
            List<CollaborationGroupMember> lcolabmember = [SELECT Id FROM CollaborationGroupMember WHERE CollaborationGroupId IN:lcobs LIMIT 50000]; 
            System.assertEquals(12, lcolabmember.size());//10 Present + 2 OwnerIds
            System.assertEquals(8,[Select Id FROM GroupMember WHERE GroupId =:lgroups[0].Id LIMIT 50000].size());
            System.assertEquals(6,[Select Id FROM GroupMember WHERE GroupId =:lgroups[1].Id LIMIT 50000].size());
        }
      }
    /*****************************************************************************
    * @description: Method Used to check whether on deletion of Collabration Group Member , the Public Groupm Member gets deleted
    * @param: none
    * @return: void
    */     
   static testmethod void removePubMemberonChatterMemberInsert(){
        List<User> lReviwers = new List<User>();
        
        for(Integer i=0;i<12;i++){
            lReviwers.add(IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWERRUNNING_USER + i,null));
        }
        
        Insert lReviwers;
        
        User runningUserAdmin = IMH_TestClassUtility.createUser('System Administrator','SysAADmin',null);
        UserRole adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'iMH System Admin' LIMIT 1];
        runningUserAdmin.UserRoleId= adminRole.Id;
        insert runningUserAdmin;
        System.runAs(runningUserAdmin){
             List<Group> lgroups = new List<Group>();
            for(Integer i=0;i<2;i++){
                lgroups.add((IMH_TestClassUtility.createPublicGroup(PUBLIC_GROUP_NAME+i, DEVELOPER_NAME + i, GROUP_TYPE)));
            }
            insert lgroups;
            
            List<GroupMember> lgroupmember = new List<GroupMember>();
            for(Integer i=0;i<2;i++){
                lgroupmember.add(IMH_TestClassUtility.createPublicGroupMember(lReviwers[10+i].Id,lgroups[i].Id));
            }
            
            insert lgroupmember;
            
            IMH_GeneralApplicationUility.createChatterGroups(runningUserAdmin.Id);
            
            //IMH_GeneralApplicationUility.addChatterGroupMembers();
            
            List<CollaborationGroup> lcobs = [Select Id,Name from CollaborationGroup LIMIT 50000];
            System.assertEquals(2, lcobs.size());
            
            List<CollaborationGroupMember> lcolbmembers = new List<CollaborationGroupMember>();
            CollaborationGroupMember cgm;
            for(Integer i=0;i<10;i++){
                cgm = new CollaborationGroupMember();
                if(i<=5){
                    cgm.MemberId = lReviwers[i].Id;
                    cgm.CollaborationGroupId = lcobs[0].Id;
                }
                else{
                    cgm.MemberId = lReviwers[i].Id;
                    cgm.CollaborationGroupId = lcobs[1].Id;
                }
                lcolbmembers.add(cgm);
            }
            Test.startTest();
            IMH_GeneralApplicationUility.isAvoidEntryinTrigger = false;
            insert lcolbmembers;
            
            
            List<CollaborationGroupMember> lcolbmembersdelete = [Select Id,MemberId,CollaborationGroupId FROM CollaborationGroupMember WHERE MemberId =:lReviwers[9].Id OR MemberId =:lReviwers[0].Id LIMIT 50000];
            //List<CollaborationGroupMember> lcolbmembersdelete = [Select Id,MemberId,CollaborationGroupId FROM CollaborationGroupMember WHERE MemberId =:lReviwers[0].Id];
            
            delete lcolbmembersdelete;
            //delete lcolbmembersdelete[1];
            
            Test.stopTest();
             List<GroupMember> lgroupmembers = [SELECT Id FROM GroupMember WHERE GroupId IN:lgroups LIMIT 50000];
            System.assertEquals(10, lgroupmembers.size());
             List<CollaborationGroupMember> lcolabmember = [SELECT Id FROM CollaborationGroupMember WHERE CollaborationGroupId IN:lcobs LIMIT 50000]; 
            System.assertEquals(10, lcolabmember.size()); //8 Present + 2 OwnerIds
            System.assertEquals(6,[Select Id FROM GroupMember WHERE GroupId =:lgroups[0].Id LIMIT 50000].size());
            System.assertEquals(4,[Select Id FROM GroupMember WHERE GroupId =:lgroups[1].Id LIMIT 50000].size());
        }
      }
    
 /*****************************************************************************
    * @description: Negative Method Used to check if no Collabration Group Member is inserted , the Public Groupm Member also doesn't gets inserted
    * @param: none
    * @return: void
    */   
    static testmethod void addnegPubMemberonChatterMemberInsert(){
        List<User> lReviwers = new List<User>();
        
        for(Integer i=0;i<14;i++){
            lReviwers.add(IMH_TestClassUtility.createUser(CAMPAIGN_REVIEWER_PROFILE,REVIEWERRUNNING_USER + i,null));
        }
        
        Insert lReviwers;
        
        User runningUserAdmin = IMH_TestClassUtility.createUser('System Administrator','SysAADmin',null);
        UserRole adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'iMH System Admin' LIMIT 1];
        runningUserAdmin.UserRoleId= adminRole.Id;
        insert runningUserAdmin;
        System.runAs(runningUserAdmin){
             List<Group> lgroups = new List<Group>();
            for(Integer i=0;i<2;i++){
                lgroups.add((IMH_TestClassUtility.createPublicGroup(PUBLIC_GROUP_NAME + i, DEVELOPER_NAME + i, GROUP_TYPE)));
            }
            insert lgroups;
            
            List<GroupMember> lgroupmember = new List<GroupMember>();
            for(Integer i=0;i<4;i++){
                lgroupmember.add(IMH_TestClassUtility.createPublicGroupMember(lReviwers[10+i].Id,lgroups[math.mod(i,2)].Id));
            }
            
            insert lgroupmember;
            IMH_GeneralApplicationUility.createChatterGroups(runningUserAdmin.Id);
            
            //IMH_GeneralApplicationUility.addChatterGroupMembers();
            List<CollaborationGroup> lcobs = [Select Id,Name from CollaborationGroup LIMIT 50000];
            System.assertEquals(2, lcobs.size());
            Test.startTest();
            List<CollaborationGroupMember> lcolbmembers = new List<CollaborationGroupMember>();
            CollaborationGroupMember cgm;
            for(Integer i=0;i<10;i++){
                cgm = new CollaborationGroupMember();
                if(i<=5){
                    cgm.MemberId = lReviwers[i].Id;
                    cgm.CollaborationGroupId = lcobs[0].Id;
                }
                else{
                    cgm.MemberId = lReviwers[i].Id;
                    cgm.CollaborationGroupId = lcobs[1].Id;
                }
                lcolbmembers.add(cgm);
            }
            //insert lcolbmembers;
            Test.stopTest();
            List<GroupMember> lgroupmembers = [SELECT Id FROM GroupMember WHERE GroupId IN:lgroups LIMIT 50000];
            System.assertEquals(4, lgroupmembers.size());
            List<CollaborationGroupMember> lcolabmember = [SELECT Id FROM CollaborationGroupMember WHERE CollaborationGroupId IN:lcobs LIMIT 50000]; 
            System.assertEquals(2, lcolabmember.size());//0 Present + 2 OwnerIds
            System.assertEquals(2,[Select Id FROM GroupMember WHERE GroupId =:lgroups[0].Id LIMIT 50000].size());
            System.assertEquals(2,[Select Id FROM GroupMember WHERE GroupId =:lgroups[1].Id LIMIT 50000].size());
        }
      }
}