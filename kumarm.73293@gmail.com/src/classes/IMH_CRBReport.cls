/**
* @author Accenture IDC 
* @date 05/26/2015
* @group QuestionSet
* @group-content CRB Report
* @description - iMH Release 1.6 (Sprint 43): Controller for CRB Report ehich gets displayed to the User
*/
public with sharing class IMH_CRBReport {
    private static final String CRBFIELDSETNAME = 'IMH_CRBReportFields';
    private static final String SELECTCOMMUNICATION = 'SELECT Id,Description__c,CreatedDate, ';
    private static final String WHERECOMMUNICATIONQUERY = ' Name,Owner.Name FROM IMH_Communication__c Where Id = :commId';
    private static final String COMMASPACE = ', ';
    private static final String DATECHECK = 'DATE';
    private static final String SELECTSPACE = 'SELECT ';
    private static final String WHERECHANNELQUERY = ' Id FROM IMH_CommChannels__c WHERE Communication__c =:commId';
    private static final String CRBINCENTIVEFIELDSET = 'IMH_CRBIncentiveInfo';
    private static final String CRBOTHERINCENTIVEFIELDSET = 'IMH_CRBOtherFields';
    private static final String WHEREINCENTIVEOTHERQUERY = ' Id FROM IMH_Incentive__c Where Communication__c = :commId';
    public String commId {get;set;}
    //Products variables
    public List<IMH_CommProducts__c> lproductInfo {get;set;}
    public Map<String,List<String>> mproductsgroupprods{get;set;}
    public Map<String,List<String>> mallproductsgroupprods{get;set;}
    public Map<String,Boolean> mallproductscheck{get;set;}
    public Boolean isProducts {get;set;}
    public Boolean ismultipleApprover {get;set;}
    public Boolean isOnlyNA {get;set;}
    //Channel variables
    public List<IMH_CommChannels__c> lchannelInfo {get;set;}
    public IMH_Communication__c communication {get;set;}
    public List<IMH_Incentive__c> lincentives {get;set;}
    public Map<Integer,String> FieldLablesChannelMap {get;set;}
    public Map<Integer,String> FieldLabelChannelAPIMap {get;set;}
    public Map<String,Boolean> mChannelDate {get;set;}
	
    
    //Communication Varaibles
    public Map<Integer,String> FieldLablesMap {get;set;}
    public Map<Integer,String> FieldLabelAPIMap {get;set;}
    public Map<String,Boolean> mcommunicationDate {get;set;}
    
    //Incentive Variables
    public Map<Integer,String> FieldLablesIncentiveMap {get;set;}
    public Map<Integer,String> FieldLabelIncentiveAPIMap {get;set;}
    public Map<Integer,String> FieldOtherLablesIncentiveMap {get;set;}
    public Map<Integer,String> FieldOtherLabelIncentiveAPIMap {get;set;}
    public Map<String,Boolean> mincentiveDate {get;set;}
  /**
    * @description  - Non Parameterized Constructor where Page paramters are fectched and the report method is called
    * @param  - None
    * @return  - N/A
*/ 
    public IMH_CRBReport(){
        commId = ApexPages.currentPage().getParameters().get(IMH_UtilityConstants.ID);
        lproductInfo = new List<IMH_CommProducts__c>();
        isProducts = false;
        ismultipleApprover = false;
        lchannelInfo = new List<IMH_CommChannels__c>();
        communication = new IMH_Communication__c();
        mproductsgroupprods = new Map<String,List<String>>();
        mallproductscheck = new Map<String,Boolean>();
        FieldLablesMap = new Map<Integer,String>();
        FieldLabelAPIMap = new Map<Integer,String>();
        mcommunicationDate = new Map<String,Boolean>();
        mallproductsgroupprods = new Map<String,List<String>>();
        FieldLablesIncentiveMap = new Map<Integer,String>();
        FieldLabelIncentiveAPIMap = new Map<Integer,String>();
        FieldOtherLablesIncentiveMap = new Map<Integer,String>();
        FieldOtherLabelIncentiveAPIMap = new Map<Integer,String>();
        lincentives = new List<IMH_Incentive__c>();
        mincentiveDate = new Map<String,Boolean>();
        FieldLablesChannelMap = new Map<Integer,String>();
        FieldLabelChannelAPIMap = new Map<Integer,String>();
        mChannelDate = new Map<String,Boolean>();
       getCommunicationDetails();
    }
     /**
    * @description  - Method Called from Constructor to construct the CRB report.
    * @param  - None
    * @return  - Void
    */ 
    public void getCommunicationDetails(){
        String queryString = IMH_UtilityConstants.EMPTY_STRING;
        String querychannelString = IMH_UtilityConstants.EMPTY_STRING;
        String queryincentiveString = IMH_UtilityConstants.EMPTY_STRING;
        Integer incetivefieldcount=0;
        Integer communicationfieldcount=0;
        Integer incentiveotherfieldcount=0;
        Integer channelfieldcount = 0;
        Map<String,Schema.SObjectField> maccessibleincenitve  = Schema.SObjectType.IMH_Incentive__c.fields.getMap();
        //Used for querying the Communication Fields on CRB Report
         List<Schema.FieldSetMember> listcommfields = new List<Schema.FieldSetMember>();
         //String fieldSetCommName = CRBFIELDSETNAME+'_'+targetMarket.deleteWhitespace();
         //System.debug('***ABC '+fieldSetCommName);
         //  listcommfields = IMH_GeneralApplicationUility.readFieldSet(fieldSetCommName,IMH_UtilityConstants.COMMUNICATION_OBJECT_API);
        //if(listcommfields == NULL){
           listcommfields = IMH_GeneralApplicationUility.readFieldSet(CRBFIELDSETNAME,IMH_UtilityConstants.COMMUNICATION_OBJECT_API); 
       // }
        queryString = SELECTCOMMUNICATION;
        
        Map<String,Schema.SObjectField> maccessible  = Schema.SObjectType.IMH_Communication__c.fields.getMap();
        for(Schema.FieldSetMember field:listcommfields){
            
            if (maccessible.get(field.getFieldPath()).getDescribe().isAccessible()){
                communicationfieldcount++;
                queryString += field.getFieldPath() + COMMASPACE;
                FieldLablesMap.put(communicationfieldcount,field.getLabel());
                FieldLabelAPIMap.put(communicationfieldcount,field.getFieldPath());
                //Creating Map to track date field format
                if(DATECHECK.equalsIgnoreCase(String.valueof(field.getType()))){
                    mcommunicationDate.put(field.getFieldPath(),true);
                }
                else{
                    mcommunicationDate.put(field.getFieldPath(),false);  
                }
            }
            
            
        }
        queryString += WHERECOMMUNICATIONQUERY;
        
        communication = Database.query(queryString);
        //Used to keep track of all the related products based on the Groups
          for(IMH_Product__c prods:[SELECT Id,
                                            Name,
                                            RequiredApprovers__c
                                            FROM IMH_Product__c 
                                     WHERE MarketMultiSelect__c includes (:communication.TargetMarket__c) AND Active__c = TRUE
                                       ]){
		   if(prods.RequiredApprovers__c == NULL){
			   prods.RequiredApprovers__c = 'N/A';
		   }										
          
		  for(String requiredapprover:prods.RequiredApprovers__c.split(';')){
			  if(mallproductsgroupprods.containsKey(requiredapprover)){
				  List<String> lprods =  mallproductsgroupprods.get(requiredapprover);
				  lprods.add(prods.Name);
				  mallproductsgroupprods.put(requiredapprover,lprods);
			  } 
			  else{
				  mallproductsgroupprods.put(requiredapprover,new List<String>{prods.Name});                                 
			  } 
		  }
     }
       
        //Used for querying the Communication Products Fields on CRB Report
        for(IMH_CommProducts__c commProds:[SELECT Id,
                                           Product__r.Name,
                                           Product__r.RequiredApprovers__c
                                           FROM IMH_CommProducts__c
                                           WHERE Communication__c =: commId]){
             if(commProds.Product__r.RequiredApprovers__c == NULL){
			    commProds.Product__r.RequiredApprovers__c = 'N/A';
			 }                             
             for(String reqapprover:commProds.Product__r.RequiredApprovers__c.split(';')){
				 if(mproductsgroupprods.containsKey(reqapprover)){
				   List<String> lcomrprods =  mproductsgroupprods.get(reqapprover);
				   lcomrprods.add(commProds.Product__r.Name);
				   mproductsgroupprods.put(reqapprover,lcomrprods);
				   } 
				   else{
					   mproductsgroupprods.put(reqapprover,new List<String>{commProds.Product__r.Name});                                 
				   }  
			 }              
         }
        
        if(!mproductsgroupprods.isEmpty()){
            isProducts = true;
        } 
        //Check If The Communication contains all the Products associated to the Required Approver
        for(String reqapprover:mproductsgroupprods.keySet()){
			if('N/A'.equalsIgnoreCase(reqapprover)
				&& mproductsgroupprods.get(reqapprover).size()==1
				&& '* N/A'.equalsIgnoreCase(mproductsgroupprods.get(reqapprover).get(0))){
				isOnlyNA = true;
			}
            if(mallproductsgroupprods.get(reqapprover).size() == mproductsgroupprods.get(reqapprover).size()){
                mallproductscheck.put(reqapprover,true);
            }
            else{
                mallproductscheck.put(reqapprover,false);
            }
        }
        
        //Used for querying the Communication Channels Fields on CRB Report
        List<Schema.FieldSetMember> listchannelfields = IMH_GeneralApplicationUility.readFieldSet(CRBFIELDSETNAME,IMH_UtilityConstants.TARGETEDCOMMCHANNEL_OBJECT_API);
        querychannelString = SELECTSPACE;
        for(Schema.FieldSetMember field:listchannelfields){
            channelfieldcount++;
            querychannelString +=  field.getFieldPath() + COMMASPACE;
            FieldLablesChannelMap.put(channelfieldcount,field.getLabel());
            FieldLabelChannelAPIMap.put(channelfieldcount,field.getFieldPath());
            //Creating Map to track date field format
            if(DATECHECK.equalsIgnoreCase(String.valueof(field.getType()))){
                mChannelDate.put(field.getFieldPath(),true);
            }
            else{
                mChannelDate.put(field.getFieldPath(),false);  
            }
            
        }
        querychannelString +=WHERECHANNELQUERY;
        lchannelInfo = Database.query(querychannelString);
        
        //Used for querying the Incentive Fields on CRB Report
        List<Schema.FieldSetMember> listincenfields = IMH_GeneralApplicationUility.readFieldSet(CRBINCENTIVEFIELDSET,IMH_UtilityConstants.INCENTIVE_OBJECT_API);
        List<Schema.FieldSetMember> listincenotherfields = IMH_GeneralApplicationUility.readFieldSet(CRBOTHERINCENTIVEFIELDSET,IMH_UtilityConstants.INCENTIVE_OBJECT_API);
        queryincentiveString = SELECTSPACE;
        
        //Genrating query for the Incentive Information Section
        for(Schema.FieldSetMember field:listincenfields){
            if(maccessibleincenitve.get(field.getFieldPath()).getDescribe().isAccessible()){
                incetivefieldcount++;
                queryincentiveString += field.getFieldPath() + COMMASPACE;
                FieldLablesIncentiveMap.put(incetivefieldcount,field.getLabel());
                FieldLabelIncentiveAPIMap.put(incetivefieldcount,field.getFieldPath());
                //Creating Map to track date field format
                if(DATECHECK.equalsIgnoreCase(String.valueof(field.getType()))){
                    mincentiveDate.put(field.getFieldPath(),true);
                }
                else{
                    mincentiveDate.put(field.getFieldPath(),false);  
                }
            }
        }
        
        //Genrating query for the Other Incentive Information Section  
        for(Schema.FieldSetMember field:listincenotherfields){
            if(maccessibleincenitve.get(field.getFieldPath()).getDescribe().isAccessible()){
                incentiveotherfieldcount++;
                queryincentiveString += field.getFieldPath() + COMMASPACE;
                FieldOtherLablesIncentiveMap.put(incentiveotherfieldcount,field.getLabel());
                FieldOtherLabelIncentiveAPIMap.put(incentiveotherfieldcount,field.getFieldPath());
            }
        }
        
        queryincentiveString += WHEREINCENTIVEOTHERQUERY;
        
        lincentives = Database.query(queryincentiveString);
    }
}