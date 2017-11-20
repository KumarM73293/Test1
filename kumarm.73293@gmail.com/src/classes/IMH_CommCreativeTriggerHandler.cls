/**
* @author Accenture IDC 
* @date 06/24/2015
* @group Answer
* @group-content N/A
* @description Trigger Handler on Creative that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/ 
    public without sharing class IMH_CommCreativeTriggerHandler {
        public static Boolean isAfterUpdateExecuted     = false;
        public static Boolean isAfterInsertExecuted     = false;
        public static Boolean isCloned                  = false;
        private static Final String CREATIVE_API        = 'IMH_CommCreative__c';
        private static Final String TARGETEDCHANNEL_API = 'IMH_CreativeChannel__c';
        private static Final String TARGETEDPRODUCT_API = 'IMH_CreativeProduct__c';
        private static final String COMMUNICATION_FIELD = 'Communication__c';
        private static Final String RECALL              = 'Recall';
        private static Final String RECALLED            = 'Recalled';
        private static Final String INPROGRESSREJECTION = 'In Progress (following rejection/recalled)';
        private static Final String REJECT              = 'Reject';
        private static Final String NULL_SPACE          = '';
        private static final String APPROVED            = 'Approved';
        private static final String COMPLETE            = 'Complete';
        private static final String CREATIVE_STAGE      = 'CreativeStage__c';
        private static final String CREATIVE_STATUS     = 'CreativeStatus__c';
        private static final String CREATIVELABEL       = 'Creative';
        private static final String DESIGN_STAGE        = 'Design';
        private static final String ESCALATE_COG        = 'Escalate_to_Central_OG__c';
        private static final String ESCALATE_GCO        = 'Escalate_to_GCO__c';
        private static final String ESCALATE_COMPLIANCE = 'Escalate_to_Insurance_Compliance__c';
        private static final String TARGETEDPRODUCTS    = 'Targeted Product';
        private static final String TARGETEDCHANNEL     = 'Targeted Channels';
        private static final String COMMCREATIVE        = 'CommCreative';
        private static final String REEVALUATE_FIELD_SET_NAME ='IMH_Re_Evaluate_Questionnaire_Fields';
    
        
        /*****************************************************************************
        * @description -  This method is called to create the answer set method on updation of Creative through  General application utility
        * @param - Trigger.New(Creative), Trigger.newMap(sObject),Trigger.OldMap(sObject)
        * @return - void
        */
        public static void handleAfterUpdate(List<IMH_CommCreative__c>ltriggernew
                                                    , Map<Id,sObject> mtriggernew
                                                    , Map<Id,sObject> mtriggerold) {
            //IMH_GeneralApplicationUility.createAnswerSet(ltriggernew,mtriggernew,mtriggerold);
            //Code for Creative Escalation Starts
            List<IMH_CommCreative__c> escalatedCreativeRecsList = new List<IMH_CommCreative__c>();
            List<IMH_CommCreative__c> submittedCreativeRecsList = new List<IMH_CommCreative__c>();
            List<IMH_CommCreative__c> approvedCreativeRecsList = new List<IMH_CommCreative__c>();
            Set<Id> communicationIds = new Set<Id>();                                            
            Boolean isAnswerUpdateRequired = false;
        	Map<sObject,Boolean> creativeUpdateRequiredMap = new Map<sObject,Boolean>();
        	List <Schema.FieldSetMember> reqApproversTriggerField = new List<Schema.FieldSetMember>();
        	reqApproversTriggerField = IMH_GeneralApplicationUility.readFieldSet(REEVALUATE_FIELD_SET_NAME,IMH_UtilityConstants.COMMCREATIVE_OBJECT_API);
            for(IMH_CommCreative__c crRec : ltriggernew ) {
                communicationIds.add(crRec.Communication__c);                                           
                if(((!Boolean.valueOf(mtriggerold.get(crRec.Id).get(ESCALATE_GCO))) && crRec.Escalate_to_GCO__c) ||
                   ((!Boolean.valueOf(mtriggerold.get(crRec.Id).get(ESCALATE_COG))) && crRec.Escalate_to_Central_OG__c) ||
                   ((!Boolean.valueOf(mtriggerold.get(crRec.Id).get(ESCALATE_COMPLIANCE))) && crRec.Escalate_to_Insurance_Compliance__c)) {
                        escalatedCreativeRecsList.add(crRec);
                }
                if((COMPLETE.equalsIgnoreCase(crRec.CreativeStage__c) && 
                                    APPROVED.equalsIgnoreCase(crRec.CreativeStatus__c))
                    || (DESIGN_STAGE.equalsIgnoreCase(crRec.CreativeStage__c) && 
                                    INPROGRESSREJECTION.equalsIgnorecase(crRec.CreativeStatus__c))){
                        approvedCreativeRecsList.add(crRec);
                }
                for(Schema.FieldSetMember field : reqApproversTriggerField) {
                    if(mtriggernew.get(crRec.Id).get(field.getFieldPath()) != mtriggerold.get(crRec.Id).get(field.getFieldPath())) {
                        isAnswerUpdateRequired = true;
                        creativeUpdateRequiredMap.put(crRec,true);
                        break;
                    }
                }
            }
            if(!approvedCreativeRecsList.isEmpty()) {
                IMH_SoftEscalationHandler.processEscalatedRecs(approvedCreativeRecsList, CREATIVE_API, true);
            }
            else if(!escalatedCreativeRecsList.isEmpty()) {
                IMH_SoftEscalationHandler.processEscalatedRecs(escalatedCreativeRecsList, CREATIVE_API, false);
            }
            //Code for Creative Escalation Ends
            //Code for Re-Evaluation of Questionnaire.
            if(isAnswerUpdateRequired) {
            	IMH_ReEvaluateQuestionnaireHandler.reEvaluate(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API, creativeUpdateRequiredMap);                                        
        	}
			//COMMENTED SINCE WE DON'T HAVE ANY SCENARIO QUESTIONNAIRE DEPENDING ON CREATIVE FIELDS 
            /**if(!Test.isRunningTest()){
                IMH_GeneralApplicationUility.updateAnswerStatus(ltriggernew,mtriggernew,communicationIds,CREATIVELABEL,IMH_UtilityConstants.COMMCREATIVE_OBJECT_API);                                                        
            }**/
        }
        /*****************************************************************************
        * @description -  This method is called to create the answer set method on insertion of Creative through  General application utility
        * @param - Trigger.New(Campaign), Trigger.newMap(sObject),Trigger.OldMap(sObject)
        * @return - void
        */
