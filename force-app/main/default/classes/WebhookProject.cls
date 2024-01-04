@RestResource(urlMapping='/api/Webhook/issuedemo/*')
global class WebhookProject {
	@HttpPost
	global static void handlePost() {
		try {
			RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;
			//fetching the body
			Blob b8 = request.requestBody;
			System.debug(b8.toString());
			//get hash value from header
			String hashedval = request.headers.get('X-Hub-Signature-256');
			System.debug ('hashedval: '+hashedval);
			Blob hmac = Crypto.generateMac('hmacSHA256', b8, Blob.valueOf('xxxxxxxxxxxxxxx'));
			String hmacstring = 'sha256='+EncodingUtil.convertToHex(hmac);
			System.debug ('hmac: '+EncodingUtil.convertToHex(hmac));
			if (hashedval == hmacstring){
                System.debug('Secret value Matched and source can be trusted');
                JSONParser parser = JSON.createParser(request.requestBody.toString());
                string action, title, body;
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                        switch on parser.getText() {
                            when 'action' {
                                parser.nextToken();
                                action = parser.getText();
                            }
                            when 'title' {
                                parser.nextToken();
                                title = parser.getText();
                            }
                            when 'body' {
                                parser.nextToken();
                                body = parser.getText();
                            }
                        }
                    }
                    
                }
                if(action.equals('opened')) {
                    case c = new case();
                    c.subject = title;
                    c.description = body;
                    c.status = 'New';
                    c.Origin = 'Web';
                    insert c;
                }
                else if(action == 'closed') {
                    case c = [SELECT ID, status FROM case WHERE subject = :title limit 1];
                    c.Status = 'Closed';
                    update c;
                }
            }
            else{
                response.statusCode = 401;
            }
		} catch (Exception e) {
			//do some error handling
			system.debug('Exception '+e.getMessage());
		}
	}
}