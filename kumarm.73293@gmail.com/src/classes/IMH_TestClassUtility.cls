/**
* @author Accenture IDC 
* @date 05/26/2015
* @group Answer
* @group-content N/A
* @description Used for Creating the data for the  Test Class
*/
public class IMH_TestClassUtility {
    public static Map<String, map<String,RecordType>> mRecordType  = new Map<String, map<String,RecordType>>() ;
    private static final String OFFER_API = 'IMH_Incentive__c';
    private static final String CREATIVE_API = 'IMH_CommCreative__c';
    private static final String QUESTION_API = 'IMH_Question__C';
    private static final String TRANSLATION_API = 'IMH_Translation__c';
    private static final String CAMPAIGN_API = 'IMH_Communication__c';
    private static final String SLAMATRIX_API = 'IMH_StepApprovalGroup__c';
    private static final String SLATRACKER_API = 'IMH_SLATracker__c';
    private static final String RESPONSEVALUE_API = 'IMH_ResponseValue__c';
    private static final String QUESTIONSET_API = 'IMH_QuestionSet__c';
    private static final String QUESTIONSET_NAME = 'QuestionSet for Test Campaign';
    private static final String QUESTION_TEXT = 'Does the campaign require markting approval?';
    private static final String CAMPAIGN_NAME = 'Test Campaign';
    private static final String CAMPAIGN_TYPE = 'Marketing';
    private static final String CAMPAIGN_OCCURANCE = 'One Time';
    private static final String OFFER_NAME = 'Test Offer';
    private static final String FEEDITEM_POST = '[Welcome to test Knowledge]';
    private static final String CAMPAIGN_TARGET_REGION = 'JAPA';
    private static final String FINAL_CREATIVE_NAME =  'Final';
    private static final String CREATIVE_STAGE =  'Design';
    private static final String WARNING_DETAIL = 'Warning Test';
    private static final String USER_ALIAS = 'standt';
    private static final String USER_EMAIL = '@unitest.com';
    private static final String USER_UTF = 'UTF-8';
    private static final String USER_LNAME= 'UnitTest';
    private static final String USER_LAN_LOCALKEY= 'en_US';
    private static final String USER_TIMEZONEKEY= 'America/Los_Angeles';
    private static final String USER_PHONE = '1234567891';
    private static final String USER_MPHONE = '1111111111';
    
      /**
      * @Method :STATIC BLOCK TO RETRIEVE ALL RECORD TYPES
      * @return Type : NA 
      * @arguments : NA
      * @description  : This method is used to retrieve all record type 
      */
     static {
        mRecordType = new Map<String, map<String,RecordType>>();
        set<string> queryString = new set<String>{OFFER_API,CREATIVE_API,TRANSLATION_API,QUESTION_API,SLAMATRIX_API,CAMPAIGN_API,SLATRACKER_API,RESPONSEVALUE_API,QUESTIONSET_API}; 
        Map<String, RecordType> mRecordTypeByDevName = new Map<String, RecordType>();
        for (RecordType eachRecordType :[ SELECT Id
                                               , DeveloperName
                                               , SobjectType
                                          FROM RecordType
                                          WHERE isActive = true AND SobjectType 
                                          IN :queryString
                                          LIMIT 50000]) {
            if (mRecordType.containsKey(eachRecordType.SobjectType)) {
                mRecordType.get(eachRecordType.SobjectType).put(eachRecordType.DeveloperName, eachRecordType);
            } else {
                mRecordTypeByDevName = new Map<String, RecordType>();
                mRecordTypeByDevName.put(eachRecordType.DeveloperName, eachRecordType);
                mRecordType.put(eachRecordType.SobjectType, mRecordTypeByDevName);
            }
        }
     }
    
    /**
    * @description  - Used for creating the Question Set
    * @param  - String, String,String,String
    * @return  - IMH_QuestionSet__c
    */ 
     public static IMH_QuestionSet__c createQuestionSet(String objectEntry){
        IMH_QuestionSet__c questionset = new IMH_QuestionSet__c();
        questionset.Name = QUESTIONSET_NAME;
        questionset.Version__c = 1.0;
        questionset.Active__c =true;
        questionset.ObjectEntryCriteria__c = objectEntry;
        questionset.Description__c = 'Description';
        questionset.ActionBy__c = 'Submitter';
        return questionset;
     }
    
    
    
