/**
 * 
 * @Description RuleEngine_OperatorsInterface defines a generalized class for the type specific
 * methods for determining the Standard Salesforce operations as outlined in the interface.
 * 
 * 
 * @author Sinan Bunni
 * @gorup IMH_Developers
 * @date 28/11/2016
 * 
 * 
**/
public interface RuleEngine_OperatorsInterface {
	
    /**
     * 
     * @Description Indicates whether the current value is equal to another value of the same type.
     * 
    **/
    Boolean equals();
    
    /**
     * 
     * @Description Indicates whether the current value is not equal to another value of the same type
     * 
    **/
    Boolean notEqualsTo();
    
    /**
     * 
     * @Description Indicates whether the current value is less than another value of the same type
     * 
    **/
    Boolean lessThan();
    
    /**
     * 
     * @Description Indicates whether the current value is greater than another value of the same type
     * 
    **/
    Boolean greaterThan();
    
    /**
     * 
     * @Description Indicates whether the current value is less than or equal another value of the same type
     * 
    **/
    Boolean lessOrEqual();
    
    /**
     * 
     * @Description Indicates whether the current value is greater than or equal another value of the same type
     * 
    **/
    Boolean greaterOrEqual();
    
    /**
     * 
     * @Description Indicates whether the current value contained another value of the same type
     * 
    **/
    Boolean contains();
    
    /**
     * 
     * @Description Indicates whether the current value is not contained in another value of the same type
     * 
    **/
    Boolean doesNotContain();
    
    /**
     * 
     * @Description Indicates whether the current value starts with another value of the same type
     * 
    **/
    Boolean startswith();
    
} // end RuleEngine_OperatorsInterface interface