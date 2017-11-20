/**************************************************************************************
 * Author: M.Wheeler
 * Date: 25-11-2016
 * Desc: IMH R1.8 - Visualforce controller for rule engine
 * Revisions:
 *************************************************************************************/
public class IMH_RuleDisplayController {
    
    public List<RuleCriteriaWrapper> relatedRuleCriteria {get; set;}
    public IMH_Rule__c currentRule {get; set;}
    public IMH_MetadataUtilityClass mdu = new IMH_MetadataUtilityClass();
    
    //Table wrapper Class
    public class RuleCriteriaWrapper implements Comparable {

        public Integer compareTo(Object objectToCompareTo) {
            RuleCriteriaWrapper rcwCompare = (RuleCriteriaWrapper)objectToCompareTo;
            if(rcwCompare.criteria.Order__c == criteria.Order__c) return 0;
            else if(!orderASC && rcwCompare.criteria.Order__c < criteria.Order__c) return 1;
            else if(!orderASC && rcwCompare.criteria.Order__c > criteria.Order__c) return -1;
            else if(orderASC && rcwCompare.criteria.Order__c < criteria.Order__c) return -1;
            else if(orderASC && rcwCompare.criteria.Order__c > criteria.Order__c) return 1;
            else return 0;
        }
        public Boolean orderASC {get; set;}
        public Boolean selected {get; set;}
        public IMH_RuleCriteria__c criteria {get; set;}
    
    }

    //Constructor
    public IMH_RuleDisplayController(ApexPages.StandardController stdController) {
        
        relatedRuleCriteria = new List<RuleCriteriaWrapper>();
        
        if(stdController.getId() != null) {
            currentRule = getRelatedRule(stdController.getId());
        }
        else {
            currentRule = new IMH_Rule__c();
        }
        
        for(IMH_RuleCriteria__c rc :getRelatedCriteria(stdController.getId())) {
            RuleCriteriaWrapper rcw = new RuleCriteriaWrapper();
            rcw.selected = false;
            rcw.criteria = rc;
            relatedRuleCriteria.add(rcw);
        }
        
    }
    
