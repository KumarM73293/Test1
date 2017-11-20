@isTest
public class RuleEngine_ExpressionEvaluationTest {

    static testMethod void simpleRuleExpression() {
        // create a rule
        List<IMH_Rule__c> rules = createTestRules(1, '1 AND 2', 'IMH_Communication__c', true);
        insert rules;
        IMH_Rule__c rule = [SELECT Id, CriteriaLogic__c FROM IMH_Rule__c WHERE Id IN :rules LIMIT 1];
        
        // create criteria
        createSingleCriterion(1, 'TargetRegion__c', 'equals',   'LACC',                        rule.Id);
        createSingleCriterion(2, 'TargetMarket__c', 'contains', 'Argentina',                   rule.Id);
        createSingleCriterion(3, 'StartDate__c',    'less than', String.valueOf(Date.today()), rule.Id);
        insert criteria;
        
        // create a source object
        IMH_Communication__c comm = createCommObject();
        insert comm;
        
        // Instantiate a RuleEvaluation object
        RuleEngine_RuleEvaluation process = new RuleEngine_RuleEvaluation((sObject) comm, (sObject) rule);
        System.assertEquals(true, process.evaluate());
        
        // update the expression
        rule.CriteriaLogic__c = '1AND3'; // should results in false
        update rule;
        System.assertEquals(false, process.evaluate());
        
        
    } // end simpleRuleExpression method
    
    static testMethod void compoundRuleExpression() {
        String expression = '1AND(3OR4)';
        
        // create a rule
        List<IMH_Rule__c> rules = createTestRules(1, expression, 'IMH_Communication__c', true);
        insert rules;
        IMH_Rule__c rule = [SELECT Id, CriteriaLogic__c FROM IMH_Rule__c WHERE Id IN :rules LIMIT 1];
        
        // create criteria
        createSingleCriterion(1, 'TargetRegion__c', 'equals',        'LACC',                        rule.Id);
        createSingleCriterion(2, 'TargetMarket__c', 'contains',      'Argentina',                   rule.Id);
        createSingleCriterion(3, 'StartDate__c',    'less than',      String.valueOf(Date.today()), rule.Id);
        createSingleCriterion(4, 'EndDate__c',      'Greater Than',   String.valueOf(Date.today()), rule.Id);
        createSingleCriterion(5, 'TargetMarket__c', 'contains',       'ina',                        rule.Id);
        insert criteria;
        
        // create a source object
        IMH_Communication__c comm = createCommObject();
        insert comm;
        
        // Instantiate a RuleEvaluation object
        RuleEngine_RuleEvaluation process = new RuleEngine_RuleEvaluation((sObject) comm, (sObject) rule);
        System.assertEquals(false, process.evaluate());
        
        // update the expression
        rule.CriteriaLogic__c = '(1 AND ( 2 AND 3))'; // should results in false
        update rule;
        System.assertEquals(false, process.evaluate());
        
        
        // update the expression
        rule.CriteriaLogic__c = '(1 OR (       3          OR       5))'; // should results in false
        update rule;
        System.assertEquals(true, process.evaluate());
        
        
    } // end compoundRuleExpression method
    
    static testMethod void compoundExpressionWithMultipleDigitsCriteria() {
        String expression = '11AND(13OR114)';
        
        // create a rule
        List<IMH_Rule__c> rules = createTestRules(1, expression, 'IMH_Communication__c', true);
        insert rules;
        IMH_Rule__c rule = [SELECT Id, CriteriaLogic__c FROM IMH_Rule__c WHERE Id IN :rules LIMIT 1];
        
        // create criteria
        createSingleCriterion(11,  'TargetRegion__c', 'equals',        'LACC',                        rule.Id);
        createSingleCriterion(12,  'TargetMarket__c', 'contains',      'Argentina',                   rule.Id);
        createSingleCriterion(13,  'StartDate__c',    'less than',      String.valueOf(Date.today()), rule.Id);
        createSingleCriterion(114, 'EndDate__c',      'Greater Than',   String.valueOf(Date.today()), rule.Id);
        createSingleCriterion(556, 'TargetMarket__c', 'contains',       'ina',                        rule.Id);
        insert criteria;
        
        // create a source object
        IMH_Communication__c comm = createCommObject();
        insert comm;
        
        // Instantiate a RuleEvaluation object
        RuleEngine_RuleEvaluation process = new RuleEngine_RuleEvaluation((sObject) comm, (sObject) rule);
        System.assertEquals(false, process.evaluate());
		
		// update the expression
        rule.CriteriaLogic__c = '(556 AND (       13          OR       12))'; // should results in false
        update rule;
        System.assertEquals(false, process.evaluate());        
        
    } // end compoundExpressionWithMultipleDigitsCriteria method
    
