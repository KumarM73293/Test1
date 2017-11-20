/**
 * 
 * @Description RuleEngine_ExpressionEvaluation is a concerte class to handle building the 
 * Expression Tree, Expression Tree Traversal and Expression Tree Evaluation.
 * 
 * The Boolean Expression is composed of binary operations and variables. Every parenthesized subexpression
 * contains an operator in the middle. The algorithm for building the Boolean Expression uses a Stack S while
 * scanning the input expression E looking for variables, operators and right parentheses.
 * 		* When we see a variable or operator x, we push it to the Stack
 * 		* When se see right parenthesis, we pop the top of the stack which represent a subexpression (E1 0 E2)
 * 		  and then we push the result back on the stack.
 * We repeate untile the expression E has been processed, at which time the top element on the stack is the
 * Expression Tree for E.
 * 
 * The Postfix traversal is described in https://en.wikipedia.org/wiki/Binary_expression_tree
 * I followed the algorithm described merely in the wiki to implement the Expression Traversal as follows
 * 1- Get the last symobl (rightmost) of the postfix notation, push it to the Stack
 * 2- Set the symbol to the current node 
 * 3- Iterate each element from right to left
 * 		Determine whether it is a Boolean Operation
 * 		Determine whether it is a right or left parenthensis 
 *		Determine whether it is a operand
 * 	Push current nodes to the stack if it has no dependency with other nodes (operands)
 * 	Search for the right parenthesis which could have children nodes and set it as the current node
 * 
 * In nutshell, the algorithm works as follows:
 * 1- Recursively traverse left subtree
 * 2- Recursively traverse right subtree
 * 3- Visit the root node
 * 
 * 
 * Assumptions for simplifications:
 * 1- Parsing in this code indicates to the method of extracting the Boolean operands and the logical operations
 *    from an input expression as in (TRUE AND (FALSE OR TRUE))
 * 2- The String passed in this class is assumed to be properly prased by the the Static Class Utility ExpressionParser
 *    hence the expression will be passed in the form of ((t)a((f)o(t))) which is an exact replica of the example above
 *    where True is replaced with 't' and False is replaced with 'f' and And is replaced with 'a' and Or is replaced with 'o'
 * 3- the Algorithm use recurive calls to evaluate the left and right subtree as below:
 * 		a- tree root of boolean expression subtree
 * 		b- node = make a new tree node
 * 		c- start from the bottom of the tree (leaf usually is a boolean operand - either true or false)
 * 		d- if boolean expression is a boolean operand return node
 * 		e- else do recursive calls 
 * 			aa- node.operation = extract the boolean operations from the expression
 * 			bb- node.left = parse the substring of expression to the left of the boolean operation
 * 			cc- node.right = parse the substring of expression to the right of the boolean operation
 * 			dd- return the node.
 * 4- if no parethnesis is provided for such an expression a right to left evaluation will be performed.
 * 
 * 
 * 
 * 
 * @author Sinan Bunni
 * @group IMH Developers
 * @date 01/12/2016
 * 
**/
public class RuleEngine_ExpressionEvaluation {
	
    /**
     * 
     * @Description define the top node in a tree - usually a root
     * 
    **/
    private Node root;
    
    /**
     * 
     * @Description the evaluation of the tree is done recursively by
     * evaluating the left substring tree and the right substring tree
     * 
     * @param node the subtree node we are evaluating recursively
     * @return true if the expression is evaluated to true, otherwise, false.
     * 
    **/
    public Boolean evaluate(final String expression) {
        // parse the expression
        root = parse(expression);
        
        // evaluate the expression
        String expressionsEvaluation = evaluate(root);
        if (expressionsEvaluation.equals('t')) {
            return true;
        } else {
            return false;
        }
        
    } // end evaluateExpression method
    
    /**
     * 
     * @Description evaluation of the tree is done recursively by 
     * evaluating the left substring tree and the right substring tree
     * 
     * @param node the subtree node we are evaluating recursively
     * @return a string 't' if it is a true evaluation, otherwise, a string 'f' for false evaluation
     * 
    **/
    private String evaluate(final Node node) {
        String evaluationResult = NULL;
        
        if (node.isLeaf) {
            return node.value;
        }
        
        // Otherwise recursively go through left and right subtrees and evaluate them
        String leftValue = evaluate(node.leftNode);
        String rightValue = evaluate(node.rightNode);
        
        // for And Operations - conversion from String to Boolean is done via the method
        if (node.operation.equals('a')) {
            Boolean result = getBooleanValue(leftValue) && getBooleanValue(rightValue);
            evaluationResult = getOperationEvaluationResult(result);
        // for Or operations
        } else if (node.operation.equals('o')) {
            Boolean result = getBooleanValue(leftValue) || getBooleanValue(rightValue);
            evaluationResult = getOperationEvaluationResult(result);
        }
        
        return evaluationResult;
        
    } // end evaluate method
    
