/**
* @author Accenture IDC 
* @date 07/22/2015
* @group Answer
* @group-content N/A
* @description: iMH Release 1 (Sprint 5) - GlobalApplicationUtility which looks for the Execution of button Logic.
*/
global without sharing class IMH_GlobalApplicationUtility {
    private static IMH_Communication__c communicationRec        = null;
    private static final String CONFIRM_TO_CREATIVE_DESIGN      = 'Confirm to Creative Design';
    private static final String CONFIRM_TO_CREATIVE_ATTESTATION = 'Confirm to Creative Attestation';
    private static final String CONFIRM_TO_CREATVE_COMPLETE     = 'Confirm to Creative Complete';
    private static final String CONFIRM_TO_PRE_EXECUTION        = 'Confirm to PreExecution';
    private static final String CONFIRM_TO_READYFOR_EXECUTION   = 'Confirm to Ready For Execution';
    private static final String CENTRAL_CAMPAIGN                = 'Central Campaign';
    private static final String SUCESS_RESPONSE                 = 'success';
    private static final String CAMPAIGN_RECORDTYPE             = 'LocalCampaignPreExecution';
    private static final String NON_MARKETING                   = 'NonMarketingPreExecution';
    private static final String CAMPAIGN_CREATIVERECORDTYPE     = 'Creative';
    private static final String COM_REQ_STATUS_API              = 'ReviewStatus__c';
    private static final String CREATIVE_STATUS_NAME            = 'CreativeStatus__c';
    private static final String BENEFIT_APP_STAGE_API           = 'ApprovalStage__c';
    private static final String SYS_READYFORREVIEW              = 'SYS_Ready_For_Review__c';
    private static final String RECORD_TYPE                     = 'RecordType';
    private static final String NAME                            = 'Name';
    private static final String TRUE_STRING                     = 'TRUE';
    private static final String FALSE_STRING                    = 'FALSE';
    private static final String INSUFFICIENT_ACCESS             = 'INSUFFICIENT_ACCESS';
    private static final String SKIP_CREATIVE                   = 'Skip_Creative';
    private static final String REVIEW_AND_APPROVAL             = 'Creative in Review';
    private static final String CANADA_MARKET                   = 'Canada';
    
    //Sprint 34
    private static final String CONFIRM_TO_CONCEPT_APPROVAL     = 'Confirm to Concept Approval';
    private static final String CONFIRM_TO_POST_EXECUTION     = 'Confirm to Post Execution';
    private static final String SEQUENCENUBER_API             = 'SequenceNumber__c';
    private static final String SYSREADYFORREVIEW_API        =  'SYS_ReadyForReview_New__c';
    private static final String SYSRECALL_API              = 'SYSRecall__c';
    private static final String PAUSEAPPROVAL = 'PauseApproval__c';
    

   
    /**
    * @description  - Method is used to process the campaign to Next Stage
    * @param  - Campaign ID, Boolean To Update Campaign,Current Stage Of a Campaign
    * @return  - String
    */  
    webservice static String moveNextStep(Id communicationId,Boolean updateCommunication,String currentStage) {
        String responseStr =IMH_UtilityConstants.EMPTY_STRING;
        try {
            Integer approvedOffers = 0;
            Integer totalOffers = 0;
            Integer approvedCreatives = 0;
            Integer totalCreatives = 0;
            if(communicationId != null) {
                communicationRec = [SELECT Id,TargetMarket__c,Communication_Type__c,StartDate__c,EndDate__c,ProcessStage__c,ReviewStatus__c,ReviewStage__c,LifecycleStage__c,
                                    SYSOpenAnswerSetsForPreExecution__c,RecordType.Name,SYSOpenAnswerSetsForCreative__c,
                                    PreviousCreativeApprovals__c,SYSReinitiateCheck__c, SYSReinitiateRecallCheck__c,
                                    (SELECT Name,StartDate__c,EndDate__c,IncentiveStatus__c FROM Incentives__r),
                                    (SELECT Name,CreativeStatus__c,SYS_Total_Targeted_Channels__c,
                                    SYS_TotalTargetedProducts__c,SYS_IsOtherCommunicationRecType__c FROM Creative__r) FROM IMH_Communication__c 
                                    WHERE Id = :communicationId LIMIT 1];
                if(!updateCommunication){
                    for(IMH_Incentive__c incObj :communicationRec.Incentives__r){
                        if(incObj.EndDate__c ==NULL 
                                || incObj.StartDate__c == NULL ){
                            responseStr = Label.iMH_BlankValidattionOfIncentiveDate;
                            break;
                        }
                        else if ((communicationRec.EndDate__c < incObj.EndDate__c || communicationRec.StartDate__c > incObj.StartDate__c ) 
                                                                                    && (!incObj.IncentiveStatus__c.equalsIgnoreCase(IMH_UtilityConstants.OFFER_CAN_STATUS))){
                            responseStr = Label.iMH_RangeValidattionOfIncentiveDate;
                            break;
                        }
                    }
                    if(String.isBlank(responseStr)){
                        //1. Code for Communication in (MRAP Stage: Concept, Review Stage: Design, Status: In Progress)
                        if(IMH_UtilityConstants.CONCEPT.equalsIgnoreCase(communicationRec.ProcessStage__c) 
                            && (((IMH_UtilityConstants.CAMPAIGN_INPROGRESS.equalsIgnoreCase(communicationRec.ReviewStatus__c)
                                    || IMH_UtilityConstants.COM_INPRO_FOL_REJ_REQ_STATUS.equalsIgnoreCase(communicationRec.ReviewStatus__c)
                                 )
                            && IMH_UtilityConstants.COM_REV_STAGE_DESIGN.equalsIgnoreCase(communicationRec.ReviewStage__c))
                                 || (IMH_UtilityConstants.COM_REV_STAGE_PROVIDELATEST.equalsIgnoreCase(communicationRec.ReviewStage__c)
                                     &&  IMH_UtilityConstants.COM_INREVIEW_REQ_STATUS.equalsIgnoreCase(communicationRec.ReviewStatus__c))
                                   )) {
                                  responseStr = CONFIRM_TO_CONCEPT_APPROVAL;
                        }
                        //2. Code for Communication in (MRAP Stage: Creative, Review Stage: Design, Status: In Progress)
                        else if(IMH_UtilityConstants.CREATIVE.equalsIgnoreCase(communicationRec.ProcessStage__c) 
                                && IMH_UtilityConstants.CAMPAIGN_INPROGRESS.equalsIgnoreCase(communicationRec.ReviewStatus__c)
                                && (IMH_UtilityConstants.COM_REV_STAGE_DESIGN.equalsIgnoreCase(communicationRec.ReviewStage__c)
                                    || REVIEW_AND_APPROVAL.equalsIgnoreCase(communicationRec.ReviewStage__c))) {
                            if(REVIEW_AND_APPROVAL.equalsIgnoreCase(communicationRec.ReviewStage__c)){
                                responseStr = Label.IMH_CreativeUnderReview;                
                            }
                            else {
                                Boolean notargetedProduct = false;
                                Boolean notargetedChannel = false;
                                for(IMH_CommCreative__c tempCreative : communicationRec.Creative__r) {
                                    if(!IMH_UtilityConstants.CREATIVE_EXP_STATUS.equalsIgnoreCase(tempCreative.CreativeStatus__c)
                                       && !IMH_UtilityConstants.CREATIVE_CAN_STATUS.equalsIgnoreCase(tempCreative.CreativeStatus__c)){
                                           totalCreatives++;
                                    }
                                    if(IMH_UtilityConstants.CREATIVE_Appr_STATUS.equalsIgnoreCase(tempCreative.CreativeStatus__c)){
                                        approvedCreatives++;
                                    }
                                    if(tempCreative.SYS_TotalTargetedProducts__c == 0 && (!tempCreative.SYS_IsOtherCommunicationRecType__c) && 
                                       !(IMH_UtilityConstants.CREATIVE_EXP_STATUS.equalsIgnoreCase(tempCreative.CreativeStatus__c) ||
                                        IMH_UtilityConstants.CREATIVE_CAN_STATUS.equalsIgnoreCase(tempCreative.CreativeStatus__c))){
                                        notargetedProduct = true;
                                    }
                                    if(tempCreative.SYS_Total_Targeted_Channels__c == 0 && (!tempCreative.SYS_IsOtherCommunicationRecType__c) &&
                                       !(IMH_UtilityConstants.CREATIVE_EXP_STATUS.equalsIgnoreCase(tempCreative.CreativeStatus__c) ||
                                        IMH_UtilityConstants.CREATIVE_CAN_STATUS.equalsIgnoreCase(tempCreative.CreativeStatus__c))){
                                        notargetedChannel = true;
                                    }
                                }
                                if(totalCreatives==0) {
                                    responseStr = Label.IMHAlertCampaignWithNoCreatives;
                                }
                                else if(notargetedProduct) {
                                    responseStr = Label.IMH_AlertIfNoTargetedProducts;
                                }
                                else if(notargetedChannel){
                                    responseStr = Label.IMH_AlertIfNoChannel;
                                }
                                else if((approvedCreatives<totalCreatives) 
                                     && (IMH_UtilityConstants.COM_REV_STAGE_DESIGN.equalsIgnoreCase(communicationRec.ReviewStage__c))) {
                                    responseStr = Label.IMHCreativesInPending;
                                }
                                else if(approvedCreatives==totalCreatives){
                                    responseStr = CONFIRM_TO_CREATVE_COMPLETE;
                                }
                            }
                        }
                        //3. Code for if Communication in (MRAP Stage: Pre-Execution, Review Stage: Design, Status: In Progress)
                        else if(IMH_UtilityConstants.CAMPAIGN_APP_STG_PREEXECUTING.equalsIgnoreCase(communicationRec.ProcessStage__c) 
                                && IMH_UtilityConstants.CAMPAIGN_INPROGRESS.equalsIgnoreCase(communicationRec.ReviewStatus__c)
                                && IMH_UtilityConstants.COM_REV_STAGE_DESIGN.equalsIgnoreCase(communicationRec.ReviewStage__c)) {
                            responseStr = CONFIRM_TO_READYFOR_EXECUTION;
                        }
                        //4. For Canada, After Ready for Execution once the submitter answer post execution questionnaire
                        //move to Post Execution Stage
                        else if(IMH_UtilityConstants.READY_FOR_EXECUTION.equalsIgnoreCase(communicationRec.ProcessStage__c) 
                                && IMH_UtilityConstants.CAMPAIGN_APP_REQ_STATUS.equalsIgnoreCase(communicationRec.ReviewStatus__c)
                                && IMH_UtilityConstants.COM_REV_STAGE_COMPLETE.equalsIgnoreCase(communicationRec.ReviewStage__c)
                                && CANADA_MARKET.equalsIgnoreCase(communicationRec.TargetMarket__c)) {
                            responseStr = CONFIRM_TO_POST_EXECUTION;
                        }
                    }
                }
                else {
                    if(IMH_UtilityConstants.READY_FOR_EXECUTION.equalsIgnoreCase(currentStage)){
                        communicationRec.ProcessStage__c = IMH_UtilityConstants.POST_EXECUTION;
                    }
                    else if(SKIP_CREATIVE.equalsIgnoreCase(currentStage)){
                        communicationRec.ReviewStage__c               = IMH_UtilityConstants.COM_REV_STAGE_DESIGN;
                        communicationRec.ReviewStatus__c             = IMH_UtilityConstants.CAMPAIGN_INPROGRESS;
                        communicationRec.ProcessStage__c             = IMH_UtilityConstants.CAMPAIGN_APP_STG_PREEXECUTING;
                    }
                    else{
                        communicationRec.ProcessStage__c             = IMH_UtilityConstants.READY_FOR_EXECUTION;
                        communicationRec.ReviewStatus__c             = IMH_UtilityConstants.CAMPAIGN_APP_REQ_STATUS;
                        communicationRec.ReviewStage__c               = IMH_UtilityConstants.COM_REV_STAGE_COMPLETE;
                        communicationRec.PreviousCreativeApprovals__c += 1;
                    }
                
                    Database.SaveResult sResult=  Database.update(communicationRec);
                    if(!sResult.isSuccess()){
                        responseStr = Label.IMH_SystemError;
                    }
                    else{
                        responseStr = SUCESS_RESPONSE;
                    }
                }
            }
        }
        catch(Exception e){
            SYstem.debug('***START Excep  ');
            if(e.getMessage().contains(INSUFFICIENT_ACCESS)){
                responseStr = Label.IMH_insufficientprivilege;
            }    
            else
            {
                responseStr = e.getMessage();
            }
        }
        SYstem.debug('***Final Excep  '+responseStr);
        return responseStr; 
    }

    /**
    * @description  - Method is used for recalling the Campaign.
    * @param  - Campaign ID
    * @return  - String
    */   
    webservice static String updateCampaignOnRecall(Id campaignId){
        String responseStr =IMH_UtilityConstants.EMPTY_STRING;
        try{
            communicationRec = [SELECT Id,ProcessStage__c,ReviewStatus__c,ReviewStage__c,SYSReinitiateCheck__c, 
                            SYSReinitiateRecallCheck__c,RecordType.DeveloperName,TargetMarket__c FROM IMH_Communication__c 
                            WHERE Id = :campaignId LIMIT 1];
            //Creative-Design OR Concept-Attestation -> Concept Design
            if((((IMH_UtilityConstants.CREATIVE.equalsIgnorecase(communicationRec.ProcessStage__c)) 
                && (communicationRec.ReviewStage__c.equalsIgnoreCase(IMH_UtilityConstants.COM_REV_STAGE_DESIGN)))))
              {
            
                communicationRec.ProcessStage__c = IMH_UtilityConstants.CONCEPT;
                communicationRec.ReviewStage__c = IMH_UtilityConstants.COM_REV_STAGE_DESIGN;
                communicationRec.ReviewStatus__c = IMH_UtilityConstants.CAMPAIGN_INPROGRESS;
              }
           /* else if(((IMH_UtilityConstants.CREATIVE.equalsIgnorecase(communicationRec.ProcessStage__c)) 
                && (communicationRec.ReviewStage__c.equalsIgnoreCase(IMH_UtilityConstants.COM_REV_STAGE_DESIGN)))
              &&  communicationRec.RecordType.DeveloperName.equalsIgnoreCase('SingleServicing')) {
                   responseStr = 'Error on Back';
            }*/
            //Pre-Execution OR Creative-    Attestation -> Creative Design
            else if((IMH_UtilityConstants.CAMPAIGN_APP_STG_PREEXECUTING.equalsIgnorecase(communicationRec.ProcessStage__c)) 
               || ((IMH_UtilityConstants.CREATIVE.equalsIgnorecase(communicationRec.ProcessStage__c)) 
                   && (communicationRec.ReviewStage__c.equalsIgnoreCase(IMH_UtilityConstants.COM_REV_STAGE_ATTESTATION)))) {
                       if(IMH_UtilityConstants.CAMPAIGN_APP_STG_PREEXECUTING.equalsIgnorecase(communicationRec.ProcessStage__c) && communicationRec.SYSReinitiateRecallCheck__c){
                            communicationRec.SYSReinitiateRecallCheck__c = false;                         
                        }
                communicationRec.ProcessStage__c            = IMH_UtilityConstants.CREATIVE;
                communicationRec.ReviewStage__c             = IMH_UtilityConstants.COM_REV_STAGE_DESIGN;
                communicationRec.ReviewStatus__c            = IMH_UtilityConstants.CAMPAIGN_INPROGRESS;
               }
            Database.SaveResult sResult=  Database.update(communicationRec);
            if(!sResult.isSuccess()){
                responseStr = Label.IMH_SystemError;
            }
            else{
                responseStr = SUCESS_RESPONSE;
            }
        }
        catch(Exception e){
           if(e.getMessage().contains(INSUFFICIENT_ACCESS)){
               responseStr = Label.IMH_insufficientprivilege;
           }    
           else{
               responseStr = System.Label.IMH_AlertOnDobleClick;
           }
        }
        return responseStr;
    }
  
    /**
    * @description  - Method is used to update Campaign on Reinitiate
    * @param  - Campaign ID
    * @return  - String
    */
    webservice static String updateCampaignOnReInitiate(Id campaignId){
        String responseStr =IMH_UtilityConstants.EMPTY_STRING;
        try{
            communicationRec = [SELECT Id,ProcessStage__c,ReviewStatus__c,SYSReinitiateCheck__c, SYSReinitiateRecallCheck__c,
                            ReviewStage__c FROM IMH_Communication__c WHERE Id = :campaignId LIMIT 1];
            communicationRec.ProcessStage__c            = IMH_UtilityConstants.CREATIVE;
            communicationRec.ReviewStage__c              = IMH_UtilityConstants.COM_REV_STAGE_DESIGN;
            communicationRec.ReviewStatus__c            = IMH_UtilityConstants.CAMPAIGN_INPROGRESS;
            communicationRec.SYSReinitiateCheck__c       = true;
            communicationRec.SYSReinitiateRecallCheck__c = true;
            communicationRec.SYSReinitiateRejectCheck__c = true;
            Database.SaveResult sResult=  Database.update(communicationRec);
            if(!sResult.isSuccess()){
                responseStr = Label.IMH_SystemError;
            }else{
                responseStr = SUCESS_RESPONSE;
            }
        }
        catch(Exception e){
            if(e.getMessage().contains(INSUFFICIENT_ACCESS)){
               responseStr = Label.IMH_insufficientprivilege;
           }    
           else
           {
               responseStr = System.Label.IMH_AlertOnDobleClick;
           }
        }
        return responseStr;
    }
    
    /**
    * @description  - Method is used to submitfor approval
    * @param  - sObject ID
    * @return  - String
    */ 
    webservice static String submitForApproval(Id sObjectId,Integer seqNo){
       String responseStr = SUCESS_RESPONSE;
       try{
            sObject sobjectToUpdate = null;
            IMH_CustomApprovalSubmit.workOnSubmittedRecord(sObjectId);
       }
       catch(Exception e){
           responseStr = Label.IMH_SystemError;
       }
       return responseStr; 
    }
    
    /**
    * @description  - Method is used to recall the approval process records 
    * @param  - ID - Communication/Creative/Benefits/Incentive 
    * @return  - String
    */ 
    webservice static String recallApprovalProcess(Id sObjectId){
        String responseStr = SUCESS_RESPONSE;
        sObject sobjectToUpdate = null;
        List<sObject> lsObjectToUpdate =  new List<sObject>();
        List<IMH_SLATracker__c> lSLAsToUpdate = new List<IMH_SLATracker__c>();
        Set<Id> lRecalledIds = new Set<Id>();
        try {
            for(IMH_SLATracker__c slaRecord : [SELECT Id,Status__c,Completed__c,ResponseBy__c FROM IMH_SLATracker__c 
                                                        WHERE (Communication__c = : sObjectId 
                                                            OR CommCreative__c = :sObjectId
                                                            OR Benefits__c = :sObjectId
                                                            OR Incentive__c = :sObjectId ) 
                                                        AND SYS_SendNotifications__c = :IMH_UtilityConstants.NONE
                                              LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
                if(slaRecord.Status__c.equalsIgnoreCase(IMH_UtilityConstants.PENDING) || slaRecord.Status__c.equalsIgnoreCase(IMH_UtilityConstants.PENDINGAPPROVAL)){                                              
                   slaRecord.Status__c = IMH_UtilityConstants.RECALLSUBMITTER;
                }
                slaRecord.SYS_SendNotifications__c =IMH_UtilityConstants.YES;                                            
                lRecalledIds.add(slaRecord.Id);                                            
                lSLAsToUpdate.add(slaRecord);
            }
            if(ID.valueOf(sObjectId).getSobjectType() == Schema.IMH_CommCreative__c.SObjectType) {
                Id CommRecordId = [SELECT Id, Communication__c FROM IMH_CommCreative__c WHERE 
                                    Id=: sObjectId LIMIT 1].Communication__c;
                sObject commRec = [SELECT Id, SYS_IsUnderComplianceReview__c  FROM IMH_Communication__c WHERE 
                                   Id=: CommRecordId];
                if (Boolean.valueOf(commRec.get('SYS_IsUnderComplianceReview__c'))) {
                    commRec.put('SYS_IsUnderComplianceReview__c',false);
                    System.debug('Setting as false');
                    lsObjectToUpdate.add(CommRec);
                }
            }
            sobjectToUpdate = sObjectId.getSobjectType().newSObject(sObjectId);
            //METHOD CALLED TO UPDATE THE COMMUNICATION/CREATIVE/BENEFITS/INCENTIVE RECORDS TO SET THE STATUS IF APPROVAL IS RECALLED 
            IMH_SLATrackerTriggerHandler.updateFinalActionsOnRecallOrReject(sobjectToUpdate,true);
            sobjectToUpdate.put(SYSRECALL_API,true);
            lsObjectToUpdate.add(sobjectToUpdate);
            //METHOD CALLED TO UPDATE THE ANSWER WARNING RECORDS TO RESET THE STATUS IF APPROVAL RECORD IS RECALLED 
            IMH_SLATrackerTriggerHandler.retrieveAnswerWarningToUpdate(lsObjectToUpdate,lRecalledIds);    
            Database.update(lSLAsToUpdate,true);
            Database.update(lsObjectToUpdate,true);
        }
        catch(Exception e){
            responseStr = Label.IMH_SystemError;
        }
        return responseStr; 
    }
}