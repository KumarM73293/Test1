/**
    * @author Accenture IDC 
    * @date 10/30/2015
    * @group Campaign
    * @group-content N/A
    * @description: iMH Release 1.3 (Sprint 15) - Stamp Mandatory Approvers for Communication based on Custom Settings and User's Team
*/
public without sharing class IMH_StampMandatoryApprovers {
    
    private static final String ID_TEXT                 = 'Id';
    private static final String MANDATORY_APPROVERS_API = 'Mandatory_Approvers__c';
    private static final String SEMI_COLON              = ';';
    private static final String WHITE_SPACE             = ' ';
    private static final String NULL_SPACE              = '';
    
    /**
    * @description  - Method to stamp mandatory approver field on communication
    * @param  - List of Communication record (new)
    * @return  - null
    */
    public static void updateCommunicationWithMandatoryApprovers(List<IMH_Communication__c> ltriggernew) {
        List<IMH_Mandatory_Approval_Matrix__c> mandatoryMatrixList = new List <IMH_Mandatory_Approval_Matrix__c>();
        mandatoryMatrixList = [SELECT Name, Team__c, Market__c, Approval_Group__c, Is_Mandatory__c FROM 
                              IMH_Mandatory_Approval_Matrix__c WHERE Is_Mandatory__c = true
                              LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
        String userTeam = [SELECT Id, IMH_User_Team__c FROM User WHERE id =: userInfo.getUserId() LIMIT 1].IMH_User_Team__c;
        List<sObject> communicationUpdateList = new List<sObject>();
        IMH_Communication__c sObj;
        String mandatoryApprovers;
        for(IMH_Communication__c commn : ltriggernew) {
            mandatoryApprovers = NULL_SPACE;
            for(IMH_Mandatory_Approval_Matrix__c mat : mandatoryMatrixList){
                if(mat.Team__c == userTeam && mat.Market__c == commn.TargetMarket__c){
                    if(String.isNotBlank(mandatoryApprovers)){
                        if(!mandatoryApprovers.contains(mat.Approval_Group__c)){
                            mandatoryApprovers = mandatoryApprovers+SEMI_COLON+WHITE_SPACE+mat.Approval_Group__c;
                        }
                    }
                    else{
                        mandatoryApprovers = mat.Approval_Group__c;
                    }
                }
            }
            sObj = new IMH_Communication__c();
            sObj.put(ID_TEXT,commn.Id);
            sObj.put(MANDATORY_APPROVERS_API, mandatoryApprovers);
            communicationUpdateList.add(sObj);
        }
        Database.update (communicationUpdateList,false);
    }
}