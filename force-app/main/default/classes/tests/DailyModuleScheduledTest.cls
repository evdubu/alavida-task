@isTest
public class DailyModuleScheduledTest {
	public static String CRON_EXP = '0 0 0 15 3 ? 2022';

	@testSetup
	static void setupData() {
		List<Account> patients = new List<Account>();
		patients.add(
			TestDataFactory.generateSinglePersonAccount(
				DailyModuleScheduled.SUBSTANCE_ALCOHOL
			)
		);
		patients.add(
			TestDataFactory.generateSinglePersonAccount(
				DailyModuleScheduled.SUBSTANCE_CANNABIS
			)
		);
		patients.add(
			TestDataFactory.generateSinglePersonAccount(
				DailyModuleScheduled.SUBSTANCE_COCAINE
			)
		);
		insert patients;

		List<Module__c> modules = TestDataFactory.generateModules();
		insert modules;

		// Assign some Daily Modules to patients to begin with
		List<DailyModule__c> dailyModules = new List<DailyModule__c>();
		for (Account p : patients) {
			for (Module__c m : modules) {
				if(p.Substance__c == m.Type__c || m.Type__c == DailyModuleScheduled.SUBSTANCE_ANY) {
					dailyModules.add(new DailyModule__c(
						Account__c = p.Id,
						Module__c = m.Id
					));
					break;
				}
			}
		}
		insert dailyModules;
	}

	@isTest
	static void shouldAssignDailyModuleWhereActive() {
		Test.startTest();

		String jobId = System.schedule(
			'ScheduledApexTest',
			CRON_EXP,
			new DailyModuleScheduled()
		);

		Test.stopTest();

		List<DailyModule__c> dailyModules = [
			SELECT Id, Module__r.Type__c, Account__r.Substance__c
			FROM DailyModule__c
		];

		System.assertNotEquals(0, dailyModules.size());

		for (DailyModule__c dm : dailyModules) {
			System.assert(dm.Module__r.Type__c == dm.Account__r.Substance__c || dm.Module__r.Type__c == DailyModuleScheduled.SUBSTANCE_ANY);
		}
	}
}