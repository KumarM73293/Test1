/**
 * 
 * @Description Unit Test Class to handle the test scenarios related to the 
 * RuleEngine_CriteriaEvalution and OperatorComparisonUtiliy which in sense
 * evaluating criteria based on the entry point of (sourceRecord and targetId)
 * SourceRecord: is the record we are evaluating on (IMH_Communications__c, IMH_Benefits__c, Account, Lead, etc...)
 * targetId: is the Id of the Rule__c where each rule could contain (1..N) RuleCriteria__c records
 * 
 * The operations are equals, notEqualsTo, lessThan, greaterThan, lessOrEqual, greaterOrEqual, contains, doesNotContain, startswith
 * The Data type we are evaluating on are listed https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_enum_Schema_DisplayType.htm
 * (Boolean, Currency, Date, DateTime, Double, Email, ID, Integer, MultiPicklist, Picklist, Percent, Phone and String)
 * 
 * IMPORTANT NOTE: each test method should contain a call to the 'getCriteriaEvaluationResultMap' of class
 * RuleEngine__CriteriaEvaluation 
 * This method will return a Map<Integer, Boolean> where key is the RuleCriteria__c OrderNumber field and 
 * 														value is the evaluation of the operation you are calling upon as above
 * 
 * Instantion of RuleEngine_CriteriaEvaluation is a MUST in each method where you invoke the constructor with 
 * the sourceRecord and the targetId
 * 
 * example: 
 * 		RuleEngine__CriteriaEvaluation operatorEvaluation = new RuleEngine_CriteriaEvluation(sourceRecord, targetId);
 * 		operatorEvaluation.getCriteriaEvaluationResultMap();
 * 
 * 		e.g. SourceRecord: 
 * 			IMH_Communication__c comm with TargetRegion__c = 'EMEA' and TargetMarket = 'UK'
 * 			
 * 			TargetId:
 * 			Rule__c rule = new Rule__c(Name = 'Test Rule', Active__c = true);
 *          insert rule;
 *           
 *           
 *          RuleCriteria__c criteria1 = new RuleCriteria__c();
 *          criteria1.Order__c = 1;
 *          criteria1.Field__c = 'TargetRegion__c';
 *          criteria1.Operator__c = 'equals';
 *          criteria1.Value__c = 'EMEA';
 *          criteria1.Rule__c = rule.Id;
 *          insert criteria1;
 *           
 *           
 *          RuleCriteria__c criteria2 = new RuleCriteria__c();
 *          criteria2.Order__c = 2;
 *          criteria2.Field__c = 'TargetMarket__c';
 *          criteria2.Operator__c = 'contains';
 *          criteria2.Value__c = 'UK / Europe';
 *          criteria2.Rule__c = rule.Id;
 *          insert criteria2;
 * 
 * 
 * 			Results should be Map { 1 => true, 2 => flase}
 * 
 * 
 * 
 * @Author Sinan Bunni
 * @Reviewer Michael Wheeler
 * @Group IMH Developers
 * 
**/ 


@isTest
public class RuleEngine_CriteriaEvaluationTest {

	/**
	*
	* Equals operator test
	*
	**/
    
    static testMethod void equalsOnBoolean() {
        
    }
    
    static testMethod void equalsOnPhone() {
        
    }
    
	static testMethod void equalsOnString() {
		

	}

	static testMethod void equalsOnEmail() {

	}

	static testMethod void equalsOnDouble() {

	}

	static testMethod  void equalsOnInteger() {

	}

	static testMethod void equalsOnDate() {

	}

	static testMethod void equalsOnDateTime() {

	}
	static testMethod void equalsOnCurrency() {

	}

	static testMethod void equalsOnPicklist() {

	}

	static testMethod void equalsOnMultiPicklist() {

	}

	static testMethod void equalsOnID() {

	}
    
    static testMethod void equalsOnURL() {
        
    }

	/**
	*
	* notEqualsTo operator test
	*
	*
	**/
	static testMethod void notEqualsToOnBoolean() {
        
    }
    
    static testMethod void notEqualsToOnPhone() {
        
    }
    
