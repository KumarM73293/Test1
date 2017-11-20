/**************************************************************************************
 * Author: M.Wheeler
 * Date: 25-11-2016
 * Desc: unit tests for IMH_MetadataUtilityClass
 * Revisions:
 *************************************************************************************/
@isTest
public class IMH_MetadataUtilityClass_Test {
    
    public static IMH_MetadataUtilityClass mdu = new IMH_MetadataUtilityClass();

    static testMethod void testUnfilteredSObjectList() {
        
        Map<String, String> objectMap = mdu.getObjects(null);
        
        System.assert(objectMap.size() > 0);
        System.assertEquals('contact' , objectMap.get('Contact'));
        System.assertEquals('user', objectMap.get('User'));

    }    
    
    static testMethod void testFilteredSObjectList() {
        
        List<String> filter = new List<String>{'contact'};
        Map<String, String> objectMap = mdu.getObjects(filter);
        
        System.assert(objectMap.size() > 0);
        System.assertNotEquals('contact' , objectMap.get('Contact'));
        System.assertEquals('user', objectMap.get('User'));

    } 
	
    static testMethod void testUnfilteredSObjectFieldContact() {
        
        Map<String, String> objectFieldMap = mdu.getObjectFields('contact', null);
        
        System.assert(objectFieldMap.size() > 0);
        System.debug(objectFieldMap);
        System.assertEquals('id', objectFieldMap.get('Contact ID'));
        System.assertEquals('lastmodifieddate', objectFieldMap.get('Last Modified Date'));

    }    
    
    static testMethod void testFilteredSObjectFieldContact() {
        
        List<String> filter = new List<String>{'contact.id'};
        Map<String, String> objectFieldMap = mdu.getObjectFields('contact', filter);
        
        System.assert(objectFieldMap.size() > 0);
        System.debug(objectFieldMap);
        System.assertEquals('id', objectFieldMap.get('Contact ID'));
        System.assertEquals('lastmodifieddate', objectFieldMap.get('Last Modified Date'));
        
    }      

}