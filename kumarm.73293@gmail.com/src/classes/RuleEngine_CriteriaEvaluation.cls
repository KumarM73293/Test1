/**
 * 
 * @Description RuleEngine_CriteriaEvaluation a concrete class to handle the 
 * criteria evaluation based on a sourceOjbect and targetObject where 
 * sourceObject represents the object we are evaluating on (i.e. Standard and Custom sObjects) and 
 * targetObject represents the object the Rule sObject (i.e. where critieria sit)
 * 
 * 
 * @author Sinan Bunni
 * @group IMH Developers
 * @date 24/11/2016
 * 
**/

public class RuleEngine_CriteriaEvaluation {

    /**
     * 
     *  @Description The sObject of the Object we are evaluating - Communication__c, Approval__c, etc...
     * 
    **/
    private sObject sourceRecord { get; private set; }
    
    /**
     * 
     * @Description The sObject in which the Rule sits - Rule__c 
     * 
    **/
        private sObject targetRecord {get; private set; }

    /**
     * 
     * @Description a two argument constructor to handle the instantiation of 
     * soruce object and target object.
     * 
    **/
    public RuleEngine_CriteriaEvaluation(sObject sourceRecord, sObject targetRecord) {
        this.sourceRecord = sourceRecord;
        this.targetRecord = targetRecord;
    }
    
    /**
     * 
     * @Description a no argument constructor intializing the source and target
     * objects to NULL, hence no further analysis / evaluation will be made.
     * 
    **/
    public RuleEngine_CriteriaEvaluation() {
        this(NULL, NULL);
    }

	
    /**
     * 
     * @Description the evaluation of criteria is made in the following steps
     * 1- Get a Map of (RuleNumber, CriteriaEvaluation) collection
     * 2- Converts the Expression string to a formatted string accepted by the Expression Engine.
     * 
     * @return a nicely formatted expression string accepted by the Expression Engine for evaluation.
     * 
     * 
    **/

    public String processCriteriaEvaluation() {
    
        // Evaluate Criteria
        Map<Integer, Boolean> criteriaEvaluation = getCriteriaEvaluationResultMap();
        System.debug('Map<RuleOrderNumber, CriteriaEvaluation> results: ' + criteriaEvaluation);

        // Format Expression String
        String expression = expressionFormat(criteriaEvaluation);
        System.debug('Formatted Expression ready for evaluation is: ' + expression);

        return expression;

    } // end processCriteriaEvaluation method

    /**
     * 
     * @Description converts the inserted Rule Expression to a fomatted expression
     * understood by the Expression Engine to process.
     * The process is as follows:
     * 1- convert the inserted String into a list collection of characters
     * 2- iterate through the characters and only populate relevant inputs (AND, OR, Right Parenth, 
     *    Left Parenth and digits (1..N), all other characters will be ignored
     * 3- produce an expression build string
     * 4- replace all digits (1..N) referring to the Rule_OrderNumber to their respectives 
     *    (true / false) based on the criteria evaluation
     * 5- Parenthesize the expression
     * 
     * 
     * @param criteriaEvaluation a Map collection where key is the rule order number and 
     * 							value is a evaluation of the criteria as true or false
     * @return a formatted String collection accepted and understood by the Expression Engine to process
     * 
    **/
    private String expressionFormat(final Map<Integer, Boolean> criteriaEvaluation) {

        String ruleExpression = (String) targetRecord.get('CriteriaLogic__c');
        String expression = RuleEngine_ExpressionParser.parse(criteriaEvaluation, ruleExpression);
        
        return expression;
        
    } // end expressionFormat method
    
    /**
    *
    * @Description process the criteria associated with a single Rule__c record by looping through
    * all the criteria and checking the criterium value with the associated source record for comparision.
    * 
    * @return the evaluation of the critieria associated with the rule in a Map collection
    * where key is the order number of the criterium and value is either true or false
    * depending the evaluation.
    *
    **/
	@TestVisible
    private Map<Integer, Boolean> getCriteriaEvaluationResultMap() {

        Map<Integer, Boolean> orderToCriteriaEvaluationMap = new Map<Integer, Boolean>();
		
        if (!getCriteriaList().isEmpty()) {
            for (IMH_RuleCriteria__c criteria : getCriteriaList()) {
            	if (!orderToCriteriaEvaluationMap.containsKey((Integer) criteria.Order__c)) {
               		// evaluate the criteria 
               		orderToCriteriaEvaluationMap.put((Integer) criteria.Order__c, 
                           evaluateRuleCriteria(String.valueOf(criteria.Field__c), 
                                                String.valueOf(criteria.Operator__c), 
                                                String.valueOf(criteria.Value__c)));
                }
            }
        }
        
        return orderToCriteriaEvaluationMap;
    }// end criteriaEvaluationResultMap method
    
