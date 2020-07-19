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