	static testMethod void notEqualsToOnString() {
		

	}

	static testMethod void notEqualsToOnEmail() {

	}

	static testMethod void notEqualsToOnDouble() {

	}

	static testMethod  void notEqualsToOnInteger() {

	}

	static testMethod void notEqualsToOnDate() {

	}

	static testMethod void notEqualsToOnDateTime() {

	}
	static testMethod void notEqualsToOnCurrency() {

	}

	static testMethod void notEqualsToOnPicklist() {

	}

	static testMethod void notEqualsToOnMultiPicklist() {

	}

	static testMethod void notEqualsToOnID() {

	}
    
    static testMethod void notEqualsToOnURL() {
        
    }

	/**
	*
	* lessThan operator test
	*
	*
	**/

	static testMethod void lessThanOnBoolean() {
        
    }
    
    static testMethod void lessThanOnPhone() {
        
    }
    
	static testMethod void lessThanOnString() {
		

	}

	static testMethod void lessThanOnEmail() {

	}

	static testMethod void lessThanOnDouble() {

	}

	static testMethod  void lessThanOnInteger() {

	}

	static testMethod void lessThanOnDate() {

	}

	static testMethod void lessThanOnDateTime() {

	}
    
	static testMethod void lessThanOnCurrency() {

	}

	static testMethod void lessThanOnPicklist() {

	}

	static testMethod void lessThanOnMultiPicklist() {

	}

	static testMethod void lessThanOnID() {

	}
    
    static testMethod void lessThanOnURL() {
        
    }
    
    /**
	*
	* greaterThan operator test
	*
	*
	**/

	static testMethod void greaterThanOnBoolean() {
        
    }
    
    static testMethod void greaterThanOnPhone() {
        
    }
    
	static testMethod void greaterThanOnString() {
		

	}

	static testMethod void greaterThanOnEmail() {

	}

	static testMethod void greaterThanOnDouble() {

	}

	static testMethod  void greaterThanOnInteger() {

	}

	static testMethod void greaterThanOnDate() {

	}

	static testMethod void greaterThanOnDateTime() {

	}
	static testMethod void greaterThanOnCurrency() {

	}

	static testMethod void greaterThanOnPicklist() {

	}

	static testMethod void greaterThanOnMultiPicklist() {

	}

	static testMethod void greaterThanOnID() {

	}
    
    static testMethod void greaterThanOnURL() {
        
    }
    
    /**
	*
	* lessOrEqual operator test
	*
	*
	**/
    
    static testMethod void lessOrEqualOnBoolean() {
        
    }
    
    static testMethod void lessOrEqualOnPhone() {
        
    }
    
	static testMethod void lessOrEqualOnString() {
		

	}

	static testMethod void lessOrEqualOnEmail() {

	}

	static testMethod void lessOrEqualOnDouble() {

	}

	static testMethod  void lessOrEqualOnInteger() {

	}

	static testMethod void lessOrEqualOnDate() {

	}

	static testMethod void lessOrEqualOnDateTime() {

	}
	static testMethod void lessOrEqualOnCurrency() {

	}

	static testMethod void lessOrEqualOnPicklist() {

	}

	static testMethod void lessOrEqualOnMultiPicklist() {

	}

	static testMethod void lessOrEqualOnID() {

	}
    
    static testMethod void lessOrEqualOnURL() {
        
    }

    
    /**
	*
	* greaterOrEqual operator test
	*
	*
	**/

	static testMethod void greaterOrEqualOnBoolean() {
        
    }
    
    static testMethod void greaterOrEqualOnPhone() {
        
    }
    
	static testMethod void greaterOrEqualOnString() {
		

	}

	static testMethod void greaterOrEqualOnEmail() {

	}

	static testMethod void greaterOrEqualOnDouble() {

	}

	static testMethod  void greaterOrEqualOnInteger() {

	}

	static testMethod void greaterOrEqualOnDate() {

	}

	static testMethod void greaterOrEqualOnDateTime() {

	}
	static testMethod void greaterOrEqualOnCurrency() {

	}