    static testMethod void complextRuleExpression() {
        
        String expression =  '(((1 AND 3) OR (4 AND 5 OR (1AND2))OR(1AND2AND3AND4AND5)AND((1OR2OR3OR4OR5) AND (1 AND (2 AND 3 AND 4 AND 5))) AND (1 OR 2 OR 3 AND (4AND5)) OR (1 OR 2 OR 3 OR4 OR 5)) OR (1 AND 2)' +
							' AND ((4 AND 5 OR (1 AND 2)) OR (1 AND 2)))';
        
        // create a rule
        List<IMH_Rule__c> rules = createTestRules(1, expression, 'IMH_Communication__c', true);
        insert rules;
        IMH_Rule__c rule = [SELECT Id, CriteriaLogic__c FROM IMH_Rule__c WHERE Id IN :rules LIMIT 1];
        
        // create criteria
        createSingleCriterion(1, 'TargetRegion__c', 'equals',        'LACC',                        rule.Id);
        createSingleCriterion(2, 'TargetMarket__c', 'contains',      'Argentina',                   rule.Id);
        createSingleCriterion(3, 'StartDate__c',    'less than',      String.valueOf(Date.today()), rule.Id);
        createSingleCriterion(4, 'EndDate__c',      'Greater Than',   String.valueOf(Date.today()), rule.Id);
        createSingleCriterion(5, 'TargetMarket__c', 'contains',       'ina',                        rule.Id);
        insert criteria;
        
        // create a source object
        IMH_Communication__c comm = createCommObject();
        insert comm;
        
        // Instantiate a RuleEvaluation object
        RuleEngine_RuleEvaluation process = new RuleEngine_RuleEvaluation((sObject) comm, (sObject) rule);
        System.assertEquals(true, process.evaluate());
        
    } // end complexRuleExpression method
    
    static testMethod void bulkCriteriaCreation() {
		
		// generate an expression        
        String expression = NULL;
        for (Integer i = 100; i <= 140; i++) {
            expression += String.valueOf(i) + 'AND';
        }
        expression = expression.removeEnd('AND');
        
        // create a rule
        List<IMH_Rule__c> rules = createTestRules(1, expression, 'IMH_Communication__c', true);
        insert rules;
        IMH_Rule__c rule = [SELECT Id, CriteriaLogic__c FROM IMH_Rule__c WHERE Id IN :rules LIMIT 1];
        
        // create criteria
        for (Integer i = 1; i <= 999; i++) {
            createSingleCriterion(i, 'TargetRegion__c', 'equals', 'LACC', rule.Id);
        }
        
        // insert criteria list
        Database.SaveResult[] insertCriteria = Database.insert(criteria, true);
        
        // create a source object
        IMH_Communication__c comm = createCommObject();
        insert comm;
        
        // Instantiate a RuleEvaluation object
        RuleEngine_RuleEvaluation process = new RuleEngine_RuleEvaluation((sObject) comm, (sObject) rule);
        System.assertEquals(false, process.evaluate());
        
        
        // update the expression with OR operator
        expression = '';
        for (Integer i = 800; i <= 840; i++) {
            expression += String.valueOf(i) + 'OR';
        }
        expression = expression.removeEnd('OR');
        
        rule.CriteriaLogic__c = expression;
        update rule;
        System.assertEquals(true, process.evaluate());  
        
    } // end bulkCriteriaCreation method
    
    /**
     * 
     * Helper methods and a static list to hold the criteria creation
     * 
    **/
    private static List<IMH_RuleCriteria__c> criteria = new List<IMH_RuleCriteria__c>();
    
    private static List<IMH_Rule__c> createTestRules(final Integer noOfRules, final String expression, final String sourceObject, Boolean isActive) {
        List<IMH_Rule__c> rules = new List<IMH_Rule__c>();
        
        for (Integer i = 0; i < noOfRules; i++) {
            rules.add(new IMH_Rule__c(
                    Name             = 'Test Rule', 
                    Active__c        = isActive,	// e.g true or false         
                    CriteriaLogic__c = expression, 
                    SourceObject__c  = sourceObject // e.g.'IMH_Communication__c', 'Account', 'Lead', etc..
            	)
             );
        }

        return rules;
        
    }// end createTestRules method
    
   
    private static void createSingleCriterion(final Integer orderNumber, final String fieldName, final String operation,
                                                            final String fieldValue, final Id ruleId) {
        criteria.add(new IMH_RuleCriteria__c(
                Order__c = orderNumber,
                Field__c = fieldName,
                Operator__c = operation,
                Value__c = fieldValue,
                Rule__c = ruleId
            )
		);
		
    } // end createSingleCriterion method

        
    private static IMH_Communication__c createCommObject() {
        IMH_Communication__c comm = new IMH_Communication__c(
            Name                     = 'Test Communication',
            TargetRegion__c          = 'LACC',
            TargetMarket__c          = 'Argentina',
            ReviewApprovalSLAType__c = 'Standard',
            ProcessStage__c          = 'Concept',
            ReviewStage__c           = 'Design',
            ReviewStatus__c          = 'In Progress',
            Communication_Type__c    = 'Incentivised Offer, Pre-Approved Benefit',
            StartDate__c			 = Date.today(),
            EndDate__c 				 = Date.today().addYears(1),
            TargetAudienceSize__c	 = 10,
            Occurrence__c			 = 'Recurring/Ongoing',	
            Description__c			 = 'Test communication'
		);
        return comm;
    } // end createCommObject method
             
} // end RuleEngine_ExpressionEvaluationTest class