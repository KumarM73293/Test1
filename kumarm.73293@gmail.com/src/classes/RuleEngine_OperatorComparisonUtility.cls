/**
 * 
 * @Description RuleEngine_OperatorComparisonUtility class implementation of the equatlity and relational operators
 * The class implements the @see RuleEngine_OperatorsInterface
 * The following comaprison operators defined
 * < operator, <= operator, > operator, >= operator, equals operator, notequals operator, startwith operator,
 * contains operators and doesNotContain operator
 * 
 * 
 * 
 * @author Sinan Bunni
 * @group IMH Developers
 * @date 28/11/2016
 * @see interface RuleEgnine_OperatorsInterface
 * 
**/
public class RuleEngine_OperatorComparisonUtility implements RuleEngine_OperatorsInterface {
    
    private String sourceValue;
    private String targetValue;
    private String apiFieldName;
    private sObject sourceSObject;
    private Schema.DisplayType fieldType;
    
    public RuleEngine_OperatorComparisonUtility(String sourceValue, String targetValue, String apiFieldName, sObject sourceSObject) {
        this.sourceValue = sourceValue;
        this.targetValue= targetValue;
        this.apiFieldName = apiFieldName;
        this.sourceSObject = sourceSObject;
        this.fieldType = getFieldType(apiFieldName, sourceSObject);
    }
    
    /**
    *
    * @Description get the FieldType associated with the metadata of the field name passed in.
    *
    * @param apiFieldName the field name in the api format (__c) associated with the source object
    * @param sourceSObject the source sObject record we are evaluating
    * @return the Schema.DisplayType FieldType enum associated with the field metadata 
    *
    *
    **/
    private Schema.DisplayType getFieldType(String apiFieldName, sObject sourceSObject) {
        Schema.SObjectType sourceSObjectType = this.sourceSObject.getSObjectType();
        Schema.DisplayType fieldType = sourceSObjectType.getDescribe().fields.getMap().get(this.apiFieldName).getDescribe().getType();
    	return fieldType;
    }
    
    /**
     * 
     * @Description see interface RuleEngine_OperatorsInterface
     * @return ture if the target value is equal to the soruce value, otherwise, false
     * 
    **/
    public Boolean equals() {
        return targetValue.equals(sourceValue);
    }
    
    /**
     * 
     * @Description see interface RuleEngine_OperatorsInterface
     * @return true if the target value is not equal to the source value, otherwise, false
     * 
    **/
    public Boolean notEqualsTo() {
        return !targetValue.equals(sourceValue);
    }
    
    /**
     * 
     * @Description see interface RuleEngine_OperatorsInterface
     * @return true if the target value is less than the source value, otherwise false
     * if the field type is not handled, an exception will be thrown
     * 
    **/
    public Boolean lessThan() {
       Boolean lessThanResult;
        
       if (fieldType == Schema.DisplayType.STRING || 
           	fieldType == Schema.DisplayType.PICKLIST || fieldType == Schema.DisplayType.MULTIPICKLIST ||
            fieldType == Schema.DisplayType.Phone || fieldType == Schema.DisplayType.URL || 
            fieldType == Schema.DisplayType.EMAIL) {
            lessThanResult = targetValue < sourceValue;
        } else if (fieldType == Schema.DisplayType.CURRENCY) {
            lessThanResult = Decimal.valueOf(targetValue) < Decimal.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.DATE) {
            lessThanResult = Date.valueOf(targetValue) < Date.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.DATETIME) {
            lessThanResult = DateTime.valueOf(targetValue) < DateTime.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.DOUBLE || fieldType == Schema.DisplayType.PERCENT) {
            lessThanResult = Double.valueOf(targetValue) < Double.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.INTEGER) {
            lessThanResult = Integer.valueOf(targetValue) < Integer.valueOf(sourceValue);
        } else {
            throw new TypeException('lessThan: Unhandled value type conversion');
        }
        
        return lessThanResult;
    } // end lessthan method
    
    /**
     * 
     * @Description see interface RuleEngine_OperatorsInterface
     * @return true if the target value is greater than the source value, otherwise, false
     * if the field type is not handled, an exception will be thrown
     * 
    **/
    public Boolean greaterThan() {
        
        Boolean greaterThanResult;
        
        if (fieldType == Schema.DisplayType.STRING || 
           	fieldType == Schema.DisplayType.PICKLIST || fieldType == Schema.DisplayType.MULTIPICKLIST ||
           	fieldType == Schema.DisplayType.Phone || fieldType == Schema.DisplayType.URL || 
            fieldType == Schema.DisplayType.EMAIL) {
            greaterThanResult = targetValue > sourceValue;
        } else if (fieldType == Schema.DisplayType.CURRENCY) {
            greaterThanResult = Decimal.valueOf(targetValue) > Decimal.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.DATE) {
            greaterThanResult = Date.valueOf(targetValue) > Date.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.DATETIME) {
            greaterThanResult = DateTime.valueOf(targetValue) > DateTime.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.DOUBLE || fieldType == Schema.DisplayType.PERCENT) {
            greaterThanResult = Double.valueOf(targetValue) > Double.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.INTEGER) {
            greaterThanResult = Integer.valueOf(targetValue) > Integer.valueOf(sourceValue);
        } else {
            throw new TypeException('greaterThan: Unhandled value type conversion');
        }
        
        return greaterThanResult;
        
    } // end greaterThanResult method
    
