/**
* @author Accenture IDC 
* @date 01/12/2016
* @group Answer
* @group-content N/A
* @description Trigger on Targeted Pre Approved object which looks for the before delete 
*				Basically triggers prevents deletion of records based on status during approval process 
*/
trigger IMH_PreApprovedBenefitTrigger on IMH_PreApprovedBenefits__c (before delete,after insert,after delete,after undelete) {
	if(Trigger.isDelete && Trigger.isBefore){
        IMH_GeneralApplicationUility.preventDeletion(Trigger.OldMap,Label.IMH_PreventDeletionOfPreApprovedBenefit,'IMH_PreApprovedBenefits__c');
    }
   if(Trigger.isAfter){
        if(Trigger.isDelete){
            IMH_PreApprovedBenefitHandler.updateBenefitsPillars(Trigger.Old); 
        }
        else if(Trigger.isUnDelete){
			IMH_PreApprovedBenefitHandler.updateBenefitsPillars(Trigger.New); 
		}else if(Trigger.isInsert){
			IMH_PreApprovedBenefitHandler.updateBenefitsPillars(Trigger.New); 
		}
    }
}