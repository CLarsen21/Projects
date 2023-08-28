public class PokeCallout {

    @InvocableMethod
    public static void getPokemon(List<Id> accountIDs){
        system.enqueueJob(new PokeCalloutQueueable(accountIDs));
    }
}