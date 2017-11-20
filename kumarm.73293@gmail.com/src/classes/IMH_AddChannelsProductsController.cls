/**
    * @author Accenture IDC 
    * @date 10/30/2015
    * @group Campaign
    * @group-content N/A
    * @description: iMH Release 1.2 (Sprint 10) - Easy Creation of Products/Channels
*/
public with sharing class IMH_AddChannelsProductsController {
    public String                            selectedsObjectRecordId              {get;set;}
    public String                            targetMarket                         {get;set;}
    public String                            targetRegion                         {get;set;}
    public String                            childObject                          {get;set;}
    public String                            sectionName                          {get;set;}
    public List<String>                      addedChildsList                      {get;set;}
    public Boolean                           captureInputOnChild                  {get;set;}
    public String                            childJunctionObject                  {get;set;}
    public String                            inputStartDefaultDate                {get;set;}
    public String                            inputEndDefaultDate                  {get;set;}
    
    public static final String INIT_TEXT            = 'init';
    public static final String ID_CONSTANT          = 'id';
    public static final String PAGE_PARAM           = 'ea0';
    public static final String MARKET_NAME          = 'mkt';
    public static final String TARGETED_CHANNEL_API = 'IMH_CreativeChannel__c';
    public static final String TARGETED_PRODUCT_API = 'IMH_CreativeProduct__c';
    public static final String PRODUCT_API          = 'IMH_Product__c';
    public static final String CHANNEL_API          = 'IMH_ChannelREF__c';
    public static final String DF_START_DATE        = 'stDate';
    public static final String DF_END_DATE          = 'enDate';
    public static final String BENEFIT_API          = 'IMH_Benefits__c';
    public static final String PRE_BENEFIT_API      = 'IMH_PreApprovedBenefits__c';
    public static final String JAPAN_SUBMITTER      = 'JapanSubmitter';
    public static final String IMH_SYSADMIN         = 'IMHSystemAdmin';
    
    private static final String SELECTIDSPACE       = 'SELECT id, ';
    private static final String COMMASPACE          = ', ';
    private static final String PR2                 = 'pr2';
    private static final String CH2                 = 'ch2';
    private static final String FROMSPACE = ' FROM ';
    private static final String WHERESPACE = ' WHERE ';
    private static final String EQUALSPACE = ' = ';
    
    /**
    * @description: Constructor method for the class.
    * @param: none
    * @return: void
    */
    public IMH_AddChannelsProductsController() {
        String pageParam      = ApexPages.currentPage().getParameters().get(PAGE_PARAM);
        selectedsObjectRecordId = ApexPages.currentPage().getParameters().get(ID_CONSTANT);
        IMH_EasyCreationParameter__mdt easyParam = [SELECT Id, DeveloperName, Child_Object__c, Primary_Parent_Field_API__c,
                                                    Secondary_Parent_Field_API__c, Actual_Parent_Field_API__c,
                                                    URL_Parameter__c, Child_Junction_Object__c, CaptureInputOnChild__c FROM 
                                                    IMH_EasyCreationParameter__mdt WHERE URL_Parameter__c =: pageParam];
        //System.debug('######0000000>>: '+easyParam);
        childObject = easyParam.Child_Object__c;
        captureInputOnChild = easyParam.CaptureInputOnChild__c;
        childJunctionObject = easyParam.Child_Junction_Object__c;
        if(!childObject.equalsIgnoreCase(BENEFIT_API) && (Id.valueOf(selectedsObjectRecordId).getSObjectType() == Schema.IMH_CommCreative__c.SObjectType)){
            IMH_CommCreative__c commCreativeObj = [SELECT Id, Name, Communication__r.TargetMarket__c,Communication__r.TargetRegion__c, 
                                                    Communication__r.StartDate__c, Communication__r.EndDate__c,Communication__r.RecordType.DeveloperName
                                                    FROM IMH_CommCreative__c WHERE id =: selectedsObjectRecordId];
            if('MarketingCommunication_BP'.equalsIgnorecase(commCreativeObj.Communication__r.RecordType.DeveloperName)
              || 'MarketingCommunicationCreative_BP'.equalsIgnoreCase(commCreativeObj.Communication__r.RecordType.DeveloperName)){
                 targetMarket = 'Other';
                 targetRegion = 'Other';
                captureInputOnChild = true;
            }
            else{
                 targetMarket = commCreativeObj.Communication__r.TargetMarket__c;
                 targetRegion = commCreativeObj.Communication__r.TargetRegion__c;
            }
           
            sectionName = commCreativeObj.Name;
            inputStartDefaultDate = String.valueOf(commCreativeObj.Communication__r.StartDate__c);
            inputEndDefaultDate = String.valueOf(commCreativeObj.Communication__r.EndDate__c);
        }
        else{
            IMH_Communication__c commsObj = [SELECT Id,Name,TargetMarket__c,TargetRegion__c, StartDate__c, EndDate__c,
                                             RecordType.DeveloperName FROM IMH_Communication__c 
                                             WHERE id=: selectedsObjectRecordId];
            if('MarketingCommunication_BP'.equalsIgnorecase(commsObj.RecordType.DeveloperName)
              ||  'MarketingCommunicationCreative_BP'.equalsIgnoreCase(commsObj.RecordType.DeveloperName)){
                targetMarket = 'Other';
                targetRegion = 'Other';
                
            }
            else {
                targetMarket = commsObj.TargetMarket__c;
                targetRegion = commsObj.TargetRegion__c;
            }
            sectionName = commsObj.Name;
            inputStartDefaultDate = String.valueOf(commsObj.StartDate__c);
            inputEndDefaultDate = String.valueOf(commsObj.EndDate__c);
        }
        
        List<sObject> lAddedChilds = new List<sObject>();
        String soql = SELECTIDSPACE+easyParam.Primary_Parent_Field_API__c+COMMASPACE;
        if(easyParam.URL_Parameter__c.equalsIgnorecase(PR2) || easyParam.URL_Parameter__c.equalsIgnorecase(CH2)) {
               soql += easyParam.Actual_Parent_Field_API__c+'.'+easyParam.Secondary_Parent_Field_API__c;
        }
        else {
               soql += easyParam.Secondary_Parent_Field_API__c;
        }
               soql += FROMSPACE+easyParam.Child_Junction_Object__c;
        
               soql += WHERESPACE+easyParam.Primary_Parent_Field_API__c+EQUALSPACE+'\''+selectedsObjectRecordId+'\'';
       // System.debug('----mySOQL>>11>>: '+soql);
        lAddedChilds =Database.query(soql);
        addedChildsList= new List<String>();
        //System.debug('_lAddedChilds___22___>>: '+lAddedChilds);
        //System.debug('_lAddProducts___333__>>: '+easyParam.Secondary_Parent_Field_API__c);
        for(sObject sobj : lAddedChilds){
            if(easyParam.URL_Parameter__c.equalsIgnorecase(PR2) || easyParam.URL_Parameter__c.equalsIgnorecase(CH2)){
                addedChildsList.add(String.valueOf(sobj.getsobject(easyParam.Actual_Parent_Field_API__c).get(easyParam.Secondary_Parent_Field_API__c)));
            }
            else {
                addedChildsList.add(String.valueOf(sobj.get(easyParam.Secondary_Parent_Field_API__c)));    
            }
        }
        //System.debug('_addedChildsList__44____>>: '+addedChildsList);
    }
}