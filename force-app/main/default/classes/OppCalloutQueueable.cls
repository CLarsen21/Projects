public class OppCalloutQueueable implements Queueable, Database.AllowsCallouts {
    
    private List<ID> oppIDs;
    
    public OppCalloutQueueable(List<ID> oppIds) {
        this.oppIDs = oppIds;
    }
    
	public void execute(QueueableContext context) {
        List<Opportunity> OppsToSerialize = [SELECT Account.Name, Amount, CloseDate FROM Opportunity WHERE Id in :OppIds];
        String Opps = json.serialize(oppsToSerialize);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:httpbin/post');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody(Opps);
        HttpResponse response = http.send(request);
    }
}