    /**
    * @description  - Used for creating the Question
    * @param  - String, String,Double,String
    * @return  - IMH_Question__c
    */
     public static IMH_Question__c createQuestion(String questionSetId
                                                  , Double orderSequence
                                                  , String recordType){
        IMH_Question__c question = new IMH_Question__c();
        question.Question__c = QUESTION_TEXT;
        question.OrderSequence__c = orderSequence;
        question.Version__c = 2.0;
        question.Active__c =true;
        question.QuestionSet__c = questionSetId;
        question.recordTypeId = recordType;
        return question; 
     }
    
    /**
    * @description  - Used for creating the Campaign
    * @param  - String, String,String
    * @return  - IMH_Communication__c
    */   
    public static IMH_Communication__c createCampaign(String approvalStage
                                                , String requesStatus
                                                , String targetMarket) {
        IMH_Communication__c campn = new IMH_Communication__c();
        campn.Name = CAMPAIGN_NAME;
        campn.ProcessStage__c = approvalStage;
        campn.ReviewStatus__c = requesStatus;
        campn.TargetMarket__c = targetMarket;
        campn.TargetRegion__c = CAMPAIGN_TARGET_REGION;
        campn.Occurrence__c = CAMPAIGN_OCCURANCE;
        campn.StartDate__c = Date.today().addDays(5);
        campn.EndDate__c = Date.today().addDays(10);
        return campn;
    }
    /**
    * @description  - Used for creating the Campaign
    * @param  - String, String,String
    * @return  - IMH_Communication__c
    */   
    public static IMH_Communication__c createCommunication(String approvalStage
                                                , String requesStatus
                                                , String targetMarket) {
        IMH_Communication__c campn = new IMH_Communication__c();
        campn.Name = CAMPAIGN_NAME;
        campn.ProcessStage__c = approvalStage;
        campn.ReviewStatus__c = requesStatus;
        campn.TargetMarket__c = targetMarket;
        campn.TargetRegion__c = CAMPAIGN_TARGET_REGION;
        campn.Occurrence__c = CAMPAIGN_OCCURANCE;
        campn.StartDate__c = Date.today().addDays(5);
        campn.EndDate__c = Date.today().addDays(10);
        return campn;
    }
  
    /**
    * @description  - Used for creating the Offer
    * @param  - String, String,String
    * @return  - IMH_Incentive__c
    */   
    public static IMH_Incentive__c createOffer(String offerType
                                            , String offerStatus
                                            , String campaignId){
        IMH_Incentive__c offer = new IMH_Incentive__c();
        offer.Name = OFFER_NAME;
        offer.RecordTypeID = offerType;
        offer.IncentiveStatus__c = offerStatus;
        offer.StartDate__c = Date.today().addDays(6);
        offer.EndDate__c = Date.today().addDays(8);
        offer.Communication__c = campaignId;
        return offer;
    }
    
    /**
    * @description  - Used for creating the Offer
    * @param  - String, String,String
    * @return  - IMH_Incentive__c
    */   
    public static IMH_Incentive__c createIncentive(String offerType
                                            , String offerStatus
                                            , String campaignId){
        IMH_Incentive__c offer = new IMH_Incentive__c();
        offer.Name = OFFER_NAME;
        offer.RecordTypeID = offerType;
        //offer.IncentiveStatus__c = offerStatus;
        offer.StartDate__c = Date.today().addDays(6);
        offer.EndDate__c = Date.today().addDays(8);
        offer.Communication__c = campaignId;
        return offer;
    }

