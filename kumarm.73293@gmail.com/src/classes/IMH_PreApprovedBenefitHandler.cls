/**
* @author Accenture IDC 
* @date 01/28/2016
* @group Pre Approved Benefit
* @group-content N/A
* @description Trigger Handler on Pre Approved Benefit that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/ 
public class IMH_PreApprovedBenefitHandler {
    private static Final String SYS_COMMUNICATIONSTAGE_API = 'SYS_CommunicationStage__c';
    private static final String CONCEPT_DESIGN = 'Concept - Design';
    private static Final String COMMUNICATIONFIELD = 'Communication__c';
    private static Final String RETAIL = 'Retail';
    private static final String AIRPORT = 'Airport';
    private static final String RETAILAIRPORT = 'Retail Airports';
    private static final String ELITETIER = 'Elite Tier';
    private static final String CARHIRE = 'Car Hire';
    private static final String PREFEREDGOLF = 'Preferred Golf';
    private static final String PRIVATEJET = 'Private Jet';
    private static final String PREMIUM = 'Premium';
    private static final String LODGING = 'Lodging';
    private static final String TOURS = 'Tours';
    private static final String TRAVEL = 'Travel';
    private static final String DINING = 'Dining';
    private static final String ENTERTAINMENT = 'Entertainment';
    private static final String CENTRALVALUE = 'Central';
     /*****************************************************************************
    * @description -  This method is called to prevent the deletion of pre approved benefit if communication stage is not Concept - Design
    * @param - Trigger.Old(sObject)
    * @return - void
    */
	/*public static void preventDeletion(List<Sobject> ltriggerOld) {
        for(Sobject sobj: ltriggerOld) {
            if(!CONCEPT_DESIGN.equalsIgnoreCase(String.valueOf(sobj.get(SYS_COMMUNICATIONSTAGE_API)))){
                sobj.addError(Label.IMH_PreventDeletionOfPreApprovedBenefit);
            }
        }
    }
    
   /*****************************************************************************
    * @description: Method to Rollup Field Benfits Pillar Queue to Communication from Benefits/Offers
    * @param: Trigger.New/Trigger.Old,Trigger.NewMap,Trigger.OldMap
    * @return: void
    */ 
    public  static void updateBenefitsPillars(List<sObject> ltrigger){
		Set<Id> sCommunicationIds = new Set<Id>();
		List<sObject> lChannelsAndProducts = new List<sObject>();
		List<IMH_Communication__c> lCommunicationsUpdate = new List<IMH_Communication__c>();                                                
        for(sObject sObj :ltrigger){
            sCommunicationIds.add(String.valueOf(sObj.get(COMMUNICATIONFIELD)));
        }
        Set<String> sBenefitsPillar = new Set<String>();
	    for(IMH_Communication__c comm : [SELECT Id,SYS_BenefitsPillarQueue__c,
                                                (SELECT Id,BenefitOffers__r.Benefit_Pillar__c FROM PreApprovedBenefits__r 
                                                                                            WHERE BenefitOffers__r.Benefit_Pillar__c != NULL
                                                                                             AND BenefitOffers__r.Benefit_Locale__c = :CENTRALVALUE) 
                                                FROM IMH_Communication__c WHERE ID IN :sCommunicationIds]){
            sBenefitsPillar = new Set<String>(); 
            comm.SYS_BenefitsPillarQueue__c = IMH_UtilityConstants.EMPTY_STRING;
            for(IMH_PreApprovedBenefits__c preApproved : comm.PreApprovedBenefits__r){
                String pillarowner = IMH_UtilityConstants.EMPTY_STRING;
                if(RETAIL.equalsIgnoreCase(String.valueof(preApproved.BenefitOffers__r.Benefit_Pillar__c)) || AIRPORT.equalsIgnoreCase(String.valueof(preApproved.BenefitOffers__r.Benefit_Pillar__c))){
                    pillarowner = RETAILAIRPORT;
                }
                else if(ELITETIER.equalsIgnoreCase(String.valueof(preApproved.BenefitOffers__r.Benefit_Pillar__c)) 
                        || CARHIRE.equalsIgnoreCase(String.valueof(preApproved.BenefitOffers__r.Benefit_Pillar__c))
                        || PREFEREDGOLF.equalsIgnoreCase(String.valueof(preApproved.BenefitOffers__r.Benefit_Pillar__c))
                        || PRIVATEJET.equalsIgnoreCase(String.valueof(preApproved.BenefitOffers__r.Benefit_Pillar__c))){
                    pillarowner = PREMIUM;
                }
                else if(LODGING.equalsIgnoreCase(String.valueof(preApproved.BenefitOffers__r.Benefit_Pillar__c)) 
                        ||TOURS.equalsIgnoreCase(String.valueof(preApproved.BenefitOffers__r.Benefit_Pillar__c))){
                    pillarowner = TRAVEL;
                }
                else if(DINING.equalsIgnoreCase(String.valueof(preApproved.BenefitOffers__r.Benefit_Pillar__c))){
                    pillarowner = DINING;
                }
                 else if(ENTERTAINMENT.equalsIgnoreCase(String.valueof(preApproved.BenefitOffers__r.Benefit_Pillar__c))){
                    pillarowner = ENTERTAINMENT;
                }
                sBenefitsPillar.add(pillarowner);
            }
			for(String reqApp : sBenefitsPillar){
                if(String.isBlank(comm.SYS_BenefitsPillarQueue__c)){
                    comm.SYS_BenefitsPillarQueue__c = reqApp;
                }else{
                    comm.SYS_BenefitsPillarQueue__c = comm.SYS_BenefitsPillarQueue__c + IMH_UtilityConstants.SEMI_COLON + reqApp;
                }
            }  
            lCommunicationsUpdate.add(comm);                                                    
			                                                   
        }
		if(!lCommunicationsUpdate.isEmpty()){
            Database.update(lCommunicationsUpdate,true);
        }									
	}
}