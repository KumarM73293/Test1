/**
 * 
 * @Description Parsing the rule expression
 * 
 * 
 * 
 * @author Sinan Bunni
 * @group IMH Developers
 * @date 01/12/2016
 * 
**/
public class RuleEngine_ExpressionParser {
    
    public static String parse(final Map<Integer, Boolean> criteriaEvaluation, final String expression) {
        List<String> parethesizedExpression = mapExpressionOperandsToRuleOrderNumber(criteriaEvaluation, expression);
        String ruleExpression = NULL;
        
        // convert the parethesizedExpression to a String and 
        // add ( at the beginning of the string and ) at the end of the String if the String does not have one already
        if (isParenthesisMatching(expression)) {
            ruleExpression = String.join(parethesizedExpression, '');
        } else {
            ruleExpression = '(' + String.join(parethesizedExpression, '') + ')';
        }
        
        System.debug('The final expression is: ' + expression);
        
        return ruleExpression;
    } // end parse method
    
    /**
     * 
     * @Description Parenthesize the Rule Expression following the steps below:
     * 
     * 1- Every True/False operand will be surrounded by parentheses.
     * 2- Every operator (AND / OR) with its operand will be enclosed in parentheses.
     * 3- Every True will be converted to the Character 't'
     * 4- Every False will be converted to the Character 'f'
     * 5- Every AND will be covnerted to the Character 'a'
     * 6- Every OR will be covnerted to the Character 'o'
     * Thus, the expression (TRUE OR (FALSE AND (TRUE AND FALSE))) OR TRUE becomes (((t)o((f)a((t)a(f))))o(t))
     *  Convert the values in the List<String> to List<Character> 
     * 	where AND -> a
     * 		OR -> o
     * 		True -> t
     * 		False -> f
     * 
     * @param criteriaEvaluation is a map where key is the rule order number and value is the evaluation of the criteria 
     * @param expression is the rule expression entered by the user
     * @return String collection of parethesized expression as described by the algorithm above
     * 
    **/

    /**
     * 
     * @Description map the input expression by the user with the criteria evaluation results,
     * hence, the rule order number will be converted to their associated criteria evaluation to
     * either True or False
     * 
     * 
     * @param criteriaEvaluation is a map where key is the rule order number and value is the evaluation of the criteria 
     * @param expression is the rule expression entered by the user
     * @return String collection where each rule order nubmer is converted to their associated criteria evaluation results
     * 
    **/
    private static List<String> mapExpressionOperandsToRuleOrderNumber(final Map<Integer, Boolean> criteriaEvaluation, final String expression) {
        
        List<String> processedExpression = new List<String>();
		List<String> buildExpression = createNewExpressionString(expression);
        
        for (String operand : buildExpression) {
            if (operand.isNumeric()) {
                Integer orderNumber = Integer.valueOf(operand);
                if (criteriaEvaluation.containsKey(orderNumber)) {
                    Boolean value = criteriaEvaluation.get(orderNumber);
                    if (value == true) {
                        processedExpression.add('(t)');
                    } else {
                        processedExpression.add('(f)');
                    }
                }
            } else {
                processedExpression.add(operand);
            }
        } // end for
        
        return processedExpression;
        
    } // end mapExpressionOperandsToRuleOrderNumber method
    
    /**
     * 
     * @Description clean the expression string inserted by the user by removing
     * leading and trailing whitespaces and ensure the expression only contains
     * the rule order number, logical operations (AND / OR) and parenthesis.
     * Any other characters will be removed.
     * 
     * 
     * @param expression is the rule expression entered by the user
     * @return cleaned version of the expression.
     * 
    **/
    private static List<String> createNewExpressionString(final String expression) {
        
        String exp = expression;
        
        // check for matching parenthesis at start and end of expression
        if (!exp.substring(0, 1).equals('(')) {
            exp = '(' + exp;
        }
        
        if (!exp.substring(exp.length() - 1, exp.length()).equals(')')) {
            exp = exp + ')';
        }
        
        // replace AND with 'a' and OR with 'o'
        exp = exp.replace('AND', 'a');
        exp = exp.replace('OR' , 'o');
        
        List<String> chars = exp.split('');
        
        List<String> newExp = new List<String>();
        
        for (Integer i = 0; i < chars.size(); i++) {
            if (chars[i].equals('(')) {
                if (chars[i + 1].isNumeric() && chars[i + 2].isNumeric() && chars[i + 3].isNumeric()) {
                    newExp.add('(');
                    newExp.add(chars[i + 1] + chars[i + 2] + chars[i + 3]);
                } else if (chars[i + 1].isNumeric() && chars[i + 2].isNumeric()) {
                    newExp.add('(');
                    newExp.add(chars[i + 1] + chars[i + 2]);
                } else if (chars[i + 1].isNumeric()) {
                    newExp.add('(');
                    newExp.add(chars[i + 1]);
                } else {
                    newExp.add('(');
                }
            } else if (chars[i].equals(')')) {
                if (chars[i - 3].isNumeric() && chars[i - 2].isNumeric() && chars[i - 1].isNumeric()) {
                    newExp.add(chars[i - 3] + chars[i - 2] + chars[i - 1]);
                    newExp.add(')');
                } else if (chars[i - 2].isNumeric() && chars[i - 1].isNumeric()) { 
                    newExp.add(chars[i - 2] + chars[i - 1]);
                    newExp.add(')');
                } else if (chars[i - 1].isNumeric()) {
                    newExp.add(chars[i - 1]);
                    newExp.add(')');
                } else {
                    newExp.add(')');
                }
            } else if ((chars[i].equals('a') || chars[i].equals('o')) && 
                       chars[i + 1].isNumeric() && 
                       (chars[i + 2].equals('a') || chars[i + 2].equals('o'))) {
                newExp.add(chars[i]);
                newExp.add(chars[i + 1]);
            } else if ((chars[i].equals('a') || chars[i].equals('o')) && 
                       (chars[i + 1].isNumeric() && chars[i + 2].isNumeric()) && 
                       (chars[i + 3].equals('a') || chars[i + 3].equals('o'))) {
                newExp.add(chars[i]);
                newExp.add(chars[i + 1] + chars[i + 2]);
            } else if ((chars[i].equals('a') || chars[i].equals('o')) && 
                       (chars[i + 1].isNumeric() && chars[i + 2].isNumeric() && chars[i + 3].isNumeric()) && 
                       (chars[i + 4].equals('a') || chars[i + 4].equals('o'))) {
                newExp.add(chars[i]);
                newExp.add(chars[i + 1] + chars[i + 2] + chars[i + 3]);
            } else if (chars[i].equals('a')) {
                newExp.add('a');
            } else if (chars[i].equals('o')) {
                newExp.add('o');
            }
        } // end for
        
        
		return newExp;        
    } // end createNewExpressionString method 
    
    private static Boolean isParenthesisMatching(final String expression) {
	
        Stack stack = new Stack();
        List<String> chars = expression.trim().split('');
        
        String character = NULL;
        for (Integer i = 0; i < chars.size(); i++) {
            character = chars.get(i);
            
            if (character.equals('(')) {
                stack.push(character);
            } else if (character.equals(')')) {
                if (stack.isEmpty()) {
                    return false;
                } else if (stack.peek().equals('(')) {
                    stack.pop();
                } else {
                    return false;
                }
            }
        }
    
    	return stack.isEmpty();
	}// end isParenthesisMatching method 
    

} // end RuleEngine_ExpressionParser class