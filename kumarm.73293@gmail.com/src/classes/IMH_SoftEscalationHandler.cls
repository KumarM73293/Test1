/**
* @author Accenture IDC 
* @date 01/14/2016
* @group Escalation
* @group-content N/A
* @description Code for Escalatin process. This code will make the user follow the record from which 
*              escalation is initiated and post escalation comments on Record's Feed.
*/
public without sharing class IMH_SoftEscalationHandler {
    
    private static final String ESCALATE_GCO_API                = 'Escalate_to_GCO__c';
    private static final String ESCALATE_COMPLIANCE_API         = 'Escalate_to_Insurance_Compliance__c';
    private static final String ESCALATE_CENTRAL_OG_API         = 'Escalate_to_Central_OG__c';
    private static final String ESCALATE_COMMENTS               = 'Escalate_Comments__c';
    private static final String REVIEWER_PROFILE                = 'iMH Campaign Reviewer';
    private static final String COMMUNICATION_API               = 'IMH_Communication__c';
    private static final String CREATIVE_API                    = 'IMH_CommCreative__c';
    private static final String AUS_MARKET                      = 'Australia';
    private static final String NZ_MARKET                       = 'New Zealand';
    private static final String GROUP_ANZ                       = 'ANZ';
    private static final String CA_MARKET                       = 'Canada';  
    private static final String GROUP_CA                        = 'CA';
    private static final String IN_MARKET                       = 'ONE India';  
    private static final String GROUP_IN                        = 'IN';
    private static final String HK_MARKET                       = 'Hong Kong';
    private static final String GROUP_HK                        = 'HK';
    private static final String JP_MARKET                       = 'Japan';  
    private static final String GROUP_JP                        = 'JP';
    private static final String SG_MARKET                       = 'Singapore';
    private static final String GROUP_SG                        = 'SG';
    private static final String TH_MARKET                       = 'Thailand'; 
    private static final String GROUP_TH                        = 'TH';
    private static final String TW_MARKET                       = 'Taiwan'; 
    private static final String GROUP_TW                        = 'TW'; 
    private static final String GROUP_COMPLIANCE                = 'IMH_Insurance_';    //This was changed from IMH_Compliance_
    private static final String GROUP_GCO                       = 'IMH_GCO_';    
    private static final String GROUP_COG                       = 'IMH_CentralOfferGovernance';
    private static final String DESIGN_STAGE                    = 'Design';
    private static final String COMPLETE                        = 'Complete';
    private static final String APPROVED                        = 'Approved';
    private static final String CONCEPT                         = 'Concept';
    private static final String CREATIVE_PROCESS                = 'Creative';
    private static final String REJECT_OR_RECALL                = 'In Progress (following rejection/recalled)';
    private static final String IN_REVIEW                       = 'In Review';
    private static final String REVIEW_STATUS                   = 'ReviewStatus__c';
    private static final String CREATIVE_STAGE                  = 'CreativeStage__c';
    private static final String CREATIVE_STATUS                 = 'CreativeStatus__c';
    private static final String PROCESS_STAGE                   = 'ProcessStage__c';
    private static final String REVIEW_STAGE                    = 'ReviewStage__c';
    private static final String UNDER_SCORE                     = '_';
    private static final String COMMUNICATION_R                 = 'Communication__r';
    private static final String OWNER_ID                        = 'OwnerId';
    private static final String INSURANCE                       = 'Insurance';
    private static final String GCO                             = 'GCO';
    private static final String COG                             = 'Central Offer Governance';
    private static final String NULL_SPACE                      = '';
    private static final String ERROR_MSG                       = 'Market should be specified on user record for escalation process. Please Contact system admin.';
    private static final String SELECTOFFERGOVERNANCE           = 'SELECT Id, Escalate_Comments__c, Escalate_to_Central_OG__c FROM ';
    private static final String WHEREOFFERGOVERNANE             = ' WHERE Id IN: followUnfollowRecordsSet';
    private static final String SELECTALLESCALATION             = 'SELECT Id, Escalate_Comments__c, Escalate_to_GCO__c, Escalate_to_Central_OG__c, Escalate_to_Insurance_Compliance__c FROM ';
    private static final String GROUPVALUE                     = 'Group';
    private static final String QUEUEVALUE                      = 'Queue';
    private static final String LEADERSHIPVALUE                = 'Leadership';
    /*****************************************************************************
    * @description: Method to get escalated records.
    * @param: sObjectlist, Object Name
    * @return: void
    */
    public static void processEscalatedRecs(List<sObject> recordsList, String escalatedObject, Boolean onApproval) {
        String userMarket = [SELECT Id, Market__c FROM USER WHERE Id =: UserInfo.getUserId()].Market__c;
        Id userProfileId = userInfo.getProfileId();
        String userProfileName = [SELECT Id, Name FROM Profile WHERE Id =: userProfileId].Name;
        Set<Id> escalatedRecordsSet = new Set<Id>();
        Set<Id> unFollowRecordsSet = new Set<Id>();
        Set<Id> followedFeedsSet = new Set<Id>();
        for(EntitySubscription es : [SELECT Id, parentId, subscriberid FROM EntitySubscription 
                                                        WHERE parentId =: recordsList]) {
            followedFeedsSet.add(es.parentId);
        }
        for(sObject sobj : recordsList) {
            if(String.isBlank(userMarket) && userProfileName.equalsIgnoreCase(REVIEWER_PROFILE)) {
                sobj.addError(ERROR_MSG);
            }
            if(escalatedObject.equalsIgnorecase(CREATIVE_API)){
                if(!(COMPLETE.equalsIgnoreCase(String.valueOf(sobj.get(CREATIVE_STAGE))))
                    && IN_REVIEW.equalsIgnoreCase(String.valueOf(sobj.get(CREATIVE_STATUS)))) {
                    if(Boolean.valueOf(sobj.get(ESCALATE_GCO_API)) || 
                        Boolean.valueOf(sobj.get(ESCALATE_COMPLIANCE_API)) || 
                        Boolean.valueOf(sobj.get(ESCALATE_CENTRAL_OG_API))) {
                        escalatedRecordsSet.add(sobj.Id);
                    }
                }
                else if((!followedFeedsSet.isEmpty()) && ((COMPLETE.equalsIgnoreCase(String.valueOf(sobj.get(CREATIVE_STAGE)))
                                              && APPROVED.equalsIgnoreCase(String.valueOf(sobj.get(CREATIVE_STATUS)))) 
                                         || (DESIGN_STAGE.equalsIgnoreCase(String.valueOf(sobj.get(CREATIVE_STAGE)))
                                              && REJECT_OR_RECALL.equalsIgnorecase(String.valueOf(sobj.get(CREATIVE_STATUS)))))) {
                    if(followedFeedsSet.contains(sobj.Id)) {
                        unFollowRecordsSet.add(sobj.Id);
                    }
                }
            }
            else if(escalatedObject.equalsIgnorecase(COMMUNICATION_API)) {
                if(CONCEPT.equalsIgnoreCase(String.valueOf(sobj.get(PROCESS_STAGE)))
                    && IN_REVIEW.equalsIgnoreCase(String.valueOf(sobj.get(REVIEW_STATUS)))){
                    if(Boolean.valueOf(sobj.get(ESCALATE_CENTRAL_OG_API))) {
                        escalatedRecordsSet.add(sobj.Id);
                    }
                }
                else if((!followedFeedsSet.isEmpty()) && ((CREATIVE_PROCESS.equalsIgnoreCase(String.valueOf(sobj.get(PROCESS_STAGE)))
                                              && DESIGN_STAGE.equalsIgnoreCase(String.valueOf(sobj.get(REVIEW_STAGE)))) 
                                         || (CONCEPT.equalsIgnoreCase(String.valueOf(sobj.get(PROCESS_STAGE)))
                                              && REJECT_OR_RECALL.equalsIgnorecase(String.valueOf(sobj.get(REVIEW_STATUS)))))) {
                    if(followedFeedsSet.contains(sobj.Id)) {
                        unFollowRecordsSet.add(sobj.Id);
                    }
                }
            }
        }
        if(!escalatedRecordsSet.isEmpty()) {
            chatterFollowProcess(escalatedRecordsSet, escalatedObject);       
        }
        else if(!unFollowRecordsSet.isEmpty()) {
            chatterUnFollowProcess(unFollowRecordsSet, escalatedObject, onApproval);       
        }
    }
    /*****************************************************************************
    * @description: Method to get escalated records
    * @param: escalated Record ids, Object Name
    * @return: List
    */
    public static List<sObject> retrieveEscalatedRecords(Set<Id> followUnfollowRecordsSet, String escalatedObject) {
        List<sObject> escalatedRecordsList = new List<sObject>();
        String queryEscalatedRecs = NULL_SPACE;
        if(escalatedObject.equalsIgnoreCase(COMMUNICATION_API)){
            queryEscalatedRecs = SELECTOFFERGOVERNANCE+escalatedObject
                                        +WHEREOFFERGOVERNANE;
        }
        else if(escalatedObject.equalsIgnoreCase(CREATIVE_API)){
            queryEscalatedRecs = SELECTALLESCALATION+escalatedObject
                                        +WHEREOFFERGOVERNANE;
        }
        escalatedRecordsList = Database.query(queryEscalatedRecs);
        return escalatedRecordsList;
    }
    /*****************************************************************************
    * @description: Method to follow record, post feed item
    * @param: escalated Record ids, Object Name
    * @return: void
    */
    public static void chatterFollowProcess(Set<Id> followUnfollowRecordsSet, String escalatedObject) {
        List<sObject> escalatedRecordsList = new List<sObject>();
        escalatedRecordsList = retrieveEscalatedRecords(followUnfollowRecordsSet,escalatedObject);
        Set<Id> groupMemberIdSet = new Set<Id>();
        groupMemberIdSet = userToAddRemoveSubscribe(escalatedRecordsList, escalatedObject, false);
        List<EntitySubscription> entitySubscriptionList = new List<EntitySubscription>();
        List<FeedItem> feedItemOnRecordList = new List<FeedItem>();
        FeedItem postonRecord;
        EntitySubscription esRec;
        Map<Id,String> creativeEscalateToMap = new Map <Id, String>();
        for(sObject sobj : escalatedRecordsList){
            for(Id userID : groupMemberIdSet) {
                esRec = new EntitySubscription();
                esRec.parentId = sobj.Id;
                esRec.subscriberid = userID;
                entitySubscriptionList.add(esRec);
            }
            postonRecord = new FeedItem();
            postonRecord.ParentId = sobj.Id;
            postonRecord.Body = String.valueOf(sobj.get(ESCALATE_COMMENTS));
            feedItemOnRecordList.add(postonRecord);
        }
        Database.insert(entitySubscriptionList,false);
        Database.insert(feedItemOnRecordList,false);
    }
    
    /*****************************************************************************
    * @description: Method to unfollow record
    * @param: escalated Record ids, Object Name
    * @return: void
    */
    public static void chatterUnFollowProcess(Set<Id> unFollowRecordsSet, String escalatedObject, Boolean onApproval) {
        if(onApproval){
            List<EntitySubscription> feedUnFollowList = new List<EntitySubscription>();
            feedUnFollowList = [SELECT Id, parentId, subscriberId FROM EntitySubscription WHERE 
                                 parentId =: unFollowRecordsSet];
            delete feedUnFollowList;
        }
        else {
            List<sObject> escalatedRecordsList = new List<sObject>();
            escalatedRecordsList = retrieveEscalatedRecords(unFollowRecordsSet,escalatedObject);
            Set<Id> groupMemberIdSet = new Set<Id>();
            groupMemberIdSet = userToAddRemoveSubscribe(escalatedRecordsList, escalatedObject, true);
            List<EntitySubscription> feedUnFollowList = new List<EntitySubscription>();
            feedUnFollowList = [SELECT Id, parentId, subscriberId FROM EntitySubscription WHERE 
                                 parentId =: unFollowRecordsSet AND subscriberId =: groupMemberIdSet];
            Database.delete(feedUnFollowList,false);
        }
    }

    /*****************************************************************************
    * @description: Method to get users who need to follow or unfollow a record
    * @param: Record ids, Object Name, Boolean
    * @return: Set of users
    */
    public static Set<Id> userToAddRemoveSubscribe(List<Sobject> escalatedRecordsList
                                                   , String escalatedObject
                                                   , Boolean isUnFollow) {
        Boolean escalateToGCO = false;
        Boolean escalateToCOG = false;
        Boolean escalateToCompliance = false;
        if(escalatedObject.equalsIgnoreCase(COMMUNICATION_API)){
            for(sObject sobj : escalatedRecordsList) {
                if(Boolean.valueOf(sobj.get(ESCALATE_CENTRAL_OG_API))){
                    escalateToCOG = true;
                }
            }
        }
        else if(escalatedObject.equalsIgnoreCase(CREATIVE_API)){
            for(sObject sobj : escalatedRecordsList) {
                if(Boolean.valueOf(sobj.get(ESCALATE_GCO_API))){
                    escalateToGCO = true;
                }
                if(Boolean.valueOf(sobj.get(ESCALATE_CENTRAL_OG_API))){
                    escalateToCOG = true;
                }
                if(Boolean.valueOf(sobj.get(ESCALATE_COMPLIANCE_API))){
                    escalateToCompliance = true;
                }
            }
        }
        Map<String, String> marketGroupMap = new Map<String, String>();
        marketGroupMap.put(GROUP_ANZ,GROUP_ANZ);
        marketGroupMap.put(AUS_MARKET,GROUP_ANZ);
        marketGroupMap.put(NZ_MARKET,GROUP_ANZ);
        marketGroupMap.put(CA_MARKET,GROUP_CA);
        marketGroupMap.put(IN_MARKET,GROUP_IN);
        marketGroupMap.put(HK_MARKET,GROUP_HK);
        marketGroupMap.put(JP_MARKET,GROUP_JP);
        marketGroupMap.put(SG_MARKET,GROUP_SG);
        marketGroupMap.put(TH_MARKET,GROUP_TH);
        marketGroupMap.put(TW_MARKET,GROUP_TW);
        Set<Id> groupMemberIdSet = new Set<Id>();
        String userMarket = [SELECT Id, Market__c FROM USER WHERE Id =: UserInfo.getUserId()].Market__c;
        String chatterAutoFollowCheck = escalatedObject+UNDER_SCORE+userMarket+UNDER_SCORE;
        Map<String, Boolean> chatterMatrixMap = new Map<String, Boolean>();
        chatterMatrixMap = buildChatterMatrixMap(escalatedObject);
        if(chatterMatrixMap.containsKey(chatterAutoFollowCheck+INSURANCE)){
            If(escalateToCompliance 
                && (chatterMatrixMap.get(chatterAutoFollowCheck+INSURANCE)
                || isUnFollow)) {
                    String publicGroupName = GROUP_COMPLIANCE+marketGroupMap.get(userMarket);
                    for(GroupMember g : [SELECT UserorGroupId From GroupMember WHERE group.DeveloperName =: publicGroupName]){
                        if(g.UserOrGroupID.getsObjectType() == Schema.User.sObjectType) {
                            groupMemberIdSet.add(g.UserOrGroupId);
                        }
                    }
            }
        }
        if(chatterMatrixMap.containsKey(chatterAutoFollowCheck+GCO)){
            If(escalateToGCO 
                && (chatterMatrixMap.get(chatterAutoFollowCheck+GCO)
                || isUnFollow)) {
                    String publicGroupName = GROUP_GCO+marketGroupMap.get(userMarket);
                    for(GroupMember g : [SELECT UserorGroupId From GroupMember WHERE group.DeveloperName =: publicGroupName]){
                        if(g.UserOrGroupID.getsObjectType() == Schema.User.sObjectType) {
                            groupMemberIdSet.add(g.UserOrGroupId);
                        }
                    }
            }
        }
        if(chatterMatrixMap.containsKey(chatterAutoFollowCheck+COG)) {
            If(escalateToCOG 
                && (chatterMatrixMap.get(chatterAutoFollowCheck+COG)
                || isUnFollow)) {
                for(GroupMember g : [SELECT UserorGroupId From GroupMember WHERE group.DeveloperName =: GROUP_COG]){
                    if(g.UserOrGroupID.getsObjectType() == Schema.User.sObjectType) {
                        groupMemberIdSet.add(g.UserOrGroupId);
                    }
                }
            }
        }
        return groupMemberIdSet;
    }
    /*****************************************************************************
    * @description: Method to used to auto follow the record on Approval Submit.
    * @param: Set<String>,Sobject,String,String,String
    * @return: void
    */
    public static void autoFollowOnApprovalSubmit(Set<String> followerQueueSet, 
                                                   Sobject submittedRecord,
                                                   Set<String> followerUserSet,
                                                   String targetMarket,
                                                   String submittedObject) {
        
        
		Map<String, Boolean> chatterMatrixMap = new Map<String, Boolean>();
        chatterMatrixMap = buildChatterMatrixMap(submittedObject);
        System.debug('----111 auto follow--->>. '+chatterMatrixMap);
		Set<Id> usersToFollowSet = new Set<Id>();
        if(followerQueueSet.isEmpty()){
            Set<Id> groupIdSet = new Set<Id>();
            Set<String> queueToFollowSet = new Set<String>();
            for(Group q :  [Select Id
                                   ,Name
                                   ,DeveloperName 
                            from Group 
                            where type=:QUEUEVALUE 
                            and DeveloperName=: followerQueueSet
                            LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
                if(chatterMatrixMap.containsKey(submittedObject+IMH_UtilityConstants.UNDERSCORE+targetMarket+IMH_UtilityConstants.UNDERSCORE+q.Name)) {
                    if(chatterMatrixMap.get(submittedObject+IMH_UtilityConstants.UNDERSCORE+targetMarket+IMH_UtilityConstants.UNDERSCORE+q.Name)){
                        queueToFollowSet.add(q.DeveloperName);
                    }
                }
            }
            //Loop for getting queue members
            for(GroupMember qm : [SELECT Group.DeveloperName, UserorGroupId From GroupMember WHERE group.DeveloperName =: queueToFollowSet]){
                if(qm.UserOrGroupID.getsObjectType() == Schema.User.sObjectType) {
                    usersToFollowSet.add(qm.UserOrGroupID);
                }
                else {
                    //Get list of groups for the queue
                    groupIdSet.add(qm.UserOrGroupID);
                }
            }
            //Loop for getting group members
            for(GroupMember gm :[SELECT Group.DeveloperName, UserorGroupId From GroupMember WHERE group.Id =: groupIdSet]){
                if(gm.UserOrGroupID.getsObjectType() == Schema.User.sObjectType) {
                    usersToFollowSet.add(gm.UserOrGroupID);
                }
            }
        }
        
            for(String user : followerUserSet) {
                if(chatterMatrixMap.containsKey(submittedObject+IMH_UtilityConstants.UNDERSCORE+targetMarket+IMH_UtilityConstants.UNDERSCORE+LEADERSHIPVALUE)) {
                    if(chatterMatrixMap.get(submittedObject+IMH_UtilityConstants.UNDERSCORE+targetMarket+IMH_UtilityConstants.UNDERSCORE+LEADERSHIPVALUE)){
                        usersToFollowSet.add(Id.valueOf(user));
                    }
                }
            }
        
        List<EntitySubscription> feedFollowersList = new List<EntitySubscription>();
        EntitySubscription es;
        Boolean isOwnerAdded = false;
        for(Id gm : usersToFollowSet){
            es = new EntitySubscription();
            es.parentId = submittedRecord.Id;
            es.subscriberid = gm;
            feedFollowersList.add(es);
            if(!isOwnerAdded){
                isOwnerAdded = true;
                es = new EntitySubscription();
                es.parentId = submittedRecord.Id;
                if(COMMUNICATION_API.equalsIgnorecase(submittedObject)) {
                    es.subscriberid = String.valueof(submittedRecord.get(OWNER_ID));
                }
                else if(CREATIVE_API.equalsIgnorecase(submittedObject)) {
                    es.subscriberid = String.valueOf(submittedRecord.getsobject(COMMUNICATION_R).get(OWNER_ID));
                }
                feedFollowersList.add(es);
            }
        }
        Database.insert(feedFollowersList,false);
    }
     /*****************************************************************************
    * @description: Method to used to prepare the Chatter Matrix Map from Custom Setting.
    * @param: String
    * @return: Map<String,Boolean>
    */
    public static Map<String,Boolean> buildChatterMatrixMap(String selectedObject) {
        Map<String,Boolean> chatterMatrixMap = new Map<String,Boolean>();
        for(IMH_Chatter_Auto_Follow__c caf : [SELECT Id, Name, Object__c, Active__c, Market__c,Escalation_Group__c 
                                              FROM IMH_Chatter_Auto_Follow__c WHERE Object__c =: selectedObject]){
            chatterMatrixMap.put(caf.Object__c+IMH_UtilityConstants.UNDERSCORE+caf.Market__c+IMH_UtilityConstants.UNDERSCORE+caf.Escalation_Group__c,caf.Active__c);
        }
        return chatterMatrixMap;
    }
}