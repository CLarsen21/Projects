public with sharing class OppCallout {
    @InvocableMethod
    public static void postOpportunities(List<id> OppIds) {
        List<Opportunity> OppsToSerialize = [SELECT Account.Name, Amount, CloseDate FROM Opportunity WHERE Id in :OppIds];
        String Opps = json.serialize(oppsToSerialize);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://httpbin.org/post');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody(Opps);
        HttpResponse response = http.send(request);
    }
}