	static testMethod void greaterOrEqualOnPicklist() {

	}

	static testMethod void greaterOrEqualOnMultiPicklist() {

	}

	static testMethod void greaterOrEqualOnID() {

	}
    
    static testMethod void greaterOrEqualOnURL() {
        
    }

	/**
	*
	* Contains operator test
	*
	*
	**/

	static testMethod void containsOnBoolean() {
        
    }
    
    static testMethod void containsOnPhone() {
        
    }
    
	static testMethod void containsOnString() {
		

	}

	static testMethod void containsOnEmail() {

	}

	static testMethod void containsOnDouble() {

	}

	static testMethod  void containsOnInteger() {

	}

	static testMethod void containsOnDate() {

	}

	static testMethod void containsOnDateTime() {

	}
	static testMethod void containsOnCurrency() {

	}

	static testMethod void containsOnPicklist() {

	}

	static testMethod void containsOnMultiPicklist() {

	}

	static testMethod void containsOnID() {

	}
    
    static testMethod void containsOnURL() {
        
    }


	/**
	*
	* DoesNotContain operator test
	*
	*
	**/

	static testMethod void doesNotContainOnBoolean() {
        
    }
    
    static testMethod void doesNotContainOnPhone() {
        
    }
    
	static testMethod void doesNotContainOnString() {
		

	}

	static testMethod void doesNotContainOnEmail() {

	}

	static testMethod void doesNotContainOnDouble() {

	}

	static testMethod  void doesNotContainOnInteger() {

	}

	static testMethod void doesNotContainOnDate() {

	}

	static testMethod void doesNotContainOnDateTime() {

	}
	static testMethod void doesNotContainOnCurrency() {

	}

	static testMethod void doesNotContainOnPicklist() {

	}

	static testMethod void doesNotContainOnMultiPicklist() {

	}

	static testMethod void doesNotContainOnID() {

	}
    
    static testMethod void doesNotContainOnURL() {
        
    }


	/**
	*
	* startswith operator test
	*
	*
	**/

	static testMethod void startswithOnBoolean() {
        
    }
    
    static testMethod void startswithOnPhone() {
        
    }
    
	static testMethod void startswithOnString() {
		

	}

	static testMethod void startswithOnEmail() {

	}

	static testMethod void startswithOnDouble() {

	}

	static testMethod  void startswithOnInteger() {

	}

	static testMethod void startswithOnDate() {

	}

	static testMethod void startswithOnDateTime() {

	}
    
	static testMethod void startswithOnCurrency() {

	}

	static testMethod void startswithOnPicklist() {

	}

	static testMethod void startswithOnMultiPicklist() {

	}

	static testMethod void startswithOnID() {

	}
    
    static testMethod void startswithOnURL() {
        
    }


	/**
	 * 
	 * @Description setup method to create Rule and Criteria records.
	 * 
	**/

	private List<IMH_Rule__c > createRuleRecords(Integer ruleCount, Integer criteriaCount, String ruleSourceObject, String ruleTargetObject) {

		List<IMH_Rule__c > rules = new List<IMH_Rule__c >();
		for (Integer i = 0; i < ruleCount; i++) {
			rules.add(
				new IMH_Rule__c (
					Active__c = true,
					SourceObject__c = ruleSourceObject,
					TargetObject__c = ruleTargetObject
				)
			);
		}

		if (rules.isEmpty()) {
			return new List<IMH_Rule__c >();
		} else {
			insert rules;
		}
		

		List<IMH_RuleCriteria__c > criteria = new List<IMH_RuleCriteria__c >();

		for (IMH_Rule__c  enteryRule : rules) {
			for (Integer i = 0; i < criteriaCount; i++) {
				criteria.add(
					new IMH_RuleCriteria__c (
						Field__c = '',
						Operator__c = '',
						Order__c = i,
						Value__c = ''
					)
				);
			}
		}

		if (!criteria.isEmpty()) {
			insert criteria;
		}

		return rules;
		
	} // end createRuleRecords method


} // end RuleEngine_CriteriaEvaluationTest end