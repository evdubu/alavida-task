global class DailyModuleScheduled implements Schedulable {
	public static final String SUBSTANCE_ALCOHOL = 'Alcohol';
	public static final String SUBSTANCE_ANY = 'Any';
	public static final String SUBSTANCE_CANNABIS = 'Cannabis';
	public static final String SUBSTANCE_COCAINE = 'Cocaine';

	global void execute(SchedulableContext sc) {
		Map<String, List<Module__c>> modules = getAllModules();
		List<Account> patients = getAllPatients();
		processDailyModuleAssignment(modules, patients);
	}

	private Map<String, List<Module__c>> getAllModules() {
		Map<String, List<Module__c>> typeToModuleMap = new Map<String, List<Module__c>>();
		List<Module__c> modules = [
			SELECT Id, Type__c, URL__c
			FROM Module__c
			ORDER BY Type__c
		];

		// Initialise the map key values based on the 'Type' picklist values on the Module object
		for (String s : getModuleTypes()) {
			typeToModuleMap.put(s, new List<Module__c>());
		}

		for (Module__c mod : modules) {
			if (typeToModuleMap.containsKey(mod.Type__c)) {
				typeToModuleMap.get(mod.Type__c).add(mod);
			}
		}

		return typeToModuleMap;
	}

	private List<Account> getAllPatients() {
		// Making the assumption that all Person Account records are Patients
		List<Account> patients = [
			SELECT Id, Substance__c, (SELECT Module__c FROM Daily_Modules__r)
			FROM Account
			WHERE IsPersonAccount = TRUE
		];

		return patients;
	}

	private void processDailyModuleAssignment(
		Map<String, List<Module__c>> modules,
		List<Account> patients
	) {
		List<DailyModule__c> dailyModules = new List<DailyModule__c>();

		for (Account p : patients) {
			Set<Id> previousModules = processPreviousModules(p.Daily_Modules__r);
			List<Module__c> newModules = modules.get(SUBSTANCE_ANY).clone();

			switch on p.Substance__c {
				when 'Alcohol' {
					newModules.addAll(modules.get(SUBSTANCE_ALCOHOL));
				}
				when 'Cocaine' {
					newModules.addAll(modules.get(SUBSTANCE_COCAINE));
				}
				when 'Cannabis' {
					newModules.addAll(modules.get(SUBSTANCE_CANNABIS));
				}
			}

			// Grab a random Module to assign and ensure it hasn't been assigned previously
			Id newModuleId;
			do {
				Integer randomIndex = Integer.valueof(
					(Math.random() * (newModules.size()))
				);
				newModuleId = newModules.get(randomIndex).Id;
			} while (previousModules.contains(newModuleId));

			dailyModules.add(
				new DailyModule__c(Account__c = p.Id, Module__c = newModuleId)
			);
		}

		try {
			insert dailyModules;
		} catch (DmlException e) {
			// Would normally output soemthing to logs here should the insert fail
			System.debug('An error occurred when inserting the record');
		}
	}

	private Set<Id> processPreviousModules(List<DailyModule__c> modules) {
		Set<Id> moduleIds = new Set<Id>();

		for (DailyModule__c dm : modules) {
			moduleIds.add(dm.Module__c);
		}

		return moduleIds;
	}

	// Get all types of Modules by extracting the picklist values from the Type__c field
	private List<String> getModuleTypes() {
		List<String> moduleTypes = new List<String>();

		Schema.DescribeFieldResult fieldResult = Module__c.Type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

		for (Schema.PicklistEntry f : ple) {
			moduleTypes.add(f.getLabel());
		}

		return moduleTypes;
	}
}
