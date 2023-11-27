@IsTest
private class PokeCalloutTest {
  @IsTest
  static void getPokemonTest() {
    // Arrange the data
    Account a = new Account(Name = 'TestAccount' + i);
    insert a;
    List<ID> accIds = new List<ID>{ a.Id };

    Test.setMock(HttpCalloutMock.class, new PokeCalloutMock());

    // Act on the data
    Test.startTest();
    PokeCallout.getPokemon(accIds);
    Test.stopTest();

    // Assert the data was changed as expected
    List<Pokemon__c> pkmn = [SELECT name, Account__c FROM Pokemon__c];
    System.assertEquals(1, pkmn.size());
  }
}
