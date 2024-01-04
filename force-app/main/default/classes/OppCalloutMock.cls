@isTest
public class OppCalloutMock implements HttpCalloutMock {
  private Integer statusCode = 200;

  public OppCalloutMock() {
  }

  public OppCalloutMock(Integer statusCode) {
    this.statusCode = statusCode;
  }
  public HttpResponse respond(HttpRequest request) {
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody('');
    res.setStatusCode(this.statusCode);
    return res;
  }
}
