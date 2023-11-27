public class PokeCallout {
  @InvocableMethod(
    label='Get Pokemon'
    description='Gets a list of Pokemon from the PokeAPI'
  )
  public static void getPokemon(List<ID> accountIDs) {
    System.enqueueJob(new PokeCalloutQueueable(accountIDs, 1));
  }
}
