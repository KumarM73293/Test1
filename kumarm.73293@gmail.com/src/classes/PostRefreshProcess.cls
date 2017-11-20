/**
* @author Kumar Murugan  - Initial Version
* @date 02/06/2017
* @group-content Utility Methods
* @description - Used to process the post refresh sandbox activity
*/

global class PostRefreshProcess implements SandboxPostCopy {
	global void runApexClass(SandboxContext context) {
      System.debug('Hello Tester Pester ' + context.organizationId()
           + ' ' + context.sandboxId() + context.sandboxName());
    }
}