/**
    * @author Accenture IDC 
    * @date 10/30/2015
    * @group Campaign
    * @group-content N/A
    * @description: iMH Release 1.2 (Sprint 10) - Easy Creation of Products/Channels
*/
public with sharing class IMH_AddChildItemsOnParentController {
    public String                            initiateSearch           {get{initialState= true; for(String s : addedChildsList){
            inStateSelectedRecords.add(s);
            addedSet.add(s);
        }startSearch(); return BLANK_SPACE;}set;}
    public Boolean                           initialState             {get;set;}
    public Boolean                           toggleSelect             {get;set;}
    public String                            selectedsObjectRecordId  {get;set;}
    public String                            targetMarket             {get;set;}
    public String                            childObject              {get;set;}
    public String                            childJunctionObject      {get;set;}
    public String                            captureInputOnChild      {get;set;}
    public String                            targetRegion             {get;set;}
    public String                            processButtonName        {get;set;}
    public List<String>                      addedChildsList          {get;set;}
    public Set<String>                       addedSet;
    
    public String                            keywordParam             {get;set;}
    public List<SearchFieldsWrapper>         SearchFieldsWrapperList  {get;set;}
    public List<SObjectWrapper>              sObjectWrapperList       {get;set;}
    public Map<Id,SObjectWrapper>            initialsObjectWrapperList{get;set;}
    public Integer                           ruleRowIndex             {get;set;}
    
    public String                            dynamicQuery;      
    public String                            whereCondition;
    public Map<Integer,String>               FieldLabelsMap           {get;set;}
    public List<String>                      inputFieldLabelsList     {get;set;}
    public Map<String,String>                fieldNameLabelMap        {get;set;}
    
    public Integer                           noOfFieldsOntable        {get;set;}
    public Map <String,List <SelectOption>>  FieldConditionMap        {get;set;}
    public List <SelectOption>               options;
    public List<SObject>                     SObjectList              {get;set;}
    public List<String>                      colList;
    public List<String>                      inputColList;
    
    public String                            inputStartDefaultDate    {get;set;}
    public String                            inputEndDefaultDate      {get;set;}
    
    public Boolean                           showSearchResultsPanel   {get;set;}
    
    public Boolean                           showFieldRules           {get;set;}
    public Boolean                           allChildAdded            {get;set;}
    
    public List<SObjectWrapper>              selectedSObjectsList     {get;set;}
    public String                            selectedObjectFields     {get;set;}
    public Set<Id>                           finalDeleteChildIdSet;
    public String                            childObjectFields;     
    
    public Integer                           totalRecs                {get;set;}
    public Integer                           totalInputFields         {get;set;}
    public boolean                           hasError                 {get;set;}
    public Map <String, Boolean>             styleMap                 {get; set;}
    public Map <ID,sObject>                  mtargetsObjectByChildId  {get; set;}
    public boolean                           isDMLSuccess             {get;set;}
    
    //Pagination code Starts
    public Integer                           index                    {get;set;}
    public Integer                           blockSize                {get;set;}
    public Integer                           rowCount                 {get;set;}
    public List<SObjectWrapper>              paginatedSObjectWrapList {get;set;}
    //Pagination code Ends
    
    //ADDED BY KUMAR
    public Map<String , Schema.DisplayType> fieldTypeByAPIName {get;set;}
    
    //Sorting Variables Starts
    public String                            sortOrderClause          {get;set;}
    public String sortField {
    get  {if (sortField == null) {sortField = NAME_TEXT; } return sortField;}
    set;
    }
    public String sortDir {
    get  { if (sortDir == null) {  sortDir = ASC_DIR; } return sortDir;  }
    set;
    }
    //Sorting Variables Ends

    public Set<String>                       sCurrentSelectionId             {get;set;}
    public Set<String>                       inStateSelectedRecords          {get;set;}
    public Boolean                            clearFilterSearch              {get;set;}
    public Boolean                            initialSearchDone              {get;set;}

    //Release 1.7 Updates
    public String userTeam = '';
        
    //Constants
    private static final String  BLANK_SPACE                = '';
    private static final String  WHITE_SPACE                = ' ';
    private static final String  MODULUS_OP                 = '%';
    private static final String  SELECT_OPTION              = '----Select----';
    private static final String  NONE_OPTION                = '---None---';
    private static final String  TABLE_FIELD_SET            = 'Dynamic_Columns_Field_Set';
    private static final String  DYNAMIC_COLUMNS            = 'Dynamic_Columns_';
    private static final String  MARKET_TABLE_FIELD_SET     = '_Column_FieldSet';
    private static final String  CONTAINS_TEXT              = 'Contains';
    private static final String  STARTS_WITH_TEXT           = 'Starts with';
    private static final String  DATE_TEXT                  = 'Date';
    private static final String  NAME_TEXT                  = 'Name';
    private static final String  SELECT_TEXT                = 'SELECT';
    private static final String  LIKE_TEXT                  = ' LIKE ';
    private static final String  FROM_TEXT                  = ' FROM ';
    private static final String  AND_TEXT                   = ' AND ';
    private static final String  WHERE_COND                 = ' WHERE ';
    private static final String  OR_COND                    = ' OR ';
    private static final String  OPEN_BRACKET               = '(';
    private static final String  CLOSE_BRACKET              = ')';
    private static final String  NOT_IN                     =' NOT IN ';
    private static final String  ESCAPE_QUOTES              ='\'';
    private static final String  FILTET_RULE_FIELD_SET      = 'Filter_Rules_Field_Set';
    private static final String  EQUALS_TEXT                = 'Equals';
    private static final String  EQUALS_SYMBOL              = '=';
    private static final String  INCLUDES                   = 'INCLUDES';
    private static final String  EXCLUDES                   = 'EXCLUDES';
    private static final String  LOWERCASE_INCLUDES         = 'Includes';
    private static final String  LOWERCASE_EXCLUDES         = 'Excludes';
    private static final String  UPDATE_TEXT                = 'Update';
    private static final String  NOT_EQUALS_TEXT            = 'Not Equals';
    private static final String  NOT_EQUALS_SYMBOL          = '!=';
    private static final String  LESS_THAN_TEXT             = 'Less than';
    private static final String  LESS_THAN_SYMBOL           = '<';
    private static final String  GREATER_THAN_TEXT          = 'Greater than';
    private static final String  GREATER_THAN_SYMBOL        = '>';
    private static final String  URL_TEXT                   = 'URL';
    private static final String  PICKLIST                   = 'Picklist';
    private static final String  MULTI_PICKLIST             = 'MutiPicklist';
    private static final String  PHONE_TEXT                 = 'Phone';
    private static final String  RULE_ROW_INDEX_PARAM       = 'ruleRowIndex';
    private static final String  BOOLEAN_TEXT               = 'Boolean';
    private static final String  STRING_TEXT                = 'String';
    private static final String  NUMBER_TEXT                = 'Number';
    private static final String  CONSTANT_ID                = 'Id';
    private static final String  TRUE_VALUE                 = 'TRUE';
    private static final String  FALSE_VALUE                = 'FALSE';
    private static String  MARKET_FIELD_API           = 'MarketMultiSelect__c';
    private static final String  TARGET_REGION_FIELD_API    = 'Region__c';
    private static final String  CREATIVE_FIELD_API         = 'Creative__c';
    private static final String  COMMA_SPACE                = ', ';
    private static final String  CP_TARGET_REGION_FIELD_API = 'TargetRegion__c';
    private static final String  ORDER_BY                   = ' ORDER BY ';
    private static final String  ASC_DIR                    = 'asc';
    private static final String  DESC_DIR                   = 'desc';
    private static final String  INPUT_FIELD_SET            = 'Input_Field_Set';
    private static final String  CHANNEL_START_DATE_API     = 'Channel_Start_Date__c';
    private static final String  CHANNEL_END_DATE_API       = 'Channel_End_Date__c';
    private static final String  CHANNEL_FIELD_API          = 'Channel__c';
    private static final String  PRODUCT_API                = 'IMH_Product__c';
    private static final String  CHANNEL_API                = 'IMH_ChannelREF__c';
    private static final String  CREATIVE_CHANNEL_API       = 'IMH_CreativeChannel__c';
    private static final String  PRE_BENEFIT_API            = 'IMH_PreApprovedBenefits__c';
    private static final String  BENEFIT_OFFER_FIELD_API    = 'BenefitOffers__c';
    private static final String  COMMUNICATION_FIELD_API    = 'Communication__c';
    private static final String  PRODUCT_FIELD_API          = 'Product__c';
    private static final String  SPENDING_OFFER_FIELD_API   = 'Spending_Offer__c';
    private static final String  BENEFIT_API                = 'IMH_Benefits__c';
    private static final String  JAPAN_MARKET               = 'JAPAN';
    private static final String   TARGETEDPRODUCT_REL       = 'TargetedProduct__r';
    private static final String  OBJECT_API                 = 'Objective__c';
    private static final String  REQUIREDAPPROVER_API       = 'RequiredApprovers__c';
    private static final String  BENEFIT_INITIAL_WHERE_CLAUSE_1 =' WHERE ((( Benefit_Locale__c = \'Local\' AND Market__c INCLUDES (\'';
    private static final String  BENEFIT_INITIAL_WHERE_CLAUSE_2 ='\')) OR  ( Benefit_Locale__c = \'Regional\' AND Region__c = \'';
    private static final String  BENEFIT_INITIAL_WHERE_CLAUSE_3 ='\') OR Benefit_Locale__c = \'Central\') AND (ApprovalStage__c = \'Accepted\')';
    private static final String  CHANNEL_REL_PARENT         = 'TargetedChannel__r.Channel__c';
    private static final String  TARGETED_CHANNEL_REL       = 'TargetedChannel__r';
    
    /**
    * @description: Contructor Method starts
    * @param: none
    * @return: void
    */
    public IMH_AddChildItemsOnParentController (){
        sObjectWrapperList  = new List<SObjectWrapper>();
        initialsObjectWrapperList  = new Map<Id,SObjectWrapper>();
        totalRecs = 0;
        totalInputFields = 0;
        index = 0;
        rowCount = 0;
        blockSize = 100;
        showSearchResultsPanel = false;
        showFieldRules         = true;
        hasError               = false;
        allChildAdded          = false;
        clearFilterSearch      = false;
        initialSearchDone      = true;
        SObjectList = new List<SObject>();
        sCurrentSelectionId = new Set<String>();
        SearchFieldsWrapperList = new List<SearchFieldsWrapper>();
        FieldConditionMap = new Map <String, List <SelectOption>> ();
        finalDeleteChildIdSet = new Set<Id>();
        addedChildsList = new List<String>();
        addedSet = new Set<String>();
        styleMap = new Map < String, Boolean > ();
        List <SelectOption> nullOptions = new List <SelectOption> ();
        nullOptions.add(new SelectOption(BLANK_SPACE, NONE_OPTION));
        FieldConditionMap.put(null, nullOptions);
        AddSearchRules();
        mtargetsObjectByChildId = new Map<Id,sObject>();
        fieldTypeByAPIName = new Map<String,Schema.DisplayType>();
        inStateSelectedRecords = new Set<String>();
    }
    //Contructor Method ends
    
    /**
    * @description  - Method to start searching after field filters are applied
    * @param  - None
    * @return  - null
    */
    public void startSearch() {
            if(!initialState){
                inStateSelectedRecords = new Set<String>();
            }
            for(SObjectWrapper sObjWrap : sObjectWrapperList) {
                if(sObjWrap.isSelected){
                    inStateSelectedRecords.add(sObjWrap.sObjectRecord.Id);
                    if(!initialSearchDone){    
                        sCurrentSelectionId.add(sObjWrap.sObjectRecord.Id);
                    }
                }
            }
        if(!sCurrentSelectionId.isEmpty()){
            clearFilterSearch=true;
        }
        if(childObject.equalsIgnoreCase(PRODUCT_API)){
            processButtonName = System.Label.IMH_UpdateProductsButton;
        }
        else if(childObject.equalsIgnoreCase(CHANNEL_API)){
            processButtonName = System.Label.IMH_UpdateChannelsButton;
        }
        else if(childObject.equalsIgnoreCase(BENEFIT_API)){
            processButtonName = System.Label.IMH_UpdateBenefitsOffersButton;
        }
        hasError = false;
        selectedObjectFields = BLANK_SPACE;
        childObjectFields = BLANK_SPACE;
        String fieldSetName = BLANK_SPACE;
       
        //Adding the fields that is market specific
        //String userMarket = [SELECT Id, Market__c FROM USER WHERE Id =: UserInfo.getUserId() LIMIT 1].Market__c;
        User loggedInUser = [SELECT Id, Market__c,IMH_User_Team__c,ProfileId FROM USER WHERE Id =: UserInfo.getUserId() LIMIT 1];
        String profileName = [SELECT Name,Id FROM Profile WHERE Id =:loggedInUser.ProfileId LIMIT 1].Name;
        String userMarket = loggedInUser.Market__c;
        userTeam = loggedInUser.IMH_User_Team__c;
        if(JAPAN_MARKET.equalsignorecase(userMarket) && BENEFIT_API.equalsIgnoreCase(childObject)){
            fieldSetName = DYNAMIC_COLUMNS + userMarket;
        }
        else{
            fieldSetName = TABLE_FIELD_SET;
        }
        List <Schema.FieldSetMember> fieldOnSearchTablesList = new List<Schema.FieldSetMember>();
        if('Other'.equalsIgnoreCase(targetMarket)) {
            String tempFSName = fieldSetName.replace('Dynamic_Columns_Field_Set','Dynamic_Columns_BP_Team');
            System.debug('>>Fsss>>><<>>>: '+childObject.substring(0,childObject.length()-2)+ tempFSName);
            fieldOnSearchTablesList = readFieldSet(childObject.substring(0,childObject.length()-2)+ tempFSName, childObject);    
        }
        else {
            fieldOnSearchTablesList = readFieldSet(childObject.substring(0,childObject.length()-2)+ fieldSetName, childObject);
        }
        List <Schema.FieldSetMember>inputFieldOnSearchTablesList = new List<Schema.FieldSetMember>();
        noOfFieldsOntable = fieldOnSearchTablesList.size();
        colList = new List<String>();
        inputColList = new List<String>();
        FieldLabelsMap = new Map<Integer,String>();
        fieldNameLabelMap = new Map<String,String>();
        integer counter = 0;
        for(Schema.FieldSetMember field : fieldOnSearchTablesList) {
            counter++;
            colList.add(field.getFieldPath());
            String fieldName = field.getFieldPath();
            if(!(CONSTANT_ID.equalsIgnoreCase(fieldName))) {
                if(selectedObjectFields == BLANK_SPACE || selectedObjectFields == null) {
                    selectedObjectFields = fieldName;
                }
                else {  
                    selectedObjectFields = selectedObjectFields +COMMA_SPACE+fieldName;
                }
            }
            //MODIFIED TO AVOID DESCRIBE CALL FOR GETTING THE LABEL NAME 
            FieldLabelsMap.put(counter,field.getLabel());
            fieldNameLabelMap.put(fieldName,field.getLabel());
            fieldTypeByAPIName.put(fieldName,field.getType());
        }
        System.debug('------>>MYNEWMARKET>>: '+targetMarket);
        System.debug('------>>MYNEWchildJunctionObjectT>>: '+childJunctionObject);
        if(Boolean.valueOf(captureInputOnChild)) {
            if('Other'.equalsIgnoreCase(targetMarket)) {
                inputFieldOnSearchTablesList = readFieldSet(childJunctionObject.substring(0,childJunctionObject.length()-2)+INPUT_FIELD_SET+'_BP', childJunctionObject);
                //System.debug('****Prod 1 '+childJunctionObject.substring(0,childJunctionObject.length()-2	)+INPUT_FIELD_SET+'_BP'+childJunctionObject);
            }
            else {
                //System.debug('****Prod 1 '+childJunctionObject.substring(0,childJunctionObject.length()-2)+INPUT_FIELD_SET);
                inputFieldOnSearchTablesList = readFieldSet(childJunctionObject.substring(0,childJunctionObject.length()-2)+INPUT_FIELD_SET, childJunctionObject);
            }
            inputFieldLabelsList = new List<String>();
            for(Schema.FieldSetMember field : inputFieldOnSearchTablesList) {
                inputColList.add(field.getFieldPath());
                inputFieldLabelsList.add(field.getLabel());
                String fieldName = field.getFieldPath();
                if(!(CONSTANT_ID.equalsIgnoreCase(fieldName))) {
                    if(childObjectFields == BLANK_SPACE || selectedObjectFields == null) {
                        childObjectFields = fieldName;
                    }
                    else {  
                        childObjectFields = childObjectFields+COMMA_SPACE+fieldName;
                    }
                }
            }
            totalInputFields=inputFieldLabelsList.size();
        }
        callInitialQuery();
        if(String.isNotBlank(keywordParam)){
            initiateKeyWordSearch();
            if(whereCondition != BLANK_SPACE){
                dynamicQuery += whereCondition;
            }
        }
        else{
            createWhereClause();
            if(whereCondition !=BLANK_SPACE) {
                dynamicQuery += whereCondition;
                
            }
        }
        System.debug('****Final Query '+dynamicQuery);
        if(!hasError){
            sortOrderClause = ORDER_BY+sortField+WHITE_SPACE+sortDir;
            runQuery();
        }
        else {
            showSearchResultsPanel = false;
        }
    }
    //Search methods Ends
    /**
    * @description  - Actual Query Runs in this method
    * @param  - None
    * @return  - null
    */
    public void runQuery() {
        
        if(!addedChildsList.isEmpty()){
            toggleSelect = true;
        }
        else {
            toggleSelect = false;
        }
        dynamicQuery += CLOSE_BRACKET;
        System.debug('__THE_QUERY___:::'+dynamicQuery+sortOrderClause);
        SObjectList = Database.query(dynamicQuery+sortOrderClause);
        if((SObjectList.size() == addedChildsList.size()) && addedChildsList.size()>0){
            allChildAdded = true;
        }
        createWrapperList();
    }
    
    /**
    * @description  - Method to generate Initial Query
    * @param  - None
    * @return  - null
    */
    public void callInitialQuery() {
        dynamicQuery = BLANK_SPACE;
        whereCondition = BLANK_SPACE;
        if(BENEFIT_API.equalsIgnoreCase(childObject)){
            MARKET_FIELD_API = 'Market__c';
        }
        if(!selectedObjectFields.containsIgnoreCase(MARKET_FIELD_API)){
			selectedObjectFields = selectedObjectFields+COMMA_SPACE+MARKET_FIELD_API;
        }
        dynamicQuery = SELECT_TEXT+WHITE_SPACE+CONSTANT_ID+COMMA_SPACE+selectedObjectFields+FROM_TEXT+childObject;
        if(!BENEFIT_API.equalsIgnoreCase(childObject)) {
            if(String.isNotBlank(targetMarket) && !('Other'.equalsIgnoreCase(targetMarket))) {
                whereCondition = WHERE_COND+OPEN_BRACKET+MARKET_FIELD_API+WHITE_SPACE+'INCLUDES'+WHITE_SPACE+'('+ESCAPE_QUOTES+targetMarket+ESCAPE_QUOTES+')';
            }
            else if ('Other'.equalsIgnoreCase(targetMarket)) {
                whereCondition = WHERE_COND+OPEN_BRACKET+'User_Team__c'+WHITE_SPACE+EQUALS_SYMBOL+ESCAPE_QUOTES+userTeam+ESCAPE_QUOTES;    
            }
            else if(String.isNotBlank(targetRegion)) {
                whereCondition = WHERE_COND+OPEN_BRACKET+TARGET_REGION_FIELD_API+WHITE_SPACE+EQUALS_SYMBOL+ESCAPE_QUOTES+targetRegion+ESCAPE_QUOTES;
            }
        }
        else {
            whereCondition = BENEFIT_INITIAL_WHERE_CLAUSE_1+targetMarket+BENEFIT_INITIAL_WHERE_CLAUSE_2+targetRegion+BENEFIT_INITIAL_WHERE_CLAUSE_3;     
        }
    }
    /**
    * @description  - Method to initiate keyword search
    * @param  - None
    * @return  - null
    */
    public void initiateKeyWordSearch(){
        String keyWordSearchCondition = BLANK_SPACE;
        for(String  field : colList){
            if(!(field.contains(IMH_UtilityConstants.ID) || MARKET_FIELD_API.equalsIgnoreCase(field))) {
                if(!BENEFIT_API.equalsIgnoreCase(childObject)) {
                    if (keyWordSearchCondition != BLANK_SPACE) {
                        keyWordSearchCondition = keyWordSearchCondition +OR_COND+field+LIKE_TEXT+ESCAPE_QUOTES+MODULUS_OP+ keywordParam +MODULUS_OP+ESCAPE_QUOTES;
                    }
                    else {
                        keyWordSearchCondition = field+LIKE_TEXT+ESCAPE_QUOTES +MODULUS_OP+ keywordParam +MODULUS_OP+ESCAPE_QUOTES;
                    }
                }
                else {
                    //Code for Multiselect picklist values. Add new multiselect picklist values as or in the below if condition
                    if(field.equalsIgnoreCase(OBJECT_API) || field.equalsIgnoreCase(REQUIREDAPPROVER_API)){
                        if (keyWordSearchCondition != BLANK_SPACE) {
                            keyWordSearchCondition = keyWordSearchCondition+OR_COND+field+WHITE_SPACE+INCLUDES+OPEN_BRACKET+ESCAPE_QUOTES+keywordParam+ESCAPE_QUOTES+CLOSE_BRACKET;
                        }
                        else {
                            keyWordSearchCondition = field+WHITE_SPACE+INCLUDES+OPEN_BRACKET+ESCAPE_QUOTES+keywordParam+ESCAPE_QUOTES+CLOSE_BRACKET;
                        }
                    }
                    //Code for non Multiselect picklist values
                    else{
                        if (keyWordSearchCondition != BLANK_SPACE) {
                            keyWordSearchCondition = keyWordSearchCondition +OR_COND+field+LIKE_TEXT+ESCAPE_QUOTES+MODULUS_OP+ keywordParam +MODULUS_OP+ESCAPE_QUOTES;
                        }
                        else{
                            keyWordSearchCondition = field+LIKE_TEXT+ESCAPE_QUOTES +MODULUS_OP+ keywordParam +MODULUS_OP+ESCAPE_QUOTES;
                        }
                    }
                }
            }
        }
        if(whereCondition != BLANK_SPACE) {
            whereCondition += AND_TEXT+OPEN_BRACKET+keyWordSearchCondition+CLOSE_BRACKET;
        }
        else {
            whereCondition = WHERE_COND+keyWordSearchCondition;
        }
    }
    /**
    * @description  - Method to generate dynamic where clause
    * @param  - None
    * @return  - null
    */
    public void createWhereClause(){
        for (SearchFieldsWrapper searchInst: SearchFieldsWrapperList) {
            if ((searchInst.searchField != null || searchInst.searchField == SELECT_OPTION) && 
                (searchInst.searchOperator != null || searchInst.searchOperator == NONE_OPTION) && 
                 searchInst.searchParam != null) {
                        if (whereCondition != BLANK_SPACE) {
                            if(CONTAINS_TEXT.equalsIgnoreCase(searchInst.searchOperator)){
                                whereCondition = whereCondition + AND_TEXT + searchInst.searchField + LIKE_TEXT +ESCAPE_QUOTES+MODULUS_OP+ searchInst.searchParam +MODULUS_OP+ESCAPE_QUOTES;
                            }
                            else if (STARTS_WITH_TEXT.equalsIgnoreCase(searchInst.searchOperator)) {
                                whereCondition = whereCondition + AND_TEXT + searchInst.searchField + LIKE_TEXT +ESCAPE_QUOTES+ searchInst.searchParam +MODULUS_OP+ESCAPE_QUOTES;
                            }
                            else if(BOOLEAN_TEXT.equalsIgnoreCase(getFieldType(searchInst.searchField,childObject))) {
                                if(!(TRUE_VALUE.equalsIgnoreCase(searchInst.searchParam) || FALSE_VALUE.equalsIgnoreCase(searchInst.searchParam))){
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.IMH_Check_Boolean_Filter
                                                                                   //CHANGED THE CODE TO REMOVE THE DESCRIBE CALL DEPENDENCY
                                                                                    + WHITE_SPACE + fieldNameLabelMap.get(searchInst.searchField));
                                    ApexPages.addMessage(myMsg);
                                    hasError= true;
                                }
                                else{
                                    whereCondition = whereCondition + AND_TEXT + searchInst.searchField + WHITE_SPACE + searchInst.searchOperator + WHITE_SPACE + searchInst.searchParam;
                                }
                            }
                            else if(INCLUDES.equalsIgnoreCase(searchInst.searchOperator) || EXCLUDES.equalsIgnoreCase(searchInst.searchOperator)){
                                whereCondition = whereCondition + AND_TEXT + searchInst.searchField + WHITE_SPACE + searchInst.searchOperator + OPEN_BRACKET+ESCAPE_QUOTES+searchInst.searchParam+ESCAPE_QUOTES+CLOSE_BRACKET;
                            }
                            else if(DATE_TEXT.equalsIgnoreCase(getFieldType(searchInst.searchField,childObject))) {
                                whereCondition = whereCondition + AND_TEXT + searchInst.searchField + WHITE_SPACE + searchInst.searchOperator + WHITE_SPACE + searchInst.searchParam;
                            }
                            else {
                                whereCondition = whereCondition + AND_TEXT + searchInst.searchField + WHITE_SPACE + searchInst.searchOperator + WHITE_SPACE + ESCAPE_QUOTES+ searchInst.searchParam +ESCAPE_QUOTES;
                            }
                        }
            }
        }
    }
    
    /**
    * @description  - Method to Create wrapper List
    * @param  - None
    * @return  - null
    */
    public void createWrapperList() {
        Map<String,Date> junctionRecIdStartDateMap        = new Map<String,Date>();   // For Targeted Channel Input Dates-Start Date
        Map<String,Date> junctionRecIdEndDateMap          = new Map<String,Date>();   // For Targeted Channel Input Dates-End Date
        Map<String,String> junctionRecIdJoinOfferMap      = new Map<String,String>(); // For Pre-Apprved Benefit Input-Joining Offer
        Map<String,String> junctionRecIdSpendingOfferMap  = new Map<String,String>(); // For Pre-Apprved Benefit Input-Spending Offer
        Map<String,String> junctionRecIdPRAdditionalInfo    = new Map<String,String>(); // For Additional Info on Product
        Map<String,String> junctionRecIdCHAdditionalInfo    = new Map<String,String>(); // For Additional Info on Channel
        if(Boolean.valueOf(captureInputOnChild)) {
            List<sObject> junctionChildList = new List<sObject>();
            if(childJunctionObject.equalsIgnoreCase(CREATIVE_CHANNEL_API) || 
               childJunctionObject.equalsIgnoreCase(IMH_UtilityConstants.TARGETEDCOMMCHANNEL_OBJECT_API) ||
               childJunctionObject.equalsIgnoreCase('IMH_CommProducts__c')
              || childJunctionObject.equalsIgnoreCase('IMH_CreativeProduct__c')) {
                String junctionRecsRetrieveQuery = IMH_UtilityConstants.EMPTY_STRING;
                if(childJunctionObject.equalsIgnoreCase('IMH_CommProducts__c')) {
               		junctionRecsRetrieveQuery = 'SELECT Id, Product__c, Additional_Info__c FROM '+childJunctionObject+' WHERE Communication__c '+EQUALS_SYMBOL+ESCAPE_QUOTES+selectedsObjectRecordId+ESCAPE_QUOTES;	      
                }
                  else if(childJunctionObject.equalsIgnoreCase('IMH_CreativeProduct__c')){
                      junctionRecsRetrieveQuery = 'SELECT Id, TargetedProduct__r.Product__c, Additional_Info__c FROM '+childJunctionObject+' WHERE Creative__c '+EQUALS_SYMBOL+ESCAPE_QUOTES+selectedsObjectRecordId+ESCAPE_QUOTES;	 
                  }
                else if(childJunctionObject.equalsIgnoreCase(CREATIVE_CHANNEL_API)) {
                    junctionRecsRetrieveQuery = SELECT_TEXT+WHITE_SPACE+CONSTANT_ID+COMMA_SPACE+CHANNEL_REL_PARENT
                                    +COMMA_SPACE+childObjectFields+FROM_TEXT+childJunctionObject+WHERE_COND+CREATIVE_FIELD_API
                                    +WHITE_SPACE+EQUALS_SYMBOL+ESCAPE_QUOTES+selectedsObjectRecordId+ESCAPE_QUOTES;
                }
                else{
                   junctionRecsRetrieveQuery = SELECT_TEXT+WHITE_SPACE+CONSTANT_ID+COMMA_SPACE+CHANNEL_FIELD_API
                                               +COMMA_SPACE+childObjectFields+FROM_TEXT+childJunctionObject+WHERE_COND+COMMUNICATION_FIELD_API
                                               +WHITE_SPACE+EQUALS_SYMBOL+ESCAPE_QUOTES+selectedsObjectRecordId+ESCAPE_QUOTES; 
                }
                System.debug('Junction SOQL:: '+junctionRecsRetrieveQuery);
                junctionChildList= Database.query(junctionRecsRetrieveQuery);
                System.debug('Junction SOWL Result:: '+junctionChildList.size());
                for(sObject so : junctionChildList){
                    String parentId;
                    System.debug('>>>JunctionCheckDIDID1111>>: '+so);
                    if(childJunctionObject.equalsIgnoreCase('IMH_CommProducts__c')) {
                        parentId = String.valueOf(so.get('Product__c'));
                        //junctionRecIdPRAdditionalInfo.put(String.valueOf(so.get('Product__c')),String.valueOf(so.get('Additional_Info__c')));
                        System.debug('>>>IMH_CommProducts__cIDIDID1111>>: '+junctionRecIdPRAdditionalInfo);
                    }
                    else if(childJunctionObject.equalsIgnoreCase('IMH_CreativeProduct__c')){
                         parentId = String.valueOf(so.getSobject('TargetedProduct__r').get('Product__c'));
                        junctionRecIdPRAdditionalInfo.put(String.valueOf(so.getSobject('TargetedProduct__r').get('Product__c')),String.valueOf(so.get('Additional_Info__c')));
                        System.debug('>>>IMH_CreativeProduct__c>>: '+junctionRecIdPRAdditionalInfo);
                    }
                    else if(childJunctionObject.equalsIgnoreCase(CREATIVE_CHANNEL_API)) {
                        parentId = String.valueOf(so.getsobject(TARGETED_CHANNEL_REL).get(CHANNEL_FIELD_API));
                         if('Other'.equalsIgnoreCase(targetMarket)){
                         junctionRecIdCHAdditionalInfo.put(String.valueOf(so.getSobject('TargetedChannel__r').get(CHANNEL_FIELD_API)),String.valueOf(so.get('Additional_Info__c')));
                         }
                        junctionRecIdStartDateMap.put(parentId,Date.valueOf(so.get(CHANNEL_START_DATE_API)));
                    	junctionRecIdEndDateMap.put(parentId,Date.valueOf(so.get(CHANNEL_END_DATE_API)));
                    }
                    else {
                        parentId = String.valueOf(so.get(CHANNEL_FIELD_API));
                      //  junctionRecIdCHAdditionalInfo.put(String.valueOf(so.get(CHANNEL_FIELD_API)),String.valueOf(so.get('Additional_Info__c')));
                        junctionRecIdStartDateMap.put(parentId,Date.valueOf(so.get(CHANNEL_START_DATE_API)));
                    	junctionRecIdEndDateMap.put(parentId,Date.valueOf(so.get(CHANNEL_END_DATE_API)));
                    }
                    mtargetsObjectByChildId.put(parentId,so);
                }
            }
            /*else if (childJunctionObject.equalsIgnoreCase('IMH_CommProducts__c')) {
                
            }
			*/
        }
        sObjectWrapperList  = new List<SObjectWrapper>();
        for(SObject sobj : SObjectList) {
            styleMap.put(sobj.Id,false);
            sObject sObjJn = null;
            if(Boolean.valueOf(captureInputOnChild)) {
                sObjJn = Schema.getGlobalDescribe().get(childJunctionObject).newSObject();
                for(String ipField : inputColList) {
                    if(childJunctionObject.equalsIgnoreCase(CREATIVE_CHANNEL_API) || childJunctionObject.equalsIgnoreCase(IMH_UtilityConstants.TARGETEDCOMMCHANNEL_OBJECT_API)) {
                        if(ipField.equalsIgnoreCase(CHANNEL_START_DATE_API)) {
                            if(junctionRecIdStartDateMap.containsKey(String.valueOf(sobj.Id))){
                                sObjJn.put(ipField, junctionRecIdStartDateMap.get(String.valueOf(sobj.Id)));
                            }
                            else {
                                if(String.isBlank(inputStartDefaultDate)){
                                    sObjJn.put(ipField, null);
                                }
                                else {
                                    sObjJn.put(ipField, Date.valueOf(inputStartDefaultDate));
                                }
                            }
                            
                        }
                        else if(ipField.equalsIgnoreCase(CHANNEL_END_DATE_API)) {
                            if(junctionRecIdEndDateMap.containsKey(String.valueOf(sobj.Id))){
                                sObjJn.put(ipField, junctionRecIdEndDateMap.get(String.valueOf(sobj.Id)));
                            }
                            else {
                                if(String.isBlank(inputEndDefaultDate)){
                                    sObjJn.put(ipField, null);
                                }
                                else {
                                    sObjJn.put(ipField, Date.valueOf(inputEndDefaultDate));
                                }
                            }
                        }
                       
                        else if (ipField.equalsIgnoreCase('Additional_Info__c')){
                             System.debug('***MMP '+junctionRecIdCHAdditionalInfo.get(String.valueOf(sobj.Id)));
                            if(junctionRecIdCHAdditionalInfo.containsKey(String.valueOf(sobj.Id))){
                                sObjJn.put(ipField, junctionRecIdCHAdditionalInfo.get(String.valueOf(sobj.Id)));
                            }
                            else {
                            	sObjJn.put(ipField, null);
                        	}
                        }
                        else {
                            sObjJn.put(ipField, null);
                        }
                    }
                    else if (childJunctionObject.equalsIgnoreCase('IMH_CommProducts__c')) {
                        if (ipField.equalsIgnoreCase('Additional_Info__c')){
                            System.debug('>>>IMH_CommProducts__cIDIDI222222>: '+junctionRecIdPRAdditionalInfo);
                            System.debug('>>>IMH_CommProdu333333>: '+ipField);
                            if(junctionRecIdPRAdditionalInfo.containsKey(String.valueOf(sobj.Id))){
                                sObjJn.put(ipField, junctionRecIdPRAdditionalInfo.get(String.valueOf(sobj.Id)));
                            }
                            else {
                            	sObjJn.put(ipField, null);
                        	}
                        }
                        else {
                            sObjJn.put(ipField, null);
                        }
                    }
                    else if(childJunctionObject.equalsIgnoreCase('IMH_CreativeProduct__c')){
                       if (ipField.equalsIgnoreCase('Additional_Info__c')){
                            System.debug('>>>IMH_CommProducts__cIDIDI222222>: '+junctionRecIdPRAdditionalInfo);
                            System.debug('>>>IMH_CommProdu333333>: '+ipField);
                            if(junctionRecIdPRAdditionalInfo.containsKey(String.valueOf(sobj.Id))){
                                sObjJn.put(ipField, junctionRecIdPRAdditionalInfo.get(String.valueOf(sobj.Id)));
                            }
                            else {
                            	sObjJn.put(ipField, null);
                        	}
                        }
                        else {
                            sObjJn.put(ipField, null);
                        } 
                    }
                }
            }
            if(inStateSelectedRecords.contains(String.valueOf(sobj.Id))){
                sObjectWrapperList.add(new SObjectWrapper(sobj,true,true,colList,inputColList,sObjJn,true));
                inStateSelectedRecords.remove(String.valueOf(sobj.Id));
            }
            else {
                sObjectWrapperList.add(new SObjectWrapper(sobj,false,false,colList,inputColList,sObjJn,true));
            }
            if(initialState){
                initialsObjectWrapperList.put(String.valueOf(sobj.Id),new SObjectWrapper(sobj,true,true,colList,inputColList,sObjJn,false));
            }
        }
        for(String str : inStateSelectedRecords){
            sObjectWrapperList.add(initialsObjectWrapperList.get(str));
        }
        initialSearchDone = false;
        initialState = false;
        if(!sObjectWrapperList.isEmpty()){
            totalRecs = sObjectWrapperList.size();
            filteredSObjectWrapList();
            showSearchResultsPanel = true; 
        }
        else {
            showSearchResultsPanel = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,System.label.IMH_AlertNoProducts);
            ApexPages.addMessage(myMsg);
        }
    }
    //Create wrapper List methods Ends
    
    /**
    * @description  - Method to process selected records from the table
    * @param  - None
    * @return  - PageReference
    */
    public PageReference processSelected() {
        Boolean doRedirect = false;
        Boolean doRedirectOnDelete = false;
        isDMLSuccess = true;
        Set<Id> notValidListIds = new Set<Id>();
        
        selectedSObjectsList = new List<SObjectWrapper>();
        List<sObject> finalDeleteRecsList = new List<sObject>();
        Set<String> sSelectedRecsId = new Set<String>();
        SYstem.debug('***AddSet '+addedSet);
        System.debug('***MAPPER '+mtargetsObjectByChildId);
        for(SObjectWrapper sObjWrap: sObjectWrapperList) {
             SYstem.debug('***ObjectWrapper 123 '+sObjWrap);
            
            styleMap.put(sObjWrap.sObjectRecord.Id,false);
            if(addedSet.contains(sObjWrap.sObjectRecord.Id) && (!sObjWrap.isSelected)) {
                finalDeleteChildIdSet.add(sObjWrap.sObjectRecord.Id);
            }
            if((sObjWrap.isSelected && ((!addedSet.contains(sObjWrap.sObjectRecord.Id))
                                            
                                            || childObject.equalsIgnoreCase(CHANNEL_API)
                                            || ((childObject.equalsIgnoreCase(BENEFIT_API) || childObject.equalsIgnoreCase('IMH_Product__c'))
                                                && Boolean.valueOf(captureInputOnChild))))) {
                selectedSObjectsList.add(sObjWrap);
            }
        }
        SYstem.debug('***SELECTED 123 '+selectedSObjectsList);
        Savepoint sp = Database.setSavepoint();
        if(selectedSObjectsList.isEmpty() && finalDeleteChildIdSet.isEmpty()) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,System.label.IMH_AlertSelectAtleastOneProduct);
            ApexPages.addMessage(myMsg);
            isDMLSuccess = false;
        }
        else {
            Id sobjectId = selectedsObjectRecordId;
            if(childObject.equalsIgnoreCase(PRODUCT_API)) {
                if(!finalDeleteChildIdSet.isEmpty()) {
                    //Adding Code For Communication Product 
                    if(sobjectId.getSobjectType() !=  Schema.IMH_Communication__c.SObjectType) {
                         finalDeleteRecsList = [SELECT Id, Creative__c, TargetedProduct__r.Product__c FROM IMH_CreativeProduct__c WHERE 
                                           Creative__c =: selectedsObjectRecordId AND 
                                           TargetedProduct__r.Product__c =: finalDeleteChildIdSet];
                        }
                    else{
                        finalDeleteRecsList = [SELECT Id, Communication__c, Product__c FROM IMH_CommProducts__c WHERE 
                                                Communication__c =: selectedsObjectRecordId AND 
                                                Product__c =: finalDeleteChildIdSet];
                    }
                    List<IMH_CreativeProduct__c> finalProductDeleteList = new List<IMH_CreativeProduct__c>();
                    //Adding Code For Communication Product
                     List<IMH_CommProducts__c> finalCommProductDeleteList = new List<IMH_CommProducts__c>();
                     Database.DeleteResult[] productDelList;
                    if(sobjectId.getSobjectType() !=  Schema.IMH_Communication__c.SObjectType){
                        finalProductDeleteList = finalDeleteRecsList.clone();
                         productDelList = Database.delete(finalProductDeleteList, false);
                    }
                    //Adding Code For Communication Product
                    else{
                        finalCommProductDeleteList = finalDeleteRecsList.clone();
                         productDelList = Database.delete(finalCommProductDeleteList, false);
                    }
                    
                    integer selectedCounter = 0;
                    
                    for(Database.DeleteResult dr : productDelList) {
                        if(!dr.isSuccess()) {
                            isDMLSuccess=false;
                            for(Database.Error err : dr.getErrors()) {
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,err.getMessage());
                                ApexPages.addMessage(myMsg);
                                if(!finalCommProductDeleteList.isEmpty()){
                                    styleMap.put(String.valueof(finalCommProductDeleteList.get(selectedCounter).Product__c),true);
                                }
                                else {
                                    styleMap.put(String.valueof(finalProductDeleteList.get(selectedCounter).TargetedProduct__r.Product__c),true);   
                                }
                            }
                        }
                        selectedCounter++;
                    }
                }
                if(!selectedSObjectsList.isEmpty()) {		
                    System.debug('******POPOP '+selectedSObjectsList);
                    List<IMH_CreativeProduct__c> insertCreativeProductList = new List<IMH_CreativeProduct__c>();
                    List<IMH_CommProducts__c> insertCommProductList = new List<IMH_CommProducts__c>();
                    Map<String,String> mprodtargetedprodMap = new  Map<String,String>();
                    Database.UpsertResult [] prodInsertList;
                    IMH_EasyCreationUtility easyCreObj = new IMH_EasyCreationUtility();
                    easyCreObj.errorOnTargetedInsert = false;
                    if(sobjectId.getSobjectType() !=  Schema.IMH_Communication__c.SObjectType){
                        IMH_CommCreative__c creativeRec = [SELECT Id, Name, Communication__c FROM IMH_CommCreative__c 
                                                           WHERE Id =: selectedsObjectRecordId LIMIT 1];
                        Map<Id,Id> targetedProductIdMap = new  Map<Id,Id>();
                        
                        targetedProductIdMap = easyCreObj.retrieveTargetedProductId(sobjectId,selectedSObjectsList);
                        IMH_CreativeProduct__c targetedProductRec;
                        List<IMH_CommProducts__c> lCommunicationChannelInsert = new List<IMH_CommProducts__c>();
                        IMH_CommProducts__c commchannel;
                        for(SObjectWrapper swrap : selectedSObjectsList) {
                             if(mtargetsObjectByChildId.containsKey(swrap.sObjectRecord.Id)) {
                                targetedProductRec = (IMH_CreativeProduct__c) mtargetsObjectByChildId.get(swrap.sObjectRecord.Id);
                            }
                            else{
                                targetedProductRec = new IMH_CreativeProduct__c();
                            targetedProductRec.Creative__c = selectedsObjectRecordId;
                            targetedProductRec.Market__c  = String.valueOf(swrap.sObjectRecord.get(MARKET_FIELD_API));
                            }
                            
                            if('Other'.equalsIgnoreCase(targetMarket)) {
                                System.debug('****ADDINFORMATION '+String.valueOf(swrap.junctionsObjectRec.get('Additional_Info__c')));
                            	targetedProductRec.Additional_Info__c = String.valueOf(swrap.junctionsObjectRec.get('Additional_Info__c'));
                            }
                            if(targetedProductIdMap.containsKey(swrap.sObjectRecord.Id)){
                                if(!mtargetsObjectByChildId.containsKey(swrap.sObjectRecord.Id)) {
                                     targetedProductRec.TargetedProduct__c = targetedProductIdMap.get(swrap.sObjectRecord.Id);
                                }
                               
                                mprodtargetedprodMap.put(targetedProductRec.TargetedProduct__c,swrap.sObjectRecord.Id);
                            }
                            System.debug('****1.2>>: '+swrap.sObjectRecord.Id);
                            System.debug('****1.2.1>>: '+mprodtargetedprodMap);
                            insertCreativeProductList.add(targetedProductRec);
                        }
                        prodInsertList =  Database.upsert(insertCreativeProductList, false);
                    }
                    else {
                        System.debug('Inserint CommPRoducst<<>**1');
                        IMH_CommProducts__c targetedProductRec;
                        for(SObjectWrapper swrap : selectedSObjectsList) {
                            targetedProductRec = new IMH_CommProducts__c();
                            targetedProductRec.Communication__c = selectedsObjectRecordId;
                            targetedProductRec.Product__c = swrap.sObjectRecord.Id;
                            targetedProductRec.Market__c  = String.valueOf(swrap.sObjectRecord.get(MARKET_FIELD_API));
                            //System.debug('>3.555>>>>>>>>:: '+String.valueOf(swrap.junctionsObjectRec.get('Additional_Info__c')));
                            
                            insertCommProductList.add(targetedProductRec);
                        }
                        System.debug('*****PRODSCOMSS '+insertCommProductList);
                        prodInsertList =  Database.upsert(insertCommProductList, false);
                    }
                    integer selectedCounter = 0;
                    for(Database.UpsertResult sr: prodInsertList) {    
                        if(!sr.isSuccess()){
                            isDMLSuccess = false;
                            for(Database.Error err : sr.getErrors()) {
                                /* Below if loop will check if there is any error message 
                                 * displayed on the page when targeted product got inserted. If there was a message,
                                 * this will skip the message on Creative Product
                                */ 
                                if(!easyCreObj.errorOnTargetedInsert) { 
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,err.getMessage());
                                    ApexPages.addMessage(myMsg);
                                    System.debug('*****MSGEEr '+myMsg);
                                    if(!insertCreativeProductList.isEmpty()) {
                                        System.debug('**Error1 '+insertCreativeProductList.get(selectedCounter));
                                        System.debug('**Error1 '+insertCreativeProductList.get(selectedCounter).get('TargetedProduct__c'));
                                        System.debug('**Error2 '+mprodtargetedprodMap.get(String.valueof(insertCreativeProductList.get(selectedCounter).get('TargetedProduct__c'))));
                                        //System.debug('**Error3 '+insertCreativeProductList.get(selectedCounter).getsobject('TargetedProduct__r').get(PRODUCT_FIELD_API));
                                        styleMap.put(String.valueof(mprodtargetedprodMap.get(String.valueof(insertCreativeProductList.get(selectedCounter).get('TargetedProduct__c')))),true);
                                    }
                                    else {
                                        styleMap.put(String.valueof(insertCommProductList.get(selectedCounter).get(PRODUCT_FIELD_API)),true);
                                    }
                                }
                                else {
                                    if(easyCreObj.easyStyleMap != NULL || !easyCreObj.easyStyleMap.isEmpty()) {
                                        for(String prId : easyCreObj.easyStyleMap.keySet()) {
                                            if(styleMap.containsKey(prId)){
                                                styleMap.put(prId,true);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        selectedCounter++;
                    }
                }
            }
            else if(childObject.equalsIgnoreCase(CHANNEL_API)) {
                if(!finalDeleteChildIdSet.isEmpty()) {
                    //Adding Code For Communication Product 
                    if(sobjectId.getSobjectType() !=  Schema.IMH_Communication__c.SObjectType) {
                        finalDeleteRecsList = [SELECT Id, Creative__c, TargetedChannel__r.Channel__c FROM IMH_CreativeChannel__c WHERE 
                                                Creative__c =: selectedsObjectRecordId AND 
                                                TargetedChannel__r.Channel__c =: finalDeleteChildIdSet];
                    }
                    else{
                        finalDeleteRecsList = [SELECT Id, Communication__c, Channel__c FROM IMH_CommChannels__c WHERE 
                                                Communication__c =: selectedsObjectRecordId AND 
                                                Channel__c =: finalDeleteChildIdSet];
                    }
                    List<IMH_CreativeChannel__c> finalChannelDeleteList = new List<IMH_CreativeChannel__c>();
                    List<IMH_CommChannels__c> finalCommChannelDeleteList = new List<IMH_CommChannels__c>();
                     Database.DeleteResult[] channelDelList ;
                    //Adding Code For Communication Product 
                    if(sobjectId.getSobjectType() !=  Schema.IMH_Communication__c.SObjectType)
                    {
                        finalChannelDeleteList = finalDeleteRecsList.clone();
                        channelDelList = Database.delete(finalChannelDeleteList, false);
                        integer selectedCounter = 0;
                        for(Database.DeleteResult dr : channelDelList) {
                            if(!dr.isSuccess()) {
                                isDMLSuccess=false;
                                for(Database.Error err : dr.getErrors()) {
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,err.getMessage());
                                    ApexPages.addMessage(myMsg);
                                    styleMap.put(String.valueof(finalChannelDeleteList.get(selectedCounter).TargetedChannel__r.Channel__c),true);
                                }
                            }
                            selectedCounter++;
                        }
                    }
                    else{
                        finalCommChannelDeleteList = finalDeleteRecsList.clone();
                        channelDelList = Database.delete(finalCommChannelDeleteList, false);
                        integer selectedCounter = 0;
                        for(Database.DeleteResult dr : channelDelList) {
                            if(!dr.isSuccess()) {
                                isDMLSuccess=false;
                                for(Database.Error err : dr.getErrors()) {
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,err.getMessage());
                                    ApexPages.addMessage(myMsg);
                                    styleMap.put(String.valueof(finalCommChannelDeleteList.get(selectedCounter).Channel__c),true);
                                }
                            }
                            selectedCounter++;
                        }
                    }
                }
                if(!selectedSObjectsList.isEmpty()) {
                    List<IMH_CreativeChannel__c> insertCreativeChannelList = new List<IMH_CreativeChannel__c>();
                    //Adding Code For Communication Product 
                    List<IMH_CommChannels__c> insertTargetedChannelList = new List<IMH_CommChannels__c>();
                    //Adding Code For Communication Product 
                    IMH_EasyCreationUtility easyCreObj = new IMH_EasyCreationUtility();
                    Map<String,String> mtargchannel = new Map<String,String>();
                    easyCreObj.errorOnTargetedInsert = false;
                    if(sobjectId.getSobjectType() !=  Schema.IMH_Communication__c.SObjectType){
                        Map<Id,Id> targetedChannelIdMap = new  Map<Id,Id>();
                        targetedChannelIdMap = easyCreObj.retrieveTargetedChannelId(sobjectId,selectedSObjectsList);
                        IMH_CreativeChannel__c targetedChannelRec;
                        for(SObjectWrapper swrap : selectedSObjectsList) {
                            if(mtargetsObjectByChildId.containsKey(swrap.sObjectRecord.Id)) {
                                targetedChannelRec = (IMH_CreativeChannel__c) mtargetsObjectByChildId.get(swrap.sObjectRecord.Id);
                            }
                            else{
                                targetedChannelRec = new IMH_CreativeChannel__c();
                                targetedChannelRec.Creative__c  = selectedsObjectRecordId;
                                if(targetedChannelIdMap.containsKey(swrap.sObjectRecord.Id)){
                                    targetedChannelRec.TargetedChannel__c = targetedChannelIdMap.get(swrap.sObjectRecord.Id);
                                    mtargchannel.put(targetedChannelRec.TargetedChannel__c,swrap.sObjectRecord.Id);
                                }
                            }
                            targetedChannelRec.Channel_End_Date__c = Date.valueOf(swrap.junctionsObjectRec.get(CHANNEL_END_DATE_API));
                            targetedChannelRec.Channel_Start_Date__c = Date.valueOf(swrap.junctionsObjectRec.get(CHANNEL_START_DATE_API));
                            targetedChannelRec.Additional_Info__c = String.valueOf(swrap.junctionsObjectRec.get('Additional_Info__c'));
                            insertCreativeChannelList.add(targetedChannelRec);
                        }
                    }
                    //Adding Code For Communication Product 
                    else {
                        IMH_CommChannels__c targetedChannelRec;
                        for(SObjectWrapper swrap : selectedSObjectsList) {
                            if(mtargetsObjectByChildId.containsKey(swrap.sObjectRecord.Id)) {
                                targetedChannelRec = (IMH_CommChannels__c) mtargetsObjectByChildId.get(swrap.sObjectRecord.Id);
                            }
                            else{
                                targetedChannelRec = new IMH_CommChannels__c();
                                targetedChannelRec.Channel__c = swrap.sObjectRecord.Id;
                                targetedChannelRec.Communication__c  = selectedsObjectRecordId;
                            }
                            targetedChannelRec.Channel_End_Date__c = Date.valueOf(swrap.junctionsObjectRec.get(CHANNEL_END_DATE_API));
                            targetedChannelRec.Channel_Start_Date__c = Date.valueOf(swrap.junctionsObjectRec.get(CHANNEL_START_DATE_API));
                            targetedChannelRec.Additional_Info__c = String.valueOf(swrap.junctionsObjectRec.get('Additional_Info__c'));
                            insertTargetedChannelList.add(targetedChannelRec);
                        }
                    }
                    Database.UpsertResult [] channelInsertList ;
                    //Adding Code For Communication Product 
                    if(sobjectId.getSobjectType() !=  Schema.IMH_Communication__c.SObjectType){
                        channelInsertList =  Database.upsert(insertCreativeChannelList,false);
                    }
                    else{
                        channelInsertList=  Database.upsert(insertTargetedChannelList,false); 
                    }
                    integer selectedCounter = 0;
                    integer counterOnCommunication = 0;
                    for(Database.UpsertResult sr: channelInsertList){    
                        if(!sr.isSuccess()) {
                            isDMLSuccess=false;
                            for(Database.Error err : sr.getErrors()) {
                                /* If loop explanation same as that of product */
                                if(!easyCreObj.errorOnTargetedInsert) { 
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,err.getMessage());
                                    ApexPages.addMessage(myMsg);
                                    if(!insertTargetedChannelList.isEmpty()) {
                                       styleMap.put(String.valueof(insertTargetedChannelList.get(selectedCounter).Channel__c),true);
                                    }
                                    else {
                                        //System.debug('****ChannelError1 '+insertCreativeChannelList.get(selectedCounter).TargetedChannel__r.Channel__c);
                                       styleMap.put(String.valueof(mtargchannel.get(insertCreativeChannelList.get(selectedCounter).TargetedChannel__c)),true); 
                                    }
                                }
                                else {
                                    if(easyCreObj.easyStyleMap != NULL || !easyCreObj.easyStyleMap.isEmpty()) {
                                        for(String chId : easyCreObj.easyStyleMap.keySet()) {
                                            if(styleMap.containsKey(chId)){
                                                styleMap.put(chId,true);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        selectedCounter++;
                    }
                }
            }
            else{
                
                if(!finalDeleteChildIdSet.isEmpty()) {
                    finalDeleteRecsList = [SELECT Id, Communication__c, BenefitOffers__c FROM IMH_PreApprovedBenefits__c WHERE 
                                           Communication__c =: selectedsObjectRecordId AND 
                                           BenefitOffers__c =: finalDeleteChildIdSet];
                    List<IMH_PreApprovedBenefits__c> finalPreApprovedBenefitDeleteList = new List<IMH_PreApprovedBenefits__c>();
                    finalPreApprovedBenefitDeleteList = finalDeleteRecsList.clone();
                    Database.DeleteResult[] preApprovedBenefitDelList = Database.delete(finalPreApprovedBenefitDeleteList, false);
                    integer selectedCounter = 0;
                    for(Database.DeleteResult dr : preApprovedBenefitDelList) {
                        if(!dr.isSuccess()) {
                            isDMLSuccess=false;
                            for(Database.Error err : dr.getErrors()) {
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,err.getMessage());
                                ApexPages.addMessage(myMsg);
                                styleMap.put(String.valueof(finalPreApprovedBenefitDeleteList.get(selectedCounter).BenefitOffers__c),true);
                            }
                        }
                        selectedCounter++;
                    }
                }
                if(!selectedSObjectsList.isEmpty()) {
                    List<IMH_PreApprovedBenefits__c> insertPreApprovedBenefitlList = new List<IMH_PreApprovedBenefits__c>();
                    IMH_PreApprovedBenefits__c targetedPreApprovedBenfitRec;
                    for(SObjectWrapper swrap : selectedSObjectsList) {
                        if(mtargetsObjectByChildId.containsKey(swrap.sObjectRecord.Id)) {
                            targetedPreApprovedBenfitRec = (IMH_PreApprovedBenefits__c) mtargetsObjectByChildId.get(swrap.sObjectRecord.Id);
                        }
                        else{
                            targetedPreApprovedBenfitRec = new IMH_PreApprovedBenefits__c();
                            targetedPreApprovedBenfitRec.BenefitOffers__c = swrap.sObjectRecord.Id;
                            targetedPreApprovedBenfitRec.Communication__c  = selectedsObjectRecordId;
                        }
                        insertPreApprovedBenefitlList.add(targetedPreApprovedBenfitRec);
                    }
                    Database.UpsertResult [] preApprovedBenefitInsertList =  Database.upsert(insertPreApprovedBenefitlList,false);
                    integer selectedCounter = 0;
                    
                    for(Database.UpsertResult sr: preApprovedBenefitInsertList){    
                        if(!sr.isSuccess()) {
                            isDMLSuccess=false;
                            for(Database.Error err : sr.getErrors()) {
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,err.getMessage());
                                ApexPages.addMessage(myMsg);
                                styleMap.put(String.valueof(insertPreApprovedBenefitlList.get(selectedCounter).BenefitOffers__c),true);
                            }
                            
                        }
                        selectedCounter++;
                    }
                }
            }
        }
        if(isDMLSuccess) {
            PageReference pageRef = new PageReference(IMH_UtilityConstants.FORWARD_SLASH+selectedsObjectRecordId);
            return pageRef;
        }
        else{
            Database.RollBack(sp);
            return null;
        }
    }
    
    /**
    * @description  - Method to go back to parent record
    * @param  - None
    * @return  - PageReference
    */
    public PageReference cancelAdding(){
        PageReference pageRef = new PageReference(IMH_UtilityConstants.FORWARD_SLASH+selectedsObjectRecordId);
        return pageRef;
    }
    /**
    * @description  - Methods to get Sobject related data from Schema Starts
    * @param  - None
    * @return  - List
    */
    public List < SelectOption > getListOfFields() {
        options = new List < SelectOption > ();
        List <Schema.FieldSetMember> FieldsInFieldSetList = new List < Schema.FieldSetMember > ();
        FieldsInFieldSetList = readFieldSet(childObject.substring(0,childObject.length()-2)+FILTET_RULE_FIELD_SET, childObject);
        options.add(new SelectOption(BLANK_SPACE, SELECT_OPTION));
        for (Schema.FieldSetMember field: FieldsInFieldSetList) {
            options.add(new SelectOption(field.getFieldPath(), field.getLabel()));
        }
        return options;
    } //End of ListofFields
    
    /**
    * @description  - Methods to get List of MERGE Conditions
    * @param  - None
    * @return  - null
    */
    public void ListOfConditions() {
        List <SelectOption> FieldsList = options;
        for (SelectOption s : FieldsList) {
            List <SelectOption> options = new List <SelectOption> ();
            FieldConditionMap.put(null, options);
            if (s.getLabel() != SELECT_OPTION) {
                String searchFieldSelected = String.Valueof(s.getValue());
                String searchFieldType;
                if (searchFieldSelected != BLANK_SPACE || searchFieldSelected != null) {
                    searchFieldType = getFieldType(searchFieldSelected, childObject);
                }
                options.add(new SelectOption(EQUALS_SYMBOL, EQUALS_TEXT));
                options.add(new SelectOption(NOT_EQUALS_SYMBOL, NOT_EQUALS_TEXT));
                FieldConditionMap.put(searchFieldSelected, options);
                if (searchFieldType == NUMBER_TEXT) {
                    options.add(new SelectOption(LESS_THAN_SYMBOL, LESS_THAN_TEXT));
                    options.add(new SelectOption(GREATER_THAN_SYMBOL, GREATER_THAN_TEXT));
                    FieldConditionMap.put(searchFieldSelected, options);
                } else if (searchFieldType == STRING_TEXT){
                    options.add(new SelectOption(CONTAINS_TEXT, CONTAINS_TEXT));
                    options.add(new SelectOption(STARTS_WITH_TEXT, STARTS_WITH_TEXT));
                    FieldConditionMap.put(searchFieldSelected, options);
                } else if (searchFieldType == DATE_TEXT) {
                    options.add(new SelectOption(LESS_THAN_SYMBOL, LESS_THAN_TEXT));
                    options.add(new SelectOption(GREATER_THAN_SYMBOL, GREATER_THAN_TEXT));
                    FieldConditionMap.put(searchFieldSelected, options);
                } else if((searchFieldType == PICKLIST) || (searchFieldType == URL_TEXT)){
                    options.add(new SelectOption(CONTAINS_TEXT, CONTAINS_TEXT));
                    options.add(new SelectOption(STARTS_WITH_TEXT, STARTS_WITH_TEXT));
                    FieldConditionMap.put(searchFieldSelected, options);
                } else if(searchFieldType == PHONE_TEXT) {
                    options.add(new SelectOption(CONTAINS_TEXT, CONTAINS_TEXT));
                    options.add(new SelectOption(STARTS_WITH_TEXT, STARTS_WITH_TEXT));
                    FieldConditionMap.put(searchFieldSelected, options);
                } else if(searchFieldType == MULTI_PICKLIST) {
                    options.add(new SelectOption(INCLUDES, LOWERCASE_INCLUDES));
                    options.add(new SelectOption(EXCLUDES, LOWERCASE_EXCLUDES));
                    FieldConditionMap.put(searchFieldSelected, options);
                } 

            }
        } //End of For Loop     
    }//End of ListOfConditions()

    /**
    * @description  - Methods to dynamically get the Selected Field datatype
    * @param  - None
    * @return  - String
    */
    public String getFieldType(String fieldName, String ObjectName) {
        if (fieldTypeByAPIName.get(fieldName) == Schema.DisplayType.Boolean) {
            return BOOLEAN_TEXT;
        }
        else if (fieldTypeByAPIName.get(fieldName) == Schema.DisplayType.String) {
            return STRING_TEXT;
        }
        else if ((fieldTypeByAPIName.get(fieldName) == Schema.DisplayType.Date) 
                 || (fieldTypeByAPIName.get(fieldName) == Schema.DisplayType.DateTime)){
            return DATE_TEXT;
        }
        else if ((fieldTypeByAPIName.get(fieldName) == Schema.DisplayType.Integer)
                    ||(fieldTypeByAPIName.get(fieldName)== Schema.DisplayType.Double) 
                    || (fieldTypeByAPIName.get(fieldName) == Schema.DisplayType.Currency)) {
            return NUMBER_TEXT;
        }
        else if (fieldTypeByAPIName.get(fieldName) == Schema.DisplayType.Id) {
            return CONSTANT_ID;
        }
        else if (fieldTypeByAPIName.get(fieldName) == Schema.DisplayType.Picklist) {
            return PICKLIST;
        }
        else if (fieldTypeByAPIName.get(fieldName) == Schema.DisplayType.TextArea) {
            return STRING_TEXT;
        }
        else if (fieldTypeByAPIName.get(fieldName) == Schema.DisplayType.URL) {
            return URL_TEXT;
        }
        else if (fieldTypeByAPIName.get(fieldName) == Schema.DisplayType.Phone) {
            return PHONE_TEXT;
        }
        else if (fieldTypeByAPIName.get(fieldName) == Schema.DisplayType.MultiPicklist) {
            return MULTI_PICKLIST;    
        }
        return null;
    }
    
    /**
    * @description  - Methods to get fields from Field Set
    * @param  - None
    * @return  - String
    */
    public List < Schema.FieldSetMember > readFieldSet(String fieldSetName, String ObjectName) {
        Map < String, Schema.SObjectType > GlobalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        if(fieldSetObj != null){
            return fieldSetObj.getFields();
        }
        else{
            return null;
        } 
            
    }
    //Methods to get Sobject related data from Schema Ends.
    
    //Wrapper Methods Starts
    /**
    * @description  - Warpper Method - SearchFieldsWrapper is for searching with field filters
    * @param  - None
    * @return  - String
    */
    public class SearchFieldsWrapper{
        public String searchParam     {get;set;}
        public String searchField     {get;set;}
        public String searchOperator  {get;set;}
        
        public SearchFieldsWrapper(){
        }
    }
    /**
    * @description: Methods to add new field filter rule
    * @param: none
    * @return: void
    */
    public void AddSearchRules() {
        SearchFieldsWrapperList.add(new SearchFieldsWrapper());
    }
    
    /**
    * @description: Methods to remove field filter rule based on rowIndex
    * @param: none
    * @return: void
    */
    public void RemoveSearchRule() {
        ruleRowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get(RULE_ROW_INDEX_PARAM));
        Integer actualIndex = ruleRowIndex - 1;
        SearchFieldsWrapperList.remove(actualIndex);
        if(SearchFieldsWrapperList.isEmpty()){
            List <SelectOption> nullOptions = new List <SelectOption> ();
            nullOptions.add(new SelectOption(BLANK_SPACE, NONE_OPTION));
            FieldConditionMap.put(null, nullOptions);
            AddSearchRules();
        }
    }
    
    /**
    * @description: Sobject wrapper with checkbox and additional fields
    * @param: none
    * @return: void
    */
    public Class SObjectWrapper {
        public sObject sObjectRecord        {get;set;}
        public List<String> columnList      {get;set;}
        public sObject junctionsObjectRec   {get;set;}
        public List<String> inputColumnList {get;set;}
        public Boolean isSelected           {get;set;}
        public Boolean isAlreadyAdded       {get;set;}
        public Boolean isValidToDisplay       {get;set;}
        
        public SObjectWrapper (sObject sObj, Boolean sel,
                               Boolean alreadyAdded, List<String> colList, List<String> inputColList,
                               sObject sObjJn, Boolean isValid ){
            sObjectRecord      = sObj;
            isSelected         = sel;
            isAlreadyAdded     = alreadyAdded;
            columnList         = colList;
            inputColumnList    = inputColList;
            junctionsObjectRec = sObjJn;
            isValidToDisplay   = isValid;
        }
    }
    //Wrapper Methods Ends
    
    /**
    * @description: Pagination methods starts
    * @param: none
    * @return: void
    */
    public List<SObjectWrapper> filteredSObjectWrapList() {
        paginatedSObjectWrapList = new List<SObjectWrapper>();
        if(!paginatedSObjectWrapList.isEmpty()){
            paginatedSObjectWrapList.clear();
        }
        rowCount = 0;
        for(Integer i=index;(i<index+blockSize && i<totalRecs);i++) {
            SObjectWrapper sObjectWrapRec = sObjectWrapperList.get(i);
            paginatedSObjectWrapList.add(sObjectWrapRec);
            rowCount++;
        }
        return paginatedSObjectWrapList;
    }
    public void beginning() {
        index = 0;
        filteredSObjectWrapList();
    }
    public void previous() {
        index = index - blockSize;
        filteredSObjectWrapList();
    }
    public void next() {
        index = index + blockSize;
        filteredSObjectWrapList();
    }
    public void end() {
        if(math.mod(totalRecs,blockSize) == 0) {
            index = totalrecs - blockSize;
        }
        else {
            index = totalrecs - math.mod(totalRecs,blockSize);
        }
        filteredSObjectWrapList();
    }
    public boolean getprev() {
        if(index == 0)
            return true;
        else
            return false;
    }
    public boolean getnxt() {
        if((index + blockSize) > totalRecs)
            return true;
        else
            return false;
    }
    //Pagination methods ends
    
}