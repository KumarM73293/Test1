/**
* @author Accenture IDC 
* @date 31/03/2016
* @group SLATracker
* @group-content N/A
* @description Trigger Handler on SLATracker that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/ 
public without sharing class IMH_SLATrackerTriggerHandler {
    public static Boolean isExecutedAfter = false;
    private static final String STATUS_API            = 'Status__c';
    private static final String SELECT_STRING = 'SELECT ';
    private static final String communicationobjectfields = 'Id,PauseApproval__c,SequenceNumber__c, SYS_ReadyForReview_New__c,ReviewStage__c,ReviewStatus__c, ';
    private static final String creativeobjectfields = 'Id,PauseApproval__c,SequenceNumber__c, SYS_ReadyForReview_New__c,CreativeStage__c,CreativeStatus__c, Communication__c, ';
    private static final String benefitsobjectfields = 'Id,PauseApproval__c,SequenceNumber__c, SYS_ReadyForReview_New__c,BenefitStage__c,ApprovalStage__c, ';
    private static final String innerquery = 'SELECT Id,AssignedApprover__c,Status__c,SYS_SendNotifications__c,ResponseBy__c,Approval_Group__c,Completed__c FROM SLAs__r ';
    private static final String whereinnerquery12 = ' Where Status__c =\'Pending\' OR Status__c = \'Pending Approval – Changes/Information Required\'';
    private static final String whereinnerquery = ' Where SYS_SendNotifications__c = \'None\'';
    private static final String FROM_STRING = ' From ';
    private static final String wherequery = ' Where ID IN:setQueryRecords LIMIT 1';
    private static final String SYSAPPROVALAPI = 'SYS_ApprovalObjectType__c';
    private static final String SYSREADYFORREVIEW = 'SYS_ReadyForReview_New__c';
    private static final String SEQUENCEAPI = 'SequenceNumber__c';
    private static final String REVIEWSTAGEAPI = 'ReviewStage__c';
    private static final String REVIEWSTATUSAPI = 'ReviewStatus__c';
    private static final String STATUSAPI = 'Status__c';
    private static final String CREATIVESTAGE_API = 'CreativeStage__c';
    private static final String CREATIVESTATUS_API = 'CreativeStatus__c';
    private static final String BENEFITSTAGE_API = 'BenefitStage__c';
    private static final String BENEFITSTATUS_API = 'ApprovalStage__c';
    private static final String SLAREL = 'SLAs__r';
    private static final String REJECTED = 'Rejected';
    private static final String SYSNOTIFICATION = 'SYS_SendNotifications__c';
    private static final String IMHUNDERSCORE = 'IMH_';
    private static final String SYS_RECALL = 'SYSRecall__c';
    private static final String OPENINGBRACE = '(';
    private static final String CLOSINGBRACE = ')';
    private static final String SUBMISSION_IN_ERROR = 'Submission Received in Error';
    //M.Wheeler - 17.10.2016 - R1.7 - US566199 - ID 58237430541
    private static final String SUBMITTER_IN_GROUP  = 'Submitter in Review Group';
    //END CHANGE M.Wheeler
    private static final String FORWARDED_FOR_EXT_REVIEW = 'Forwarded for External Review';
    private static final String CANNOT_EXECUTE_FLOW_TRIGGER = 'CANNOT_EXECUTE_FLOW_TRIGGER';
    
    /*****************************************************************************
    * @description: Mehod called on after update of trigger event
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
    public static void handleAfterUpdate(List<IMH_SLATracker__c> ltriggernew
                                         , Map<Id,IMH_SLATracker__c> mtriggernew
                                         , Map<Id,IMH_SLATracker__c> mtriggerold){
		try{                                         	
			IMH_SLATrackerTriggerHandler.updateProcessingRecords(ltriggernew, mtriggernew, mtriggerold);
		}
		catch(Exception exp){
			for(IMH_SLATracker__c approval : mtriggernew.values()){
				approval.addError(Label.IMH_SystemError);
			}
		}
        
        
    }
    
    /*****************************************************************************
    * @description: Mehod called on before update of trigger event
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
    public static void handleBeforeUpdate(List<IMH_SLATracker__c> ltriggernew
                                         , Map<Id,IMH_SLATracker__c> mtriggernew
                                         , Map<Id,IMH_SLATracker__c> mtriggerold){
        IMH_SLATrackerTriggerHandler.updateResponseByAndDate(ltriggernew, mtriggernew, mtriggerold);
        IMH_SLATrackerTriggerHandler.updateDeltandTotal(ltriggernew, mtriggernew, mtriggerold);
    }
    
        
    /*****************************************************************************
    * @description: Mehod to update the response by and complete date on communication/campaign/offer/creative
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void 
    */ 
    private  static void updateResponseByAndDate(List<IMH_SLATracker__c> ltriggernew
                                                , Map<Id,IMH_SLATracker__c> mtriggernew
                                                 , Map<Id,IMH_SLATracker__c> mtriggerold){ 
        Set<Id> approvalIds = new Set<Id>();
        
                                                             
        for(IMH_SLATracker__c appRecord : ltriggernew ){
            if(appRecord.Status__c != NULL 
                      && mtriggerold.get(appRecord.Id).Status__c!= mtriggernew.get(appRecord.Id).Status__c
                  && (appRecord.Status__c.containsIgnoreCase(IMH_UtilityConstants.CAMPAIGN_APP_REQ_STATUS)
                      || REJECTED.containsIgnoreCase(appRecord.Status__c)
                      || SUBMISSION_IN_ERROR.containsIgnoreCase(appRecord.Status__c)
                      || FORWARDED_FOR_EXT_REVIEW.containsIgnoreCase(appRecord.Status__c))){
               appRecord.Completed__c = System.now();
               //M.Wheeler - 17.10.2016 - R1.7 - US566199 - ID 58237430541
               if(appRecord.ResponseBy__c == null) {
                appRecord.ResponseBy__c = UserInfo.getUserId();
               }
               //END CHANGE M.Wheeler           
               if(REJECTED.equalsIgnoreCase(appRecord.Status__c)){
                   appRecord.SYS_SendNotifications__c = IMH_UtilityConstants.YES;           
               }
                          approvalIds.add(appRecord.Id);           
            }
        }
                                                     
        //LOGIC TO CHECK IF THERE ARE ANY EXCEPTIONS WHICH ARE UNANSWERED BY REVIEWER BEFORE APPROVING                                             
        for(IMH_SLATracker__c tempSLA : [SELECT Id ,(SELECT Id FROM AnswerWarnings__r WHERE Status__c = :IMH_UtilityConstants.EXCEPTION_RAISED ) FROM IMH_SLATracker__c WHERE Id IN : approvalIds]){
            if(!tempSLA.AnswerWarnings__r.isEmpty()){
                mtriggernew.get(tempSLA.Id).addError(Label.IMH_ValidateApprovalIfAnswerWarning);
            }
        }                                                       
    }
    
    /*****************************************************************************
    * @description: Mehod to process the approval records on communication/campaign/offer/creative
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void 
    */ 
    private static void updateProcessingRecords(List<IMH_SLATracker__c>ltriggernew
                                                , Map<Id,IMH_SLATracker__c> mtriggernew
                                                , Map<Id,IMH_SLATracker__c> mtriggerold){ 
        Set<Id> setapprovedRecords = new Set<Id>();
        Set<Id> setrejectedRecords = new Set<Id>();
        Set<Id> setQueryRecords = new Set<Id>();                                             
        Map<Id,List<IMH_SLATracker__c>> mapCommslaTrack = new Map<Id,List<IMH_SLATracker__c>>();
        String queryString = IMH_UtilityConstants.EMPTY_STRING;
        String ObjectName = IMH_UtilityConstants.EMPTY_STRING;
        Boolean isrejected = false;
        String objectfields = IMH_UtilityConstants.EMPTY_STRING;                                          
        Sobject recordOnApprovalProcess = NULL;                                            
        List<sobject> lsobjectupdate = new List<sobject>();
        List<sobject> lslatrackervalues = new List<sobject>(); 
        List<sobject> lupdateslatrackervalues = new List<sobject>(); 
        Set<Id> lApprovalWarningRejectionIds= new Set<Id>();                                             
        Boolean isPause = false;                                                    
        MAP<Id,IMH_SLATracker__c> slaTrackerMap = new Map<Id,IMH_SLATracker__c>([SELECT Id,Approval_Matrix__r.PauseApproval__c,Approval_Matrix__r.StatusToPauseApproval__c
                                                                                        FROM IMH_SLATracker__c WHERE Id IN :ltriggernew
                                                                                LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]);
        Set<String> setOfPauseApprovalStatus = new Set<String>();                                                    
         for(Id sobj : mtriggernew.keySet()){
            setOfPauseApprovalStatus = new Set<String>();
            if(mtriggernew.get(sobj).get(STATUS_API)!= NULL && mtriggerold.get(sobj).get(STATUS_API)!= mtriggernew.get(sobj).get(STATUS_API)){
            	
            	if((String.valueof(mtriggernew.get(sobj).get(STATUS_API)).containsIgnoreCase(IMH_UtilityConstants.CAMPAIGN_APP_REQ_STATUS)
                  || String.valueof(mtriggernew.get(sobj).get(STATUS_API)).equalsIgnoreCase(SUBMISSION_IN_ERROR)
                  || String.valueof(mtriggernew.get(sobj).get(STATUS_API)).equalsIgnoreCase(SUBMITTER_IN_GROUP)
                  || String.valueof(mtriggernew.get(sobj).get(STATUS_API)).equalsIgnoreCase(FORWARDED_FOR_EXT_REVIEW))) {
                  	  setQueryRecords.add(String.valueof(mtriggernew.get(sobj).get(String.valueof(mtriggernew.get(sobj).get(SYSAPPROVALAPI)))));
                  	  if(slaTrackerMap.get(sobj).Approval_Matrix__r.StatusToPauseApproval__c != NULL){
                          setOfPauseApprovalStatus.addAll(slaTrackerMap.get(sobj).Approval_Matrix__r.StatusToPauseApproval__c.split(IMH_UtilityConstants.SEMI_COLON));
                          isPause = setOfPauseApprovalStatus.contains(String.valueof(mtriggernew.get(sobj).get(STATUS_API)))?true:false;
                      } 
                }else if(String.valueof(mtriggernew.get(sobj).get(STATUS_API)).equalsIgnoreCase(REJECTED)){
                	setQueryRecords.add(String.valueof(mtriggernew.get(sobj).get(String.valueof(mtriggernew.get(sobj).get(SYSAPPROVALAPI)))));
            		lApprovalWarningRejectionIds.add(Id.valueOf(sobj));
            		isrejected = true;
            	}	
            }
            ObjectName =  String.valueof(mtriggernew.get(sobj).get(SYSAPPROVALAPI));
        }
        
        String sobjectApi = IMHUNDERSCORE+ObjectName;
        if(sobjectApi.equalsIgnoreCase(IMH_UtilityConstants.COMMUNICATION_OBJECT_API)){
           objectfields = communicationobjectfields;
        }
        else if(sobjectApi.equalsIgnoreCase(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API)){
           objectfields = creativeobjectfields;
        }
        else if(sobjectApi.equalsIgnoreCase(IMH_UtilityConstants.BENEFIT_API)){
           objectfields = benefitsobjectfields;                                           
        }                                            
        queryString = SELECT_STRING + IMH_UtilityConstants.BLANK_SPACE 
                        + objectfields +  OPENINGBRACE + innerquery + whereinnerquery + CLOSINGBRACE
                        + IMH_UtilityConstants.BLANK_SPACE + FROM_STRING + sobjectApi + wherequery;                                                                                    
        if(!setQueryRecords.isEmpty()){
           recordOnApprovalProcess = Database.query(queryString); 
        }   
        //for(Sobject recordOnApprovalProcess:lrecords) 
        if(recordOnApprovalProcess!=NULL){
	       	//APPROVAL DOESNOT HANDLE BULK ACROSS MUTLIPLE OBJECTS,HOWEVER IT CAN HANDLE IF MULITPLE APPROVAL HAPPENED ON SINGLE RECORD
	        Boolean isPending = false;
	        for(IMH_SLATracker__c sla:recordOnApprovalProcess.getsobjects(SLAREL)){
	            if(sla.Status__c.equalsIgnoreCase(IMH_UtilityConstants.PENDING) 
	            			|| sla.Status__c.equalsIgnoreCase(IMH_UtilityConstants.PENDINGAPPROVAL)){
	                isPending = true;
	            }
	        }
	        if(!Boolean.ValueOf(recordOnApprovalProcess.get(IMH_UtilityConstants.PAUSE_APPROVAL_API_NAME))){
	            recordOnApprovalProcess.put(IMH_UtilityConstants.PAUSE_APPROVAL_API_NAME,isPause);
	        }
	        Boolean readyforReview = false;
	        if(!isPending && !isrejected ){
	            System.debug('DEBUGGS 2 '+recordOnApprovalProcess);
	            if(!Boolean.ValueOf(recordOnApprovalProcess.get(IMH_UtilityConstants.PAUSE_APPROVAL_API_NAME))){
	                readyforReview = true;
	            }else if(sobjectApi.equalsIgnoreCase(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API)){
	                recordOnApprovalProcess.put(CREATIVESTAGE_API,Label.iMH_ProvideLatestCreative);
	            }
	            else if(sobjectApi.equalsIgnoreCase(IMH_UtilityConstants.COMMUNICATION_OBJECT_API)){
	                recordOnApprovalProcess.put(REVIEWSTAGEAPI,IMH_UtilityConstants.COM_REV_STAGE_PROVIDELATEST);
	            }
	            
	        }
	        if(isrejected){
	            IMH_SLATrackerTriggerHandler.updateFinalActionsOnRecallOrReject(recordOnApprovalProcess,false);
	            if(recordOnApprovalProcess.getsobjects(SLAREL) != NULL){
	                lslatrackervalues = recordOnApprovalProcess.getsobjects(SLAREL);
	                for(Sobject sla:lslatrackervalues){
	                    if(String.valueof(sla.get(STATUSAPI)).equalsIgnoreCase(IMH_UtilityConstants.PENDING)
	                    			 || String.valueof(sla.get(STATUSAPI)).equalsIgnoreCase(IMH_UtilityConstants.PENDINGAPPROVAL)){
	                      sla.put(STATUSAPI,IMH_UtilityConstants.RECALLEDREJECTION);
	                    }
	                    sla.put(SYSNOTIFICATION,IMH_UtilityConstants.YES);
	                    lsobjectupdate.add(sla);
	                }
	            }
	        }
	        if(!readyforReview){
	        	lsobjectupdate.add(recordOnApprovalProcess); 
	        }else{
	        	IMH_CustomApprovalSubmit.workOnSubmittedRecord(String.valueOf(recordOnApprovalProcess.get('Id')));
	        }
	    }
        IMH_SLATrackerTriggerHandler.retrieveAnswerWarningToUpdate(lsobjectupdate,lApprovalWarningRejectionIds);                                                  
        if(!lsobjectupdate.isEmpty()){
            Database.update(lsobjectupdate,true);
        }                                           
    }
    
    /*****************************************************************************
    * @description: Method to stamp the reject/recall actions on respective fields 
    * @param: sObject Record
    * @return: void 
    */ 
    public static void updateFinalActionsOnRecallOrReject(sObject recordOnApprovalProcess, Boolean bool){
        recordOnApprovalProcess.put(SEQUENCEAPI,0);
        recordOnApprovalProcess.put(IMH_UtilityConstants.PAUSE_APPROVAL_API_NAME,false);
        if(recordOnApprovalProcess.getSObjectType()== IMH_Communication__c.sObjectType){
            recordOnApprovalProcess.put(REVIEWSTAGEAPI,IMH_UtilityConstants.COM_REV_STAGE_DESIGN);
            recordOnApprovalProcess.put(REVIEWSTATUSAPI,IMH_UtilityConstants.COM_INPRO_FOL_REJ_REQ_STATUS);
        }
        else if(recordOnApprovalProcess.getSObjectType()== IMH_CommCreative__c.sObjectType){
            recordOnApprovalProcess.put(CREATIVESTAGE_API,IMH_UtilityConstants.COM_REV_STAGE_DESIGN);
            recordOnApprovalProcess.put(CREATIVESTATUS_API,IMH_UtilityConstants.COM_INPRO_FOL_REJ_REQ_STATUS);
            //Code added as a part of Digital Complicance US.
            Id creativeId = String.valueOf(recordOnApprovalProcess.get('Id'));
            Id commId = [SELECT Id, Communication__c FROM IMH_CommCreative__c WHERE Id =: creativeId LIMIT 1].Communication__c;
            
            
            IMH_Communication__c commRec = [SELECT Id, SYS_IsUnderComplianceReview__c  FROM IMH_Communication__c WHERE 
                                   Id=: commId];
            if (Boolean.valueOf(commRec.get('SYS_IsUnderComplianceReview__c'))) {
                List<IMH_Communication__c> updCommList = new List<IMH_Communication__c>();
                commRec.SYS_IsUnderComplianceReview__c = false;
                updCommList.add(CommRec);
                Database.update(updCommList,true);
            }
        }   
        else if(recordOnApprovalProcess.getSObjectType()== IMH_Benefits__c.sObjectType){
            recordOnApprovalProcess.put(BENEFITSTAGE_API,IMH_UtilityConstants.COM_REV_STAGE_DESIGN);
            recordOnApprovalProcess.put(BENEFITSTATUS_API,IMH_UtilityConstants.COM_INPRO_FOL_REJ_REQ_STATUS);
        }
        if(bool){
             recordOnApprovalProcess.put(SYS_RECALL,bool);
        }
    }
    
    /*****************************************************************************
    * @description: Mehod to update the response by and complete date on communication/campaign/offer/creative
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void 
    */ 
    private  static void updateDeltandTotal(List<IMH_SLATracker__c> ltriggernew
                                                , Map<Id,IMH_SLATracker__c> mtriggernew
                                                 , Map<Id,IMH_SLATracker__c> mtriggerold){ 
        List<IMH_SLATracker__c> lchangesIds = new List<IMH_SLATracker__c>();                                           
        for(IMH_SLATracker__c sobj : ltriggernew){
            if(sobj.Completed__c != NULL 
                    && (mtriggerold.get(sobj.Id).Completed__c != mtriggernew.get(sobj.Id).Completed__c)){
                lchangesIds.add(sobj);
            }
        }
        if(!lchangesIds.isEmpty()){
            IMH_GeneralApplicationUility.deltaCalculation(lchangesIds);                                         
        }                                           
    }
    
    
     /*****************************************************************************
    * @description: Mehod to update the Retreive the answer warning record witht he status "Exception Raised" to "Raise Exception"
    * @param: List<sObject> , Set<String> answerWarningIds
    * @return: void 
    */ 
    public static void retrieveAnswerWarningToUpdate(List<sObject> lSobjectToUpdate
                                                      ,Set<Id> lApprovalWarningRejectionIds){
        for(IMH_SLATracker__c tempSLA : [SELECT Id ,(SELECT Id,Status__c FROM AnswerWarnings__r WHERE Status__c = :IMH_UtilityConstants.EXCEPTION_RAISED )
                                                                                FROM IMH_SLATracker__c WHERE Id IN : lApprovalWarningRejectionIds
                                         LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
            for(IMH_AnswerWarning__c ansWarn : tempSLA.AnswerWarnings__r){
                ansWarn.Status__c = IMH_UtilityConstants.RAISE_EXCEPTION;
                lSobjectToUpdate.add(ansWarn);
            }
        } 
    }
}