    /**
    * @description  - Used for creating the Question Action
    * @param  - String, String,String,String,String
    * @return  - IMH_QuestionAction__c
    */
    public static IMH_QuestionAction__c createQuestionAction(String entryCriteria
                                                            , String fieldName
                                                            , String objectName
                                                            , String questionId
                                                            , String valueUpdate)
    {
        IMH_QuestionAction__c questionaction = new IMH_QuestionAction__c();
        questionaction.Question__c = questionId;
        questionaction.MultiEntryCriteria__c = entryCriteria;
        questionaction.Object__c = objectName;
        questionaction.Field__c = fieldName;
        questionaction.ValueUpdate__c = valueUpdate;
        return questionaction;
    }
   /**
    * @description  - Used for creating the Answer
    * @param  - String, String,String,String
    * @return  - IMH_Answer__c
    */ 
    public static IMH_Answer__c createAnswer(String answer
                                            , String status
                                            , String answersetId
                                            , String questionId){
        IMH_Answer__c ans = new IMH_Answer__c();
        ans.Status__c = status;
        ans.Answer__c = answer;
        ans.AnswerSet__c = answersetId;
        ans.Question__c = questionId;
        return ans;
    }
    /**
    * @description  - Used for creating the Feed Item
    * @param  - String
    * @return  - FeedItem
    */ 
    public static FeedItem createFeedItem(ID value){
        FeedItem post = new FeedItem();
        post.body = FEEDITEM_POST; 
        post.ParentId = value;
        return post;
    }
    /**
    * @description  - Used for creating the Final Creative
    * @param  - String
    * @return  - IMH_FinalCreative__c
    */    
    public static IMH_CommCreative__c createFinalCreative(String CampaignId
                                                        , String CreateStatus
                                                        , String recordType){
        IMH_CommCreative__c finalcreate = new IMH_CommCreative__c();
        finalcreate.Name = FINAL_CREATIVE_NAME;
        finalcreate.Communication__c = CampaignId;
        finalcreate.CreativeStatus__c = CreateStatus;
        finalcreate.CreativeStage__c = CREATIVE_STAGE;
        finalcreate.RecordTypeId = recordType;
        return finalcreate;
    }
    /**
    * @description  - Used for creating the User
    * @param  - String,String,Id
    * @return  - User
    */    
     public static User createUser (String profileName, String uName,ID mgrId){
        Profile prof = [select id from Profile where Name =:profileName LIMIT :1];
        User newUser = new User(alias = USER_ALIAS, email=uName+USER_EMAIL, emailencodingkey=USER_UTF, lastname=USER_LNAME
                        , languagelocalekey=USER_LAN_LOCALKEY, localesidkey=USER_LAN_LOCALKEY, profileid = prof.Id, timezonesidkey=USER_TIMEZONEKEY
                        , username= uName+USER_EMAIL
                        , isActive=true
                        ,Market__c = 'Thailand'
                        , IMH_User_Team__c = 'IMH');
            if(mgrId != null){
                newUser.ManagerId = mgrId;
            }
         if(profileName == 'iMH Campaign Submitter' || profileName == 'iMH Central Campaign Submitter' || profileName == 'iMH Bank Partner Submitter'){
            newUser.IMH_UserRoleTypeNew__c = 'Submitter'; 
         }
         else if(profileName == 'iMH Campaign Reviewer'){
             newUser.IMH_UserRoleTypeNew__c = 'Reviewer'; 
         }
        newUser.Phone = USER_PHONE;
        newUser.MobilePhone =USER_MPHONE; 
        return newUser;
    }
    
    /**
    * @description  - Used for creating the Question Warning
    * @param  - Strin,String,String
    * @return  - IMH_QuestionWarning__c
    */
     public static IMH_QuestionWarning__c createQuestionWarning(String questionId
                                                                , String entryCriteria
                                                                , String flag
                                                                ,Double numbr){
        IMH_QuestionWarning__c questWarn = new IMH_QuestionWarning__c();
        questWarn.Detail__c = WARNING_DETAIL;
        questWarn.Version__c = 1.0;
        questWarn.Active__c =true;
        questWarn.Flag__c = flag;
        questWarn.EntryCriteria__c =  entryCriteria;
        questWarn.Question__c = questionId;
        questWarn.ResponseValue__c = 'Advice has been applied';
        questWarn.OrderSequence__c = numbr;                                                             
        return questWarn;
     }
    
