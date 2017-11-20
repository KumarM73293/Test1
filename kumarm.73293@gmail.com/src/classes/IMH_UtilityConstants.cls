/**
* @author Accenture IDC 
* @date 06/04/2015
* @group N/A
* @group-content N/A
* @description - iMH Release 1 (Sprint 1) Class where String constants are resided if it is Common.
*/
public without sharing class IMH_UtilityConstants {
    //GENERAL CONSTANTS
    
    public static final String ID = 'Id';
    public static final String EMPTY_STRING = '';
    public static final String FORWARD_SLASH = '/';
    public static final String BLANK_SPACE = ' ';
    public static final String NONE = 'None';
    public static final String SEMI_COLON = ';';
    public static final String COMMA = ',';
    public static final String UNDERSCORE = '_';
    
    //PICLIST VALUES FOR ANSWER STATUS
    public static final String ANS_INPROGRESS = 'In Progress';
    public static final String ANS_COMPLETED = 'Completed';
    public static final String ANS_NA = 'N/A';  
    
    //SELECT OPTIONS PICKLISTS FOR ANSWER YES/NO/NA
    public static final String YES = 'Yes';
    public static final String NO = 'No';
    public static final String NOT_APPLICABLE = 'N/A';
    
    //QUESTION RECORD TYPE DEVELOPER NAME
    public static final String YES_NO_NA = 'Yes_No_NA';
    public static final String YES_NO = 'Yes_No';
    public static final String PICKLIST = 'Picklist';
    public static final String FREETEXT = 'Freetext';
    public static final String COMPLIANCE = 'Compliance';
    public static final String SUBMITTER = 'Submitter';
    
    
    // PICKLIST VALUES OF QUESTION WARNING
    public static final String ADVICE_APPLIED = 'Advice Applied';
    public static final String RAISE_EXCEPTION = 'Raise Exception';
    public static final String EXCEPTION_RAISED = 'Exception Raised';
    public static final String EXCEPTION_APPROVED = 'Exception Approved';
    public static final String REVIEW_GROUP_ENGAGED = 'Review Group Engaged'; 
    public static final String CONFIRM_CHANGES = 'Confirm Changes'; 
    public static final String RESOLVED = 'Resolved'; 
    public static final String WILL_REVIEW_AND_AMEND = 'Will Review And Amend';
    public static final String I_WILL_REVIEW_AND_AMEND = 'I will review and amend';
    
    //Picklist values for Answer
    public static Final String NOT_REQUIRED = 'Not Required';
    
    //Profile Names
    public static Final String CAMPAIGN_REVIEWER = 'iMH Campaign Reviewer';
    
    //Picklist values for Approval Stage of Campaign/Commmunication
    public static Final String READY_FOR_EXECUTION = 'Ready for Execution';
    public static Final String CONCEPT = 'Concept';
    public static Final String CREATIVE = 'Creative';
    public static final String PRE_EXECUTION = 'Pre-Execution Testing';
    public static final String POST_EXECUTION = 'Post Execution';
    
    //Picklist value for Status in SLA tracker
    public static Final String PENDING = 'Pending';
    public static Final String APPROVED = 'Approved';
    public static Final String APPROVEDWITHCOMMENTS = 'Approved with Comments';
    public static Final String APPROVEDWITHCONDITION = 'Approved with Conditions';
    public static Final String APPROVEDWITHCHANGES = 'Approved with Changes';
    public static Final String PENDINGAPPROVAL = 'Pending Approval – Changes/Information Required';
     public static Final String RECALLEDREJECTION ='Recalled (Rejection)';
    public static final String RECALLSUBMITTER    = 'Recalled (Submitter)';
    public static final String PAUSE_APPROVAL_API_NAME  = 'PauseApproval__c';
    
    //Record Type of SLA Tracker
    public static Final String STAGE = 'Stage';
    public static Final String REVIEWER_TRACKER = 'Reviewer';
    
    // Record Type For SLA Matrix Record
    public static Final String STAGE_SLAMAT = 'Stage';
    public static Final String CENTRAL_STAGE = 'CentralStage';
    public static Final String REVIEWER = 'Reviewer';
    public static Final String CENTRAL_REVIEWER = 'CentralReviewer';
    
    public static final String CAMPAIGN_APP_STG_PREEXECUTING = 'Pre-Execution Testing';
    public static final String CAMPAIGN_INPROGRESS = 'In Progress';
    public static final String CAMPAIGN_CAN_STATUS = 'Cancelled';
    public static final String CAMPAIGN_LIFECYCLE_STAGE = 'Design';
    public static final String CAMPAIGN_LIFECYCLE_EXE_STAGE = 'Execute';
    public static final String CAMPAIGN_LIFECYCLE_PLAN_STAGE = 'Plan';
    public static final String CAMPAIGN_APP_REQ_STATUS = 'Approved';
    public static final String CAMPAIGN_RECALLED_REQ_STATUS = 'Recalled';
    public static final String COM_INREVIEW_REQ_STATUS = 'In Review';
    public static final String COM_READYFORREVIEW_REQ_STATUS = 'Ready For Review';
    public static final String COM_INPRO_FOL_REJ_REQ_STATUS = 'In Progress (following rejection/recalled)';
    //Picklist values for Communication Review Stage
    public static final String COM_REV_STAGE_ATTESTATION     = 'Attestation';
    public static final String COM_REV_STAGE_CENTRALBRAND    = 'Central Brand';
    public static final String COM_REV_STAGE_COMPLETE        = 'Complete';
    public static final String COM_REV_STAGE_DESIGN          = 'Design';
    public static final String COM_REV_STAGE_LEADERSHIP      = 'Leadership';
    public static final String COM_REV_STAGE_LOCAL           = 'Local';
    public static final String COM_REV_STAGE_OFFER_GOV       = 'Offer Governance';
    public static final String COM_REV_STAGE_PROVIDELATEST   = 'Provide latest updates';
    //Picklist value for Benefit Approval Stage
    public static final String BENE_READYFORREVIEW_APP_STAGE = 'Ready For Review';
    //Picklist Value for Offer Status
    public static final String OFFER_EXP_STATUS = 'Expired';
    public static final String OFFER_CAN_STATUS = 'Cancelled';
    public static final String OFFER_Appr_STATUS = 'Approved';
    public static final String OFFER_READYFOR_REVIEW_STATUS = 'Ready For Review';
    
    //Picklist Value for Creative Status
    public static final String CREATIVE_EXP_STATUS = 'Expired';
    public static final String CREATIVE_CAN_STATUS = 'Cancelled';
    public static final String CREATIVE_Appr_STATUS = 'Approved';
    public static final String CREATIVE_READYFOR_REVIEW_STATUS = 'Ready For Review';
    
    //API NAME CONSTANTS NEW
    public static final String COMMUNICATION_OBJECT_API = 'IMH_Communication__c';
    public static final String COMMUNICATION_REF_FIELD = 'Communication__c';
    public static final String COMMUNICATION_ID_REF_FIELD = 'Communication_Id__c';
    public static final String INCENTIVE_OBJECT_API = 'IMH_Incentive__c';
    public static final String COMMCREATIVE_OBJECT_API = 'IMH_CommCreative__c';
    public static final String PRODUCT_API = 'IMH_Product__c';
    public static final String CHANNEL_API = 'IMH_ChannelREF__c';
    public static final String BENEFIT_API = 'IMH_Benefits__c';
    public static final String PREAPPROVED_OBJECT_API = 'IMH_PreApprovedBenefits__c';
    public static final String TARGETEDPRODUCT_OBJECT_API = 'IMH_CreativeProduct__c';
    public static final String TARGETEDCHANNEL_OBJECT_API = 'IMH_CreativeChannel__c';
    public static final String TARGETEDCOMMPRODUCT_OBJECT_API = 'IMH_CommProducts__c';
    public static final String TARGETEDCOMMCHANNEL_OBJECT_API = 'IMH_CommChannels__c';
    
    //RECORD TYPE DEVELOPER NAMES
    public static final String QUESTIONSET_CHILD_RT_DEVNAME = 'Child';
    
    //ANSWER WARNING PICKLIST VALUES
    public static final String FILE_EVIDENCE_ATTACHMENT = 'File evidence to be attached';
        
    //INNER QUERY CONSTANTS FOR ENTRY CHECK
    public static Final String INNER_QUERY_INCENTIVE = '(SELECT IncentiveSubType__c, ProcessPlatformToFulfilIncentive_ANZ__c,IncentiveType__c,ConstructFulfilmentType__c, ConstructType__c,SYS_IsDurationBeyond6Months__c,Merchant_Fulfillment_Detail__c,MultiMerchantIncentive__c From Incentives__r Where (IncentiveStatus__c != \'Cancelled\' OR  IncentiveStatus__c != \'Expired\'))';
    public static Final String INNER_QUERY_CREATIVE = '(SELECT IMH_RequiredProductOwnerEngagement__c From Creative__r Where CreativeStatus__C != \'Cancelled\' OR CreativeStatus__c != \'Expired\')';
    public static Final String INNER_QUERY_PRE_APPROVED = '(SELECT  SYS_CommunicationRegion__c From PreApprovedBenefits__r)';
    
    
    //POST RELEASE 1.3 
    //PICLIST VALUES FOR ANSWER SET STATUS
    public static final String ANS_SET_COMPLETED = 'Completed';
    
    //CALCULATE OPEN ANSWERSET API NAMES
    public static final String OPEN_ANSSET_CONCEPT = 'SYSOpenAnswerSetsForConcept__c';
    public static final String OPEN_ANSSET_CREATIVE = 'SYSOpenAnswerSetsForCreative__c';
    public static final String OPEN_ANSSET_PREEXECUTION = 'SYSOpenAnswerSetsForPreExecution__c';
    public static final String OPEN_ANSSET_READYFOREXECUTION = 'SYSOpenAnswerSetsForReadyForExecution__c';
    public static final String OPEN_ANSSET = 'SYSOpenAnswerSets__c';
    
    
    //LABEL NAMES 
    public static final String COMMUNICATION_LABELNAME = 'Communication';
    public static final String INCENTIVE_LABELNAME = 'Incentive';
    public static final String PREAPPROVEDBENEFITS_LABELNAME = 'PreApprovedBenefits';
    public static final String OFFER_LABELNAME = 'Offer';
    public static final String BENEFITS_ENTRY_LABEL = 'Benefits';
    public static final String TARGETED_CHANNEL_LABEL = 'Targeted Channels';
    public static final String TARGETED_PRODUCTS_LABEL = 'Targeted Products';
    public static final String CREATIVE_LABEL = 'Creative';
}