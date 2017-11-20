/**
* @author Accenture IDC 
* @date 06/10/2015
* @group Answer
* @group-content N/A
* @description Trigger  on FeedItem that handles ensuring the correct system 
* logic has been triggered on particular event of an object.
*/
trigger IMH_FeedItemTrigger on FeedItem (before delete) {
    //INVOKING HANDLER CLASS METHOD TO PREVENT DELETION OF POSTS
    IF(Trigger.IsBefore && Trigger.IsDelete)
    IMH_FeedItemTriggerHandler.preventFeedPostDeletion(Trigger.Old);

}