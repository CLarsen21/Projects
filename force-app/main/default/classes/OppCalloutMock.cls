@isTest
public class OppCalloutMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('');
        res.setStatusCode(200);
        return res;
    }
}