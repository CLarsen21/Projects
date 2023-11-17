@isTest
private class ConvertLeadsTest {
	
    @isTest
    private static void LeadAssignTest() {
        List<Lead> leads = new List<Lead>();
        for(Integer i = 0; i < 200; i++) {
            leads.add(New Lead(FirstName = 'Test', LastName = 'Lead' + i, Company = 'TestCompany' + i));
            if(i < 100) {
                leads[i].Create_Opportunity_upon_Conversion__c = true;
            }
            else {
                leads[i].Create_Opportunity_upon_Conversion__c = false;
            }
        }
        insert leads;
        
        Test.startTest();
        for(lead l : leads) {
            l.Convert__c = true;
        }
        update leads;
        Test.stopTest();
        
        List<Account> accs = [Select ID, Name from Account];
        System.assertEquals(200, accs.size());
        List<Contact> conts = [Select ID, Name from Contact];
        System.assertEquals(200, conts.size());
        List<Opportunity> opps = [Select ID, Name from Opportunity];
        System.assertEquals(100, opps.size());
    }
}