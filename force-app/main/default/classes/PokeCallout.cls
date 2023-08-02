public with sharing class PokeCallout {
    
    public class Pokeresp {
        public integer count;
        public string next;
        public string previous;
        public list<Pokemon__c> results;
    }
    @InvocableMethod
    public static void getPokemon(List<Id> accountIDs){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon?limit=9&offset=721');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            string pokerespstring = response.getBody().replace('url', 'url__c');
            List<Pokemon__c> pokelist = new List<Pokemon__c>();
            for(Id accid : accountIDs) {
                Pokeresp p = (Pokeresp)JSON.deserializeStrict(pokerespstring, Pokeresp.class);
                for(Pokemon__c pkmn : p.results) {
                    pkmn.Account__c = accid;
                }
                pokelist.addAll(p.results);
            }
            insert pokelist;        
        }
    }
}