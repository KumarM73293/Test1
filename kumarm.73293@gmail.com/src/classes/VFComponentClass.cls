public class VFComponentClass {
	private final List<Account> accounts;

	public VFComponentClass() {
		accounts = [select Name from Account];
	}

	public List<Account> getSmithAccounts() {
		return accounts;
	}
}