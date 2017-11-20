/**
* @author Saravvanan Kandaswamy 
* @date 08/08/2016
* @group N/A
* @group-content N/A
* @description: iMH Test Class for GeneralApplicationUtility.
*/
@istest 
private class IMH_GeneralApplicationUtilityTest {
    
    private static final String PUBLIC_GROUP_NAME = 'ChatterGroupCreationTest';
    private static final String DEVELOPER_NAME = 'IMH_TestClassDummy_UK';
    private static final String USER_NAME = 'testChatterUser';
    private static final String GROUP_TYPE = 'Regular';
    private static final Integer NUMBER_OF_GROUPS = 2;
    private static final Integer NUMBER_OF_USERS = 3;
    
    /**
    * @description: Test Method used to create chatter groups
    * @param: none
    * @return: void
    */
    static testMethod void testCreateChatterGroups() {
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
         User adminUser = new User(Alias = 'standt', Email='userchatterstandIMHGEneral@amerextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='userchatterstandIMHGEneral@amextest.com');
        Insert adminUser;
        //No records should be present.
        List<Group> pubGroup = [Select Id,Name,Type from Group where Name LIKE : PUBLIC_GROUP_NAME+'%' LIMIT 50000];
        System.assert(pubGroup.isEmpty());
        System.debug('Public Group initial size = '+ pubGroup.size());
        System.Debug('*********Test 1');
        List<CollaborationGroup> colGroup = [Select id,Name from CollaborationGroup where Name LIKE : PUBLIC_GROUP_NAME+'%' LIMIT 50000];
        System.assert(colGroup.isEmpty());
        Test.startTest();  
        
        //Create the test public group
        List<Group> lTestGroup = new List<Group>();
        for(Integer iVal=0; iVal < NUMBER_OF_GROUPS;iVal++ )
        {
            lTestGroup.add(IMH_TestClassUtility.createPublicGroup(PUBLIC_GROUP_NAME+iVal, DEVELOPER_NAME+iVal, GROUP_TYPE));            
        }
        insert lTestGroup;
        
        System.Debug('*********Test 2');
        pubGroup = [Select Id,Name from Group where Name LIKE : PUBLIC_GROUP_NAME+'%' LIMIT 50000];
        System.assertEquals(pubGroup.size(), NUMBER_OF_GROUPS);
        
        System.debug('Public Group size = '+ pubGroup.size());
         
        IMH_GeneralApplicationUility.createChatterGroups(adminUser.Id);
        
        Test.stopTest(); 
              
        colGroup = [Select Id,Name from CollaborationGroup where Name LIKE : PUBLIC_GROUP_NAME+'%' LIMIT 50000];
        
        System.debug('Col Group size = '+ colGroup.size());
        // Equal record should be present.
        System.assertEquals(colGroup.size(),NUMBER_OF_GROUPS);
        
         
    }
    
    /**
    * @description: Test Method used to check chatter groups are not getting created if it already exists
    * @param: none
    * @return: void
    */
    static testMethod void testDontCreateExistingChatterGroups() {
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
         User adminUser = new User(Alias = 'standt', Email='userchatterstandIMHGEneral@amerextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='userchatterstandIMHGEneral@amextest.com');
        Insert adminUser;
        //No records should be present.
        List<Group> pubGroup = [Select Id,Name,Type from Group where Name LIKE : PUBLIC_GROUP_NAME+'%' LIMIT 50000];
        System.assert(pubGroup.isEmpty());
        System.debug('Public Group initial size = '+ pubGroup.size());
        
        List<CollaborationGroup> colGroup = [Select id,Name from CollaborationGroup where Name LIKE : PUBLIC_GROUP_NAME+'%' LIMIT 50000];
        System.assert(colGroup.isEmpty());
        Test.startTest();  
        
       //Create the test public group
        List<Group> lTestGroup = new List<Group>();
        for(Integer iVal=0; iVal < NUMBER_OF_GROUPS;iVal++ )
        {
            lTestGroup.add(IMH_TestClassUtility.createPublicGroup(PUBLIC_GROUP_NAME+iVal, DEVELOPER_NAME+iVal, GROUP_TYPE));            
        }
        insert lTestGroup;

        
        pubGroup = [Select Id,Name from Group where Name LIKE : PUBLIC_GROUP_NAME+'%' LIMIT 50000];
        System.assertEquals(pubGroup.size(), NUMBER_OF_GROUPS);
        
        System.debug('Public Group size = '+ pubGroup.size());
         
        IMH_GeneralApplicationUility.createChatterGroups(adminUser.Id); 
              
        colGroup = [Select Id,Name from CollaborationGroup where Name LIKE : PUBLIC_GROUP_NAME+'%' LIMIT 50000];
        
        //System.debug('Col Group size = '+ colGroup.size());
        // Equal records should be present.
        System.assertEquals(colGroup.size(),NUMBER_OF_GROUPS);
        
        // Run the method again to check if the group is created again
        IMH_GeneralApplicationUility.createChatterGroups(adminUser.ID);
        
        Test.stopTest();
        
        List<CollaborationGroup> colGroupNew = [Select Id,Name from CollaborationGroup where Name LIKE : PUBLIC_GROUP_NAME+'%' LIMIT 50000];
        
        //System.debug('Col Group size = '+ colGroup.size());
        // There should not be any change in record count. 
        System.assertEquals(colGroup.size(),NUMBER_OF_GROUPS); 
          
    }
    
    /**
    * @description: Test Method used to add chatter group members
    * @param: none
    * @return: void
    */
    static testMethod void testAddChatterGroupMembers() {
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
         User adminUser = new User(Alias = 'standt', Email='userchatterstandIMHGEneral@amerextest.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='userchatterstandIMHGEneral@amextest.com');
        Insert adminUser;
        //Create the test public group
        List<Group> lPubGroup = new List<Group>();
        for(Integer iVal=0; iVal < NUMBER_OF_GROUPS;iVal++ )
        {
            lPubGroup.add(IMH_TestClassUtility.createPublicGroup(PUBLIC_GROUP_NAME+iVal, DEVELOPER_NAME+iVal, GROUP_TYPE));            
        }

        Test.startTest(); 
        insert lPubGroup;
        
        // run the script to create chatter group       
        IMH_GeneralApplicationUility.createChatterGroups(adminUser.ID);
               
        List<User> lUserList = new List<User>();
 
        
        for (Integer iVal = 0 ; iVal< NUMBER_OF_USERS; iVal++){
            lUserList.add(IMH_TestClassUtility.CreateUser('Standard User',USER_NAME + iVal,null));
        }
        
        insert lUserList;
       
        System.runAs(new user(ID = UserInfo.getUserID())){
        List<GroupMember> lGrpMem = new List<GroupMember>();
        
        for( Group itrGrp : lPubGroup){
            for(User itrUser : lUserList ){
                GroupMember gm= new GroupMember(); 
                gm.GroupId=itrGrp.id;
                gm.UserOrGroupId = itrUser.id;
                lGrpMem.add(gm);
            }
        }
            
        insert lGrpMem;
        System.debug('Group Members Created !!!!!!!!');
        
        IMH_GeneralApplicationUility.addChatterGroupMembers();
        
        Test.stopTest();
        
        //add current User running the script as the first index value
        lUserList.add(0, [select id,Name from User where id = :Userinfo.getUserId() LIMIT 50000]);
                    
        List<CollaborationGroup> colGroup = [Select Id,Name, MemberCount from CollaborationGroup where Name LIKE : PUBLIC_GROUP_NAME +'%' LIMIT 50000];
            List<Id> lCollGrpId = new List<Id>();
            for ( CollaborationGroup iterCollab : colGroup ){
                
                System.Debug('Collab Group '+ iterCollab.Name + '  ID : ' + iterCollab.Id + ' Member Count = ' + iterCollab.MemberCount );
                System.assertEquals(iterCollab.MemberCount, NUMBER_OF_USERS + 1);  // Number of User added + User running the script
                lCollGrpId.add(iterCollab.Id);
            }
            
            System.debug('Col Group size = '+ colGroup.size());
            System.assertEquals(colGroup.size(),NUMBER_OF_GROUPS);
            
            List<CollaborationGroupMember> lColGroupMember = [Select Id, CollaborationGroupId, MemberId From CollaborationGroupMember where CollaborationGroupId IN: lCollGrpId LIMIT 50000]; 
            
            
            System.Debug('Col Group Member size = ' + lColGroupMember.size() );
            
            Map<ID,List<CollaborationGroupMember>> mColGrp = new Map<ID,List<CollaborationGroupMember>>();
            for(ID itrId : lCollGrpId){
                List<CollaborationGroupMember> lColGrpMemList = new List<CollaborationGroupMember>();
                for(CollaborationGroupMember itrColGrpMem : lColGroupMember ){
                    if(itrId == itrColGrpMem.CollaborationGroupId)
                    {
                        lColGrpMemList.add(itrColGrpMem);
                    }
                }
                System.assertEquals(lColGrpMemList.size(),NUMBER_OF_USERS+1 ); // add current script running use (added as owner of coll group)
                mColGrp.put(itrId,lColGrpMemList);
                
            }
            System.assertEquals(mColGrp.size(),NUMBER_OF_GROUPS);
        }   
    }
   
}