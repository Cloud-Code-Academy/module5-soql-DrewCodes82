/**
 * The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
 * It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
 *
 * This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
 * a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
 * records, and manage data volume using the LIMIT keyword.
 *
 * Topics covered in this class include:
 * - Understanding the structure of a SOQL query.
 * - Crafting basic SELECT statements in SOQL.
 * - Applying filters using the WHERE clause in SOQL.
 * - Fetching related records using Relationship queries.
 * - Controlling the amount of data retrieved using the LIMIT keyword.
 *
 * Users of this class can expect to gain a solid understanding of SOQL in Apex and
 * be prepared to handle data retrieval tasks in Salesforce development.
 *
 * @author Drew Howard
 */

public with sharing class SOQL {
	/**
	 * Question 1
	 * Update/Uncomment the template code to create a method
	 * Returns all leads from Salesforce Org
	 * @return List of all leads with Id, LastName, Company, Phone, Email
	 * Update the corresponding test class and testGetAllLeads method to cover this method
	 */
	public static List<Lead> getAllLeads () {
	//  The body of the method
	List<Lead> allLeads = [SELECT Id, LastName, Company, Phone, Email FROM Lead WITH SECURITY_ENFORCED];
	return allLeads;
	}

	/**
	 * Question 2
	 * Update/Uncomment the template code to create a method
	 * Returns all contacts with first name of John.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByFirstName method to cover this method
	 */
	public static List<Contact> getContactsNamedJohn () {
	//  The body of the method
	List<Contact> contactsNamedJohn = [SELECT Id, FirstName, LastName, Name FROM Contact WHERE FirstName = 'John' WITH SECURITY_ENFORCED];
	return contactsNamedJohn;
	}

	/**
	 * Question 3
	 * Update/Uncomment the template code to create a method
	 * Returns the Contact Id for all contacts with last name of Smith or Jones
	 * @return A list of Contact Ids.
	 * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
	 */
	public static List<Id> getContactByLastName () {
	//  The body of the method
	List<Contact> contactsByLastName = [SELECT Id, FirstName, LastName FROM Contact WHERE LastName IN ('Smith', 'Jones') WITH SECURITY_ENFORCED];
	List<Id> contactIds = new List<Id>();
	for (Contact con : contactsByLastName){
		contactIds.add(con.Id);
	}
	return contactIds;
	}

	/**
	 * Question 4
	 * Update/Uncomment the template code to create a method
	 * Returns List of closed won opportunities for a specific Account.
	 * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Opportunities with important opportunities fields
	 * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
	 */
	public static List<Opportunity> opportunitiesByAccountId (String accountId) {
	//  The body of the method
		List<Opportunity> opps = [SELECT Id, Name, StageName, CloseDate, AccountId, Amount 
								FROM Opportunity 
								WHERE AccountId = :accountId
								AND StageName = 'Closed Won'
								WITH SECURITY_ENFORCED];
		return opps;
	}

	/**
	 * Question 5
	 * Update/Uncomment the template code to create a method
	 * Returns the total count of Account records.
	 * @return The Integer count of Account records.
	 * Update the corresponding test class and testGetAccountCount method to cover this method
	 */
	public static Integer numberOfAccounts () {
		AggregateResult accts = [SELECT COUNT(Id) totalAccts FROM Account WITH SECURITY_ENFORCED];
		Integer numOfAccts = (Integer) accts.get('totalAccts');
		return numOfAccts;
	}

	/**
	 * Question 6
	 * Update/Uncomment the template code to create a method
	 * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
	 * @return A map of Task Ids to Task records.
	 * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
	 */
	public static Map<Id, Task> tasksDueWithinAWeek () {
	//  The body of the method

	// Declare the map
	Map<Id, Task> taskIdToTask = new Map<Id, Task>();
	// Create variables for today and the next week
	Date today = Date.today();
	Date nextWeek = today.addDays(7);
	// Query to a list
	List<Task> upcomingTasks = [SELECT Id, Subject, Status, ActivityDate
								FROM Task
								WHERE ActivityDate >= :today AND ActivityDate <= :nextWeek
								WITH SECURITY_ENFORCED];
	// Loop through the results and add them to the map with the Id as the Key
	for (Task t : upcomingTasks) {
		taskIdToTask.put(t.Id, t);
	}
	// Return the Map
	return taskIdToTask;

	}

	/**
	 * Question 7
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Contacts that have a example.com domain in their Email.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
	 */
	public static List<Contact> getContactsByEmailDomain () {
	//  The body of the method
	List<Contact> contactsByEmail = [SELECT Id, Name, FirstName, LastName, Email
									FROM Contact
									WHERE Email LIKE '%example.com'
									WITH SECURITY_ENFORCED];

	return contactsByEmail;

	}

	/**
	 * Question 8
	 * Retrieves all Opportunities that have a specific keyword in their Name.
	 * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
	 * @param keyword The keyword to search for in the Opportunity Name.
	 * @return A list of Opportunity records.
	 */
	public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
		String keywordInputStr = '%' + keyword + '%';
		List<Opportunity> oppsByNameKeyword = [SELECT Id, Name, StageName, CloseDate, accountId 
												FROM Opportunity 
												WHERE Name LIKE : keywordInputStr
												WITH SECURITY_ENFORCED];
		return oppsByNameKeyword; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 9
	 * Retrieves all Cases that Case Origin is not Web or Email or Blank
	 * @return A list of Case records.
	 */
	public static List<Case> getFilterCaseOrigins() {
		List<Case> casesByOrigin = [SELECT Id, Status, Origin 
									FROM Case 
									WHERE Origin != 'Web' 
									AND Origin != 'Email'
									AND Origin != ''
									WITH SECURITY_ENFORCED];

		return casesByOrigin; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 10
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
	 * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
	 * @param leadSource The Lead Source to search for.
	 * @param keyword The keyword to search for in the Lead Title.
	 * @return A list of Lead records.
	 * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
	 */
	public static List<Lead> getLeadsBySourceOrTitle (String source, String title) {
	//  The body of the method
	String titleInput = '%' + title + '%';
	List<Lead> leadsBySourceOrTitle = [SELECT Id, LastName, LeadSource, Title, Email, Company, Phone
										FROM Lead
										WHERE LeadSource = :source
										OR Title LIKE :titleInput
										WITH SECURITY_ENFORCED];
		
		return leadsBySourceOrTitle;
	}

	/**
	 * Question 11
	 * Returns the names of all Contacts associated with an Account.
	 * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Contact LastName.
	 */
	public static List<String> getContactNamesByAccount(Id accountId) {
		// Create a list to hold the Contact LastNames
		List<String> contactsLastNames = new List<String>();
		// Query the Contacts
		List<Contact> contactsByAccountId = [SELECT Id, LastName, FirstName, Name, AccountId 
											FROM Contact
											WHERE AccountId = :accountId
											WITH SECURITY_ENFORCED];
		// Loop through each Contact and add the LastName to the list
		for (Contact con : contactsByAccountId){
			contactsLastNames.add(con.LastName);
		}
		// Return the list of Contact LastNames
		return contactsLastNames;
	}

	/**
	 * Question 12
	 * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
	 * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
	 * @param stage The Stage value to filter Opportunities.
	 * @return The total revenue.
	 */
	public static Decimal getTotalRevenueByStage(String stage) {
		// Use AggregateQuery to get the total revenue
		AggregateResult oppRevenue = [SELECT SUM(Amount) total 
										FROM Opportunity 
										WHERE StageName = :stage
										OR Amount > 10000
										WITH SECURITY_ENFORCED];

		Decimal totalRevenue = (Decimal) oppRevenue.get('total');
		// Return the total revenue
		return totalRevenue; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 13
	 * Retrieves the first 10 Accounts ordered by Name.
	 * @return A list of the first 10 Accounts ordered by Name.
	 */
	public static List<Account> getFirstTenAccounts() {
		List<Account> firstTenAccts = [SELECT Id, Name
										FROM Account
										WITH SECURITY_ENFORCED
										ORDER BY Name ASC
										LIMIT 10];

		return firstTenAccts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 14
	 * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 */
	public static List<Opportunity> getHighValueOpportunities() {
		List<Opportunity> highValueOpps = [SELECT Id, Name, StageName, Amount, CloseDate
											FROM Opportunity
											WHERE Amount > 100000
											WITH SECURITY_ENFORCED
											ORDER BY CloseDate
											LIMIT 5];
			return highValueOpps;
	}

	/**
	 * Question 15
	 * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
	 * @return A list of Contacts
	 */
	public static List<Contact> getBirthdateContacts() {
		Date today = Date.today();
		
		List<Contact> contactsByBirthdate = [SELECT Id, Name, FirstName, LastName, Birthdate
											FROM Contact
											WHERE Birthdate <= :today
											WITH SECURITY_ENFORCED 
											ORDER BY Birthdate DESC 
											LIMIT 3];

		return contactsByBirthdate; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 16
	 * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
	 * @return A list of Cases
	 */
	public static List<Case> getCasesWithStatus() {
		List<Case> cases = [SELECT Id, Status, Subject, CreatedDate
							FROM Case
							WHERE Status = 'Open'
							WITH SECURITY_ENFORCED
							ORDER BY CreatedDate 
							LIMIT 10
							OFFSET 5];

		return cases; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 17
	 * Returns Set of Case Ids for a specific Account.
	 * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A set of Case Ids.
	 */
	public static Set<Id> getCaseIdsByAccount(Id accountId) {
		// Create a set to hold the Case Ids
		Set<Id> caseIds = new Set<Id>();
		// Query the Cases
		List<Case> cases = [SELECT Id, AccountId
							FROM Case
							WHERE AccountId = :accountId
							WITH SECURITY_ENFORCED];
		// Loop through each Case and add the Id to the set
		for (Case c : cases) {
			caseIds.add(c.Id);
		}
		return caseIds; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 18
	 * Return Map of Account Ids to Account Names Not in a specific Country.
	 * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
	 * @param country The country to filter Accounts.
	 * @return A map of Account Ids to Account Names.
	 */
	public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
		// Create a map to hold the Account Ids to Account Names
		Map<Id, String> accountIdsToNames = new Map<Id, String>();

		// Query the Accounts
		List<Account> accts = [SELECT Id, Name
								FROM Account 
								WHERE BillingCountry != :country
								WITH SECURITY_ENFORCED];
		// Loop through each Account and add the Id and Name to the map
		for (Account acc : accts) {
			accountIdsToNames.put(acc.Id, acc.Name);
		}
		return accountIdsToNames; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 19
	 * Retrieves the Account Name for a given Contact.
	 * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
	 * @param contactId The Id of the Contact.
	 * @return The Account Name of the Contact.
	 */
	public static String getAccountNameForContact(String contactId) {
		List<Contact> contactsAccount = [SELECT Id, Name, AccountId, Account.Name 
										FROM Contact 
										WHERE Id = :contactId
										WITH SECURITY_ENFORCED
										LIMIT 1];
		
		String acctName = contactsAccount[0].Account.Name;
		return acctName; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 20
	 * Returns single Account that has related opportunities in the same query
	 * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
	 * @param accountId The ID of the Account.
	 * @return An Account record with related Opportunities.
	 */
	public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
		Map<Id, Account> accountById = new Map<Id, Account>([SELECT Id, Name, (SELECT Name, StageName, CloseDate, AccountId FROM Opportunities)FROM Account WHERE Id = :accountId WITH SECURITY_ENFORCED LIMIT 1]);

		Account singleAccount = accountById.get(accountId);

		return singleAccount; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 21
	 * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
	 * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
	 * @param Account Id
	 * @return List of contacts with the same Mailing State as the Account Billing State
	 */
	public static List<Contact> getAccountsWithContactsByState(Id accountId) {
		// Query the Account
		Account acc = [SELECT Id, Name, BillingState FROM Account WHERE Id = :accountId WITH SECURITY_ENFORCED LIMIT 1];
		// Store the Account's BillingState
		String accBillingState = '%' + acc.BillingState + '%';
		// Query the Contacts
		List<Contact> contacts = [SELECT Id, Name, FirstName, LastName, MailingState FROM Contact WHERE MailingState LIKE :accBillingState WITH SECURITY_ENFORCED];

		return contacts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 22
	 * Extracts email domains from them leads, then finds Accounts with matching website domains
	 * If Lead Email = test@test.com return account with website = www.test.com
	 * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
	 * @param A set of Lead Ids.
	 * @return A list of Accounts with matching email domains.
	 */
	public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
		// Query the Leads
		List<Lead> leads = [SELECT Id, Name, Email FROM Lead WHERE Id IN :leadIds WITH SECURITY_ENFORCED];

		// Create a set of email domains from the Leads
		Set<String> leadEmailDomains = new Set<String>();

		// Loop through each Lead
		for (Lead l : leads) {
			// Check if the email is not null
			if (l.Email != null){
				// Get the email from the Lead
				String emailDomain = 'www.' + l.Email.substringAfter('@');
				// Add the email domain to the set
				leadEmailDomains.add(emailDomain);
			}
			
		}
		// Query the Accounts
		List<Account> accts = [SELECT Id, Name, Website FROM Account WHERE Website IN :leadEmailDomains WITH SECURITY_ENFORCED];
		return accts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 23
	 * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
	 * Adds a randomized number between 1 to 3 to the quantity of each line item.
	 * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
	 * @param Original Opportunity Id
	 * @param List of cloned Opportunity Ids
	 */
	public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
		// Query the original Opportunity Line Items
		List<OpportunityLineItem> originalOLIs = [
			SELECT PricebookEntryId, Quantity, UnitPrice, OpportunityId
			FROM OpportunityLineItem
			WHERE OpportunityId = :origOppId
			WITH SECURITY_ENFORCED
		];
		// Create a list to hold the new line items
		List<OpportunityLineItem> newOLIs = new List<OpportunityLineItem>();
		
		// Loop through each cloned Opportunity Id
		for (Id cloneOppId : cloneOppIds) {
			// Loop through each original line item
			for (OpportunityLineItem oli : originalOLIs) {
				// Generate a random number between 1 and 3
				Integer randomQty = Math.round(Math.random() * 2) + 1;

				// Clone the original line item and add the random number to the quantity
				OpportunityLineItem newOli = new OpportunityLineItem();
				newOli.PricebookEntryId = oli.PricebookEntryId;
				newOli.Quantity = oli.Quantity + randomQty;
				newOli.UnitPrice = oli.UnitPrice;
				newOli.OpportunityId = cloneOppId;

				newOLIs.add(newOli);

			}
		}
		if (Schema.sObjectType.OpportunityLineItem.isCreateable()) {
			insert newOLIs;
		}
		// Insert the new line items
	}

	/**
	 * Question 24
	 * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
	 * @return A list of filtered Opportunity
	 */
	public static List<Opportunity> getOpportunityDetailsForClosedWon() {
		List<Opportunity> oppsClosedWon = [SELECT Id, Name, AccountId, Account.Name, OwnerId, Owner.Name FROM Opportunity WHERE StageName = 'Closed Won' WITH SECURITY_ENFORCED];
		return oppsClosedWon; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 25
	 * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to the Contact on the associated Account with the alphabetically first first name.
	 * Example: if there are two Contacts on the Account, "Billy" and "Abby," the 'Primary_Contact__c' will be set to "Abby."
	 */
	public static void setPrimaryContact() {
		//Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
		List<Opportunity> opps = SOQL.getOpportunityDetailsForClosedWon();
		// Create a set of Account Ids from the Opportunities
		Set<Id> accountIds = new Set<Id>();
		for (Opportunity opp : opps) {
			accountIds.add(opp.AccountId);
		}
		// Query the Contacts
		List<Contact> contacts = [SELECT Id, Name, FirstName, LastName, AccountId FROM Contact WHERE AccountId IN :accountIds WITH SECURITY_ENFORCED ORDER BY Name];
		// Loop through each Contact and add the Account Id and Contact to the map
		Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();
		for (Contact con : contacts) {
			if (!accountToContactMap.containsKey(con.AccountId)) {
				accountToContactMap.put(con.AccountId, con);
			}
		}
		// Loop through each Opportunity
		for (Opportunity opp : opps) {
			if (accountToContactMap.containsKey(opp.AccountId)) {
				// Update the Opportunity primary contact from accountToContactMap
				opp.Primary_Contact__c = accountToContactMap.get(opp.AccountId).Id;
			}
		}
		// Update the Opportunities
		if (Schema.sObjectType.Opportunity.isUpdateable()) {
			update opps;
		}
	}
}
