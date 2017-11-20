@isTest
public class RuleEngine_ExpressionParserTest {
    
    /**
     * 
     * Test scenario is X AND Y
     * 
    **/
    static testMethod void testAndOperation() {
        String expression = NULL;
        String parse = NULL;
        Map<Integer, Boolean> criteriaMap = new Map<Integer, Boolean>();
        
        expression = '1 AND 2';
        criteriaMap.put(1, False);
        criteriaMap.put(2, False);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((f)a(f))', parse);
        
        criteriaMap.clear();
        
		expression = '1 AND 2';
        criteriaMap.put(1, False);
        criteriaMap.put(2, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((f)a(t))', parse);       
        
        criteriaMap.clear();
        
		expression = '1 AND 2';
        criteriaMap.put(1, True);
        criteriaMap.put(2, False);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((t)a(f))', parse);  
        
        criteriaMap.clear();
        
		expression = '1 AND 2';
        criteriaMap.put(1, True);
        criteriaMap.put(2, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((t)a(t))', parse);
        
        criteriaMap.clear();
        
        // expression with parenthesis
		expression = '(1 AND 2)';
        criteriaMap.put(1, True);
        criteriaMap.put(2, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((t)a(t))', parse);
        
        
    } // end testAndOperation method
    
    /**
     * 
     * Test scenario is X OR Y
     * 
    **/
    static testMethod void testOrOperation() {
        
        String expression = NULL;
        String parse = NULL;
        Map<Integer, Boolean> criteriaMap = new Map<Integer, Boolean>();
        
        expression = '1 OR 2';
        criteriaMap.put(1, False);
        criteriaMap.put(2, False);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((f)o(f))', parse);
        
        criteriaMap.clear();
        
		expression = '1 OR 2';
        criteriaMap.put(1, False);
        criteriaMap.put(2, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((f)o(t))', parse);       
        
        criteriaMap.clear();
        
		expression = '1 OR 2';
        criteriaMap.put(1, True);
        criteriaMap.put(2, False);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((t)o(f))', parse);  
        
        criteriaMap.clear();
        
		expression = '1 OR 2';
        criteriaMap.put(1, True);
        criteriaMap.put(2, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((t)o(t))', parse);
        
        criteriaMap.clear();
        
        // expression with parenthesis
		expression = '(1 OR 2)';
        criteriaMap.put(1, True);
        criteriaMap.put(2, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((t)o(t))', parse);  
        
    } // end testOrOperation method 
    
    /**
     * 
     * Test scenario is (X AND Y) OR Z
     * 
    **/
    static testMethod void testComposedAndOrExpressionWithParenthAroundAndOperator() {
        
        String expression = NULL;
        String parse = NULL;
        Map<Integer, Boolean> criteriaMap = new Map<Integer, Boolean>();
        
        expression = '(1 AND 2) OR 3';
        criteriaMap.put(1, TRUE);
        criteriaMap.put(2, True);
        criteriaMap.put(3, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('(((t)a(t))o(t))', parse);
        
        criteriaMap.clear();
        
        expression = '(1 AND 2) OR 3';
        criteriaMap.put(1, TRUE);
        criteriaMap.put(2, True);
        criteriaMap.put(3, False);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('(((t)a(t))o(f))', parse);
        
        criteriaMap.clear();
        
        expression = '(1 AND 2) OR 3';
        criteriaMap.put(1, TRUE);
        criteriaMap.put(2, False);
        criteriaMap.put(3, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('(((t)a(f))o(t))', parse);
        
        criteriaMap.clear();
        
        expression = '(1 AND 2) OR 3';
        criteriaMap.put(1, TRUE);
        criteriaMap.put(2, False);
        criteriaMap.put(3, False);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('(((t)a(f))o(f))', parse);
        
        criteriaMap.clear();
        
        expression = '(1 AND 2) OR 3';
        criteriaMap.put(1, False);
        criteriaMap.put(2, True);
        criteriaMap.put(3, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('(((f)a(t))o(t))', parse);
       	        
        criteriaMap.clear();
        
        expression = '(1 AND 2) OR 3';
        criteriaMap.put(1, False);
        criteriaMap.put(2, True);
        criteriaMap.put(3, False);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('(((f)a(t))o(f))', parse);
        
        criteriaMap.clear();
        
        expression = '(1 AND 2) OR 3';
        criteriaMap.put(1, False);
        criteriaMap.put(2, False);
        criteriaMap.put(3, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('(((f)a(f))o(t))', parse);
                
        criteriaMap.clear();
        
        expression = '(1 AND 2) OR 3';
        criteriaMap.put(1, False);
        criteriaMap.put(2, False);
        criteriaMap.put(3, False);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('(((f)a(f))o(f))', parse);
        
    } // end testComposedAndOrExpressionWithParethAroundAndOperator method
    
    /**
     * 
     * Test scenario is X (AND Y OR Z)
     * 
    **/
    static testMethod void testComposedAndOrExpressionWithParenthAroundOrOperator() {
        
        String expression = NULL;
        String parse = NULL;
        Map<Integer, Boolean> criteriaMap = new Map<Integer, Boolean>();
        
        expression = '1 AND (2 OR 3)';
        criteriaMap.put(1, True);
        criteriaMap.put(2, True);
        criteriaMap.put(3, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((t)a((t)o(t)))', parse);
        
        criteriaMap.clear();
        
        expression = '1 AND (2 OR 3)';
        criteriaMap.put(1, True);
        criteriaMap.put(2, True);
        criteriaMap.put(3, False);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((t)a((t)o(f)))', parse);
        
        criteriaMap.clear();
        
        expression = '1 AND (2 OR 3)';
        criteriaMap.put(1, TRUE);
        criteriaMap.put(2, False);
        criteriaMap.put(3, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((t)a((f)o(t)))', parse);
        
        criteriaMap.clear();
        
        expression = '1 AND (2 OR 3)';
        criteriaMap.put(1, TRUE);
        criteriaMap.put(2, False);
        criteriaMap.put(3, False);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((t)a((f)o(f)))', parse);
        
        criteriaMap.clear();
        
        expression = '1 AND (2 OR 3)';
        criteriaMap.put(1, False);
        criteriaMap.put(2, True);
        criteriaMap.put(3, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((f)a((t)o(t)))', parse);
       	        
        criteriaMap.clear();
        
        expression = '1 AND (2 OR 3)';
        criteriaMap.put(1, False);
        criteriaMap.put(2, True);
        criteriaMap.put(3, False);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((f)a((t)o(f)))', parse);
        
        criteriaMap.clear();
        
        expression = '1 AND (2 OR 3)';
        criteriaMap.put(1, False);
        criteriaMap.put(2, False);
        criteriaMap.put(3, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((f)a((f)o(t)))', parse);
                
        criteriaMap.clear();
        
        expression = '1 AND (2 OR 3)';
        criteriaMap.put(1, False);
        criteriaMap.put(2, False);
        criteriaMap.put(3, False);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((f)a((f)o(f)))', parse);
        
    } // end testComposedAndOrExpressionWithParenthAroundOrOperator method 
    
    
    /**
     * 
     * Test scenario is (X AND Y) OR (Y OR Z)
     * 
    **/
    static testMethod void testComposedExpressionWithTwoOredParenthesis() {
        
        String expression = NULL;
        String parse = NULL;
        Map<Integer, Boolean> criteriaMap = new Map<Integer, Boolean>();
        
        expression = '(1 AND 2) OR (3 OR 4)';
        criteriaMap.put(1, True);
        criteriaMap.put(2, True);
        criteriaMap.put(3, True);
        criteriaMap.put(4, True);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((t)a(t))o((t)o(t))', parse);
        
        criteriaMap.clear();
        
        expression = '((1 AND 2) OR (3 OR 4))';
        criteriaMap.put(1, False);
        criteriaMap.put(2, False);
        criteriaMap.put(3, False);
        criteriaMap.put(4, False);
        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('(((f)a(f))o((f)o(f)))', parse);
        
    } // end testComposedExpressionWithTwoOredParenthesis method 
    
    
    /**
     * 
     * Test scenario is (A AND B) OR (((C OR D) AND (E OR (F AND G))) OR H)
     * 
    **/
    static testMethod void testComposedExpressionComplex() {
        
        String expression = NULL;
        String parse = NULL;
        Map<Integer, Boolean> criteriaMap = new Map<Integer, Boolean>();
        
        expression = '(1 AND 2) OR (((3 OR 4) AND (5 OR (6 AND 7))) OR 8)';
        criteriaMap.put(1, True);
        criteriaMap.put(2, True);
        criteriaMap.put(3, True);
        criteriaMap.put(4, True);
        criteriaMap.put(5, True);
        criteriaMap.put(6, True);
        criteriaMap.put(7, True);
        criteriaMap.put(8, True);

        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((t)a(t))o((((t)o(t))a((t)o((t)a(t))))o(t))', parse);
        
        criteriaMap.clear();
    
        expression = '(1 AND 2) OR (((3 OR 4) AND (5 OR (6 AND 7))) OR 8)';
        criteriaMap.put(1, False);
        criteriaMap.put(2, True);
        criteriaMap.put(3, False);
        criteriaMap.put(4, True);
        criteriaMap.put(5, False);
        criteriaMap.put(6, True);
        criteriaMap.put(7, False);
        criteriaMap.put(8, True);

        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((f)a(t))o((((f)o(t))a((f)o((t)a(f))))o(t))', parse);
        
        criteriaMap.clear();
    
        expression = '(1 AND 2) OR (((3 OR 4) AND (5 OR (6 AND 7))) OR 8)';
        criteriaMap.put(1, False);
        criteriaMap.put(2, False);
        criteriaMap.put(3, True);
        criteriaMap.put(4, True);
        criteriaMap.put(5, False);
        criteriaMap.put(6, True);
        criteriaMap.put(7, False);
        criteriaMap.put(8, True);

        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((f)a(f))o((((t)o(t))a((f)o((t)a(f))))o(t))', parse);
        
		criteriaMap.clear();
    
        expression = '(1 AND 2) OR (((3 OR 4) AND (5 OR (6 AND 7))) OR 8)';
        criteriaMap.put(1, False);
        criteriaMap.put(2, False);
        criteriaMap.put(3, False);
        criteriaMap.put(4, False);
        criteriaMap.put(5, False);
        criteriaMap.put(6, False);
        criteriaMap.put(7, False);
        criteriaMap.put(8, False);

        parse = RuleEngine_ExpressionParser.parse(criteriaMap, expression);
        System.assertEquals('((f)a(f))o((((f)o(f))a((f)o((f)a(f))))o(f))', parse);		        
                
    } // end testComposedExpressionComplex method

} // end RuleEngine_ExpressionParserTest class