    //Page Block Button Methods, save all and remove all records
    public pageReference saveRecords() {
        
        //validate first
        validatePage(currentRule, relatedRuleCriteria);
        
        try {
            upsert currentRule;
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        List<IMH_RuleCriteria__c> ruleCriteria = new List<IMH_RuleCriteria__c>();

        //for(IMH_RuleCriteria__c rc :relatedRuleCriteria) {
        for(RuleCriteriaWrapper rc :relatedRuleCriteria) {
            if(rc.criteria.Rule__c == null) rc.criteria.Rule__c = currentRule.Id;
            ruleCriteria.add(rc.criteria);
        }
        
        
        try {
            upsert ruleCriteria;
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        
        return ApexPages.currentPage();
    }
    public pageReference deleteRecords() {
        if(currentRule.Id != null) {
            delete currentRule;
        }
        
        String returnURL = '/' + currentRule.getSObjectType().getDescribe().getKeyPrefix() + '/o';
        return new Pagereference(returnURL);
    }
    
    //Rule Criteria Table Methods, add row, remove selected row, order column
    public void addRow() {
    	RuleCriteriaWrapper rcw = new RuleCriteriaWrapper();
        rcw.criteria = new IMH_RuleCriteria__c(Order__c = getHighestOrderNumber(relatedRuleCriteria));
        rcw.selected = false;
        relatedRuleCriteria.add(rcw);
    }
    public void removeRow() {
        List<IMH_RuleCriteria__c> ruleCriteria = new List<IMH_RuleCriteria__c>();
        
        List<RuleCriteriaWrapper> newRCW = new List<RuleCriteriaWrapper>();
        
        for(Integer i = 0; i < relatedRuleCriteria.size(); i++) {
            RuleCriteriaWrapper rcw = relatedRuleCriteria.get(i);
            if(!rcw.selected) {
                newRCW.add(rcw);
            }
            if(rcw.selected && rcw.criteria.Id != null){
                ruleCriteria.add(rcw.criteria);
            }
        }

        relatedRuleCriteria = newRCW;
        delete ruleCriteria;
    }
    public void sortByOrder() {
        for(RuleCriteriaWrapper rcw :relatedRuleCriteria) {
            if(rcw.orderASC == null) rcw.orderASC = false;
            else if(rcw.orderAsc) rcw.orderASC = false;
            else rcw.orderAsc = true;
        }

        relatedRuleCriteria.sort();    
    }
    
	//Helper Methods
    private List<IMH_RuleCriteria__c> getRelatedCriteria(Id ruleId){
        return [SELECT ID, Field__c, Operator__c, Order__c, Rule__c, Value__c FROM IMH_RuleCriteria__c WHERE Rule__c = :ruleId ORDER BY Order__c ASC];
    }
    private IMH_Rule__c getRelatedRule(Id ruleId){
        return [SELECT ID, Name, CriteriaLogic__c, RelatedTo__c, SourceObject__c, TargetObject__c, Active__c  FROM IMH_Rule__c WHERE Id = :ruleId];
    }
    private Integer getHighestOrderNumber(List<RuleCriteriaWrapper> criteriaWrapper) {
        Integer highestOrder = 1;
        for(RuleCriteriaWrapper rcw :criteriaWrapper) {
            if(rcw.criteria.Order__c >= highestOrder) {
                highestOrder = Integer.valueOf(rcw.criteria.Order__c) + 1;
            }
        }
    	return highestOrder;
    }
    
    public void validateOnRerender(){
        validatePage(currentRule, relatedRuleCriteria);
    }

    //Page validation methods
    public void validatePage(IMH_Rule__c rule, List<RuleCriteriaWrapper> criteriaWrapper) {
        noDuplicateOrder(rule, criteriaWrapper);
        mustBeAtLeastOneCriteria(rule, criteriaWrapper);
        noDuplicateFields(rule, criteriaWrapper);
        nameNotNull(rule);
		SOQLValidationLogic(rule, criteriaWrapper);
		validateCriteriaLogic(rule, criteriaWrapper);
    }
    
    private void checkCriteriaLogic(IMH_Rule__c rule) {

        try {
            
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(rule.SourceObject__c);
            sObject obj = targetType.newSObject();
            obj.put('Name', 'string');
            
            RuleEngine_RuleEvaluation re = new RuleEngine_RuleEvaluation(obj, (sObject)currentRule);
            re.evaluate();
        }
        catch(exception e) {
            ApexPages.addMessages(e);
        }
        
    }
    
    private void noDuplicateOrder(IMH_Rule__c rule, List<RuleCriteriaWrapper> criteriaWrapper) {
        
        Set<Integer> criteriaSet = new Set<Integer>();
        
        for(RuleCriteriaWrapper rcw :criteriaWrapper) {
            criteriaSet.add(Integer.valueOf(rcw.criteria.Order__c));
		}
        
        if(criteriaSet.size() != criteriaWrapper.size()) {
            rule.addError ('You cannot have duplicates in the order column');
        }
        
        
    }
    private void noDuplicateFields(IMH_Rule__c rule, List<RuleCriteriaWrapper> criteriaWrapper) {
        if(rule.CriteriaLogic__c != null && !rule.CriteriaLogic__c.contains('OR')) {
            Set<String> criteriaSet = new Set<String>();
            
            for(RuleCriteriaWrapper rcw :criteriaWrapper) {
                criteriaSet.add(rcw.criteria.Field__c);
            }
            
            if(criteriaSet.size() != criteriaWrapper.size()) {
                rule.addError ('You cannot have duplicates in the field column');
            }
        }
    }
    private void mustBeAtLeastOneCriteria(IMH_Rule__c rule, List<RuleCriteriaWrapper> criteriaWrapper) {
        if(criteriaWrapper.size() < 1) {
            rule.addError ('You must have at least one criteria');
        }
    }
    private void nameNotNull(IMH_Rule__c rule) { 
        if(rule.Name == null || rule.Name == '') {
            rule.addError('You must enter a name for this rule');
        }
    }
    private void validateCriteriaLogic(IMH_Rule__c rule, List<RuleCriteriaWrapper> criteriaWrapper) {
        
        String errorMsg;
        String criteria = rule.CriteriaLogic__c;
        criteria = criteria.toUpperCase();
        
        
		Set<Integer> critCount = new Set<Integer>();
        for(RuleCriteriaWrapper rcw :criteriaWrapper) {
            critCount.add(Integer.valueOf(rcw.criteria.Order__c));
        }
        
        //contains not enough or too many criteria
        String count = criteria.replaceAll('\\D+', ' ');
        List<String> test = count.split(' ');                
        Set<Integer> deDupeCount = new Set<Integer>();
        for(String s :test) {
            deDupeCount.add(Integer.valueOf(s.replaceAll(' ', '')));
        }
        
        //criteria counts matching
        Boolean critsMatch = false;
        for(Integer c :critCount) {
            for(Integer d :deDupeCount) {
                if(c == d){
                   critsMatch = true;
                }
                else {
                    critsMatch = false;
                }
            }
        }
        //word pattern matching
		Pattern numberStatement = Pattern.compile('[0-9]*[AND/OR]*[0-9]');
        Boolean patternValid = false;
        List<String> critSplit = criteria.split('[0-9]*[AND/OR]*[0-9]');
        for(String s : critSplit) {
            String compareString = s.replaceAll('[ /(/)]', '');
            System.debug(compareString);
            if(compareString == 'AND' || compareString == 'OR') {
            	patternValid = true;
            }
            else {
                patternValid = false;
            }
        }
        system.debug(patternValid);

		Matcher valCheck = numberStatement.matcher(criteria.replaceAll(' ', ''));
        
        //invalid brackets
        if(criteria.contains('()') || criteria.contains(')(')){
            errorMsg = 'Criteria logic brackets are in the wrong place';
        }
        // 'AND' and 'OR' next to eachother
        if(criteria.replaceAll(' ', '').contains('DO')){
            errorMsg = 'Criteria logic invalid';
        }
        // 'OR' and 'AND' next to eachother
        if(criteria.replaceAll(' ', '').contains('RA')){
            errorMsg = 'Criteria logic invalid';
        }
        //criteria must be 1 if only 1 rule
        if(critCount.size() == 1 && criteria != '1') {
            errorMsg = 'Criteria logic be \'1\' if there is only one criteria';
        }
        //doesn't contain AND or OR, however also be '1' only
        if(criteria != '1' && critCount.size() != 1) {
            if(!criteria.contains('AND') && !criteria.contains('OR')) {
                errorMsg = 'Criteria logic must contain at least one AND or OR statement';
            }
        }
        /*//Too many criteria
        if(deDupeCount.size() > critCount.size()) {
            errorMsg = 'Criteria logic contains too many criteria';
        }
        //not enough criteria
        if(deDupeCount.size() < critCount.size()) {
            errorMsg = 'Criteria logic must contain all criteria';
        } */
        //criteria numbers don't match 
        if(!critsMatch) {
            errorMsg = 'Each rule criteria must be referenced in the criteira logic field e.g \'1 AND 2\' for two rule criteria';
        }
		//pattern doesnt match ('1 AND/OR 2')
        if ( !valCheck.matches() ) {
            errorMsg = 'If you have more than one criteria, criteria logic must be in the following format \'1 AND 2\' or \'1 AND (2 OR 3)\'';
        }
        
        // add msg to page
        if(errorMsg != null) {
            rule.addError(errorMsg);
        }
    }
    
    private void SOQLValidationLogic(IMH_Rule__c rule, List<RuleCriteriaWrapper> criteriaWrapper) {
        
        //map the natural language operator to SOQL operator
        Map<String, String> operatorMap = new Map<String, String>();
        operatorMap.put('Equals', '=');
        operatorMap.put('Does not equal', '!=');
        operatorMap.put('Contains', 'LIKE');
        operatorMap.put('Does not contain', 'NOT LIKE');
        operatorMap.put('Less than', '<');
        operatorMap.put('Greater than', '>');
        operatorMap.put('Less Or Equal', '<=');
        operatorMap.put('Greater Or Equal', '>=');
        operatorMap.put('Starts with', 'LIKE');

        //get the field infos from the object
        Schema.DescribeSObjectResult dsr = Schema.getGlobalDescribe().get(rule.SourceObject__c).getDescribe();
        Map<String, Schema.SObjectField> fieldMap = dsr.fields.getMap();
        Map<Integer, String> orderCritMap = new Map<Integer, String>();
        
        //for each criterial build a criteria string (e.g Field__c = 'value') and put in a map
        for(RuleCriteriaWrapper rcw :criteriaWrapper) {
            
            String criteria = rcw.criteria.Field__c;

            //get the type of field we are working with
            Schema.DisplayType fieldInfo = fieldMap.get(rcw.criteria.Field__c).getDescribe().getType();

           //Bool, Date, Datetime cannot do contains or does not contain, so sub for equals/not equals
            if(fieldInfo == Schema.DisplayType.BOOLEAN || 
               fieldInfo == Schema.DisplayType.DATE || 
               fieldInfo == Schema.DisplayType.DATETIME ) {
                   if(rcw.criteria.Operator__c == 'Contains') {
                       criteria += ' = ';
                   }
                   else if(rcw.criteria.Operator__c == 'Does not contain') {
                       criteria +=  ' != ';
                   }
                   criteria += rcw.criteria.Value__c;
               } 
            
            //All other field types can do LIKE/NOT LIKE
            else { 
      
                criteria += ' ' + operatorMap.get(rcw.criteria.Operator__c) + ' ';
                
                if(rcw.criteria.Operator__c == 'Starts with') { 
                    criteria += ' ' + '\'' + rcw.criteria.Value__c + '%\'';
                }
                // contains has wildcard either side
                else if(rcw.criteria.Operator__c == 'Contains') {
                    criteria += ' ' + '\'%' + rcw.criteria.Value__c + '%\'';
                }
                // does not contain has wildcard either side
                else if(rcw.criteria.Operator__c == 'Does not contain') {
                    criteria += ' ' + '\'%' + rcw.criteria.Value__c + '%\'';
                }
                //anything else, use normal quotes
                else {
                    criteria += ' ' + '\'' +rcw.criteria.Value__c + '\'';
                }
            }
            orderCritMap.put(Integer.valueOf(rcw.criteria.Order__c), criteria );          
        }
        
        System.debug(orderCritMap);   
        
        String criteriaLogic = rule.CriteriaLogic__c;
        String soqlCrit = '';
        // build the criteria logic string
        
        
        
        
        
        
        
        for(Integer i=0; i < criteriaLogic.length(); i++) {
            
     		List<Integer> charArray = new List<Integer>();
            charArray.add(criteriaLogic.charAt(i));
            String s = String.fromCharArray(charArray);
            
            if(s.isNumeric()) {
                String totalNumber;
                while (s.isNumeric()) {
                    totalNumber += s;
                }
                soqlCrit += orderCritMap.get(Integer.valueOf(totalNumber));
            }
            else {
                soqlCrit += s;
            }

        }

        try{
            String soql = 'SELECT Id FROM ' + rule.SourceObject__c + ' WHERE ' + soqlCrit + ' LIMIT 1';
            system.debug(soql);
            database.query(soql);
        }
        catch (exception e){
            ApexPages.addMessages(e);
        }
        
		System.debug(soqlCrit);       
        
        
    }
    
    //TO BE MOVED TO COMPONENT - METADATA METHODS
    public List<SelectOption> getSObjectPicklist() {
        
        List<String> excludes = new List<String>();
        
        for(IMH_ExcludedObject__mdt ex :[Select FieldAPIName__c, ObjectAPIName__c  from IMH_ExcludedObject__mdt]) {
            if(ex.FieldAPIName__c == null && ex.ObjectAPIName__c != null) {
                excludes.add(ex.ObjectAPIName__c);
            }
        }
        
        Map<String, String> sObjects = mdu.getObjects(excludes);
        
        List<SelectOption> sObjectPicklist = new List<SelectOption>();
        sObjectPicklist.add(new SelectOption('','-None-'));
        for(String s :sObjects.keySet()) {
            sObjectPicklist.add(new SelectOption(sObjects.get(s), s));
        }
        
        return sObjectPicklist;
    }
    public List<SelectOption> getSObjectFieldPicklist() {
        
        List<String> excludes = new List<String>();
        
        for(IMH_ExcludedObject__mdt ex :[Select FieldAPIName__c, ObjectAPIName__c  from IMH_ExcludedObject__mdt]) {
            if(ex.FieldAPIName__c != null) {
                excludes.add(ex.ObjectAPIName__c + '.' + ex.FieldAPIName__c);
            }
        }
        
        List<SelectOption> sObjectFieldPicklist = new List<SelectOption>();
        sObjectFieldPicklist.add(new SelectOption('','-None-'));
        
        if(currentRule.SourceObject__c != null) {
        Map<String, String> sObjectFields = mdu.getObjectFields(currentRule.SourceObject__c, excludes);
            for(String s :sObjectFields.keySet()) {
                sObjectFieldPicklist.add(new SelectOption(sObjectFields.get(s), s));
            }
        }
        
        return sObjectFieldPicklist;
    }
    
}