    /**
     * 
     * @Description see interface RuleEngine_OperatorsInterface
     * @return true if the target value is less than or equal the source value, otherwise false
     * if the field type is not handled, an exception will be thrown
     * 
    **/
    public Boolean lessOrEqual() {
        
        Boolean lessThanOrEqualsResult;
        
        if (fieldType == Schema.DisplayType.STRING || 
           	fieldType == Schema.DisplayType.PICKLIST || fieldType == Schema.DisplayType.MULTIPICKLIST ||
           	fieldType == Schema.DisplayType.Phone || fieldType == Schema.DisplayType.URL || 
            fieldType == Schema.DisplayType.EMAIL) {
            lessThanOrEqualsResult = targetValue <= sourceValue;
        } else if (fieldType == Schema.DisplayType.CURRENCY) {
            lessThanOrEqualsResult = Decimal.valueOf(targetValue) <= Decimal.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.DATE) {
            lessThanOrEqualsResult = Date.valueOf(targetValue) <= Date.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.DATETIME) {
            lessThanOrEqualsResult = DateTime.valueOf(targetValue) <= DateTime.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.DOUBLE || fieldType == Schema.DisplayType.PERCENT) {
            lessThanOrEqualsResult = Double.valueOf(targetValue) <= Double.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.INTEGER) {
            lessThanOrEqualsResult = Integer.valueOf(targetValue) <= Integer.valueOf(sourceValue);
        } else {
            throw new TypeException('lessOrEqual: Unhandled value type conversion');
        }
        
        return lessThanOrEqualsResult;
        
    } // end lessOrEqual method
    
    /**
     * 
     * @Description see interface RuleEngine_OperatorsInterface
     * @return true if the target value is greater than or equal the source value, otherwise, false
     * if the field type is not handled, an exception will be thrown
     * 
    **/
    public Boolean greaterOrEqual() { 
        
        Boolean greaterOrEqualResult;
        
        if (fieldType == Schema.DisplayType.STRING || 
           	fieldType == Schema.DisplayType.PICKLIST || fieldType == Schema.DisplayType.MULTIPICKLIST || 
           	fieldType == Schema.DisplayType.Phone || fieldType == Schema.DisplayType.URL || 
            fieldType == Schema.DisplayType.EMAIL) {
            greaterOrEqualResult = targetValue >= sourceValue;
        } else if (fieldType == Schema.DisplayType.CURRENCY) {
            greaterOrEqualResult = Decimal.valueOf(targetValue) >= Decimal.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.DATE) {
            greaterOrEqualResult = Date.valueOf(targetValue) >= Date.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.DATETIME) {
            greaterOrEqualResult = DateTime.valueOf(targetValue) >= DateTime.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.DOUBLE || fieldType == Schema.DisplayType.PERCENT) {
            greaterOrEqualResult = Double.valueOf(targetValue) >= Double.valueOf(sourceValue);
        } else if (fieldType == Schema.DisplayType.INTEGER) {
            greaterOrEqualResult = Integer.valueOf(targetValue) >= Integer.valueOf(sourceValue);
        } else {
            throw new TypeException('greaterOrEqual: Unhandled value type conversion');
        }
        
        return greaterOrEqualResult;
    	
    } // end greaterOrEqual method
    
    /**
     * 
     * @Description see interface RuleEngine_OperatorsInterface
     * @return true if the target value contains the source value, otherwise, false
     * 
    **/
    public Boolean contains() {
        return targetValue.trim().contains(sourceValue.trim());
    } // end contains method
    
    /**
     * 
     * @Description see interface RuleEngine_OperatorsInterface
     * @return true if the target value does not contain the source value, otherwise, false
     * 
    **/
    public Boolean doesNotContain() {
        return !targetValue.trim().contains(sourceValue.trim());
    } // end doesNotContain method 
    
    /**
     * 
     * @Description see interface RuleEngine_OperatorsInterface
     * @return true if the target value starts with the source value, otherwise, false
     * 
    **/
    public Boolean startswith() {
        return targetValue.startsWith(sourceValue);
    } // end startsWith method
    
} // end RuleEngine_OperatorComparisonUtility class