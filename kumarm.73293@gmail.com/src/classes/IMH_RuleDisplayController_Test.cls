@isTest
public class IMH_RuleDisplayController_Test {
    
    static testMethod void testNewRecordAllNull() {
        
        PageReference pageRef = Page.IMH_RuleDisplay;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', null);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IMH_Rule__c());
        IMH_RuleDisplayController controller = new IMH_RuleDisplayController(sc);
        
        controller.saveRecords();
        
        List<IMH_Rule__c> allRules = [ SELECT ID FROM IMH_Rule__c];
        
        System.assert(allRules.size() == 0);
        
    }
    
    static testMethod void testNewRecordNotNull() {
        
        PageReference pageRef = Page.IMH_RuleDisplay;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', null);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IMH_Rule__c());
        IMH_RuleDisplayController controller = new IMH_RuleDisplayController(sc);
        
        controller.currentRule.CriteriaLogic__c = '1 AND 2';
        controller.currentRule.SourceObject__c = 'contact';
        controller.currentRule.Name = 'Test Rule';
        
        controller.addRow();
        
        controller.relatedRuleCriteria[0].criteria.Value__c = 'test';
        controller.relatedRuleCriteria[0].criteria.Field__c = 'id';
        controller.relatedRuleCriteria[0].criteria.Operator__c = 'equals';
        
        controller.saveRecords();
        
        List<IMH_Rule__c> allRules = [ SELECT ID, Name, CriteriaLogic__c, SourceObject__c  FROM IMH_Rule__c];
        
        System.assert(allRules.size() == 1);
        System.assertEquals(allRules[0].SourceObject__c, 'contact');
        System.assertEquals(allRules[0].CriteriaLogic__c, '1 AND 2');
        System.assertEquals(allRules[0].Name, 'Test Rule');
        
        List<IMH_RuleCriteria__c> allRuleCriteria = [ SELECT ID, Rule__c, Value__c, Field__c, Operator__c FROM IMH_RuleCriteria__c];
        
        System.assert(allRuleCriteria.size() == 1);
        
        System.assertEquals( allRules[0].Id, allRuleCriteria[0].Rule__c);
        System.assertEquals('test', allRuleCriteria[0].Value__c);
        System.assertEquals('id', allRuleCriteria[0].Field__c);
        System.assertEquals('Equals', allRuleCriteria[0].Operator__c);
        
    }
    
    static testMethod void testNewRecordNotNullRemoveRow() {
        
        PageReference pageRef = Page.IMH_RuleDisplay;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', null);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IMH_Rule__c());
        IMH_RuleDisplayController controller = new IMH_RuleDisplayController(sc);
        
        controller.currentRule.CriteriaLogic__c = '1 AND 2';
        controller.currentRule.SourceObject__c = 'contact';
        controller.currentRule.Name = 'Test Rule';
        
        controller.addRow();
        
        controller.relatedRuleCriteria[0].criteria.Value__c = 'test';
        controller.relatedRuleCriteria[0].criteria.Field__c = 'id';
        controller.relatedRuleCriteria[0].criteria.Operator__c = 'equals';
        
        controller.addRow();
        
        controller.relatedRuleCriteria[1].criteria.Value__c = 'test2';
        controller.relatedRuleCriteria[1].criteria.Field__c = 'lastmodifieddate';
        controller.relatedRuleCriteria[1].criteria.Operator__c = 'equals';
        
        controller.relatedRuleCriteria[0].selected = true;
        
        controller.removeRow();
        
        controller.saveRecords();
        
        List<IMH_Rule__c> allRules = [ SELECT ID, Name, CriteriaLogic__c, SourceObject__c  FROM IMH_Rule__c];
        
        System.assert(allRules.size() == 1);
        System.assertEquals(allRules[0].SourceObject__c, 'contact');
        System.assertEquals(allRules[0].CriteriaLogic__c, '1 AND 2');
        System.assertEquals(allRules[0].Name, 'Test Rule');
        
        List<IMH_RuleCriteria__c> allRuleCriteria = [ SELECT ID, Rule__c, Value__c, Field__c, Operator__c FROM IMH_RuleCriteria__c];
        
        System.assert(allRuleCriteria.size() == 1);
        
        System.assertEquals( allRules[0].Id, allRuleCriteria[0].Rule__c);
        System.assertEquals('test2', allRuleCriteria[0].Value__c);
        System.assertEquals('lastmodifieddate', allRuleCriteria[0].Field__c);
        System.assertEquals('Equals', allRuleCriteria[0].Operator__c);
        
        
    }
    
