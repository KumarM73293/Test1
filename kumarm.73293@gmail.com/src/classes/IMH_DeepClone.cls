/**
* @author Accenture IDC 
* @date 03/18/2016
* @group-content N/A
* @description:iMH Release 1.4 (Sprint 32) It is used to clone the child and grandchild records from the original records
*/
public with sharing class IMH_DeepClone {
   public static String constructQueryObj1 = IMH_UtilityConstants.EMPTY_STRING;
   public static String constructQueryObj2 = IMH_UtilityConstants.EMPTY_STRING;
   public static String constructQueryObj3 = IMH_UtilityConstants.EMPTY_STRING;
   public static String constructQueryObj4 = IMH_UtilityConstants.EMPTY_STRING;
   public static String constructQueryObj5 = IMH_UtilityConstants.EMPTY_STRING;         
   private static final String UNIQUEAPPROVALAPI = 'UniqueApprovalCode__c';
   private static final String SUBMITTERAPI = 'Submitter__c';
   private static final String REVIEWSTAGEAPI = 'ReviewStage__c';
   private static final String REVIEWSTATUS = 'ReviewStatus__c';
   private static final String CANCELAPI = 'CommunicationCancellationReason__c';
   private static final String PROCESTAGEAPI = 'ProcessStage__c';
     private static final String REQUIREDAPPROVER_API = 'RequiredApprovers__c';
   private static final String STAGEAPI = 'Stage__c';
   private static final String CONCEPTDESIGN = 'Concept - Design';
   private static final String CREATIVEDESIGN = 'Creative - Design';
   private static final String SINGLESERVICING = 'ServicingCommunicationConcept';
   private static final String SINGLEMARKETING = 'SingleMarketing';
   private static final String MIXED = 'Multiple';
   private static final String OTHERCOMMS = 'Other_Communications';
   private static final String CREATIVEDESIGNRECORDTYPE = 'CreativeDesign';
   private static final String RECORDTYPEID = 'RecordTypeId';
   private static final String CREATIVEREL = 'Creative__r';
   private static final String INCENTIVEREL = 'Incentives__r';
   private static final String PREAPPROVEDREL = 'PreApprovedBenefits__r';
   private static final String TARGETEDPRODUCTREL = 'Targeted_Products__r';
   private static final String TARGETEDCHANNELREL = 'Targeted_Channels__r';
   private static final String TARGETEDCOMMPRODUCTREL = 'CommunicationProducts__r';
   private static final String TARGETEDCOMMCHANNELREL = 'CommunicationChannel__r';
   private static final String COMMUNICATIONRECORDTYPE_API = 'CommunicationRecordType__c';
   private static final String MARKETINGCOMMS = 'Marketing Communication';
   private static final String MIXEDCOMMS     =  'Mixed Communications';
   private static final String SERVICINGCOMMS = 'Servicing Communication';
   private static final String OTHERCOMMUNICATIONS     = 'Other Communications';
   private static final String WHEREQUERY_CREATVE = ' WHERE (CreativeStatus__c = \'Approved\' OR (CreativeStage__c = \'Complete\' AND   CreativeStatus__c = \'Cancelled\' AND CreativeReviewCancellationReason__c = \'Expired\'))';
   private static final String WHEREQUERY_Communication = ' WHERE Id IN: setComms';
   private static final String WHEREQUERY_Creative = ' WHERE Id IN: setComms';
   private static final String WHEREQUERY_Prod = ' WHERE Product__r.Active__c = true';
   private static final String WHEREQUERY_Channel = ' WHERE Channel__r.Active__c = true';
   private static final String WHEREQUERY_CreativeProd = ' WHERE TargetedProduct__r.Product__r.Active__c = true';
   private static final String WHEREQUERY_CreativeChannel = ' WHERE TargetedChannel__r.Channel__r.Active__c = true';
   private static final String WHEREQUERY_INCENTIVE      = ' WHERE ((IncentiveStatus__c  = \'Approved\' OR (IncentiveStatus__c  = \'Cancelled\' AND IncentiveCancellationReason__c = \'Expired\')) AND RecordType.Name != \'Message\')';
    
    /*****************************************************************************
    * @description -  It is called on before insert context of trigger of Communication when it is cloned.
    * @param - Sobject (Communication)
    * @return - void
    */
   /*--------PEER REVIEW  - KUMAR 13062016
     * DECLARE ALL VARIABLES AT TOP OF THE METHOD - 
     * REMOVE ALL DEBUG STATEMENTS - 
     * GIVE COMMENTS TO THE CODE WRITTEN
     */ 
   public static void createCommuincation(Sobject sobj){
             User use = [SELECT Id,IMH_User_Team__c From User Where Id = :UserInfo.getUserId()];
             sobj.put(UNIQUEAPPROVALAPI,IMH_UtilityConstants.EMPTY_STRING);
             sobj.put(REQUIREDAPPROVER_API,IMH_UtilityConstants.EMPTY_STRING); 
             sobj.put(SUBMITTERAPI,UserInfo.getUserId());
             sobj.put(REVIEWSTAGEAPI,IMH_UtilityConstants.COM_REV_STAGE_DESIGN);
             sobj.put(CANCELAPI,IMH_UtilityConstants.EMPTY_STRING);
             sobj.put(REVIEWSTATUS,IMH_UtilityConstants.CAMPAIGN_INPROGRESS);
             // STAMPING SUBMITTERS TEAM DURING INSERT SINCE USER TEAM DOESN'T GET REFLECTED IN QUESTIONNAIRE ENTRY CRITERIA WITH THE WORKLFOW UPDATE  - TRANSACTION ISSUE
             if(use.IMH_User_Team__c!=NULL){
                 sobj.put('Submitters_Team__c',use.IMH_User_Team__c);
             }
             if(sobj.get(RECORDTYPEID) == IMH_GeneralApplicationUility.mRecordType.get(IMH_UtilityConstants.COMMUNICATION_OBJECT_API).get(SINGLEMARKETING).Id) 
             {
               sobj.put(COMMUNICATIONRECORDTYPE_API,MARKETINGCOMMS);  
               sobj.put(RECORDTYPEID,IMH_GeneralApplicationUility.mRecordType.get(IMH_UtilityConstants.COMMUNICATION_OBJECT_API).get(SINGLEMARKETING).Id);
               sobj.put(PROCESTAGEAPI,IMH_UtilityConstants.CONCEPT);
               sobj.put(STAGEAPI,CONCEPTDESIGN);
             }
            else if(sobj.get(RECORDTYPEID) == IMH_GeneralApplicationUility.mRecordType.get(IMH_UtilityConstants.COMMUNICATION_OBJECT_API).get(MIXED).Id) {
               sobj.put(COMMUNICATIONRECORDTYPE_API,MIXEDCOMMS); 
               sobj.put(RECORDTYPEID,IMH_GeneralApplicationUility.mRecordType.get(IMH_UtilityConstants.COMMUNICATION_OBJECT_API).get(MIXED).Id);
               sobj.put(PROCESTAGEAPI,IMH_UtilityConstants.CONCEPT);
               sobj.put(STAGEAPI,CONCEPTDESIGN);
            }
            else if(sobj.get(RECORDTYPEID) == IMH_GeneralApplicationUility.mRecordType.get(IMH_UtilityConstants.COMMUNICATION_OBJECT_API).get(SINGLESERVICING).Id) {
               sobj.put(COMMUNICATIONRECORDTYPE_API,SERVICINGCOMMS);
               sobj.put(RECORDTYPEID,IMH_GeneralApplicationUility.mRecordType.get(IMH_UtilityConstants.COMMUNICATION_OBJECT_API).get(SINGLESERVICING).Id);
               sobj.put(PROCESTAGEAPI,IMH_UtilityConstants.CONCEPT);
               sobj.put(STAGEAPI,CONCEPTDESIGN);
            }
            else if(sobj.get(RECORDTYPEID) == IMH_GeneralApplicationUility.mRecordType.get(IMH_UtilityConstants.COMMUNICATION_OBJECT_API).get(OTHERCOMMS).Id) {
               sobj.put(COMMUNICATIONRECORDTYPE_API,OTHERCOMMUNICATIONS);
               sobj.put(PROCESTAGEAPI,IMH_UtilityConstants.CREATIVE);
               sobj.put(STAGEAPI,CREATIVEDESIGN);
                
            }
        }
    /*****************************************************************************
    * @description -  It is called on after insert context of trigger of Communication when it is cloned and is used to clone the children of Communication 
    *                   i.e Creative,Incentive,Pre Approved Benefits
    * @param - Map<Id,Id>
    * @return - void
    */
    /*--------PEER REVIEW  - KUMAR 13062016
     * DECLARE ALL VARIABLES AT TOP OF THE METHOD - 
     * REMOVE UNUSED VARIABLES 
     * REMOVE ALL DEBUG STATEMENTS - 
     * GIVE COMMENTS TO THE CODE WRITTEN
     */ 
    public static void constructChildren(Map<Id,Id> mapConstructChild){
        SET<Id> setComms = new SET<ID>();
        setComms = mapConstructChild.keyset();
        List<sObject> lupdatesobjectlist = new List<sObject>();
        
         List<Sobject> listprodschannels = new List<Sobject>();
        
         //Incentives Variables
        List<IMH_Incentive__c> newInceList = new List<IMH_Incentive__c>();
         List<IMH_Incentive__c> updateInceList = new List<IMH_Incentive__c>();
       // 
       // Pre Approved Benefit Variables
        List<IMH_PreApprovedBenefits__c> newPreApprovedeList  = new List<IMH_PreApprovedBenefits__c>();
        List<IMH_PreApprovedBenefits__c> updatepreApproved = new List<IMH_PreApprovedBenefits__c>();
        
        //Creative Variables
        List<IMH_CommCreative__c> newCreList = new List<IMH_CommCreative__c>();
        List<IMH_CommCreative__c> updateCreatList = new List<IMH_CommCreative__c>();
        
        //Targeted Product Variables
         Map<Id,List<IMH_CreativeChannel__c>> mapCommChannelsCreativechannel = new Map<Id,List<IMH_CreativeChannel__c>>();
        List<IMH_CommChannels__c> newChannelList = new List<IMH_CommChannels__c>();
        List<IMH_CommChannels__c> updateChannelList = new List<IMH_CommChannels__c>();
        List<IMH_CommChannels__c> lvalidChannelList = new List<IMH_CommChannels__c>();
        
        //Targeted Channel Variables
        Map<Id,List<IMH_CreativeProduct__c>> mapCommProductsCreativeProd = new Map<Id,List<IMH_CreativeProduct__c>>();
        List<IMH_CommProducts__c> newProductList = new List<IMH_CommProducts__c>();
        List<IMH_CommProducts__c> updateProductList = new List<IMH_CommProducts__c>();
        List<IMH_CommProducts__c> lvalidproductslist = new List<IMH_CommProducts__c>();
        
       
         Map<Id,IMH_Communication__c> mapDates = new Map<Id,IMH_Communication__c>();
        
        String sobjectCreatives = IMH_GeneralApplicationUility.fetchAllFieldsClone(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API,IMH_UtilityConstants.EMPTY_STRING);
        constructQueryObj1 = sobjectCreatives.replace(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API, CREATIVEREL) + WHEREQUERY_CREATVE;
        String sobjectIncentives = IMH_GeneralApplicationUility.fetchAllFieldsClone(IMH_UtilityConstants.INCENTIVE_OBJECT_API,IMH_UtilityConstants.EMPTY_STRING);
        constructQueryObj2 = sobjectIncentives.replace(IMH_UtilityConstants.INCENTIVE_OBJECT_API, INCENTIVEREL) + WHEREQUERY_INCENTIVE;
        String sobjectpreApprovedBenefits = IMH_GeneralApplicationUility.fetchAllFieldsClone(IMH_UtilityConstants.PREAPPROVED_OBJECT_API,IMH_UtilityConstants.EMPTY_STRING);  
        constructQueryObj3 = sobjectpreApprovedBenefits.replace(IMH_UtilityConstants.PREAPPROVED_OBJECT_API,PREAPPROVEDREL);
        
        //Targeted Products
        String sobjectTargetedProducts = IMH_GeneralApplicationUility.fetchAllFieldsClone(IMH_UtilityConstants.TARGETEDCOMMPRODUCT_OBJECT_API,IMH_UtilityConstants.EMPTY_STRING);
        constructQueryObj4 = sobjectTargetedProducts.replace(IMH_UtilityConstants.TARGETEDCOMMPRODUCT_OBJECT_API, TARGETEDCOMMPRODUCTREL) + WHEREQUERY_Prod;
        //Targeted Channels
        String sobjectTargetedChannels = IMH_GeneralApplicationUility.fetchAllFieldsClone(IMH_UtilityConstants.TARGETEDCOMMCHANNEL_OBJECT_API,IMH_UtilityConstants.EMPTY_STRING);
        constructQueryObj5 = sobjectTargetedChannels.replace(IMH_UtilityConstants.TARGETEDCOMMCHANNEL_OBJECT_API, TARGETEDCOMMCHANNELREL) + WHEREQUERY_Channel;
        
        
        String innerquery = constructQueryObj1 + constructQueryObj2  + constructQueryObj3 + constructQueryObj4 + constructQueryObj5  ;
        String sobjectCommunication = IMH_GeneralApplicationUility.fetchAllFieldsClone(IMH_UtilityConstants.COMMUNICATION_OBJECT_API,innerquery); 
        List<IMH_Communication__c> lCommunication = Database.Query(sobjectCommunication + WHEREQUERY_Communication);
        
       
         for(IMH_Communication__c comm:[SELECT Id,
                                               StartDate__c,
                                               EndDate__c
                                        FROM IMH_Communication__c
                                        WHERE Id IN:mapConstructChild.values()]) {
                                            
                mapDates.put(comm.Id, comm);                                          
         }
        
        //Map of All the Creative Products Apart From Cancelled
        
          for(IMH_CreativeProduct__c createProducts:[SELECT Id,Product__r.Name,
                                                            TargetedProduct__c,
                                                            Creative__r.CreativeStatus__c 
                                                     FROM IMH_CreativeProduct__c
                                                     WHERE TargetedProduct__c IN:lCommunication[0].CommunicationProducts__r
                                                     AND ( Creative__r.CreativeStatus__c  = :IMH_UtilityConstants.CREATIVE_Appr_STATUS
                                                     OR (Creative__r.CreativeStage__c = :IMH_UtilityConstants.COM_REV_STAGE_COMPLETE AND Creative__r.CreativeStatus__c = :IMH_UtilityConstants.CREATIVE_CAN_STATUS
                                                         AND Creative__r.CreativeReviewCancellationReason__c = :IMH_UtilityConstants.CREATIVE_EXP_STATUS))]){
                                                         
                     if(mapCommProductsCreativeProd.containsKey(createProducts.TargetedProduct__c)) {
                             List<IMH_CreativeProduct__c> lcreativeprodsId = mapCommProductsCreativeProd.get(createProducts.TargetedProduct__c);
                             lcreativeprodsId.add(createProducts);
                             mapCommProductsCreativeProd.put(createProducts.TargetedProduct__c,lcreativeprodsId);
                       }
                  else{                                       
                      mapCommProductsCreativeProd.put(createProducts.TargetedProduct__c,new List<IMH_CreativeProduct__c>{createProducts}); 
                  }                                      
           }
        
            //Map of All the Creative Channles Apart From Cancelled
       
          for(IMH_CreativeChannel__c createchannel:[SELECT Id,
                                                            TargetedChannel__c,
                                                            Creative__r.CreativeStatus__c 
                                                     FROM IMH_CreativeChannel__c
                                                     WHERE TargetedChannel__c IN:lCommunication[0].CommunicationChannel__r
                                                    AND ( Creative__r.CreativeStatus__c  = :IMH_UtilityConstants.CREATIVE_Appr_STATUS
                                                     OR (Creative__r.CreativeStage__c = :IMH_UtilityConstants.COM_REV_STAGE_COMPLETE AND Creative__r.CreativeStatus__c = :IMH_UtilityConstants.CREATIVE_CAN_STATUS
                                                         AND Creative__r.CreativeReviewCancellationReason__c = :IMH_UtilityConstants.CREATIVE_EXP_STATUS))]){
                                                         
                     if(mapCommChannelsCreativechannel.containsKey(createchannel.TargetedChannel__c)) {
                             List<IMH_CreativeChannel__c> lcreativechannelId = mapCommChannelsCreativechannel.get(createchannel.TargetedChannel__c);
                             lcreativechannelId.add(createchannel);
                             mapCommChannelsCreativechannel.put(createchannel.TargetedChannel__c,lcreativechannelId);
                       }
                  else{                                       
                      mapCommChannelsCreativechannel.put(createchannel.TargetedChannel__c,new List<IMH_CreativeChannel__c>{createchannel}); 
                  }                                      
           }
        
        
        for(IMH_Communication__c camp:lCommunication){
            if(camp.Incentives__r != NULL){ 
                newInceList = camp.Incentives__r.deepClone(false);
                for(IMH_Incentive__c incentive:newInceList){
                    incentive.Communication__c = mapConstructChild.get(camp.ID);
                    incentive.UniqueApprovalCode__c = IMH_UtilityConstants.EMPTY_STRING;
                    incentive.IncentiveStatus__c = IMH_UtilityConstants.CAMPAIGN_INPROGRESS;
                    lupdatesobjectlist.add(incentive);
                }
            }
            if(camp.PreApprovedBenefits__r != NULL){  
                newPreApprovedeList = camp.PreApprovedBenefits__r.deepClone(false);
                for(IMH_PreApprovedBenefits__c pre:newPreApprovedeList){
                    pre.Communication__c = mapConstructChild.get(camp.ID);
                    lupdatesobjectlist.add(pre);
                }
            }
            
            if(camp.Creative__r != NULL){  
                newCreList = camp.Creative__r.deepClone(false);
                for(IMH_CommCreative__c create:newCreList){
                    create.Communication__c = mapConstructChild.get(camp.ID);
                    create.ApprovalCode__c = IMH_UtilityConstants.EMPTY_STRING;
                    create.CreativeStatus__c = IMH_UtilityConstants.CAMPAIGN_INPROGRESS;
                    create.CreativeStage__c = IMH_UtilityConstants.COM_REV_STAGE_DESIGN;
                    create.RecordTypeId = IMH_GeneralApplicationUility.mRecordType.get(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API).get(CREATIVEDESIGNRECORDTYPE).Id;
                    lupdatesobjectlist.add(create);
                }
            }
            if(camp.CommunicationProducts__r != NULL){
                  //List of Valid Creative Prodcuts Apart From Cancelled
                for(IMH_CommProducts__c tproducts:camp.CommunicationProducts__r){
                    if(!tproducts.SYS_UICreated__c || (tproducts.SYS_UICreated__c && mapCommProductsCreativeProd.containsKey(tproducts.Id))){
                              lvalidproductslist.add(tproducts);
                    } 
                }
                newProductList =lvalidproductslist.deepClone(false);
                for(IMH_CommProducts__c tproducts:newProductList){
                    tproducts.Communication__c = mapConstructChild.get(camp.ID);
                    listprodschannels.add(tproducts);
                    
                }
            }
            if(camp.CommunicationChannel__r != NULL){
                  //List of Valid Creative Channels Apart From Cancelled
                for(IMH_CommChannels__c tchannels:camp.CommunicationChannel__r){
                    if(!tchannels.SYS_UICreated__c || (tchannels.SYS_UICreated__c && mapCommChannelsCreativechannel.containsKey(tchannels.Id))){
                              lvalidChannelList.add(tchannels);
                    } 
                }
                newChannelList = lvalidChannelList.deepClone(false);
                for(IMH_CommChannels__c channel:newChannelList){
                    if(channel.Channel_Start_Date__c!=NULL){
                       channel.Channel_Start_Date__c =  mapDates.get(mapConstructChild.get(camp.ID)).StartDate__c;
                    }
                    if(channel.Channel_End_Date__c != NULL) {
                       channel.Channel_End_Date__c =    mapDates.get(mapConstructChild.get(camp.ID)).EndDate__c;
                    }
                    channel.Communication__c =   mapConstructChild.get(camp.ID);
                    listprodschannels.add(channel);
                }
            }
            
        }
        if(!listprodschannels.isEmpty()){
             Database.insert(listprodschannels,true);
        }


        if(!lupdatesobjectlist.isEmpty()){
            Database.insert(lupdatesobjectlist,true);
        }
         
    }
    /*****************************************************************************
    * @description -  It is called on after insert context of trigger of Creative when it is cloned and is used to clone the children of Creatives 
    *                   i.e Targeted Products, Targeted Channels
    * @param - Map<Id,Id>
    * @return - void
    */
    /*--------PEER REVIEW  - KUMAR 13062016
     * DECLARE ALL VARIABLES AT TOP OF THE METHOD - 
     * REMOVE ALL DEBUG STATEMENTS - 
     * GIVE COMMENTS TO THE CODE WRITTEN
     */
    public static void constructGrandChildren(Map<Id,Id> mapConstructChild){
        SET<ID> setComms = new SET<ID>();
        List<sObject> lupdatesobjectlist = new List<sObject>();
        Map<ID,ID> mapClonedTargetedProductByProduct= new Map<ID,ID>();
        Map<ID,ID> mapProductByNewTargetedProduct= new Map<ID,ID>();
        Map<ID,ID> mapChannelByNewTargetedChannel= new Map<ID,ID>();
        Map<ID,ID> mapClonedTargetedChannelByChannel= new Map<ID,ID>();
        
        //Products Variables
        List<IMH_CreativeProduct__c> newProdList = new List<IMH_CreativeProduct__c>();
        List<IMH_CreativeProduct__c> updateProdList = new List<IMH_CreativeProduct__c>();
        // 
        // Channles Variables
         List<IMH_CreativeChannel__c> newChannelList  = new List<IMH_CreativeChannel__c>();
         List<IMH_CreativeChannel__c> updateChannel = new List<IMH_CreativeChannel__c>();
         List<IMH_CreativeChannel__c> lChannelsToInsert = new List<IMH_CreativeChannel__c>();
         List<IMH_CreativeProduct__c> lProductsToInsert = new List<IMH_CreativeProduct__c>();
        
         Map<Id,IMH_CommCreative__c> mapDates = new Map<Id,IMH_CommCreative__c>();
         Map<Id,List<IMH_CommProducts__c>> mapnewcommsprods = new Map<Id,List<IMH_CommProducts__c>>(); 
         Map<Id,List<IMH_Commchannels__c>> mapnewcommschannels = new Map<Id,List<IMH_Commchannels__c>>(); 
         Map<Id,List<Id>> mapnewcomms = new Map<Id,List<Id>>();//Map of Communication Id and Creative Id
         Set<Id> clonedComms = new Set<Id> ();
        
        setComms = mapConstructChild.keyset();
        String sobjectProducts = IMH_GeneralApplicationUility.fetchAllFieldsClone(IMH_UtilityConstants.TARGETEDPRODUCT_OBJECT_API,IMH_UtilityConstants.EMPTY_STRING);
        constructQueryObj1 = sobjectProducts.replace(IMH_UtilityConstants.TARGETEDPRODUCT_OBJECT_API, TARGETEDPRODUCTREL) + WHEREQUERY_CreativeProd ;
        String sobjectChannels = IMH_GeneralApplicationUility.fetchAllFieldsClone(IMH_UtilityConstants.TARGETEDCHANNEL_OBJECT_API,IMH_UtilityConstants.EMPTY_STRING);
        constructQueryObj2 = sobjectChannels.replace(IMH_UtilityConstants.TARGETEDCHANNEL_OBJECT_API, TARGETEDCHANNELREL) + WHEREQUERY_CreativeChannel ;
        String innerquery = constructQueryObj1 + constructQueryObj2 ;
        String sobjectCreative = IMH_GeneralApplicationUility.fetchAllFieldsClone(IMH_UtilityConstants.COMMCREATIVE_OBJECT_API,innerquery); 
        //Queries all the fields from Creative Product,Channel and Creative
        List<IMH_CommCreative__c> lCreative = Database.Query(sobjectCreative + WHEREQUERY_Creative);
       
        
         // HAVE A MEANGINGFUL VARIABLE NAMES - EX- crate
         for(IMH_CommCreative__c creative : [SELECT Id,Communication__r.StartDate__c
                                                   ,Communication__r.EndDate__c
                                                   ,Communication__c
                                              FROM IMH_CommCreative__c
                                              WHERE (Id IN:mapConstructChild.values() OR Id IN : setComms)
                                              LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
              // TO CATEGORIZE THE OLD COMMUNICATIONS AND NEWLY CLONED COMMUNICATION                                              
              if(setComms.contains(creative.Id)){
                  clonedComms.add(creative.Communication__c);
              }else{
                  mapDates.put(creative.Id,creative);
                  if(mapnewcomms.containsKey(creative.Communication__c)){
                     // PPER REVIEW  - INITIALIZE THE COLLECTIONS
                      List<Id> lcreativeid =  mapnewcomms.get(creative.Communication__c);
                      lcreativeid.add(creative.Id);
                      mapnewcomms.put(creative.Communication__c,lcreativeid);
                  }
                  else{   
                      mapnewcomms.put(creative.Communication__c,new List<Id> {creative.Id});
                  }
              }                                              
            }
        //PEER REVIEW - USE LIMIT IN QUERY
         for(IMH_Communication__c tempComm:[SELECT Id,
                                                  (Select Id,Product__c FROM CommunicationProducts__r),
                                                  (Select Id,Channel__c FROM CommunicationChannel__r)
                                            FROM IMH_Communication__c
                                            WHERE (Id IN:mapnewcomms.keySet() OR Id IN : clonedComms)
                                             LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
                //CONSTRUCT TWO DIFFERENT MAPS TO GET NEWLY CREATED TARGETED PRODUCT/CHANNEL AND MAP IT TO RESPECTIVE CREATIVE PRODUCTS                                            
                for(IMH_CommProducts__c commProds:tempComm.CommunicationProducts__r){
                    if(mapnewcomms.containsKey(tempComm.Id)){
                        mapProductByNewTargetedProduct.put(commProds.Product__c,commProds.Id);
                    }else{
                        mapClonedTargetedProductByProduct.put(commProds.Id,commProds.Product__c);
                    }
                }
                for(IMH_CommChannels__c commChannels:tempComm.CommunicationChannel__r){
                    if(mapnewcomms.containsKey(tempComm.Id)){
                        mapChannelByNewTargetedChannel.put(commChannels.Channel__c,commChannels.Id);
                    }else{
                        mapClonedTargetedChannelByChannel.put(commChannels.Id,commChannels.Channel__c);
                    }
                }
           }
          
          for(IMH_CommCreative__c camp:lCreative){
            if(camp.Targeted_Products__r != NULL){ 
                newProdList = camp.Targeted_Products__r.deepClone(false);
                for(IMH_CreativeProduct__c prod:newProdList){
                    prod.Creative__c = mapConstructChild.get(camp.ID);
                    prod.Status__c = IMH_UtilityConstants.EMPTY_STRING;
                    prod.TargetedProduct__c = mapProductByNewTargetedProduct.get(
                                                    mapClonedTargetedProductByProduct.get(prod.TargetedProduct__c));
                   
                    lProductsToInsert.add(prod);
                }
            }
            if(camp.Targeted_Channels__r != NULL){  
                newChannelList = camp.Targeted_Channels__r.deepClone(false);
                for(IMH_CreativeChannel__c channel:newChannelList){
                    channel.TargetedChannel__c = mapChannelByNewTargetedChannel.get(
                                                    mapClonedTargetedChannelByChannel.get(channel.TargetedChannel__c));
                    
                    channel.Creative__c = mapConstructChild.get(camp.ID);
                    channel.Status__c = IMH_UtilityConstants.EMPTY_STRING;
                    if(channel.Channel_Start_Date__c != NULL){
                       channel.Channel_Start_Date__c = mapDates.get(mapConstructChild.get(camp.ID)).Communication__r.StartDate__c;
                    }
                    if(channel.Channel_End_Date__c != NULL){
                       channel.Channel_End_Date__c = mapDates.get(mapConstructChild.get(camp.ID)).Communication__r.EndDate__c;
                    }
                    lChannelsToInsert.add(channel);
                }
            }

        } 
        lupdatesobjectlist.addAll((List<sObject>)lProductsToInsert);
        lupdatesobjectlist.addAll((List<sObject>)lChannelsToInsert);
        if(!lupdatesobjectlist.isEmpty()){
            //Used to avoid the entry into Creative trigger to Create Products and Channels 
            IMH_CommCreativeTriggerHandler.isCloned = true;
            Database.insert(lupdatesobjectlist,true); 
        }
    }
}