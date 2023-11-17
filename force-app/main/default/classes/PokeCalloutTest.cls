@isTest
private class PokeCalloutTest {
    
    @isTest
    private Static void getPokemonTest() {
        List<Account> accs = new List<Account>();
        for(integer i = 0; i < 10; i++) {
            accs.add(new Account(Name = 'TestAccount' + i));
        }
        List<ID> accids = new list<ID>();
        for (account a : accs) {
            accids.add(a.ID);
        }
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PokeCalloutMock());
        integer counter = 1;
        while(accids.size() != 0) {
            system.enqueueJob(new PokeCalloutQueueable(accids, counter));
            counter++;
            accids.remove(0);
        }
        Test.stopTest();
        List<Pokemon__c> pkmn = [Select name, Account__c from Pokemon__c];
        System.assertEquals(5, pkmn.size());
    }
}