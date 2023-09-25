public class OppCallout {
    @InvocableMethod
    public static void postOpportunities(List<id> OpportunityIDs) {
        system.enqueueJob(new OppCalloutQueueable(OpportunityIDs));
    }
}