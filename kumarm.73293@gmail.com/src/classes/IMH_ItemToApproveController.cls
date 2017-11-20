/**
* @author Accenture IDC 
* @date 06/29/2016
* @group-content N/A
* @description Page Controller Used to get the Items To Approve Information on Home Page as well as on VF Page. 
* logic has been triggered on load of Items to Approve Page.
*/
public with sharing class IMH_ItemToApproveController {
    private static final String FIELDSET_ITEMTOAPPROVE = 'IMH_ItemToApprove';
    private static final String SLATRACKER_API = 'IMH_SLATracker__c';
    private static final String SELECT_SPACE = 'SELECT ';
    private static final String COMMA_SPACE = ', '; 
    private static final String WHEREQUERY = ' Id,OwnerId,SYSDelegatedApprover__c FROM IMH_SLATracker__c WHERE (Status__c =\'Pending\' OR Status__c = \'Pending Approval – Changes/Information Required\')';
    private static final String HOMEPAGECONDITION = ' AND (OwnerId IN:setqueueIds OR OwnerId IN:setowners OR OwnerId =:currentUser OR  ID IN:setdelegatedapprovalrecords) AND ApprovalType__c!=NULL ORDER BY Started__c ASC LIMIT 10';
    private static final String COMMONPAGECONDITION = ' AND (OwnerId IN:setqueueIds OR OwnerId IN:setowners OR OwnerId =:currentUser OR ID IN:setdelegatedapprovalrecords) AND ApprovalType__c!=NULL ORDER BY Started__c ASC';   
    private static final String REFERENCEVALUE  = 'REFERENCE'; 
    private static final String PARAMETER = 'param';
    private static final String ONE = '1';
    private static final String LKSEARCH = 'lksrch';
    public List<IMH_SLATracker__c> lslatracker{get;set;}
    public List<WrapperList> lwrapper {get;set;}
    public List<IMH_SLATracker__c> assignedReviewerLookup{get;set;}
    public string searchString{get;set;}
    public List<User> lassignedReviewer {get;set;}
    public Map<String,Boolean> linputCol ;
    public String newPageParameter {get;set;}
    public Map<Integer,String> FieldLablesMap {get;set;}
    public Map<Integer,String> FieldLabelAPIMap {get;set;}
    public Map<String,String> mUserNameId {get;set;}
    public Integer    noOfFieldsOntable      {get;set;}
    public Boolean isBlankRecords {get;set;}
    public Boolean redirectPage {get;set;}
    public Map<String, Boolean> styleMap{get;set;}
    public Map<String,String> mapOldAssignedReviewer;
    public String ResultHeading {get;set;}
    public String ItemToApproveHeading {get;set;}
    
    //Getting User Name To AvoidLookup
    SET<ID> setuserId;
    
     /**
    * @description  - Non Parameterized Constructor where Page paramters are fectched and Headings are Set
    * @param  - None
    * @return  - N/A
    */ 
    public IMH_ItemToApproveController(){
        lslatracker = new List<IMH_SLATracker__c>();
        lwrapper = new List<WrapperList>();
        lassignedReviewer = new List<User>();
        //assignedReviewerLookup = new IMH_SLATracker__c();
        assignedReviewerLookup = [SELECT Id,AssignedApprover__c FROM IMH_SLATracker__c LIMIT 1];
        searchString = System.currentPageReference().getParameters().get(LKSEARCH);
        newPageParameter = ApexPages.currentPage().getParameters().get(PARAMETER);
        FieldLablesMap = new Map<Integer,String>();
        FieldLabelAPIMap = new Map<Integer,String>();
        mUserNameId = new Map<String,String>();
        linputCol = new Map<String,Boolean>();
        redirectPage = false;
        styleMap = new Map < String, Boolean > ();
        mapOldAssignedReviewer = new Map<String,String>();
        setuserId = new SET<ID>();
        if(newPageParameter == ONE){
             ResultHeading = Label.IMH_ItemstoApproveHeading_CP;
             ItemToApproveHeading = IMH_UtilityConstants.EMPTY_STRING;
        }
        else{
            ResultHeading = Label.IMH_ItemstoApproveHeading_HP;
            ItemToApproveHeading = Label.IMH_ItemstoApproveHeading_HP;
        }
        displayRecords(newPageParameter);
    }
  /**
    * @description  - Method Called from Constructor to build a wrapper list with the list of approvals retrieved.
    * @param  - None
    * @return  - Void
    */ 
    public void displayRecords(String newPageParameter){
        String queryString = IMH_UtilityConstants.EMPTY_STRING;
         SET<ID> setowners = new SET<ID>();
         SET<ID> setqueueIds = new SET<ID>();
          SET<ID> setdelegatedowners = new SET<ID>();
        SET<ID> setdelegatedapprovalrecords = new SET<ID>();
         String currentUser = UserInfo.getUserId();
         //Id delegetedapprovalId = [SELECT ID,DelegatedApproverId FROM User WHERE ID =:currentUser].DelegatedApproverId;
        //Query to get all the approval groups of which the loogged in user is a member.
         for(GroupMember approvalGroup : [SELECT Id, GroupId,UserOrGroupId  FROM GroupMember WHERE 
                                            UserOrGroupId =: UserInfo.getUserId()]){
                    setowners.add(approvalGroup.GroupId);                    
         }
        //Query to get all the queues from the Groups queried above.
        for(GroupMember queuegroups:[SELECT Id, GroupId,UserOrGroupId  FROM GroupMember WHERE 
                                     UserOrGroupId IN:setowners]){
              setqueueIds.add(queuegroups.GroupId);                                    
        }
        
          for(IMH_SLATracker__Share shareRecords:[SELECT Id,
                                                      ParentId,
                                                      UserOrGroupId
                                                    FROM IMH_SLATracker__Share
                                                    WHERE UserOrGroupId =:currentUser
                                                    AND RowCause = 'Manual']){
                  setdelegatedapprovalrecords.add(shareRecords.ParentId);                                  
         }
        
        List<Schema.FieldSetMember> listoffields = IMH_GeneralApplicationUility.readFieldSet(FIELDSET_ITEMTOAPPROVE,SLATRACKER_API);
        queryString = SELECT_SPACE;
        Integer counter = 0;
        //Preparing the query string to get the list of fields from fieldset.
        for(Schema.FieldSetMember f : listoffields){
            counter++;
            queryString += f.getFieldPath() + COMMA_SPACE;
            FieldLablesMap.put(counter,f.getLabel());
            FieldLabelAPIMap.put(counter,f.getFieldPath());
            //Getting the map of fields which are of type Lookup and the true as boolean
            if(String.valueof(f.getType()) != REFERENCEVALUE){
                linputCol.put(f.getFieldPath(),false);
            }
            else{
                 linputCol.put(f.getFieldPath(),true);
            }
            
        }
        noOfFieldsOntable = FieldLablesMap.size();
        queryString += WHEREQUERY;
        if(newPageParameter != ONE){ 
         queryString += HOMEPAGECONDITION;
        }
        else{
          queryString += COMMONPAGECONDITION;
        }
        System.debug('');
        lslatracker = Database.query(queryString);
        
        if(lslatracker.isEmpty()){
            isBlankRecords = true;
        }
        for(IMH_SLATracker__c sla:lslatracker){
            lwrapper.add(new WrapperList(sla,false,linputCol));
            styleMap.put(String.valueof(sla.Id),false);
            mapOldAssignedReviewer.put(sla.Id,sla.AssignedApprover__c);
            if(sla.Submitter__c != NULL){
                setUserId.add(sla.Submitter__c);
            }
            if(sla.AssignedApprover__c != NULL){
             setUserId.add(sla.AssignedApprover__c);
            }
           // mUserNameId.put(sla.Id,sla.AssignedApprover__c);
                 //mUserNameId.put(sla.Id,sla.Submitter__c);
         }
       
      
       findNameofUser();
       
    }
/**
    * @description  - Method Called for getteing User Map to get the Name of the user to avoid hover
    * @param  - None
    * @return  - Void
*/
  public void findNameofUser(){
         for(User userdetail:[SELECT Id,Name From User
                             WHERE ID IN:setUserId]){
                mUserNameId.put(userdetail.Id,userdetail.Name);                 
        }
    }
 /**
    * @description  - Method Called to assign the user to Assigend Reviewer on Click of Assign button
    * @param  - None
    * @return  - PageReference
*/
    public PageReference assignReveiwer(){
         Savepoint sp = Database.setSavepoint();
        Boolean errorMessage = false;
          Boolean isdmError = false;
        PageReference ReturnPageval = null;
         //System.debug('****AR1 '+lwrapper);
        List<IMH_SLATracker__c> lselectedrecords = new List<IMH_SLATracker__c>();
        Boolean boolval = false;
        if(assignedReviewerLookup[0].AssignedApprover__c==NULL){
                     errorMessage = true;
                     ApexPages.Message myMsg;
                      myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.IMH_NoReviewerAssignedError);
                     ApexPages.addMessage(myMsg);
                }
    if(!errorMessage){
        for(WrapperList wrap:lwrapper){
             styleMap.put(String.valueof(wrap.sla.Id),false);
            if(wrap.isSelected){
                wrap.sla.AssignedApprover__c = assignedReviewerLookup[0].AssignedApprover__c;
                wrap.isSelected = false;
             if(assignedReviewerLookup[0].AssignedApprover__c != NULL){
             setUserId.add(assignedReviewerLookup[0].AssignedApprover__c);
            }
                lselectedrecords.add(wrap.sla);
               
            }
          }
      }
       // Assigned approver is assigned but there are no records selected
       if(assignedReviewerLookup[0].AssignedApprover__c != NULL 
                && (lselectedrecords.isEmpty() || lselectedrecords == NULL)){
                     errorMessage = true;
                     ApexPages.Message myMsg;
                      myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.IMH_NoRecordsSelected);
                     ApexPages.addMessage(myMsg);
      }
        assignedReviewerLookup[0].AssignedApprover__c = null;
        // Assigned approver is assigned by a manager is restriceted using below snippet
        if(!lselectedrecords.isEmpty()){
            List<Database.SaveResult> lSaveResult = new List<Database.SaveResult> ();
                lSaveResult = Database.update(lselectedrecords,false);
                integer selectedCounter = 0;
                for(Database.SaveResult sr:lSaveResult){
                    if(!sr.isSuccess()){
                        errorMessage = true;
                        isdmError = true;
                        for(Database.Error err : sr.getErrors()) {
                             ApexPages.Message myMsg;
                            if(String.valueof(err.getMessage()).contains('Please note that you cannot assign the Reviewer.')){
                                 myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.IMH_DirectorManagerError);
                            }
                            else{
                                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.IMH_SystemError);  
                            }
                              styleMap.put(String.valueof(lselectedrecords.get(selectedCounter).Id),true);
                              ApexPages.addMessage(myMsg);
                        }
                    }
                    selectedCounter++;
                }
        }
         if(errorMessage){
             Integer iterator = 0;
             for(WrapperList wrap:lwrapper){
                 //if(wrap.isSelected){
                    wrap.isSelected = false;
                    //System.debug('****Map '+iterator+'()'+mapOldAssignedReviewer.get(wrap.sla.Id)) ;
                    wrap.sla.AssignedApprover__c =  mapOldAssignedReviewer.get(wrap.sla.Id);
                    lwrapper[iterator] = wrap;
                 //}
                 iterator++;
             }
             if(isdmError)
             {
                 Database.RollBack(sp);
             }
            // System.debug('***Lwrap '+lwrapper[0]);
            // System.debug('***Map '+lwrapper[0]);
         }
         findNameofUser();
        return ReturnPageval;
    }
    
    /**
    * @description: Wrapper Class used to bind the checkbox with Sla record and columns
    * @param: none
    * @return: void
    */
    public class WrapperList{
        public Boolean isSelected{get;set;}
        public IMH_SLATracker__c sla {get;set;}
        public Map<String,Boolean> linputColumn {get;set;}
        public WrapperList(IMH_SLATracker__c sla, Boolean bool,Map<String,Boolean>linputCol){
            isSelected = bool;
            this.sla = sla;
            linputColumn = linputCol;
        }
    }
}