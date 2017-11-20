/**
    * @author Accenture IDC 
    * @date 03/29/2016
    * @group Approval
    * @group-content N/A
    * @description: iMH Release 1.4 (Sprint 33) - Custom Approval Submission Code
*/
public without sharing class IMH_CustomApprovalSubmit {
    private static final String EQUALTO                      = '=';
    private static final String SEMI_COLON                   = ';';
    private static final String WHITESPACE                   = ' ';
    private static final String COMMA                        = ',';
    private static final String OPEN_BRACKET                 = '(';
    private static final String CLOSE_BRACKET                = ')';
    private static final String GREATER_THAN                 = '>';
    private static final String ESCAPE_QUOTES                = '\'';
    private static final String COMMUNICATION                = 'Communication';
    private static final String CREATIVE                     = 'Creative';
    private static final String BENEFIT                      = 'Benefits';
    private static final String BENEFIT_API                  = 'IMH_Benefits__c';
    private static final String INCENTIVE                    = 'Incentive';
    private static final String INCENTIVE_API                = 'IMH_Incentive__c';
    private static final String TARGET_MARKET                = 'TargetMarket__c';
    private static final String TARGETLOCALE                 = 'Locale__c';
    private static final String REGION                       = 'Region__c';
    private static final String SUBMITTER_TEAM               = 'Submitters_Team__c';
    private static final String OWNERID                      = 'OwnerId';
    private static final String COMM_TYPE_API                = 'Communication_Type__c';
    private static final String REQUIRED_APPROVERS           = 'RequiredApprovers__c';
    private static final String MARKET_API                   = 'Market__c';
    private static final String ANSWER_WARNING_API           = 'IMH_AnswerWarning__c';
    private static final String LEADERSHIP                   = 'Leadership';
    private static final String GROUP_QUEUE                  = 'Group';
    private static final String EDIT                         = 'Edit';
    private static final String SEQ_NUMBER                   = 'SequenceNumber__c';
    private static final String THRESHOLD                    = 'Threshold__c';
    private static final String PRIORITY                     = 'Priority__c';
    private static final String PROCESS_STAGE                = 'ProcessStage__c';
    private static final String REVIEW_STAGE                 = 'ReviewStage__c';
    private static final String REVIEW_STATUS                = 'ReviewStatus__c';
    private static final String DESIGN                       = 'Design';
    private static final String INPROGRESS                   = 'In Progress';
    private static final String CREATIVE_STAGE               = 'CreativeStage__c';
    private static final String CREATIVE_STATUS              = 'CreativeStatus__c';
    private static final String SYS_FINALCREATIVECREATED     = 'SYS_IsFinalCreativeCreated__c';
    private static final String APPROVAL_GROUP               = 'Approval_Group__c';
    private static final String STATUS_API                   = 'Status__c';
    private static final String PENDING                      = 'Pending';
    private static final String PENDING_CHANGE_REQ           = 'Pending Approval – Changes Required';
    //M.Wheeler - 17.10.2016 - R1.7 - US566199 - ID 58237430541
    private static final String SUBMITTER_IN_GROUP           = 'Submitter in Review Group';
    //END CHANGE - M.Wheeler
    private static final String RECORDTYPEID                 = 'RecordTypeId';
    private static final String STARTED_DATE                 = 'Started__c';
    private static final String BENEFIT_STAGE                = 'BenefitStage__c';
    private static final String APPROVAL_STAGE               = 'ApprovalStage__c';
    private static final String COMM_FIELD_API               = 'Communication__c';
    private static final String CREATIVE_FIELD_API           = 'Creative__c';
    private static final String BENEFIT_FIELD_API            = 'Benefits__c';
    private static final String IN_REVIEW                    = 'In Review';
    private static final String FINAL_CREATIVE               = 'Final Creative';
    private static final String COMMUNICATION_R              = 'Communication__r';
    private static final String SYS_OWNER                    = 'SYS_Owner__c';
    private static final String IMH_PRETEXT                  = 'IMH_';
    private static final String APPROVAL_VALUE               = 'Approval';
    private static final String QUEUE                        = 'Queue';
    private static final String SELECT_TEXT                  = 'SELECT';
    private static final String ID_API                       = 'Id,RequestTypeLevel__c';
    private static final String NAME_API                     = 'Name';
    private static final String OBJECT_API                   = 'Object__c';
    private static final String OWNER_API                    = 'Owner__c';
    private static final String SEQUENCE_API                 = 'Sequence__c';
    private static final String APPROVALTYPE_API             = 'SYS_ApprovalType__c';
    private static final String REQUIRED_APPROVER_LEVEL      = 'Required_Approver_Level__c';
    private static final String COMMUNICATION_COMPONENTS     = 'Communication_Components__c';
    private static final String REQUIRED_MANDATORY_APPROVER  = 'RequiredMandatory_Approver__c';
    private static final String MANDATORY_API                = 'Mandatory__c';
    private static final String USER_TEAM_API                = 'User_Team__c';
    private static final String FROM_TEXT                    = 'FROM';
    private static final String SLA_MATRIX_API               = 'IMH_StepApprovalGroup__c';
    private static final String SLA_TRACKER_API              = 'IMH_SLATracker__c';    
    private static final String WHERE_TEXT                   = 'WHERE';
    private static final String ACTIVE_API                   = 'Active__c';
    private static final String BOOLEAN_TRUE                 = 'True';
    private static final String INCLUDES_TEXT                = 'INCLUDES';
    private static final String ORDER_BY                     = 'ORDER BY';
    private static final String AND_TEXT                     = 'AND';
    private static final String SLA_REL                      = 'SLAs__r';
    private static final String ACCEPTED                     = 'Accepted';
    private static final String COMPLETE                     = 'Complete';
    private static final String SUBMITTER                    = 'Submitter__c';
    private static final String SYSDELEGATEDAPPROVER         = 'SYSDelegatedApprover__c';
    private static final String SYSRESTRICNOTIFICATION       = 'SYS_RestrictEmailNotification__c';
    private static final String SYS_ISPRODUCTREVIEW          = 'SYS_IsProductOwnerApproval__c';
    private static final String BENEFITLOCALE                = 'Benefit_Locale__c';
    private static final String BENEFITREGION                = 'Region__c';
    private static final String REGIONALVALUE                = 'Regional';
    private static final String PRODUCTVALUE                 = 'Product';
    private static final String SYS_VALIDATION               = 'SYS_Validation__c';
    private static final String LOCALOFFRGOVERNANCE          = 'Local Offer Governance';
    private static final String LOCALOFFERGOVERNANCEIN       = 'Local Offer Governance (IN)';
    private static final String CENTRALOFFERGOVERNANCE       = 'Central Offer Governance';
    private static final String ONEINDIA                     = 'ONE India';
    private static final String REVIEWAPPROVASLATYPE_API     = 'ReviewApprovalSLAType__c';
    private static final String DIRECTORVALE                 = 'Director';
    private static final String INCENTIVESTATUS_API          = 'IncentiveStatus__c';
    private static final String INCENTIVESTAGE_API           = 'IncentiveStage__c';
    private static final String INCENTIVEAPPROVEDCALUE       = 'Approved';
    private static final String REVIEWAPPORVED               = 'Review & Approval';
    private static final String COMMCREATIVE_API             = 'CommCreative__c';
    private static final String INCENTIVE_APIVALUE           = 'Incentive__c';
    private static final String SYSNACINSURANCE_API          = 'SYS_ISNACInsurance__c';
    private static final String SYS_DIRECTOR_API             = 'SYS_Director__c';
    private static final String APPROVAL_MATRIX_API          = 'Approval_Matrix__c';
    private static final String GCOQUEUENAME                 = 'IMH_GCO_CA';
    private static final String BAND40                       = 'Band 40';
    private static final String COMPLIANCEQUEUENAME          = 'IMH_Compliance_CA';
    private static final String NACINSURANCE                 =  'NAC Insurance';
    private static final String SUBMISSION_IN_ERROR          = 'Submission Received in Error';
    private static final String FORWARDED_FOR_EXT_REVIEW     = 'Forwarded for External Review';
    private static final String IMH_B35INS_UK                = 'IMH_B35Ins_UK';
    private static final String IMH_B40INS_UK                = 'IMH_B40Ins_UK';
    private static final String B35_INS_UK                   = 'B35 Ins (UK)';
    private static final String B40_INS_UK                   = 'B40 Ins (UK)';
    private static final String SYSCHATTERGROUP_API          = 'SYS_ChatterGroupId__c';
    private static final String EXCEPTIONRAISED_API          = 'ExceptionRaised__c';
    private static final String IMHCENTRALOFFERGOVERNANCE = 'IMH_CentralOfferGovernance';
    private static final String IMHLOCALOFFERGOVERNANCE  = 'IMH_LocalOfferGovernance';
    private static final String APPROVAL_THRESHOLD           = 'SYS_Threshold__c';
    private static final String APPROVER_API = 'Approver__c';
    //M.Wheeler - 19.10.2016 - R1.7 - US695151 - ID 29731578165
    private static List<IMH_ApprovalGroup__c> approvalGroups = new List<IMH_ApprovalGroup__c>();
    //END CHANGE M.Wheeler
    
     
    /**
    * @description  - Method to create approval record based on approval process details and submitter record. Following functionality is included
    * SLA is determined
    * Approval has been shared to Delegated Approval
    * Send email notificatio for delegated approvers
    * Colloboration group Id is stamped against approval
    * @param  - Submitted Record Id
    * @return  - null
    */
    
    public static void workOnSubmittedRecord(Id selectedrecordId){
        //TODO : CLEAR OUT ALL UNWANTED VARIABLES
        sObject submittedRecord;
        String selectedSObject = IMH_UtilityConstants.EMPTY_STRING;
        String selectedSObjectAPI = IMH_UtilityConstants.EMPTY_STRING;
		if(selectedrecordId.getSobjectType() == Schema.IMH_Communication__c.SObjectType) {
	        selectedSObject = COMMUNICATION;
	        selectedSObjectAPI = IMH_UtilityConstants.COMMUNICATION_OBJECT_API;
	    }
	    else if(selectedrecordId.getSobjectType() == Schema.IMH_CommCreative__c.SObjectType) {
	       selectedSObject = CREATIVE;
	       selectedSObjectAPI = IMH_UtilityConstants.COMMCREATIVE_OBJECT_API;
	    }
	    else if(selectedrecordId.getSobjectType() == Schema.IMH_Benefits__c.SObjectType) {
	       selectedSObject = BENEFIT;
	       selectedSObjectAPI = BENEFIT_API;
	    }
	    String componentUnEscapedString = IMH_UtilityConstants.EMPTY_STRING;
        Integer sequenceNumber = 0;
        String targetMarket = IMH_UtilityConstants.EMPTY_STRING;
        String requestType = IMH_UtilityConstants.EMPTY_STRING;//Communication/Benefit Request Type
        String creativeRequestType = IMH_UtilityConstants.EMPTY_STRING;//Creative Request Type
        String userTeam;
        String exceptionApprover = IMH_UtilityConstants.EMPTY_STRING;
        String targetRegion=IMH_UtilityConstants.EMPTY_STRING;
        String locale=IMH_UtilityConstants.EMPTY_STRING;
        String approvalStage = IMH_UtilityConstants.EMPTY_STRING;
        String relatedCommRecord = IMH_UtilityConstants.EMPTY_STRING;
        
        //Stamping threshold
        Integer thresholdhrs = 0;
        Id submittedRecOwnerId;
        
        List<String> communicationComponents        = new List<String>();
        List<String> communicationReqApprovers      = new List<String>();
        List<String> creativeReqApprovers           = new List<String>();
        List<String> benefitReqApprovers            = new List<String>();
        List<String> benefitMarkets                 = new List<String>();
        List<IMH_SLATracker__c> relatedTrackerList  = new List<IMH_SLATracker__c>();
        List<IMH_AnswerWarning__c> lAnswerWarning   = new List<IMH_AnswerWarning__c>();
        
        // PEER REVIEW - WE DON'T REQUIRE WHERE CLAUSE CHECK ON COMMUNICATION ID IN INNER QUERY
        if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(selectedSObjectAPI)) {
            //COMMENTS : RETRIEVE THE COMMUNICATION RELATED FIELDS WHICH DRIVES THE APPROVAL ENGAGEMENT
            submittedRecord = [SELECT Id, Name, ReviewApprovalSLAType__c, SequenceNumber__c, Submitters_Team__c, 
                               ReviewStage__c, SYS_ReadyForReview_New__c, SYS_IsUnderComplianceReview__c, TargetMarket__c, Communication_Type__c, 
                               ReviewStatus__c, ProcessStage__c, RequiredApprovers__c, OwnerId,SYS_RestrictEmailNotification__c,
                               (SELECT Id, Status__c, Communication__c FROM SLAs__r 
                               WHERE Status__c =: PENDING OR Status__c=: PENDING_CHANGE_REQ) 
                               FROM IMH_Communication__c WHERE Id =: selectedrecordId LIMIT 1];
            //COMMENTS : RETRIEVE THE ANSWER WARNINGS IF THERE ARE ANY EXCEPTION RAISED. THIS IS APPLICABLE ONLY FOR CONCEPT STAGE
            lAnswerWarning = [SELECT Id FROM IMH_AnswerWarning__c WHERE ((Answer__r.AnswerSet__r.Communication__c = : submittedRecord.Id
                                                            AND  Answer__r.AnswerSet__r.SYS_CommunicaitonQuestionSetType__c = :IMH_UtilityConstants.CONCEPT) OR Answer__r.AnswerSet__r.Benefits__c = : submittedRecord.Id)
                                                            AND Status__c = :IMH_UtilityConstants.RAISE_EXCEPTION];
            relatedCommRecord   = (String)submittedRecord.get('Id');
            targetMarket         = (String)submittedRecord.get(TARGET_MARKET);
            //ADDED THE LOGIC TO ENGAGE CENTRAL OFFER GOVERNANCE IF THERE ARE 
            //NO OFFER GOVERNANCE GROUP STAMPED TTHROUGH QUESTIONNAIRE (EXISTING OFFER CONSTRUCT TYPE)
            if(!lAnswerWarning.isEmpty() && (submittedRecord.get(REQUIRED_APPROVERS)==NULL 
                                             || !String.valueOf(submittedRecord.get(REQUIRED_APPROVERS)).containsIgnoreCase(LOCALOFFRGOVERNANCE)
                                                    || !String.valueOf(submittedRecord.get(REQUIRED_APPROVERS)).containsIgnoreCase(CENTRALOFFERGOVERNANCE))){
                
                if(ONEINDIA.equalsIgnoreCase(targetMarket)){
                    exceptionApprover = LOCALOFFRGOVERNANCE;
                 }else{
                    exceptionApprover  = CENTRALOFFERGOVERNANCE;
                }
                if(submittedRecord.get(REQUIRED_APPROVERS)!=null){
                   exceptionApprover = String.valueOf(submittedRecord.get(REQUIRED_APPROVERS)) +IMH_UtilityConstants.SEMI_COLON+ exceptionApprover;
                   submittedRecord.put(REQUIRED_APPROVERS, exceptionApprover);
                }else{
                    submittedRecord.put(REQUIRED_APPROVERS, exceptionApprover);
                }                                                
            }
            //TODO : MOVE THE COMMON ASSIGNMENTS OUT OF THE LOOP REGARDLESS OF THE OBJECT TYPE
            relatedTrackerList  = submittedRecord.getsobjects(SLA_REL);
            sequenceNumber      = Integer.valueOf(submittedRecord.get(SEQ_NUMBER));
           
            requestType       = (String)submittedRecord.get(REVIEWAPPROVASLATYPE_API);
            userTeam            = (String)submittedRecord.get(SUBMITTER_TEAM);
            submittedRecOwnerId = (String)submittedRecord.get(OWNERID);
            componentUnEscapedString = getUnescapedStrings(submittedRecord.get(COMM_TYPE_API));
            //componentUnEscapedString = getUnescapedStrings(submittedRecord.getsobject(COMMUNICATION_R).get(COMM_TYPE_API));
            if(String.isNotBlank(String.valueOf(submittedRecord.get(REQUIRED_APPROVERS)))) {
                communicationReqApprovers = String.valueOf(submittedRecord.get(REQUIRED_APPROVERS)).split(SEMI_COLON);
            }
        }
        else if(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API.equalsIgnoreCase(selectedSObjectAPI)) {
            //COMMENTS : RETRIEVE THE CREATIVE RELATED FIELDS WHICH DRIVES THE APPROVAL ENGAGEMENT
            submittedRecord    = [SELECT Id, SequenceNumber__c, Communication__c, SYS_Owner__c, RequiredApprovers__c,
                                  Communication__r.TargetMarket__c, Communication__r.Communication_Type__c,Communication__r.OwnerId,
                                  Communication__r.Submitters_Team__c, Communication__r.RequiredApprovers__c,
                                  Communication__r.ReviewApprovalSLAType__c,Communication__r.SYS_Validation__c,
                                  ReviewApprovalSLAType__c, CreativeStatus__c,PostFinalCreativeNotificationReviewer__c,
                                  (SELECT Id, Status__c, CommCreative__c FROM SLAs__r WHERE (Status__c =: PENDING OR Status__c=: PENDING_CHANGE_REQ))
                                  FROM IMH_CommCreative__c WHERE Id =: selectedrecordId LIMIT 1];
            //TODO : MOVE THE COMMON ASSIGNMENTS OUT OF THE LOOP REGARDLESS OF THE OBJECT TYPE                                  
            relatedCommRecord   = (String)submittedRecord.get('Communication__c');
            relatedTrackerList  = submittedRecord.getsobjects(SLA_REL);
            sequenceNumber      = Integer.valueOf(submittedRecord.get(SEQ_NUMBER));
            submittedRecOwnerId = (String)submittedRecord.get(SYS_OWNER);
            targetMarket        = (String)submittedRecord.getsobject(COMMUNICATION_R).get(TARGET_MARKET);
            userTeam            = (String)submittedRecord.getsobject(COMMUNICATION_R).get(SUBMITTER_TEAM);
            requestType         = (String)submittedRecord.getsobject(COMMUNICATION_R).get(REVIEWAPPROVASLATYPE_API);
            creativeRequestType = (String)submittedRecord.get(REVIEWAPPROVASLATYPE_API);
            
            componentUnEscapedString = getUnescapedStrings(submittedRecord.getsobject(COMMUNICATION_R).get(COMM_TYPE_API));
            if(String.isNotBlank((String)submittedRecord.getsobject(COMMUNICATION_R).get(REQUIRED_APPROVERS))) {
                communicationReqApprovers = String.valueOf(submittedRecord.getsobject(COMMUNICATION_R).get(REQUIRED_APPROVERS)).split(SEMI_COLON);
            }
            //SEPERATE VARIABLE TO CHECK FOR THE CREATIVE APPROVERS IN CASE THE LEVEL IS CREATIVE AT APPROVAL MATRIX LEVEL
            if(String.isNotBlank(String.valueOf(submittedRecord.get(REQUIRED_APPROVERS)))) {
                creativeReqApprovers = String.valueOf(submittedRecord.get(REQUIRED_APPROVERS)).split(SEMI_COLON);
            }
        }
        else if(BENEFIT_API.equalsIgnoreCase(selectedSObjectAPI)) {
            //COMMENTS : RETRIEVE THE BENEFITS RELATED FIELDS WHICH DRIVES THE APPROVAL ENGAGEMENT
            submittedRecord    = [SELECT Id, SequenceNumber__c, OwnerId, RequiredApprovers__c, Market__c,Submitters_Team__c,ReviewApprovalSLAType__c,   
                                   Benefit_Locale__c,Region__c,
                                  (SELECT Id, Status__c, Benefits__c FROM SLAs__r
                                  WHERE (Status__c =: PENDING OR Status__c=: PENDING_CHANGE_REQ)) 
                                  FROM IMH_Benefits__c WHERE Id =: selectedrecordId LIMIT 1];
            //TODO : MOVE THE COMMON ASSIGNMENTS OUT OF THE LOOP REGARDLESS OF THE OBJECT TYPE                                     
            relatedTrackerList = submittedRecord.getsobjects(SLA_REL);
            sequenceNumber = Integer.valueOf(submittedRecord.get(SEQ_NUMBER));
            submittedRecOwnerId = (String)submittedRecord.get(OWNERID);
            userTeam = (String)submittedRecord.get(SUBMITTER_TEAM);
            requestType = (String)submittedRecord.get(REVIEWAPPROVASLATYPE_API);
            targetRegion = (String)submittedRecord.get(BENEFITREGION);
            locale = (String)submittedRecord.get(BENEFITLOCALE);
            //TODO : MAKE THE REQUIRED APPROVERS AS COMMON ACROSS THE DIFFERENT OBJECT TYPE 
            //NAMING CONVNETION SHOULD BE SAME ACROSS THE OBJECT WHICH UTILIZES THE APPROVAL
            if(String.isNotBlank(String.valueOf(submittedRecord.get(REQUIRED_APPROVERS)))) {
                benefitReqApprovers = String.valueOf(submittedRecord.get(REQUIRED_APPROVERS)).split(SEMI_COLON);
            }
            targetMarket = getUnescapedStrings(submittedRecord.get(MARKET_API));
            
        }
        if(relatedTrackerList == null) {
            // TODO - CANNOT WE INTITIATE THE SET AT THE BEGINNING AND ASSIGN THE VALUES FROM REQUIRED APPROVERS DIRECTLY TO SET
            //RELEASE 1.8  - APPROVAL DATA MODEL CHANGE
            Map<String,Id> groupMatrixRecordMap = new Map<String,Id>(); 
            Map<Integer,IMH_ApprovalStep__c> approvalStepMapBySequence = new Map<Integer,IMH_ApprovalStep__c>();
            String targetMarketCondition = '';
            if(!'Regional'.equalsIgnoreCase(locale)){
                targetMarketCondition = ' Market__c INCLUDES (\'' + targetMarket + '\') AND ';
            }
            String approvalProcessQuery = 'SELECT Id FROM IMH_ApprovalProcess__c WHERE '+ targetMarketCondition +'Object__c = :selectedSObjectAPI AND UserTeam__c = :userTeam AND Region__c = :targetRegion AND Locale__c = :Locale AND Active__c = TRUE ORDER BY LastModifiedDate DESC LIMIT 1';
            List<IMH_ApprovalProcess__c> listApprovalProcess = Database.query(approvalProcessQuery);
            system.debug('---->>>> List Of approval process +'+listApprovalProcess);
            IMH_ApprovalStep__c currentApprovalStep = null;
            Map<Id,IMH_StepApprovalGroup__c> stepApprovalsByApprovalGroupId = new Map<Id,IMH_StepApprovalGroup__c>();
            String approvalStepQuery = 'SELECT Id,Name,Sequence__c,(SELECT Id,RequestTypeLevel__c,Approval_Group__r.QueueAPI__c,';
            approvalStepQuery+= 'Approval_Group__r.RequiredMandatoryApprover__c,';
            approvalStepQuery+= 'Required_Approver_Level__c,Communication_Components__c,Approval_Group__c,Mandatory__c FROM StepApprovalGroups__r ';
            approvalStepQuery+= 'WHERE (Active__c = TRUE ';
            approvalStepQuery+= 'AND (Mandatory__c = TRUE ';
            approvalStepQuery+= 'OR (Required_Approver_Level__c=NULL AND Communication_Components__c = NULL) ';
            approvalStepQuery+= 'OR (Required_Approver_Level__c=NULL AND Communication_Components__c !=NULL AND Communication_Components__c INCLUDES (\''+componentUnEscapedString+'\')) ';
            approvalStepQuery+= 'OR (Required_Approver_Level__c!=NULL AND Communication_Components__c = NULL ';
            approvalStepQuery+= 'AND ((Required_Approver_Level__c = \'Communication__c\' AND Approval_Group__r.RequiredMandatoryApprover__c IN :communicationReqApprovers) '; 
            approvalStepQuery+= 'OR (Required_Approver_Level__c = \'Creative__c\' AND Approval_Group__r.RequiredMandatoryApprover__c IN :creativeReqApprovers) ';
            approvalStepQuery+= 'OR (Required_Approver_Level__c = \'Benefits__c\' AND Approval_Group__r.RequiredMandatoryApprover__c IN :benefitReqApprovers))) ';
            approvalStepQuery+= 'OR (Required_Approver_Level__c!=NULL AND Communication_Components__c !=NULL AND Communication_Components__c INCLUDES (\''+componentUnEscapedString +'\') ';
            approvalStepQuery+= 'AND ((Required_Approver_Level__c = \'Communication__c\' AND Approval_Group__r.RequiredMandatoryApprover__c IN :communicationReqApprovers) '; 
            approvalStepQuery+= 'OR (Required_Approver_Level__c = \'Creative__c\' AND Approval_Group__r.RequiredMandatoryApprover__c IN :creativeReqApprovers) ';
            approvalStepQuery+= 'OR (Required_Approver_Level__c = \'Benefits__c\' AND Approval_Group__r.RequiredMandatoryApprover__c IN :benefitReqApprovers))) ';
            approvalStepQuery+= '))) ';
            approvalStepQuery+= 'FROM IMH_ApprovalStep__c '; 
            approvalStepQuery+= 'WHERE ApprovalProcess__c IN :listApprovalProcess '; 
            approvalStepQuery+= 'AND Sequence__c > :sequenceNumber ORDER BY Sequence__c ';
            
            system.debug('-->>>>'+approvalStepQuery);
            
            for(IMH_ApprovalStep__c appProcessStep : (List<IMH_ApprovalStep__c>)Database.query(approvalStepQuery)){
				if(!appProcessStep.StepApprovalGroups__r.isEmpty()){
					currentApprovalStep = appProcessStep;
					for(IMH_StepApprovalGroup__c appStepGroup : appProcessStep.StepApprovalGroups__r){
						stepApprovalsByApprovalGroupId.put(appStepGroup.Approval_Group__c,appStepGroup);
						groupMatrixRecordMap.put(appStepGroup.Approval_Group__r.QueueAPI__c,appStepGroup.Id);
					}
                    break;
				}            												
            }
            Map<String,Integer> groupthresholdmap = new Map<String,Integer>();
            String approverGroups = IMH_UtilityConstants.EMPTY_STRING;
            Integer currentSequence = sequenceNumber;
            Integer leadershipSeqNo = sequenceNumber;
            List<String> matrixCommunicationComp ;
            Integer threholdTime = 0;
            Integer newSequenceNumber = 0;            
            String tempRequestType = '';
            Set<Id> tempSet = new Set<Id>();
            tempSet.addAll(stepApprovalsByApprovalGroupId.keySet());
            // RETRIEVE THE APPROVAL GROUPS TO SET THE SLA'S FOR THE RESPECTIVE GROUPS BASED ON PRIORITY
            //M.Wheeler - 19.10.2016 - R1.7 - US695151 - ID 29731578165
            String approvalGroupQueryStr = 'SELECT Id,QueueAPI__c,SendPostFinalCreaitveNotification__c,IMH_AutoApproveReviewGroup__c,';
            	   approvalGroupQueryStr += '(SELECT Id,SLAThreshold__c,Priority__c,RequestTypeLevel__c,Default__c FROM ApprovalPriorities__r';
                   approvalGroupQueryStr += ' WHERE Stage__c = : selectedSObject  AND (Priority__c = : requestType ';
                   approvalGroupQueryStr += ' OR Priority__c = : creativeRequestType) AND (Default__c = \'Yes\' OR Market__c INCLUDES (\'' + targetMarket + '\')) ORDER BY Default__c DESC)';
                   approvalGroupQueryStr += ' FROM IMH_ApprovalGroup__c WHERE Id IN : tempSet';
            
            //M.Wheeler - 19.10.2016 - R1.7 - US695151 - ID 29731578165
            approvalGroups = Database.query(approvalGroupQueryStr);
            
            for(IMH_ApprovalGroup__c appGroup : approvalGroups){
                //END CHANGE M.Wheeler
                    tempRequestType = '';                                                            
                    for(IMH_ApprovalGroupSLA__c appSLA : appGroup.ApprovalPriorities__r){
                        // CHECK IF WE NEED TO LOOK REQUEST TYPE AT CREATIVE LEVEL
                        if('Creative'.equalsIgnoreCase(stepApprovalsByApprovalGroupId.get(appGroup.Id).RequestTypeLevel__c)){
                            tempRequestType = creativeRequestType;
                        }
                        else{
                             tempRequestType = requestType;
                        }
                        if(tempRequestType.equalsIgnoreCase(appSLA.Priority__c)){
                            groupthresholdmap.put(appGroup.QueueAPI__c,(Integer)appSLA.SLAThreshold__c);
                            break;
                        }
                    }
            }
            
            //PASS THE REQUIRED PARAMATERS TO CREATE THE APRPOVAL RECORDS
            if(currentApprovalStep!=NULL) {
                createApprovalTracker(submittedRecord,
                                      selectedSObjectAPI,
                                      currentApprovalStep,
                                      submittedRecOwnerId,
                                      groupthresholdmap,
                                      groupMatrixRecordMap,
                                      lAnswerWarning,
                                      targetMarket,
                                      relatedCommRecord);

            }
            //UPDATE THE SUBMITTED RECORD TO THE FINAL LEVEL IF THERE ARE NO MATCHES
            else {
                Boolean isfinalStage = false;
                submittedRecord.put(SEQ_NUMBER,0);
                List<SObject> lsObjectToUpdate;
                if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(selectedSObjectAPI)) {
                    //COMMUNICATION TO BE SET TO CREATIVE DESIGN AND STATUS AS INPROGRESS
                    submittedRecord.put(PROCESS_STAGE,CREATIVE);
                    submittedRecord.put(REVIEW_STAGE,DESIGN);
                    submittedRecord.put(REVIEW_STATUS,INPROGRESS);
                    submittedRecord.put(SYSRESTRICNOTIFICATION,true);
                    isfinalStage = true;
                 }
                else if (IMH_UtilityConstants.COMMCREATIVE_OBJECT_API.equalsIgnoreCase(selectedSObjectAPI)) {
                     //CREATIVE TO BE SET TO FINAL CREATIVE AND STATUS AS INPROGRESS
                    submittedRecord.put(CREATIVE_STAGE,FINAL_CREATIVE);
                    submittedRecord.put(CREATIVE_STATUS,INPROGRESS); 
                    submittedRecord.put(SYS_FINALCREATIVECREATED,true); 
                    isfinalStage = true;
                }
                else if (BENEFIT_API.equalsIgnoreCase(selectedSObjectAPI)) {
                     //MAKE THE BENEFTIS TO COMPLETE AND ACCEPTED
                    submittedRecord.put(BENEFIT_STAGE,COMPLETE); 
                    submittedRecord.put(APPROVAL_STAGE,ACCEPTED);
                    isfinalStage = true;
                }
                //UPDATE ALL APPROVAL RECORDS TO SET THE SYS NOTIFICATION TO N/A TO DIFFERENTITATE THE SEQUENCE 
	            lsObjectToUpdate = new List<SObject>();
                for(IMH_SLATracker__c slatrack: [SELECT Id,Status__c,
                                                           SYS_SendNotifications__c
                                                    FROM IMH_SLATracker__c
                                                    WHERE (Communication__c =:submittedRecord.ID
                                                           OR CommCreative__c =:submittedRecord.ID
                                                           OR Benefits__c =:submittedRecord.ID
                                                           OR Incentive__c =:submittedRecord.ID)
                                                   AND (Status__c = :IMH_UtilityConstants.APPROVED 
                                                        OR Status__c = :IMH_UtilityConstants.APPROVEDWITHCOMMENTS
                                                        OR Status__c = :IMH_UtilityConstants.APPROVEDWITHCONDITION
                                                        OR Status__c = :IMH_UtilityConstants.APPROVEDWITHCHANGES
                                                        OR Status__c = :SUBMISSION_IN_ERROR
                                                        OR Status__c = :FORWARDED_FOR_EXT_REVIEW)
                                                    AND SYS_SendNotifications__c = :IMH_UtilityConstants.NONE]){
                   slatrack.SYS_SendNotifications__c =  IMH_UtilityConstants.NOT_APPLICABLE; 
                   lsObjectToUpdate.add(slatrack);                                 
                }
            	lsObjectToUpdate.add(submittedRecord);
	            if(!lsObjectToUpdate.isEmpty()){
	              //TODO - USE EXCEPTIONAL FRAMEWORK
	              Database.update(lsObjectToUpdate,true);
	            }
            }
            
        }
    }

    /**
    * @description  - Method to Geneate the approval record from data on Matrix
    * -	Reviewer to Auto follow/unfollow the approval record
    * -	Create the share record for the delegated approver
    * -	Moves the submitted record to different stages
    * @param  - Submitter Record, APi Name of Submitted Object,current Approval Step,submittedRecordOwnerId,Threshold Map,Step approval Group Map,Exception list,Target maret,Related Communication Record
    * @return  - void
    */
    public static void createApprovalTracker(Sobject submittedRecord,
                                             String objectName,
                                             IMH_ApprovalStep__c currentApprovalStep,
                                             Id submittedRecOwnerId,
                                             Map<String,Integer> mthresholdTime,
                                             Map<String,Id> groupMatrixRecordMap,
                                             List<IMH_AnswerWarning__c> lAnswerWarning,
                                             String targetMarket,
                                             String relatedCommRecord){
        Boolean isFinalAutoApproval = false;
        Map<IMH_SLATracker__c,Integer> maptrackthreshold = new Map<IMH_SLATracker__c,Integer>(); 
        Boolean isBand35 = false; // To check Group name as Band 35
        Boolean isBand40 = false; // To check Group name as Band 40
        Boolean isCompliance = false; // To check Group name as Compliance
        Map<String,List<Id>> mDelegateApprovers = new Map<String,List<Id>>(); // To store delegated approver of set of users 
        Id appRecordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName =: APPROVAL_VALUE 
                                         AND SobjectType =: SLA_TRACKER_API LIMIT 1].Id;
        List<Sobject> approvalTrackerList = new List<Sobject>();
        List<Sobject> sObjectToUpdate = new List<Sobject>(); 
        //Set that will store the current approval group whose members will follow this submitted record
        //List for Apex Sharing on Approval Tracker record
        List<IMH_SLATracker__Share> lApprovalTrackerShare = new List<IMH_SLATracker__Share>();
        IMH_SLATracker__Share approvalShare;
        Id approvalOwnerId;
        Id delegatedApprover; // Delegated Approver user Id;
        sObject trackerRec;
        Integer thresholdTime = 0;
        //Map of Collabration Group Name and Collabration Group Id
        Map<String,String> mcolabnamecolabId = new Map<String,String>();                                       
        String requestType = IMH_UtilityConstants.EMPTY_STRING;                                                 
        String relatedObjectFieldAPI = objectName.removeStartIgnoreCase(IMH_PRETEXT);
        //STAMP THE REQUEST TYPE TO APPROVAL RECORD                                                  
        if(COMMCREATIVE_API.equalsIgnoreCase(relatedObjectFieldAPI)
                    && submittedRecord.get(REVIEWAPPROVASLATYPE_API)==NULL){
            requestType = (String)submittedRecord.getsobject(COMMUNICATION_R).get(REVIEWAPPROVASLATYPE_API);
        } else {
            requestType = String.valueOf(submittedRecord.get(REVIEWAPPROVASLATYPE_API));
        }
        Map<String,Group> mapQueueByName = new Map<String,Group>();
        //Group/Queue Approval
        
        User recordOwnerDetails = [SELECT Id,IMHDirector__c,Band_CA__c,Manager.Band_CA__c,
                                        ManagerId, Manager.DelegatedApproverId,IMHDirector__r.DelegatedApproverId,Name 
                                                    FROM User Where Id = :submittedRecOwnerId LIMIT 1];
        // CONTRUCT THE MAP OF COLLOBORATION NAME AND COLLOBORATION IDS
        for (CollaborationGroup colabgrp: [Select Id,Name From CollaborationGroup]){
            mcolabnamecolabId.put(colabgrp.Name,colabgrp.Id);  
        }
        
        // CONTRUCT THE MAP OF QUEUE DEVELOPER NAME AND QUEUE FROM THE APPROVAL SET MATCHED
        for(Group approvalGroup :[SELECT Id, Name, DeveloperName, Type 
                                 FROM Group 
                                 WHERE DeveloperName =: groupMatrixRecordMap.keySet() 
                                 AND Type =: QUEUE]) {
            mapQueueByName.put(approvalGroup.DeveloperName,approvalGroup);
        }
                                                 
        //M.Wheeler - 19.10.2016 - R1.7 - US695151 - ID 29731578165
        //NOT SURE WHY WE NEED THIS SINCE IT IS DECLARED AS MEMBER VARIABLE AND ASSIGNMENT IS IN PRIOR METHOD
        /*if(approvalGroups.size() <= 0) {
            approvalGroups = [ SELECT ID, QueueAPI__c,SendPostFinalCreaitveNotification__c, IMH_AutoApproveReviewGroup__c 
                               FROM IMH_ApprovalGroup__c 
                               WHERE QueueAPI__c IN :approvalGroupsSet];                                           
        }*/
        
        Map<String, IMH_ApprovalGroup__c> approvalGroupMap = new Map<String, IMH_ApprovalGroup__c>();                                  
        for(IMH_ApprovalGroup__c ag :approvalGroups) {
            approvalGroupMap.put(ag.QueueAPI__c, ag);
        }
        //M.Wheeler - 17.10.2016 - R1.7 - US566199 - ID 58237430541
        List<Group> recOwnerGroups = [SELECT Id, DeveloperName
                                   FROM Group 
                                   WHERE Id IN(
                                       SELECT GroupId 
                                       FROM GroupMember 
                                       WHERE UserOrGroupId 
                                       = :submittedRecOwnerId
                                        )
                                  ];
       Map<String, Group> recOwnerGroupsMap = new Map<String, Group>();
       for(Group g :recOwnerGroups) {
            recOwnerGroupsMap.put(g.DeveloperName, g);
       }
                                   
        String tempStr = IMH_UtilityConstants.EMPTY_STRING;
        Set<String> postFinalCreativeNotifiers = new Set<String>();
        if(COMMCREATIVE_API.equalsIgnoreCase(relatedObjectFieldAPI) 
                    && submittedRecord.get('PostFinalCreativeNotificationReviewer__c')!=NULL){
           postFinalCreativeNotifiers.addAll((String.valueOf(submittedRecord.get('PostFinalCreativeNotificationReviewer__c'))).split(';'));  
        }                                         
        
        Boolean isSubmitterInGroupReview = false;  
        Boolean isApprovalPending = false;                                                   
        //ITEREATE THE APPROVAL GROUP SET INCLUDING THE LEADERSHIP AND DIRECTOR TO CREATE THE APPROVAL INSTANCE
        for(String approvalGroupName : groupMatrixRecordMap.keySet()){
            //INSTANTIATE THE OBJECT TO CREATE THE RECORD FOR EACH APPROVAL GROUP
            trackerRec = Schema.getGlobalDescribe().get(SLA_TRACKER_API).newSObject();
            if(approvalGroupMap.get(approvalGroupName).SendPostFinalCreaitveNotification__c){
                postFinalCreativeNotifiers.add(approvalGroupName);
            }
           /* if(recOwnerGroupsMap.get(approvalGroupName) != null ) {
                if(approvalGroupMap.get(approvalGroupName).IMH_AutoApproveReviewGroup__c){
                    trackerRec.put(STATUS_API,SUBMITTER_IN_GROUP);
                    isSubmitterInGroupReview = true;
                }
            }*/
            //else {
              //  isApprovalPending = true;
                trackerRec.put(STATUS_API,PENDING);
            //}
            //END CHANGES - M.Wheeler
            // 
            
            trackerRec.put(RECORDTYPEID,appRecordTypeId);
            trackerRec.put(STARTED_DATE,System.Now());
            trackerRec.put(relatedObjectFieldAPI,submittedRecord.Id);
            trackerRec.put(SUBMITTER,submittedRecOwnerId);
            trackerRec.put(APPROVAL_THRESHOLD,mthresholdTime.get(approvalGroupName));
            trackerRec.put(APPROVAL_MATRIX_API,groupMatrixRecordMap.get(approvalGroupName)); 
            
            //CALCULATE THE THRESHOLD FOR THE APPROVAL GROUP
            if(mthresholdTime.get(approvalGroupName) != NULL){
                    IMH_GeneralApplicationUility.calcualteThreshold((IMH_SLATracker__c)trackerRec,mthresholdTime.get(approvalGroupName));                         
            }
            // CHECK IF THE QUEUE EXISTS
            if(mapQueueByName.containsKey(approvalGroupName)){
                //CHECK IF THE APPROVAL GROUP IS BAND 40 OR BAND 35 TO SHARE THE APPROVAL RECORD TO 
                if(IMH_B35INS_UK.equalsIgnoreCase(approvalGroupName) 
                        || IMH_B40INS_UK.equalsIgnoreCase(approvalGroupName)) {
                   tempStr = approvalGroupName;
                }
                if(approvalGroupName.containsIgnoreCase('Compliance')){
                    isCompliance = true;
                }
                trackerRec.put(APPROVAL_GROUP,mapQueueByName.get(approvalGroupName).Name);
                if((IMHCENTRALOFFERGOVERNANCE.equalsIgnoreCase(approvalGroupName)
                   ||IMHLOCALOFFERGOVERNANCE.equalsIgnoreCase(approvalGroupName))
                    && !lAnswerWarning.isEmpty()){
                    trackerRec.put(EXCEPTIONRAISED_API, TRUE);
                }                                           
                trackerRec.put(OWNERID,mapQueueByName.get(approvalGroupName).Id);
                // Ankur - 12/12: Updated to stamp Approver Name for Queue
                trackerRec.put(APPROVER_API,mapQueueByName.get(approvalGroupName).Name);
                if(recordOwnerDetails.IMHDirector__c != NULL && 
                            (recordOwnerDetails.Band_CA__c==NULL || (recordOwnerDetails.Band_CA__c != NULL && !BAND40.equalsIgnoreCase(recordOwnerDetails.Band_CA__c))) && 
                            (COMPLIANCEQUEUENAME.equalsIgnoreCase(approvalGroupName)
                                                     || GCOQUEUENAME.equalsIgnoreCase(approvalGroupName))){
                    trackerRec.put(SYS_DIRECTOR_API,recordOwnerDetails.IMHDirector__c);                           
                }
                if(mcolabnamecolabId.get(mapQueueByName.get(approvalGroupName).Name)!=NULL){
                       trackerRec.put(SYSCHATTERGROUP_API,mcolabnamecolabId.get(mapQueueByName.get(approvalGroupName).Name)); 
                }
                approvalTrackerList.add(trackerRec);
            }else if(approvalGroupName.containsIgnoreCase(LEADERSHIP)
                                        || approvalGroupName.containsIgnoreCase(DIRECTORVALE)){
                if(approvalGroupName.containsIgnoreCase(DIRECTORVALE)){
                    approvalOwnerId = recordOwnerDetails.IMHDirector__c;
                    if(recordOwnerDetails.IMHDirector__r.DelegatedApproverId!=NULL){
                        mDelegateApprovers.put(DIRECTORVALE,new List<Id>{recordOwnerDetails.IMHDirector__r.DelegatedApproverId});
                        trackerRec.put(SYSDELEGATEDAPPROVER,recordOwnerDetails.IMHDirector__r.DelegatedApproverId);
                    }
                }
                else{
                    approvalOwnerId = recordOwnerDetails.ManagerId;
                    if(recordOwnerDetails.Manager.DelegatedApproverId!=NULL){
                        mDelegateApprovers.put(LEADERSHIP,new List<Id>{recordOwnerDetails.Manager.DelegatedApproverId});
                        trackerRec.put(SYSDELEGATEDAPPROVER,recordOwnerDetails.Manager.DelegatedApproverId);
                    }
                }
                trackerRec.put(OWNERID,approvalOwnerId);
                // Ankur - 12/12: Updated to stamp Approver Name for Leadership and Director
                trackerRec.put(APPROVER_API,recordOwnerDetails.Name);
                approvalTrackerList.add(trackerRec);
            }
        }
        if(String.isNotBlank(tempStr)){
            mDelegateApprovers.putAll(fetchDelegatedApprovers(tempStr));
        }
        Savepoint sp = Database.setSavepoint();
        Boolean isDMLFail = false;
        Database.SaveResult [] approvalTrackerListDB =  Database.insert(approvalTrackerList,true);
        for(Database.SaveResult sr: approvalTrackerListDB){    
            if(!sr.isSuccess()) {
                isDMLFail=true;
                break;
            }
        }
        Set<String> approverManagerSet = new Set<String>();
        for(IMH_SLATracker__c approvalsCreated : [SELECT Id,Approval_Matrix__r.Approval_Group__r.QueueAPI__c FROM IMH_SLATracker__c WHERE ID IN :approvalTrackerList]){
            if(mDelegateApprovers.containsKey(approvalsCreated.Approval_Matrix__r.Approval_Group__r.QueueAPI__c)){
                for(Id delegateUser : mDelegateApprovers.get(approvalsCreated.Approval_Matrix__r.Approval_Group__r.QueueAPI__c)){
                    approverManagerSet.add(delegateUser);
                    approvalShare = new IMH_SLATracker__Share();
                    approvalShare.ParentId = approvalsCreated.Id;
                    approvalShare.UserOrGroupId = delegateUser;
                    approvalShare.AccessLevel = EDIT;
                    lApprovalTrackerShare.add(approvalShare);
                }
            }
        }
        if(!isDMLFail){
            if(approvalOwnerId != NULL){
                approverManagerSet.add(approvalOwnerId);
            }
            IMH_SoftEscalationHandler.autoFollowOnApprovalSubmit(mapQueueByName.keySet(),submittedRecord,approverManagerSet,targetMarket,objectName);
        }
        if(!lApprovalTrackerShare.isEmpty()){
            Database.SaveResult [] approvalTrackerShareDB =  Database.insert(lApprovalTrackerShare,true);
            IMH_UserTriggerHandler.sendApprovalEmailNotificationsForDelApprovers(lApprovalTrackerShare);
        }                                                 
        
        if(IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(objectName)) {
            submittedRecord.put(REVIEW_STAGE,currentApprovalStep.Name);
            submittedRecord.put(REVIEW_STATUS,IN_REVIEW);
            
        }
        else if(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API.equalsIgnoreCase(objectName)) {
            submittedRecord.put(CREATIVE_STAGE,currentApprovalStep.Name);
            submittedRecord.put('PostFinalCreativeNotificationReviewer__c','');
            for(String str : postFinalCreativeNotifiers){
                submittedRecord.put('PostFinalCreativeNotificationReviewer__c',
                                    (String)submittedRecord.get('PostFinalCreativeNotificationReviewer__c')+str+';');
                
            }
            submittedRecord.put(CREATIVE_STATUS,IN_REVIEW); 
            if(isCompliance) {
                sObject commSObj = (IMH_Communication__c)IMH_Communication__c.SObjectType.newSObject((Id)submittedRecord.get('Communication__c'));
                commSObj.put('SYS_IsUnderComplianceReview__c',isCompliance);
                sObjectToUpdate.add(commSObj);
            }
        }
        else if(BENEFIT_API.equalsIgnoreCase(objectName)) {
            submittedRecord.put(BENEFIT_STAGE,currentApprovalStep.Name);
            submittedRecord.put(APPROVAL_STAGE,IN_REVIEW); 
        }
        if(BENEFIT_API.equalsIgnoreCase(objectName) 
            || IMH_UtilityConstants.COMMUNICATION_OBJECT_API.equalsIgnoreCase(objectName)){
            List<IMH_SLATracker__c> approvalRecord = [SELECT Id,SYS_IsWarning__c FROM IMH_SLATracker__c WHERE Id IN : approvalTrackerList
                                                        AND (Approval_Group__c = :CENTRALOFFERGOVERNANCE 
                                                             OR Approval_Group__c = :LOCALOFFERGOVERNANCEIN) LIMIT 1];
            if(!approvalRecord.isEmpty()){
                for(IMH_AnswerWarning__c tempAns : lAnswerWarning){
                    tempAns.Approval__c = approvalRecord.get(0).Id;
                    tempAns.Status__c = IMH_UtilityConstants.EXCEPTION_RAISED;
                    sObjectToUpdate.add(tempAns); 
                     
                } 
                if(lAnswerWarning != NULL && !lAnswerWarning.isEmpty()){
                    approvalRecord[0].SYS_IsWarning__c = true;
                    sObjectToUpdate.add(approvalRecord[0]);
                } 
            }
        }                                         
        /*if(!isApprovalPending 
        			&& isSubmitterInGroupReview) {                                        
           submittedRecord.put(SEQ_NUMBER,Integer.valueOf(currentApprovalStep.Sequence__c)+1);
           submittedRecord.put('SYS_ReadyForReview_New__c',true);
        }else{*/
            submittedRecord.put(IMH_UtilityConstants.PAUSE_APPROVAL_API_NAME,false);
            submittedRecord.put(SEQ_NUMBER,Integer.valueOf(currentApprovalStep.Sequence__c));             
        //}
           
        sObjectToUpdate.add(submittedRecord);
        Database.update(sObjectToUpdate,true); 
        if(!recOwnerGroupsMap.isEmpty()){
        	updateSubmitterinGroupApprovals(submittedRecord,recOwnerGroupsMap);
        }                                                
    }
    
	private static void updateSubmitterinGroupApprovals(sObject submittedRecord,
											Map<String,Group> recOwnerGroupsMap){
		List<IMH_SLATracker__c> approvalsWithSubmitter = new List<IMH_SLATracker__c>();												
		for(IMH_SLATracker__c approvals :[SELECT Id,Approval_Matrix__r.Approval_Group__r.QueueAPI__c,Status__c FROM IMH_SLATracker__c WHERE Status__c = 'Pending' 
																				AND Approval_Matrix__r.Approval_Group__r.IMH_AutoApproveReviewGroup__c = TRUE 
																				AND (Communication__c = :submittedRecord.Id 
																				OR CommCreative__c = :submittedRecord.Id
																				OR Benefits__c = :submittedRecord.Id )]){
			if(recOwnerGroupsMap.get(approvals.Approval_Matrix__r.Approval_Group__r.QueueAPI__c)!=NULL){
				approvals.Status__c = SUBMITTER_IN_GROUP;
				approvalsWithSubmitter.add(approvals);
				IMH_SLATrackerTriggerHandler.isExecutedAfter = false;
			}
			Database.update(approvalsWithSubmitter,true);																					
		}
	}
    /**
    * @description  - Method to fetch the delegated aprpovers of the users in specific groups
    * @param  - List of groups
    * @return  - Set<Id> delegated User Ids
    */
    private static Map<String,List<Id>> fetchDelegatedApprovers(String groupName){
        Map<String,List<Id>> mDelegatedApproverIds = new Map<String,List<Id>>();
        List<Id> delegatedApproverIds = new List<Id>();
        for(User userRec : [SELECT Id,Name,DelegatedApproverId FROM User WHERE Id IN (SELECT UserOrGroupId  FROM GroupMember 
                                                    WHERE Group.DeveloperName =: groupName) 
                                                    AND isActive = TRUE 
                                                    AND delegatedApproverId != NULL]){
            delegatedApproverIds.add(userRec.DelegatedApproverId);
        }
        mDelegatedApproverIds.put(groupName,delegatedApproverIds);
        return mDelegatedApproverIds;
    }
    
    /**
    * @description  - Method to construct the string to check against the multiselect values in SOQL query
    * @param  - Source Strig
    * @return  - String
    */
    private static string getUnescapedStrings(Object sourceString){
    	String parsedString = '';
    	List<String> sourceStringSet = new List<String>();
    	if(sourceString!=NULL){
    		sourceStringSet = String.valueOf(sourceString).split(SEMI_COLON);
    	}
    	if(!sourceStringSet.isEmpty()){
            for(String str : sourceStringSet) {
                if(String.isNotBlank(parsedString)) {
                    parsedString += COMMA+ESCAPE_QUOTES+str+ESCAPE_QUOTES;
                }
                else {
                    parsedString = str+ESCAPE_QUOTES;
                }
            }
            parsedString = parsedString.removeEndIgnoreCase(ESCAPE_QUOTES);
        }
        return parsedString;
    }
    
     
}