@isTest
public class PokeCalloutMock implements HttpCalloutMock{
    public HttpResponse respond(HttpRequest request){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"count":1292,"next":"https://pokeapi.co/api/v2/pokemon?offset=252&limit=1","previous":"https://pokeapi.co/api/v2/pokemon?offset=250&limit=1","results":[{"name":"treecko","url":"https://pokeapi.co/api/v2/pokemon/252/"}]}');
        res.setStatusCode(200);
        return res;
    }
}