    static testMethod void testNewRecordNotNullReOrder() {
        
        PageReference pageRef = Page.IMH_RuleDisplay;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', null);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IMH_Rule__c());
        IMH_RuleDisplayController controller = new IMH_RuleDisplayController(sc);
        
        controller.currentRule.CriteriaLogic__c = '1 AND 2';
        controller.currentRule.SourceObject__c = 'contact';
        controller.currentRule.Name = 'Test Rule';
        
        controller.addRow();
        
        controller.relatedRuleCriteria[0].criteria.Value__c = 'test';
        controller.relatedRuleCriteria[0].criteria.Field__c = 'id';
        controller.relatedRuleCriteria[0].criteria.Operator__c = 'equals';
        
        controller.addRow();
        
        controller.relatedRuleCriteria[1].criteria.Value__c = 'test2';
        controller.relatedRuleCriteria[1].criteria.Field__c = 'lastmodifieddate';
        controller.relatedRuleCriteria[1].criteria.Operator__c = 'equals';
        
        controller.sortByOrder(); //first sort is asc
        controller.sortByOrder(); //second sort is desc
        
        System.assertEquals('test2', controller.relatedRuleCriteria[0].criteria.Value__c);
        System.assertEquals(2.0, controller.relatedRuleCriteria[0].criteria.Order__c);
    }
    
    static testMethod void testMetadataPicklists() {
        
        PageReference pageRef = Page.IMH_RuleDisplay;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', null);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IMH_Rule__c());
        IMH_RuleDisplayController controller = new IMH_RuleDisplayController(sc);
        
        controller.getSObjectPicklist();
        
        controller.currentRule.SourceObject__c = 'contact';
        
        controller.getSObjectFieldPicklist();
    }
    
    static testMethod void testDeleteRecord() {
        
        IMH_Rule__c newRule = new IMH_Rule__c(CriteriaLogic__c = '1 AND 2', 
                                              SourceObject__c = 'contact', 
                                              Name = 'TestRule');
        insert newRule;
        
        
        IMH_RuleCriteria__c newRuleCriteria = new IMH_RuleCriteria__c(Value__c = 'test', 
                                                                      Field__c = 'id', 
                                                                      Order__c = 1.0,
                                                                      Operator__c = 'Equals',
                                                                      Rule__c = newRule.Id);
        insert newRuleCriteria;
        
        
        PageReference pageRef = Page.IMH_RuleDisplay;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', null);
        ApexPages.StandardController sc = new ApexPages.StandardController(newRule);
        IMH_RuleDisplayController controller = new IMH_RuleDisplayController(sc);
        
        controller.deleteRecords();
        
        List<IMH_Rule__c> allRules = [ SELECT ID, Name, CriteriaLogic__c, SourceObject__c  FROM IMH_Rule__c];
        
        System.assert(allRules.size() == 0);
        
        List<IMH_RuleCriteria__c> allRuleCriteria = [ SELECT ID FROM IMH_RuleCriteria__c];
        
        System.assert(allRuleCriteria.size() == 0);
        
        
    }
    
    static testMethod void testValidationDuplicateOrder() {
        
        PageReference pageRef = Page.IMH_RuleDisplay;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', null);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IMH_Rule__c());
        IMH_RuleDisplayController controller = new IMH_RuleDisplayController(sc);
        
        controller.currentRule.CriteriaLogic__c = '1 AND 2';
        controller.currentRule.SourceObject__c = 'contact';
        controller.currentRule.Name = 'Test Rule';
        
        controller.addRow();
        
        controller.relatedRuleCriteria[0].criteria.Value__c = 'test';
        controller.relatedRuleCriteria[0].criteria.Field__c = 'id';
        controller.relatedRuleCriteria[0].criteria.Operator__c = 'equals';
        
        controller.addRow();

        controller.relatedRuleCriteria[1].criteria.Order__c = 1.0;
        controller.relatedRuleCriteria[1].criteria.Value__c = 'test';
        controller.relatedRuleCriteria[1].criteria.Field__c = 'lastmodifieddate';
        controller.relatedRuleCriteria[1].criteria.Operator__c = 'equals';
        
        controller.saveRecords();
        
        List<IMH_Rule__c> allRules = [ SELECT ID, Name, CriteriaLogic__c, SourceObject__c  FROM IMH_Rule__c];
        
        System.assert(allRules.size() == 0);
        
    }
    
    static testMethod void testValidationDuplicateField() {
        
        PageReference pageRef = Page.IMH_RuleDisplay;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', null);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IMH_Rule__c());
        IMH_RuleDisplayController controller = new IMH_RuleDisplayController(sc);
        
        controller.currentRule.CriteriaLogic__c = '1 AND 2';
        controller.currentRule.SourceObject__c = 'contact';
        controller.currentRule.Name = 'Test Rule';
        
        controller.addRow();
        
        controller.relatedRuleCriteria[0].criteria.Value__c = 'test';
        controller.relatedRuleCriteria[0].criteria.Field__c = 'id';
        controller.relatedRuleCriteria[0].criteria.Operator__c = 'equals';
        
        controller.addRow();

        controller.relatedRuleCriteria[1].criteria.Value__c = 'test';
        controller.relatedRuleCriteria[1].criteria.Field__c = 'id';
        controller.relatedRuleCriteria[1].criteria.Operator__c = 'equals';
        
        controller.saveRecords();
        
        List<IMH_Rule__c> allRules = [ SELECT ID, Name, CriteriaLogic__c, SourceObject__c  FROM IMH_Rule__c];
        
        System.assert(allRules.size() == 0);
                
    }
    
    
    
}