    /**
    *
    * @Description returns an empty list if no criteria are associated with the Rule
    * Otherwise returns a list of criteria associated with the Rule
    * 
    * @return an the list of criteria associated with the rule, otherwise, an empty list
    * collection
    *
    *
    **/
    private List<IMH_RuleCriteria__c> getCriteriaList() {
        
        List<IMH_RuleCriteria__c> criteria = [SELECT Id, Field__c, Operator__c, Order__c, Value__c
                                            FROM IMH_RuleCriteria__c 
                                            WHERE Rule__c = :targetRecord.Id AND 
                                         		  Rule__r.Active__c = TRUE];

        return criteria.isEmpty() ? new List<IMH_RuleCriteria__c>() : criteria;
    
    } // end criteriaList method
    
    /**
     * 
     * @Description evaluation of a single critirium by making a comparison on the populated fields
     * per criterium with the sourceRecord object. The evaluation is made based on the following 
     * operations (equals, not equals to, less than, greather than, less or equal, greater or equal, 
     * contains, does not contain and startswith)
     * 
     * 
     * @param critieraFieldName the field name where the comparision is made against
     * @param criteriaOperator the operator where the comparison is made against
     * @return true if the criteria is evaluated to true, otherwise false
     * @see OperatorComparisonUtility class to handle the values comparision.
     * 
    **/   
    private Boolean evaluateRuleCriteria(final String criteriaFieldName, final String criteriaOperator, final String criteriaValue) {
		Boolean evaluationResult;
        
        // get the fields that are populated in the Source sObject record
		Map<String, Object> sourceFieldsToValues = sourceRecord.getPopulatedFieldsAsMap();

        for (String sourceFieldName : sourceFieldsToValues.keySet()) {
            if (sourceFieldName.equals(criteriaFieldName)) {
                
                String sourceFieldValue = String.valueOf(sourceFieldsToValues.get(sourceFieldName));
                
                // instantiate an OperatorComparison object
				RuleEngine_OperatorComparisonUtility operator = new RuleEngine_OperatorComparisonUtility(sourceFieldValue, criteriaValue, sourceFieldName, sourceRecord);
                
                if (criteriaOperator.equalsIgnoreCase(EQUALS)) {
                    evaluationResult = operator.equals();
                } else if (criteriaOperator.equalsIgnoreCase(NOT_EQUALS_TO)) {
                    evaluationResult = operator.notEqualsTo();
                } else if (criteriaOperator.equalsIgnoreCase(LESS_THAN)) {
                    evaluationResult = operator.lessThan();
                } else if (criteriaOperator.equalsIgnoreCase(GREATER_THAN)) {
                     evaluationResult = operator.greaterThan();
                } else if (criteriaOperator.equalsIgnoreCase(LESS_OR_EQUAL)) {
                    evaluationResult = operator.lessOrEqual();
                } else if (criteriaOperator.equalsIgnoreCase(GREATER_OR_EQUAL)) {
                    evaluationResult = operator.greaterOrEqual();
                } else if (criteriaOperator.equalsIgnoreCase(CONTAINS)) {
                    evaluationResult = operator.contains();
                } else if (criteriaOperator.equalsIgnoreCase(DOES_NOT_CONTAIN)) {
                    evaluationResult = operator.doesNotContain();
                } else if (criteriaOperator.startsWith(STARTSWITH)) {
                    evaluationResult = operator.startswith();
                }
            }
        } // end for      
        
        return evaluationResult;
    } // end evaluteRuleCriteria method 
    
    /**
     * 
     * @Description exception handling class used to capture the exception
     * when the expression is syntacitically wrong
     * e.g. if a Rule has two criteria 1 and 2 (order numbers)
     * and the expression has (1 AND 5)
     * an error will be throw as 5 is not a valid Order Number in the Criteria list
     * 
     * 
    **/
    private class UnhandledCriteriaException extends Exception {
        
    }
    
    /**
     * 
     * @Description constants fields represent the operations available 
     * for comparison.
     * 
    **/
    private static final String EQUALS = 'equals';
    private static final String NOT_EQUALS_TO = 'not equals to';
    private static final String LESS_THAN = 'less than';
    private static final String GREATER_THAN = 'greater than';
    private static final String LESS_OR_EQUAL = 'less or equal';
    private static final String GREATER_OR_EQUAL = 'greater or equal';
    private static final String CONTAINS = 'contains';
    private static final String DOES_NOT_CONTAIN = 'does not contain';
    private static final String STARTSWITH = 'starts with';
    
} // end RuleEngine_CriteriaEvaluation