    /**
    * @description  - Used for creating the ResponseValue
    * @param  - Strin,String,String
    * @return  - IMH_QuestionWarning__c
    */ 
     public static IMH_ResponseValue__c createResponseValues(String questionId
                                                            , String responseValue
                                                            , Integer seqNo){
        IMH_ResponseValue__c resValue = new IMH_ResponseValue__c();
        resValue.OrderSequence__c = seqNo;
        resValue.Text__c =  responseValue;
        resValue.Question__c = questionId;
        return resValue;
     }
    
    /**
    * @description  - Used for creating the Translation
    * @param  - Strin,String,String,String
    * @return  - IMH_Translation__c
    */ 
     public static IMH_Translation__c createTranslation(String recordtypeId
                                                        , String questionId
                                                        , String responseValueId
                                                        , String questionWarningId
                                                        , String languageId
                                                        ){
        IMH_Translation__c translation = new IMH_Translation__c();
        translation.RecordTypeId = recordtypeId;
        translation.Question__c = questionId;
        translation.ResponseValue__c = responseValueId;
        translation.QuestionWarning__c = questionWarningId;
        translation.Language_IMH__c = languageId;
        return translation;
    }
     /**
    * @description  - Used for creating the SLA Matrix Record
    * @param  - String,String,String,Double,String,String,String
    * @return  - IMH_StepApprovalGroup__c
    */ 
    public static IMH_StepApprovalGroup__c createSLAMatrix(String stage,
                                                   String targetMarket,
                                                   String targetregion,
                                                   Double threshold,
                                                   String priority,
                                                   String recodtypeId,
                                                   String approvalGroup,
                                                   String subStage
                                                   ,String objectvalue){
        
         IMH_StepApprovalGroup__c slamat = new IMH_StepApprovalGroup__c();
         slamat.Priority__c = priority;
         slamat.Stage__c = stage;
         slamat.TargetMarket__c = targetMarket;
         slamat.Region__c = targetregion;
         slamat.Threshold__c =  threshold;
         slamat.RecordTypeId =  recodtypeId;
         slamat.ApprovalGroup__c = approvalGroup;
         slamat.SubStage__c =  subStage; 
         slamat.Object__c = objectvalue;                                              
         return slamat;                                              
    }

     /**
    * @description  - Used for creating the Aproval Matrix Record
    * @param  - String,String,String,Double,String,String,String
    * @return  - IMH_StepApprovalGroup__c
    */ 
    public static IMH_StepApprovalGroup__c createApprovalMatrix(String stage,
                                                   String targetMarket,
                                                   String targetregion,
                                                   Double threshold,
                                                   String priority,
                                                   String recodtypeId,
                                                   String owner,
                                                   Double sequence,
                                                   String commComponent,
                                                   String reqMandApprover,
                                                   String objectvalue,
                                                   String reqApproverLevel,
                                                   String userTeam,
                                                   Boolean isMandatory,
                                                   String approvalGroupId){
        
         IMH_StepApprovalGroup__c Approvalmat = new IMH_StepApprovalGroup__c();
         Approvalmat.Priority__c = priority;
         Approvalmat.ReviewStage__c = stage;
         Approvalmat.TargetMarket__c = targetMarket;
         Approvalmat.Region__c = targetregion;
         Approvalmat.Threshold__c =  threshold;
         Approvalmat.RecordTypeId =  recodtypeId;
         Approvalmat.Object__c = objectvalue;  
         Approvalmat.Active__c = True;
         Approvalmat.Sequence__c = sequence;
         Approvalmat.Owner__c = owner;  //'IMH_CentralOfferGovernance';
         Approvalmat.Approval_Group__c = approvalGroupId;                                                       
         Approvalmat.Request_Type__c = 'Standard';
         Approvalmat.Required_Approver_Level__c = reqApproverLevel; 
         Approvalmat.Locale__c = 'Local';
         Approvalmat.User_Team__c = userTeam; 
         Approvalmat.Communication_Components__c = commComponent;
         Approvalmat.RequiredMandatory_Approver__c = reqMandApprover;  
         Approvalmat.Mandatory__c = isMandatory;
         return Approvalmat;                                              
    }
    
