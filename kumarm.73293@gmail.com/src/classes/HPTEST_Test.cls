@isTest
public class HPTEST_Test {
    
    private static testmethod void method_1(){
       HPTest hp = new HPTEST();
        hp.method_1();
        system.assertEquals([SELECT Id FROM Account WHERE Name  = 'test umar'].size(), 1);
    }
        
}