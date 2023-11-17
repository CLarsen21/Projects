@isTest
private class OppCalloutTest {
    
    @isTest
    private static void postOpportunitiesTest() {
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer i = 0; i < 200; i++) {
            opps.add(new Opportunity(name = 'TestOpportunity' + i, StageName = 'Prospecting', CloseDate = system.today()));
        }
        insert opps;
        List<ID> oppids = new list<ID>();
        for(opportunity o : opps) {
            oppids.add(o.ID);
        }
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OppCalloutMock());
        for(Opportunity opp : opps) {
            opp.StageName = 'Closed Won';
        }
        update opps;
        system.enqueueJob(new OppCalloutQueueable(oppids));
        Test.stopTest();
        List<opportunity> opps2 = [SELECT ID, Name from opportunity where StageName = 'Closed Won'];
        system.assertEquals(200, opps2.size());
    }
}