   /**
    * @description  - Used for creating the SLA Tracker Record
    * @param  - String,String,String,Double,String,String,String
    * @return  - IMH_StepApprovalGroup__c
    */ 
    public static IMH_SLATracker__c  createSLATracker(String RecordType,
                                                      String Stage,
                                                      String Substage,
                                                      String ApprovalGroup,
                                                      String CommunicationId,
                                                      String CreativeId){
        
         IMH_SLATracker__c slatrack = new IMH_SLATracker__c();
         slatrack.RecordTypeId = RecordType;
         slatrack.Stage__c = Stage;
         slatrack.SubStage__c = Substage;                                                   
         slatrack.ApprovalGroup__c =  ApprovalGroup;
         slatrack.Communication__c =  CommunicationId;
         //slatrack.CommunicationCreative__c =  CreativeId;                                                
         return slatrack;                                              
    }
    
   /**
    * @description  - Used for creating the Entry Criteria
    * @param  - String, String,String
    * @return  - IMH_EntryCriteria__c
    */
    public static IMH_EntryCriteria__c createEntryCriteria(String QuestionSetId
                                                           ,String ObjectEntry
                                                           ,String FieldEntry
                                                           ,String ValueEntry
                                                          ){
          IMH_EntryCriteria__c entry = new IMH_EntryCriteria__c();
          entry.Object__c = ObjectEntry;
          entry.Field__c = FieldEntry;
          entry.Equals__c = ValueEntry;
          entry.QuestionSet__c = QuestionSetId;                                                   
          return  entry;
    }
     /**
    * @description  - Used for creating the Channel
    * @param  - String, String,String
    * @return  - IMH_ChannelREF__c
    */
    public static IMH_ChannelREF__c createChannel(String targetMarket,
                                               String targetRegion,
                                               String channelName
                                              ) {
      IMH_ChannelREF__c channel  = new IMH_ChannelREF__c();
      channel.MarketMultiSelect__c       = targetMarket;
      channel.Region__c       = targetRegion;
      channel.Name            = channelName;
      channel.Active__c            = TRUE;
      return channel;
    }
    
