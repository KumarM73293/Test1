public class AttachmentController {
    public Document att {get;set;}
    public Blob attBody {get;set;}
    public String attName {get;set;}
    public AttachmentController() {
        att = new Document();
    }                 

    public PageReference saveAttachment(){
        //att.ParentId = 'a0F6F00000lz7hM';
        att.FolderId = '00l6F000002SL0Z';
         //att.Name = attName;
         //att.Body = attBody;
       system.debug('--->>>>>Att.Name'+att.Name);
        insert att;
        att = new Document();
        attName = null;
        attBody = null;
        return null;
    }
}