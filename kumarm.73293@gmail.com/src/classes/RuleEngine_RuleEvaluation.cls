/**
 * 
 * @Description a concrete class used to initialize a usuable object to evluate the Rule Expression
 * The evaluation of the rule expression is done in two stages:
 * 1- evaluation of the criteria associated with the Rule
 * 2- evaluation of the expression using a simple Boolean Expression Tree implementation based on the
 * postfix tree traversal algorithm.
 * 
 * 
 * @author Sinan Bunni
 * @group IMH Developers
 * @date 30/11/2016
 * 
 * 
**/
public class RuleEngine_RuleEvaluation {
    
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
    private sObject targetRecord { get; private set; }

    /**
     * 
     * @Description a two argument constructor to handle the instantiation of 
     * soruce object and target object.
     * 
    **/
    public RuleEngine_RuleEvaluation(sObject sourceRecord, sObject targetRecord) {
        this.sourceRecord = sourceRecord;
        this.targetRecord = targetRecord;
    }
    
    public RuleEngine_RuleEvaluation() {
        this(NULL, NULL);
    }
    
    /**
     * 
     * @Descritpion correctly evaluate the expression by following the steps:
     * 1- Fully evaluate the rule criteria and
     * 2- Full evaluate the expression
     * 
     * @return true if the expression evaluates to true, otherwise, false.
     * 
    **/
    public Boolean evaluate() {
        // evaluate the criteria
        RuleEngine_CriteriaEvaluation criteriaEvaluation = new RuleEngine_CriteriaEvaluation(sourceRecord, targetRecord);
        String formattedExpression = criteriaEvaluation.processCriteriaEvaluation();
        
        // evaluate the expression
        RuleEngine_ExpressionEvaluation process = new RuleEngine_ExpressionEvaluation();
        Boolean result = process.evaluate(formattedExpression);
        
        return result;
    } // end evaluate method 

} // end RuleEngine_RuleEvaluation class