public static void handleAfterInsert(List<IMH_CommCreative__c>ltriggernew
                                             , Map<Id,sObject> mtriggernew
                                             , Map<Id,sObject> mtriggerold){
            Set<Id> communicationIds = new Set<Id>();                                             
            for(sObject sObj :ltriggernew){
                communicationIds.add(String.valueOf(sObj.get(COMMUNICATION_FIELD)));
            }
            Map<Id,Id> mapOfCloneIds = new Map<Id,Id>();                                     
                 for(Sobject sobj:ltriggernew) {
                    if(sobj.isClone()){
                        mapOfCloneIds.put(sobj.getCloneSourceId(),sobj.Id);

                 }
                }
           if(!mapOfCloneIds.isEmpty()) {
               IMH_DeepClone.constructGrandChildren(mapOfCloneIds);                                      

           }
            if(!isCloned){
                System.debug('*****ABC ');
               insertCreativeProdChannel(ltriggernew,mtriggernew,mtriggerold,COMMCREATIVE); 
            } 
                                                 //insertCreativeProdChannel(ltriggernew,mtriggernew,mtriggerold);
        }
        
        
        
           /*****************************************************************************
        * @description -  This method is called to create Creative Products/Channels fromTargeted Products/Channels at the time of insert
        * @param - Trigger.New(Campaign), Trigger.newMap(sObject),Trigger.OldMap(sObject)
        * @return - void
        */
        public static void insertCreativeProdChannel(List<sObject> ltriggernew
                                                     , Map<Id,sObject> mtriggernew
                                                     , Map<Id,sObject> mtriggerold
                                                     , String objecttype){
             List<ID> lCommunicationId = new List<ID>();
             List<Sobject> linsertprodchannel = new List<Sobject>();
                                                         
             Map<Id,List<IMH_CommChannels__c>> mcommunicationchannel = new Map<Id,List<IMH_CommChannels__c>>();
             Map<Id,List<IMH_CommProducts__c>> mcommunicationproducts = new Map<Id,List<IMH_CommProducts__c>>(); 
                                                         
              for(sObject sObj :ltriggernew){
                lCommunicationId.add(String.valueOf(sObj.get(COMMUNICATION_FIELD)));

                 
            }
                                                         
                                                         
            //This part of method is used for inserting Creative Products either on Creation of Creative or Targeted Channels  
            if(!objecttype.equalsIgnoreCase(TARGETEDPRODUCTS)){
                System.debug('***** 1 '+objecttype);
                List<IMH_CommChannels__c> lcommChannels = new List<IMH_CommChannels__c>();
           //The if else below is used to identify the place from where we need to pick the Targeted Products for creating the Map
            if(objecttype.equalsIgnoreCase(TARGETEDCHANNEL)){
                //Used at the time when Targeted channel through Creative Channel or fter Creative was added
                lcommChannels = mtriggernew.values();
                 System.debug('***** 1.2 ');
            }
            else{
                lcommChannels    =    [SELECT Id,
                                              Channel__c,
                                              Communication__c,
                                              Channel_End_Date__c,
                                              Channel_Start_Date__c,
                                       SYS_UICreated__c
                                              FROM IMH_CommChannels__c
                                               WHERE Communication__c IN:lCommunicationId];
            }
                 System.debug('***** 2 '+lcommChannels);
            //Making map of Communication and Communication Channel Associated to it
            for(IMH_CommChannels__c cchannels:lcommChannels){
                if(cchannels.SYS_UICreated__c != TRUE) {                       
                        if(mcommunicationchannel.containsKey(cchannels.Communication__c)){
                            List<IMH_CommChannels__c> lchannels = mcommunicationchannel.get(cchannels.Communication__c);
                            lchannels.add(cchannels);
                            mcommunicationchannel.put(cchannels.Communication__c,lchannels);                    
                       }
                       else{
                           mcommunicationchannel.put(cchannels.Communication__c,new List<IMH_CommChannels__c> {cchannels});                                
                       }
                }
              }                                          

              //Adding Creative Channels 
               
              IMH_CreativeChannel__c creativechannel; 
              if(!mcommunicationchannel.isEmpty()){
                 List<IMH_CommCreative__c> lcommcreative = new List<IMH_CommCreative__c>();

                 //The if else below is used to identify the place from where we need to pick the Crative for creating the Creative Channels
                 if(!objecttype.equalsIgnoreCase(TARGETEDCHANNEL)){
                     lcommcreative = mtriggernew.values();
                 }
                 else{
                     lcommcreative = [SELECT ID,
                                             Communication__c
                                      FROM IMH_CommCreative__c
                                      WHERE Communication__c IN:lCommunicationId];
                 }

             for(Sobject comm: lcommcreative){


				if(mcommunicationchannel.get(String.valueof(comm.get(COMMUNICATION_FIELD)))!=NULL){
                     for(IMH_CommChannels__c commchannel:mcommunicationchannel.get(String.valueof(comm.get(COMMUNICATION_FIELD)))){
                          creativechannel = new IMH_CreativeChannel__c();
                          creativechannel.Channel_End_Date__c = commchannel.Channel_End_Date__c;
                          creativechannel.Channel_Start_Date__c = commchannel.Channel_Start_Date__c;
                          creativechannel.Creative__c = comm.Id;
                          //creativechannel.Channel__c = commchannel.Channel__c;
                          creativechannel.TargetedChannel__c  = commchannel.Id;
                          linsertprodchannel.add(creativechannel);
                 	} 


                }
             }
          }
        }
        
                                                         
                                                         
                                                         
     //This part of method is used for inserting Creative Products either on Creation of Creative or Targeted Products                                                  
                                                         
       if(!objecttype.equalsIgnoreCase(TARGETEDCHANNEL)){
            //Used at the time when Targeted channel through Creative Channel or fter Creative was added

            List<IMH_CommProducts__c> lcommProds = new List<IMH_CommProducts__c>();
           //The if else below is used to identify the place from where we need to pick the Targeted Products for creating the Map
            if(objecttype.equalsIgnoreCase(TARGETEDPRODUCTS)){

                lcommProds = mtriggernew.values();
            }
            else{
                lcommProds    =    [SELECT Id,
                                           Product__c,
                                           Communication__c,
                                           Market__c,
                                           NotRequired__c,
                                    SYS_UICreated__c
                                     FROM IMH_CommProducts__c
                                     WHERE Communication__c IN:lCommunicationId];
            }
            //Making map of Communication and Communication Products Associated to it
               for(IMH_CommProducts__c cproduts:lcommProds){
                   if(cproduts.SYS_UICreated__c != TRUE){                           
                        if(mcommunicationproducts.containsKey(cproduts.Communication__c)){
                            List<IMH_CommProducts__c> lproducts = mcommunicationproducts.get(cproduts.Communication__c);
                            lproducts.add(cproduts);
                            mcommunicationproducts.put(cproduts.Communication__c,lproducts);                    
                       }
                       else{
                           mcommunicationproducts.put(cproduts.Communication__c,new List<IMH_CommProducts__c> {cproduts});                                
                       }
                    }
                }  
           //Adding Creative Products                                              
             IMH_CreativeProduct__c creativeproducts;
            if(!mcommunicationproducts.isEmpty()){
                List<IMH_CommCreative__c> lcommcreative = new List<IMH_CommCreative__c>();
                 //The if else below is used to identify the place from where we need to pick the Crative for creating the Creative Products
                 if(!objecttype.equalsIgnoreCase(TARGETEDPRODUCTS)){
                     lcommcreative = mtriggernew.values();
                 }
                 else{
                     lcommcreative = [SELECT ID,
                                             Communication__c
                                      FROM IMH_CommCreative__c
                                      WHERE Communication__c IN:lCommunicationId];
                 }
            for(Sobject comm: lcommcreative){
				if(mcommunicationproducts.get(String.valueof(comm.get(COMMUNICATION_FIELD)))!=NULL){
					 for(IMH_CommProducts__c commproducts:mcommunicationproducts.get(String.valueof(comm.get(COMMUNICATION_FIELD)))){
							  creativeproducts = new IMH_CreativeProduct__c();
							  creativeproducts.NotRequired__c = commproducts.NotRequired__c;
							  creativeproducts.Market__c = commproducts.Market__c;
							  creativeproducts.Creative__c = comm.Id;
							  //creativeproducts.Product__c = commproducts.Product__c;
							  creativeproducts.TargetedProduct__c  = commproducts.Id;
							  linsertprodchannel.add(creativeproducts);
					 }
                }
             }
            }
          }
        
       //used to Insert The Targeted Products/Channels                                                  
         if(!linsertprodchannel.isEmpty()){

                   Database.insert(linsertprodchannel,true);                                          
       }                                             
  }
        /*****************************************************************************
        * @description -  This method is called to change the status of Communication once all the creatives are approved.
        * @param - Trigger.New(Campaign), Trigger.newMap(sObject),Trigger.OldMap(sObject)
        * @return - void
        */
        /*
        public static void changeCommunicationStatus(List<IMH_CommCreative__c>ltriggernew
                                             , Map<Id,sObject> mtriggernew
                                             , Map<Id,sObject> mtriggerold){
                                                 
        SET <Id> setcamp = new SET<Id>();
        List<IMH_Communication__c> lupdatedcommunication = new List<IMH_Communication__c>();
        Map<Id,List<IMH_CommCreative__c>> mcampcreative = new Map<Id,List<IMH_CommCreative__c>>(); 
        Set<Id> setstatuscamp = new Set<Id>();                                         
        for(ID sobj:mtriggernew.keySet()){
                  if( mtriggerold.get(sobj).get('CreativeStatus__c')!= mtriggernew.get(sobj).get('CreativeStatus__c')
                    && (String.valueof(mtriggernew.get(sobj).get('CreativeStatus__c')).equalsIgnoreCase('Approved')
                       || String.valueof(mtriggernew.get(sobj).get('CreativeStatus__c')).equalsIgnoreCase('Cancelled'))) {
                           setcamp.add(String.valueof(mtriggernew.get(sobj).get('Campaign__c')));   
                     }                                  
        }
        for(IMH_CommCreative__c creative: [SELECT Id,
                                              CreativeStatus__c,
                                              Campaign__c
                                       FROM IMH_CommCreative__c
                                       WHERE Campaign__c IN :setcamp]){
                                           if(mcampcreative.containsKey(creative.Campaign__c)){
                                               List<IMH_CommCreative__c> lcreative = mcampcreative.get(creative.Campaign__c);
                                               lcreative.add(creative);
                                               mcampcreative.put(creative.Campaign__c,lcreative);
                                           }
                                           else{
                                               mcampcreative.put(creative.Campaign__c,new List<IMH_CommCreative__c> {creative});                             
                                           }                               
        }
        for(Id camp : setcamp){
             Integer totalcount = 0;
             Integer approvedcount = 0;
             Integer cancelledcount = 0;
             for(IMH_CommCreative__c countcreative : mcampcreative.get(camp)){
                 totalcount ++;
                 if(countcreative.CreativeStatus__c.equalsIgnoreCase('Approved')){
                     approvedcount ++;                             
                 }
                 else if(countcreative.CreativeStatus__c.equalsIgnoreCase('Cancelled')){
                     cancelledcount ++;                              
                 }
                  
             }
             if(approvedcount > 0 && (totalcount == (approvedcount + cancelledcount))){
                     setstatuscamp.add(camp); 
                 } 
        }                                         
        for(IMH_Communication__c communication: [SELECT ID,
                                              ReviewStage__c,
                                              RequestStatus__c,
                                              ApprovalStage__c
                                     FROM IMH_Communication__c
                                      WHERE ID IN:setstatuscamp]){
               communication.ReviewStage__c = 'Design';
               communication.ApprovalStage__c = 'Pre-Execution Testing';
               communication.RequestStatus__c = 'In Progress'; 
               lupdatedcommunication.add(communication);                           
        }
        if(!lupdatedcommunication.isEmpty()){
            Database.update(lupdatedcommunication);                                          
        }                                        
    }
    */
}