    /**
     * 
     * @Description helper method to return either true if the 
     * the operand value is 't' for (True) or false if the operand
     * value is 'f' for (False)
     * 
     * 
     * @param operandValue the operand value either 't' for True or 'f' for false
     * @return true if the operand is 't' otherwise, false if the operand is 'f'
     * 
    **/
    private Boolean getBooleanValue(final String operandValue) {
        if (operandValue.equals('t')) {
            return true;
        } else {
            return false;
        }
    } // end getBooleanValue method
    
    /**
     * 
     * @Description helper method to return either 'f' for false or 't' for true
     * 
     * @param operandValue is logical operand either true or false
     * @return a string 'f' for false and 't' for true 
     * 
    **/
    private String getOperationEvaluationResult(final Boolean operandValue) {
        if (operandValue == false) {
            return 'f';
        } else {
            return 't';
        }
    } // end getOperationEvaluationResult method
    
    /**
     * 
     * @Descrptioin parse the parsed expresion for evaluation purposes,
     * the parsing algorith is described at @see RuleEgnine_ExpressionEvaluation
     * class description.
     * 
     * @param expression the parsed expression entered by the user.
     * 
    **/
    private Node parse(final String expression) {
        
        Node node = new Node();
        
		// The parsed expression must start and end with parenthesis as explained in the RuleEngine_ExpressionParser
		// hence the expression.substring(0, 1) must a left parenthesis '('
        // First, find the matching right parenthesis
        Integer rightMatch = findRightParenthesis(expression, 1);
        String leftExpression = expression.substring(1, rightMatch + 1);
        
        // Condition to find the leaf
        if (rightMatch == expression.length() - 1) {
            // this a leaf
            String operand = expression.substring(1, expression.length() - 1);
            Boolean leafValue = true;
            node.setIsLeaf(leafValue);
            node.setValue(getOperandValue(operand));
            
            return node;
        }
        
        // Otherwise there is a second operand and an operator -
        // find the left parethesis to match the rightmost right parethesis
        Integer leftMatch = findLeftParenthesis(expression, expression.length() - 2);
        String rightExpression = expression.substring(leftMatch, expression.length() - 1);
        
        // Recursive parsing of the left and right subtrees (substrings)
        node.setLeftNode(parse(leftExpression));
        node.setRightNode(parse(rightExpression));
        node.setOperation(expression.substring((rightMatch + 1), (rightMatch + 2)));
        
        return node;
        
    } // end parse method
    
    /**
     * 
     * @Description given the position of the left parenthesis in the expression 
     * find the matching right parenthesis
     * 
     * @param expression the parsed rule expression entered by the user
     * @param leftPosition the position of the starting left parenthesis
     * @return the index in which the matching leftmost left parenthesis is found
     * 
    **/
    private Integer findRightParenthesis(final String expression, final Integer leftPosition) {
        
        Stack stack = new Stack();
        stack.push(expression.substring(leftPosition));
        
        for (Integer i = leftPosition + 1; i < expression.length(); i++) {
            String character = expression.substring(i, i + 1);
            
            if (character.equals('(')) {
                stack.push(character);
            } else if (character.equals(')')) {
                stack.pop();
                if (stack.isEmpty()) {
                    // last parenthesis
                    return i;
                }
            }
        }
        
        // if failed to find the matching left parethesis
        return -1;
        
    } // end findRightParenthesis method
    
    /**
     * 
     * @Description given the position of the right parenthesis in the expression
     * find the matching left parenthesis
     * 
     * 
     * @param expression the parsed rule expression entered by the user
     * @param rightPosition the position of the starting right parenthesis
     * @return the index in which the matching rightmost right parenthesis is found
     * 
    **/
    private Integer findLeftParenthesis(final String expression, final Integer rightPosition) {

		Stack stack = new Stack();
        stack.push(expression.substring(rightPosition));
        
        for (Integer i = rightPosition - 1; i >= 0; i--) {
            String character = expression.substring(i, i + 1);
            
            if (character.equals(')')) {
                stack.push(character);
            } else if (character == '(') {
                stack.pop();
                if (stack.isEmpty()) {
                    // last parenthesis
                    return i;
                }
            }
        }
	
        // if failed to find the matching right parethesis
		return -1;

    } // end findLeftParenthesis method
    
    /**
     * 
     * @Description get the operand value 'f' or 't' usually is set
     * as the value of a leaf node hence the leaf has no children.
     * 
     * @param expression parsed expression entered by the user
     * @return the leaf value either 'f' for false or 't' for true.
     * 
    **/
    private String getOperandValue(final String expression) {
        return expression.substring(0, 1);
    } // end getOperandValue method

} // end RuleEngine_ExpressionEvaluation class