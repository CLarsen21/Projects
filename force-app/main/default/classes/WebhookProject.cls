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
            IssueWbhk__c mc = IssueWbhk__c.getOrgDefaults();
			Blob hmac = Crypto.generateMac('hmacSHA256', b8, Blob.valueOf(mc.key__c));
			String hmacstring = 'sha256='+EncodingUtil.convertToHex(hmac);
			System.debug ('hmac: '+EncodingUtil.convertToHex(hmac));
			if (hashedval == hmacstring){
                System.debug('Secret value Matched and source can be trusted');
                WebhookParser wp = WebhookParser.parse(request.requestBody.toString());
                string action = wp.action;
                string title = wp.issue.title;
                string body = wp.issue.body;
                integer gid = wp.issue.id;
                if(action.equals('opened')) {
                    case c = new case();
                    c.subject = title;
                    c.description = body;
                    c.status = 'New';
                    c.Origin = 'Web';
                    c.git_issue_id__c = gid;
                    insert c;
                }
                else if(action.equals('closed')) {
                    case c = [SELECT ID, status, git_issue_id__c FROM case WHERE subject = :title AND git_issue_id__c = :gid limit 1];
                    c.status = 'Closed';
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