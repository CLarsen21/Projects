public class OppCallout {
  @InvocableMethod(
    label='Post won opportunities'
    description='posts won opportunities to httpbin'
  )
  public static void postOpportunities(List<id> OpportunityIDs) {
    System.enqueueJob(new OppCalloutQueueable(OpportunityIDs));
  }
}
