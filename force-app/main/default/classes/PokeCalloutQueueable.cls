public class PokeCalloutQueueable implements Queueable, Database.AllowsCallouts {
  private static final Integer UPPER_LIMIT = 5;

  private Integer counter = 0;
  private List<ID> accIDs;

  public PokeCalloutQueueable(List<ID> accIds, Integer counter) {
    this.accIDs = accIds;
    this.counter = counter;
  }

  public class Pokeresp {
    public Integer count;
    public String next;
    public String previous;
    public List<Pokemon__c> results;
  }

  public void execute(QueueableContext context) {
    if (counter > UPPER_LIMIT) {
      System.debug('>>> We\'ve hit our upper limit, ending now.');
      return;
    }

    // 1. Pull the first account off the list of accounts to work with
    // GET THE ID OF THE ACCOUNT AND ALSO REMOVE IT FROM THE LIST SO WE DON'T REPEAT ACCOUNTS
    // ->
    ID Accid = accIds[0];
	accIds.remove(0);
    // 2. For this account, make a callout to the PokeAPI
    // 3. Parse the response and create a list of Pokemon__c records
    // 4. Associate those records with the current Account
    // 5. Insert the list of Pokemon__c records
    // 6. Check if there are any other Accounts in the list of AccountIds to work with
    //      - If there are NO more accounts, your code can return and end
    //      - If there are more accounts to work with, re-enqueue this job with the remaining accounts

    Http http = new Http();
    HttpRequest request = new HttpRequest();

    // TODO: Change this out for a Named Credential
    request.setEndpoint('callout:pokemon/pokemon?limit=9&offset=721');
    request.setMethod('GET');
    HttpResponse response = http.send(request);
    // If the request is successful, parse the JSON response.
      if (response.getStatusCode() == 200) {
          string pokerespstring = response.getBody().replace('url', 'url__c');
          List<Pokemon__c> pokelist = new List<Pokemon__c>();
          Pokeresp p = (Pokeresp) JSON.deserializeStrict(
              pokerespstring,
              Pokeresp.class
          );
          for (Pokemon__c pkmn : p.results) {
              pkmn.Account__c = accid;
          }
          pokelist.addAll(p.results);
          insert pokelist;
      }
	
    this.handleNextPage();
  }

    void handleNextPage() {
        if (this.accIDs.isEmpty()) {
            System.debug('>>> No more accounts to work with, we\'re done!');
            return;
        }
        
        Integer newCounter = this.counter + 1;
        if (!Test.isRunningTest()) {
            System.debug('>>> Enqueuing next job with remaining accounts');
            System.enqueueJob(new PokeCalloutQueueable(this.accIDs, newCounter));
        } 
    }
}