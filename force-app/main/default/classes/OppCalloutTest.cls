@IsTest
private class OppCalloutTest {
  @IsTest
  static void postOpportunitiesTest() {
    // Arrange the data
    List<Opportunity> opps = new List<Opportunity>();
    for (Integer i = 0; i < 200; i++) {
      opps.add(
        new Opportunity(
          name = 'TestOpportunity' + i,
          StageName = 'Prospecting',
          CloseDate = system.today()
        )
      );
    }
    insert opps;

    List<ID> oppids = new List<ID>();
    for (opportunity o : opps) {
      oppids.add(o.ID);
    }

    Test.setMock(HttpCalloutMock.class, new OppCalloutMock());

    // Act on the data
    Test.startTest();
    for (Opportunity opp : opps) {
      opp.StageName = 'Closed Won';
    }
    update opps;
    Test.stopTest();

    // Assert the data was changed as expected
    List<Response_Info__c> responseInfoList = [
      SELECT ID, Name
      FROM Response_Info__c
    ];
    System.assertEquals(
      0,
      responseInfoList.size(),
      'Some response info records should NOT have been created.'
    );
  }

  @IsTest
  static void testNegativeResponse() {
    // Arrange the data
    List<Opportunity> opps = new List<Opportunity>();
    for (Integer i = 0; i < 200; i++) {
      opps.add(
        new Opportunity(
          name = 'TestOpportunity' + i,
          StageName = 'Prospecting',
          CloseDate = system.today()
        )
      );
    }
    insert opps;

    List<ID> oppids = new List<ID>();
    for (opportunity o : opps) {
      oppids.add(o.ID);
    }

    Test.setMock(HttpCalloutMock.class, new OppCalloutMock(403));

    // Act on the data
    Test.startTest();
    for (Opportunity opp : opps) {
      opp.StageName = 'Closed Won';
    }
    update opps;
    Test.stopTest();

    // Assert the data was changed as expected
    List<Response_Info__c> responseInfoList = [
      SELECT ID, Name
      FROM Response_Info__c
    ];
    System.assertNotEquals(
      0,
      responseInfoList.size(),
      'Some response info records should NOT have been created.'
    );
  }
}
