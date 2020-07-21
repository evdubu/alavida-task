@isTest
public class TestDataFactory {
	// Genarates a single Person Account record
	public static Account generateSinglePersonAccount(String substance) {
		Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();
		Account acc = new Account(
			FirstName = generateRandomString(5),
			LastName = generateRandomString(8),
			Substance__c = substance,
			RecordTypeId = rectypeId
		);

		return acc;
	}

	// Generates some sample Modules for test data
	public static List<Module__c> generateModules() {
		List<Module__c> mods = new List<Module__c>();
		List<String> moduleTypes = new List<String>{
			DailyModuleScheduled.SUBSTANCE_ANY,
			DailyModuleScheduled.SUBSTANCE_ALCOHOL,
			DailyModuleScheduled.SUBSTANCE_CANNABIS,
			DailyModuleScheduled.SUBSTANCE_COCAINE
		};

		for (String s : moduleTypes) {
			for (Integer i = 0; i < 10; i++) {
				mods.add(new Module__c(URL__c = generateRandomString(30), Type__c = s));
			}
		}

		return mods;
	}

	public static String generateRandomString(Integer len) {
		final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
		String randStr = '';
		while (randStr.length() < len) {
			Integer idx = Math.mod(
				Math.abs(Crypto.getRandomInteger()),
				chars.length()
			);
			randStr += chars.substring(idx, idx + 1);
		}
		return randStr;
	}
}
