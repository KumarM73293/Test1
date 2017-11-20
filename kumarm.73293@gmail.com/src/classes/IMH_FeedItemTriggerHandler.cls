/**
* @author Accenture IDC 
* @date 06/01/2015
* @group Answer
* @group-content N/A
* @description Trigger handler on FeedItem that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/
public with sharing class IMH_FeedItemTriggerHandler {
    //private static final String IMH_CAMPAIGN_REVIEWER = 'iMH Campaign Reviewer';
    private static final String SYSTEM_ADMIN = 'System Administrator';
    private static final String IMH_CAMPAIGN_SUBMITTER = 'iMH Campaign Submitter';
    private static final String EMPTY_STRING = '';
        
    /**
    * @description  - Method to restrict the deletion of chatter post of any type if user is of profile other than below
    * @param  - Trigger.old(FeedItem)
    * @return  - void
    */ 
    public static void preventFeedPostDeletion(List<Feeditem> lTriggerOld){
        Schema.DescribeSObjectResult commObj = IMH_Communication__c.sObjectType.getDescribe();
        Schema.DescribeSObjectResult commCreativeObj = IMH_CommCreative__c.sObjectType.getDescribe();
        //Check if Current logged in user is MDT user with IMH Submitter Permission Set.
        Boolean userCanDoIMH = false;
        
        string customLabel = EMPTY_STRING;
       // List<String> profileNames = new List<String>{SYSTEM_ADMIN,IMH_CAMPAIGN_SUBMITTER};
       // queries the SYS_IMHRole which is set to true if the Users is Reviewer
           User currentuser = [SELECT Id,SYS_IMHHROLE__c FROM User
                            WHERE Id =:UserInfo.getUserId()];
            if(currentuser.SYS_IMHHROLE__c){//(!lpquery.containsKey((Id)Userinfo.getProfileId())) || (userCanDoIMH) || 
                //ITERATE THROUGH THE FEED ITEM AND RESTRICT IF THE USER IS DELETING THE POST OF CAMPAIGN/OFFER
                for(FeedItem fitem : lTriggerOld){
                    if (((String)fitem.parentId).startsWith(commObj.getKeyPrefix())
                            ||  ((String)fitem.parentId).startsWith(commCreativeObj.getKeyPrefix())) {  
                            customLabel=System.Label.ErrorLabel;
                            fitem.addError(customLabel); 
                        }
                }
            }
    }
        
}