    /**
    * @description: Test Method used to create channel custom settings
    * @param: none
    * @return: void
    */
    public static IMH_Channel_Type__c createChannelCustomSetting(String Name,
                                                                 String channelType) {
        IMH_Channel_Type__c chType = new IMH_Channel_Type__c();
        chType.Name = Name;
        chType.Channel_Type__c = channelType;                                                            
        return chType;
    }
    /**
    * @description  - Used for creating the Products
    * @param  - String, String,Boolean,String
    * @return  - IMH_Product__c
    */ 
    public static IMH_Product__c createProduct(String NAME,String MARKET,Boolean ACTIVE,String Colour){
        IMH_Product__c prod=new IMH_Product__c();
        prod.Name= NAME;
        prod.MarketMultiSelect__c=MARKET;
        prod.Active__c=ACTIVE; 
        prod.Colour__c=Colour; 
        return prod;
    }
    /**
    * @description  - Used for creating the Targeted Products
    * @param  - Id,Id,String
    * @return  - IMH_CommProducts__c
    */ 
    public static IMH_CommProducts__c createCommTargetedProduct(Id communicationId, Id ProductId, String targetMarket) {
        IMH_CommProducts__c cp = new IMH_CommProducts__c();
        cp.Communication__c = communicationId;
        cp.Product__c = ProductId;
        cp.Market__c = targetMarket;
        return cp;
    }
    /**
    * @description  - Used for creating the Creative Products
    * @param  - Id,Id,String
    * @return  - IMH_CreativeProduct__c
    */ 
    public static IMH_CreativeProduct__c createTargetedProduct(Id creativeId, Id ProductId, String targetMarket) {
        IMH_CreativeProduct__c cp = new IMH_CreativeProduct__c();
        cp.Creative__c = creativeId;
        cp.TargetedProduct__c = ProductId;
        cp.Market__c = targetMarket;
        return cp;
    }
       /**
    * @description  - Used for creating the Targeted Channels
    * @param  - Id,Id
    * @return  - IMH_CommChannels__c
    */ 
    public static IMH_CommChannels__c createCommTargetedChannel(Id communicationId, Id channelId) {
        IMH_CommChannels__c cp = new IMH_CommChannels__c();
        cp.Communication__c = communicationId;
        cp.Channel__c = channelId;
        cp.Channel_Start_Date__c = Date.today().addDays(5);
        cp.Channel_End_Date__c = Date.today().addDays(10);      
        return cp;
    }
      /**
    * @description  - Used for creating the Creative Channels
    * @param  - Id,Id
    * @return  - IMH_CreativeChannel__c
    */ 
    public static IMH_CreativeChannel__c createTargetedChannel(Id creativeId, Id channelId) {
        IMH_CreativeChannel__c cp = new IMH_CreativeChannel__c();
        cp.Creative__c = creativeId;
        cp.TargetedChannel__c = channelId; 
        cp.Channel_Start_Date__c = Date.today().addDays(7);
        cp.Channel_End_Date__c = Date.today().addDays(8);
        return cp;
    }
      /**
    * @description  - Used for creating the Benefits
    * @param  - String,String,String
    * @return  - IMH_Benefits__c
    */ 
    public static IMH_Benefits__c createBenefits(String locale
                                                 ,String Region
                                                 ,String Market){
        IMH_Benefits__c benefit = new IMH_Benefits__c(); 
        benefit.Name = 'TestBenefit';
        benefit.ReviewApprovalSLAType__c = 'Standard';
        benefit.Benefit_Locale__c = locale;
        benefit.Region__c = Region;
        benefit.Market__c = Market;
        //benefit.BenefitStartDate__c = Date.Today().addDays(4);
        benefit.BenefitEndDate__c = Date.Today().addDays(8);
        benefit.ProcessStage__c =  'Concept'; 
        benefit.BenefitStage__c =  'Design';   
        benefit.Objective__c = 'Awareness'; 
        return benefit;
    }
     /**
    * @description  - Used for creating the Pre Approved Benefits
    * @param  - Id,Id
    * @return  - IMH_PreApprovedBenefits__c
    */ 
    public static IMH_PreApprovedBenefits__c createPreApprovedBenefits(Id communicationId, Id benefitId) {
        IMH_PreApprovedBenefits__c prebenefit = new IMH_PreApprovedBenefits__c(); 
        prebenefit.Communication__c = communicationId;
        prebenefit.BenefitOffers__c = benefitId;
        return prebenefit;
    } 
    
     /**
    * @description  Used to intantiate the Approval Group 
    * @param   Name of the queue, Required Approver to check against
    * @return   IMH_ApprovalGroup__c
    */ 
    public static IMH_ApprovalGroup__c createApprovalGroup(String queueName, String reqApp) {
        IMH_ApprovalGroup__c appGrp = new IMH_ApprovalGroup__c(); 
        appGrp.QueueAPI__c = queueName;
        appGrp.RequiredMandatoryApprover__c = reqApp;
        return appGrp;
    } 
    
    /**
    * @description  - Used for creating a Public Group
    * @param  - String,String,String,Integer
    * @return  - Group
    */ 
    public static Group createPublicGroup(String  groupName,String developerName, String groupType) {

       /* List<Group> lGroups = new List<Group>();
        for(Integer i = 0; i<numberOfGroup; i++ ){
            Group newGroup = new Group();
            newGroup.Name = groupName + i;
            System.Debug('Group id ' + newGroup.Id );
            System.Debug('Group Name ' + newGroup.Name );
            newGroup.DeveloperName = developerName + i;
            newGroup.Type = groupType;
            lGroups.add(newGroup);
        }*/
        
        Group newGroup = new Group();
        newGroup.Name = groupName;
        newGroup.DeveloperName = developerName;
        newGroup.Type = groupType;
        
        return newGroup;
    }
    
    /**
    * @description  - Used for creating a Public Group Emeber
    * @param  - String,String,String
    * @return  - Group
    */ 
    public static GroupMember createPublicGroupMember(Id  UserGroupId,Id groupId) {
        GroupMember newGroupmember = new GroupMember();
        newGroupmember.UserOrGroupId = UserGroupId;
        newGroupmember.GroupId = groupId;
        //newGroup.Type = groupType;
        
        return newGroupmember;
    }  
}