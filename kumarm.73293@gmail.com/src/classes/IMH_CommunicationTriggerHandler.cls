/**
* @author Accenture IDC 
* @date 05/26/2015
* @group Answer
* @group-content N/A
* @description Trigger Handler on Communication that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/ 
    public without sharing class IMH_CommunicationTriggerHandler {
        private static final String COMMUNICATION_STATUS            = 'ReviewStatus__c';
        private static final String RECALLED                        = 'Recalled due to cancellation';
        private static final String CANCELLED                       = 'Cancelled';
        private static final String REMOVED                         = 'Removed';
        private static final String COMMUNICATION_STAGE             = 'ProcessStage__c';
        private static final String CONCEPT_STAGE                   = 'Concept';
        private static Final String RECALLED_STATUS                 = 'Recalled';
        private static Final String COMMUNICATION_API               = 'IMH_Communication__c';
        private static final String ESCALATE_CENTRALOG_API          = 'Escalate_to_Central_OG__c';
        private static final String SYS_READYFORREV_API             = 'SYS_Ready_For_Review__c';
        public static Boolean isExecutedAfter                       = false;
        public static Boolean iscreatedAnswerSet                    = false;
        private static final String COMPLETE                        = 'Complete';
        private static final String PROCESS_STAGE                   = 'ProcessStage__c';
        private static final String REVIEW_STAGE                    = 'ReviewStage__c';
        private static final String CREATIVE_PROCESS                = 'Creative';
        private static final String REJECT_OR_RECALL                = 'In Progress (following rejection/recalled)';
        private static final String REVIEW_STATUS                   = 'ReviewStatus__c';
        private static final String DESIGN_STAGE                    = 'Design';
        private static Final String ERROR_MESSAGE = 'Please note that a communication can only be cloned once it is approved.';
        private static final String SYS_CENTRALBENEFITS = 'SYS_CentralPreApprovedBenefits__c';
        private static final String BENEFITSTEAM = 'Benefits Team';
        private static final String BENEFITSTEAMSEMI = 'Benefits Team;';
        private static final String SEMIBENEFITSTEAM = ';Benefits Team';
        private static final String REEVALUATE_FIELD_SET_NAME ='IMH_Re_Evaluate_Questionnaire_Fields';
        
        
        
        
         /*****************************************************************************
    * @description: Mehod called on before insert of trigger event
    * @param: Trigger.New,Trigger.NewMap
    * @return: void
    */
    public static void handleBeforeInsert(List<sObject> ltriggernew
                                         , Map<Id,sObject> mtriggernew){
        for(Sobject sobj:ltriggernew) {
            if(sobj.isClone()){
                IMH_DeepClone.createCommuincation(sobj);
                }
        }
    }
    /*****************************************************************************
    * @description: Mehod called on after update of trigger event
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
    public static void handleAfterUpdate(List<sObject> ltriggernew
                                         , Map<Id,sObject> mtriggernew
                                         , Map<Id,sObject> mtriggerold){
        if(!IMH_CommunicationTriggerHandler.iscreatedAnswerSet){
           IMH_GeneralApplicationUility.createAnswerSet(ltriggernew,mtriggernew,mtriggerold);
        }    
        List<sObject> escalatedCommunicationList = new List<sObject>();
        List<sObject> submittedCommunicationList = new List<sObject>();
        List<sObject> approvedCommunicationList = new List<sObject>();
        for(sObject commRec: ltriggernew) {
            if(Boolean.valueOf(commRec.get(ESCALATE_CENTRALOG_API)) &&
               (mtriggernew.get(commRec.Id).get(ESCALATE_CENTRALOG_API) != 
                mtriggerold.get(commRec.Id).get(ESCALATE_CENTRALOG_API))) {
                escalatedCommunicationList.add(commRec);
            }
            if(( CREATIVE_PROCESS.equalsIgnoreCase(String.valueOf(commRec.get(PROCESS_STAGE)))
                  && DESIGN_STAGE.equalsIgnoreCase(String.valueOf(commRec.get(REVIEW_STAGE)))) 
               || (CONCEPT_STAGE.equalsIgnoreCase(String.valueOf(commRec.get(PROCESS_STAGE)))
                   && REJECT_OR_RECALL.equalsIgnorecase(String.valueOf(commRec.get(REVIEW_STATUS))))) {
                approvedCommunicationList.add(commRec);
            }
        }
        if(!approvedCommunicationList.isEmpty()){
            IMH_SoftEscalationHandler.processEscalatedRecs(approvedCommunicationList, COMMUNICATION_API, true);
        }
        else if(!escalatedCommunicationList.isEmpty()){
            IMH_SoftEscalationHandler.processEscalatedRecs(escalatedCommunicationList, COMMUNICATION_API, false);
        }
    }
    
   /*****************************************************************************
    * @description: Mehod called on after insert of trigger event
    * @param: Trigger.New,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */
     public static void handleAfterInsert(List<sObject>ltriggernew
                                          , Map<Id,sObject> mtriggernew
                                          , Map<Id,sObject> mtriggerold){
        IMH_GeneralApplicationUility.createAnswerSet(ltriggernew,mtriggernew
                                                     , new Map<Id,IMH_Communication__c>());
        IMH_StampMandatoryApprovers.updateCommunicationWithMandatoryApprovers(ltriggernew);
         Map<Id,Id> mapOfCloneIds = new Map<Id,Id>();                                     
         for(Sobject sobj:ltriggernew) {
            if(sobj.isClone()){
                mapOfCloneIds.put(sobj.getCloneSourceId(),sobj.Id);
         }
        }
        if(!mapOfCloneIds.isEmpty()) {                                      
        IMH_DeepClone.constructChildren(mapOfCloneIds); 
         }
    }
        /*****************************************************************************
    * @description -  Used to add Benefits Team when Pre Approved benefits is selected.
    * @param - Trigger.New(Communication), Trigger.newMap(Communication),Trigger.OldMap(Communication)
    * @return - void
    */   
    public static void updateRequiredApprover(List<IMH_Communication__c>ltriggernew
                                                  , Map<Id,IMH_Communication__c> mtriggernew
                                                  , Map<Id,IMH_Communication__c> mtriggerold){
        SET<ID> setcomms = new SET<ID>();
        SET<ID> setremovecomms = new SET<ID>();                                            
        Boolean isAnswerUpdateRequired = false;
        Map<Sobject,Boolean> commUpdateRequiredMap = new Map<Sobject,Boolean>();
        List <Schema.FieldSetMember> reqApproversTriggerField = new List<Schema.FieldSetMember>();
        reqApproversTriggerField = IMH_GeneralApplicationUility.readFieldSet(REEVALUATE_FIELD_SET_NAME,IMH_UtilityConstants.COMMUNICATION_OBJECT_API);
        for(IMH_Communication__c comm : ltriggernew){
            if(Integer.valueOf(mtriggerold.get(comm.Id).get(SYS_CENTRALBENEFITS)) == 0   
                && Integer.valueOf(mtriggernew.get(comm.Id).get(SYS_CENTRALBENEFITS)) > 0
                && Integer.valueOf(mtriggerold.get(comm.Id).get(SYS_CENTRALBENEFITS)) != Integer.valueOf(mtriggernew.get(comm.Id).get(SYS_CENTRALBENEFITS))){
                    setcomms.add(comm.Id);
            }
            else if(Integer.valueOf(mtriggerold.get(comm.Id).get(SYS_CENTRALBENEFITS)) > 0
                      && Integer.valueOf(mtriggernew.get(comm.Id).get(SYS_CENTRALBENEFITS)) == 0){
                          setremovecomms.add(comm.Id);
            }
            for(Schema.FieldSetMember field : reqApproversTriggerField) {
                if(mtriggernew.get(comm.Id).get(field.getFieldPath()) != mtriggerold.get(comm.Id).get(field.getFieldPath())) {
                    isAnswerUpdateRequired = true;
                    commUpdateRequiredMap.put(comm,true);
                    break;
                }
            }
        }
        /* Code for Re-Evaluation of Questionnaire */
        if(isAnswerUpdateRequired) {
            IMH_ReEvaluateQuestionnaireHandler.reEvaluate(IMH_UtilityConstants.COMMUNICATION_OBJECT_API, commUpdateRequiredMap);
        }
        /* Code for Restamping of Required Approvers based on Central Benefit being added or removed.*/
        List<IMH_Communication__c> lcomms = new List<IMH_Communication__c>();
        if(!setcomms.isEmpty()) {                            
            for(IMH_Communication__c comms:[SELECT ID,
                                             RequiredApprovers__c
                                             FROM IMH_Communication__c
                                             WHERE ID IN:setcomms]){
                if(String.isBlank(comms.RequiredApprovers__c)){
                            comms.RequiredApprovers__c =BENEFITSTEAMSEMI;  
                            lcomms.add(comms);
                }                             
                else if(!comms.RequiredApprovers__c.containsIgnoreCase(BENEFITSTEAM)) { 
                         comms.RequiredApprovers__c +=SEMIBENEFITSTEAM; 
                         lcomms.add(comms);
                 }  
            }
        }
        else if(!setremovecomms.isEmpty()) {
            for(IMH_Communication__c comms:[SELECT ID,
                                                  RequiredApprovers__c
                                                  FROM IMH_Communication__c
                                                  WHERE ID IN:setremovecomms]){
                    comms.RequiredApprovers__c =comms.RequiredApprovers__c.remove(BENEFITSTEAM); 
                    lcomms.add(comms);
            }                                           
        }                                           
        if(!lcomms.isEmpty()){
          Database.update(lcomms);                                            
        }
    } 
    
    /*****************************************************************************
    * @description -  Used to recall all the offers and creative once the communication gets cancelled depending 
    *                 on which stage communication presently is in.
    * @param - Trigger.New(Communication), Trigger.newMap(Communication),Trigger.OldMap(Communication)
    * @return - void
    */    
        public static void recallOffersOnCancellation(List<IMH_Communication__c>ltriggernew
                                                      , Map<Id,IMH_Communication__c> mtriggernew
                                                      , Map<Id,IMH_Communication__c> mtriggerold){
          /*  Set<ID>scommunication = new Set<ID>();
            List<IMH_Incentive__c> loffer = new List<IMH_Incentive__c>();
            List<Approval.ProcessWorkitemRequest> lprocess = new List<Approval.ProcessWorkitemRequest>();
            List<IMH_CommCreative__c> lcreative = new List<IMH_CommCreative__c>();
            // ITERATE THROUGH THE TRIGGER NEW VALUES 
             if(mtriggernew != null && !mtriggernew.isEmpty()){
                 for(Id camp:mtriggernew.keySet()){
                     if(mtriggerold.isEmpty() 
                        && (String.valueof(mtriggernew.get(camp).get(COMMUNICATION_STATUS)).equalsIgnoreCase(CANCELLED))
                        || (mtriggerold.get(camp)!=null
                             && (String.valueof(mtriggernew.get(camp).get(COMMUNICATION_STATUS)).equalsIgnoreCase(CANCELLED))
                             && (String.valueof(mtriggernew.get(camp).get(COMMUNICATION_STAGE)).equalsIgnoreCase(CONCEPT_STAGE))
                             && mtriggerold.get(camp).get(COMMUNICATION_STATUS)!= mtriggernew.get(camp).get(COMMUNICATION_STATUS)))
                     {
                         scommunication.add(camp);
                     }
                     else if(mtriggerold.isEmpty() 
                        || (mtriggerold.get(camp)!=null
                             && (String.valueof(mtriggernew.get(camp).get(COMMUNICATION_STATUS)).equalsIgnoreCase(CANCELLED))
                             && !(String.valueof(mtriggernew.get(camp).get(COMMUNICATION_STAGE)).equalsIgnoreCase(CONCEPT_STAGE))
                             && mtriggerold.get(camp).get(COMMUNICATION_STATUS)!= mtriggernew.get(camp).get(COMMUNICATION_STATUS)))
                     {
                         scommunication.add(camp);
                     }
                     
                 }
             }
             // GET ALL OFFERS LIST RELATED TO COMMUNICATION WHICH HAS BEEN CANCELLED
            if(!scommunication.isEmpty()){
               loffer = [Select Id
                         FROM IMH_Incentive__c
                         WHERE Communication__c IN:scommunication
                         LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
                
               lcreative = [Select Id
                            FROM IMH_CommCreative__c
                            WHERE Communication__c IN:sCommunication
                            LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
                
            }
            //GET THE APPROVAL PROCESS IF ANY APPLIED ON OFFER LEVEL
            Approval.ProcessWorkitemRequest workitem;
            if(!loffer.isEmpty()){
                for(ProcessInstanceWorkitem proc: [SELECT Id
                                                          , ProcessInstanceId
                                                          , ProcessInstance.TargetObjectId
                                                    FROM ProcessInstanceWorkitem 
                                                    WHERE ProcessInstance.TargetObjectId IN:loffer
                                                    LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){ 
                    workitem = new Approval.ProcessWorkitemRequest();
                    workitem.setComments(RECALLED);
                    workitem.setAction(REMOVED);
                    workitem.setWorkitemId(proc.Id);
                    lprocess.add(workitem);                                      
               } 
            }
            if(!lcreative.isEmpty() && lcreative != NULL){
                for(ProcessInstanceWorkitem proc: [SELECT Id
                                                          , ProcessInstanceId
                                                          , ProcessInstance.TargetObjectId
                                                    FROM ProcessInstanceWorkitem 
                                                    WHERE ProcessInstance.TargetObjectId IN:lcreative
                                                    LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){ 
                    workitem = new Approval.ProcessWorkitemRequest();
                    workitem.setComments(RECALLED);
                    workitem.setAction(REMOVED);
                    workitem.setWorkitemId(proc.Id);
                    lprocess.add(workitem);                                      
               } 
                                                         
            }
           // RECALLING THE APPROVAL PROCESS TO SET THE STATUS TO RECALLED ON ALL OFFERS AND Creatives                                              
             if(!lprocess.isEmpty()){
                    Approval.process(lprocess,false);
                }   */                                           
        }
}