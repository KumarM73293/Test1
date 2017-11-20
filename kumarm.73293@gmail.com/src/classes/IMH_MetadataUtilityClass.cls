/**************************************************************************************
 * Author: M.Wheeler
 * Date: 25-11-2016
 * Desc: Visualforce controller for rule engine
 * Revisions:
 *************************************************************************************/
public class IMH_MetadataUtilityClass {
    
    public Map<String, String> getObjects(List<String> excludes) {
        
        Map<String, String> sObjectNametoApiMap = new Map<String,String>();
        Map<String, Schema.SObjectType> allSObjects = new Map<String, Schema.SObjectType>();
        allSObjects = filterSObjectTypes(Schema.getGlobalDescribe(),excludes);
        
        for(String s :allSObjects.keySet()) {
            sObjectNametoApiMap.put(allSObjects.get(s).getDescribe().getLabel(), s);
        }        
        
        return sObjectNametoApiMap;
    }
    
    private Map<String, Schema.SObjectType> filterSObjectTypes(Map<String, Schema.SObjectType> allSObjects, List<String> excludes) {
 
        Map<String, Schema.SObjectType> filteredSObjects = new Map<String, Schema.SObjectType>();
        filteredSObjects.putAll(allSObjects);
        
        if(excludes != null && excludes.size() > 0) {
            for(String s :excludes) {
                filteredSObjects.remove(s);
            }
        }        
  
        return filteredSObjects;
    }
    
    public Map<String, String> getObjectFields(String objectApiName, List<String> excludes) {
        
        Map<String, String> fieldNametoApiMap = new Map<String,String>();
        Schema.DescribeSObjectResult dsr = Schema.getGlobalDescribe().get(objectApiName).getDescribe();
        Map<String, Schema.SObjectField> filteredFields = filterSObjectFields(dsr.fields.getMap(), objectApiName, excludes);
        
        for(String s :filteredFields.keySet()) {
            fieldNametoApiMap.put(filteredFields.get(s).getDescribe().getLabel(), s);
        }  
        
        return fieldNametoApiMap;
    }
    
    private Map<String, Schema.SObjectField> filterSObjectFields(Map<String, Schema.SObjectField> allFields, String objectAPIname, List<String> excludes) {
    
        Map<String, Schema.SObjectField> filteredSObjectFields = new Map<String, Schema.SObjectField>();
        filteredSObjectFields.putAll(allFields);
        
        if(excludes != null && excludes.size() > 0 ) {        
            for(String s :excludes) {
                if(s.contains('.') && s.substringBefore('.') == objectAPIname) {
                    filteredSObjectFields.remove(s.substringAfter('.'));
                }
            }
        }
        
        return filteredSObjectFields;
    }
    
}