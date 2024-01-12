@isTest
public class WebhookProjectTest {
    @isTest(SeeAllData=true)
    public static void handlePostTestOpen() {
        String testreq = getRequest('opened');
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/api/Webhook/issuedemo/';
        req.requestBody = Blob.valueOf(testreq);
        IssueWbhk__c mc = IssueWbhk__c.getOrgDefaults();
        Blob hmac = Crypto.generateMac('hmacSHA256', Blob.valueOf(testreq), Blob.valueOf(mc.key__c));
		String hmacstring = 'sha256='+EncodingUtil.convertToHex(hmac);
        RestContext.request = req;
        req.headers.put('X-Hub-Signature-256', hmacstring);
        RestContext.response = res;
        Datetime cd = datetime.now();
        
        test.startTest();
        WebhookProject.HandlePost();
        test.stopTest();
        
        Case c = [SELECT ID, Subject, CreatedDate FROM Case WHERE subject = :'Test Case' AND git_issue_id__c = :2070802854 AND CreatedDate >= :cd];
        System.assertEquals(c.subject, 'Test Case');
    }
    
    @isTest(SeeAllData=true)
    public static void handlePostTestClose() {
        String testreq = getRequest('closed');
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/api/Webhook/issuedemo/';
        req.requestBody = Blob.valueOf(testreq);
        IssueWbhk__c mc = IssueWbhk__c.getOrgDefaults();
        Blob hmac = Crypto.generateMac('hmacSHA256', Blob.valueOf(testreq), Blob.valueOf(mc.key__c));
		String hmacstring = 'sha256='+EncodingUtil.convertToHex(hmac);
        RestContext.request = req;
        req.headers.put('X-Hub-Signature-256', hmacstring);
        RestContext.response = res;
        Datetime cd = datetime.now();
        Case c1 = New Case(subject = 'Test Case', status = 'New', origin = 'Web', git_issue_id__c = 2070802854);
        insert c1;
        
        test.startTest();
        WebhookProject.HandlePost();
        test.stopTest();
        
        Case c2 = [SELECT ID, Subject, CreatedDate, Status FROM Case WHERE subject = :'Test Case' AND CreatedDate >= :cd AND status = :'Closed' AND git_issue_id__c = :2070802854];
        System.assertEquals(c2.subject, 'Test Case');
        System.assertEquals(c2.status, 'Closed');
    }
    
    public static string getRequest(String act) {
        return '{'+
		'  \"action\": \"'+act+'\",'+
		'  \"issue\": {'+
		'    \"url\": \"https://api.github.com/repos/CLarsen21/Projects/issues/11\",'+
		'    \"repository_url\": \"https://api.github.com/repos/CLarsen21/Projects\",'+
		'    \"labels_url\": \"https://api.github.com/repos/CLarsen21/Projects/issues/11/labels{/name}\",'+
		'    \"comments_url\": \"https://api.github.com/repos/CLarsen21/Projects/issues/11/comments\",'+
		'    \"events_url\": \"https://api.github.com/repos/CLarsen21/Projects/issues/11/events\",'+
		'    \"html_url\": \"https://github.com/CLarsen21/Projects/issues/11\",'+
		'    \"id\": 2070802854,'+
		'    \"node_id\": \"I_kwDOJtfKI857bfGm\",'+
		'    \"number\": 11,'+
		'    \"title\": \"Test Case\",'+
		'    \"user\": {'+
		'      \"login\": \"CLarsen21\",'+
		'      \"id\": 131187408,'+
		'      \"node_id\": \"U_kgDOB9HC0A\",'+
		'      \"avatar_url\": \"https://avatars.githubusercontent.com/u/131187408?v=4\",'+
		'      \"gravatar_id\": \"\",'+
		'      \"url\": \"https://api.github.com/users/CLarsen21\",'+
		'      \"html_url\": \"https://github.com/CLarsen21\",'+
		'      \"followers_url\": \"https://api.github.com/users/CLarsen21/followers\",'+
		'      \"following_url\": \"https://api.github.com/users/CLarsen21/following{/other_user}\",'+
		'      \"gists_url\": \"https://api.github.com/users/CLarsen21/gists{/gist_id}\",'+
		'      \"starred_url\": \"https://api.github.com/users/CLarsen21/starred{/owner}{/repo}\",'+
		'      \"subscriptions_url\": \"https://api.github.com/users/CLarsen21/subscriptions\",'+
		'      \"organizations_url\": \"https://api.github.com/users/CLarsen21/orgs\",'+
		'      \"repos_url\": \"https://api.github.com/users/CLarsen21/repos\",'+
		'      \"events_url\": \"https://api.github.com/users/CLarsen21/events{/privacy}\",'+
		'      \"received_events_url\": \"https://api.github.com/users/CLarsen21/received_events\",'+
		'      \"type\": \"User\",'+
		'      \"site_admin\": false'+
		'    },'+
		'    \"labels\": ['+
		''+
		'    ],'+
		'    \"state\": \"open\",'+
		'    \"locked\": false,'+
		'    \"assignee\": null,'+
		'    \"assignees\": ['+
		''+
		'    ],'+
		'    \"milestone\": null,'+
		'    \"comments\": 0,'+
		'    \"created_at\": \"2024-01-08T16:22:06Z\",'+
		'    \"updated_at\": \"2024-01-08T16:22:06Z\",'+
		'    \"closed_at\": null,'+
		'    \"author_association\": \"OWNER\",'+
		'    \"active_lock_reason\": null,'+
		'    \"body\": \"Description for Test Issue 9\",'+
		'    \"reactions\": {'+
		'      \"url\": \"https://api.github.com/repos/CLarsen21/Projects/issues/11/reactions\",'+
		'      \"total_count\": 0,'+
		'      \"+1\": 0,'+
		'      \"-1\": 0,'+
		'      \"laugh\": 0,'+
		'      \"hooray\": 0,'+
		'      \"confused\": 0,'+
		'      \"heart\": 0,'+
		'      \"rocket\": 0,'+
		'      \"eyes\": 0'+
		'    },'+
		'    \"timeline_url\": \"https://api.github.com/repos/CLarsen21/Projects/issues/11/timeline\",'+
		'    \"performed_via_github_app\": null,'+
		'    \"state_reason\": null'+
		'  },'+
		'  \"repository\": {'+
		'    \"id\": 651676195,'+
		'    \"node_id\": \"R_kgDOJtfKIw\",'+
		'    \"name\": \"Projects\",'+
		'    \"full_name\": \"CLarsen21/Projects\",'+
		'    \"private\": false,'+
		'    \"owner\": {'+
		'      \"login\": \"CLarsen21\",'+
		'      \"id\": 131187408,'+
		'      \"node_id\": \"U_kgDOB9HC0A\",'+
		'      \"avatar_url\": \"https://avatars.githubusercontent.com/u/131187408?v=4\",'+
		'      \"gravatar_id\": \"\",'+
		'      \"url\": \"https://api.github.com/users/CLarsen21\",'+
		'      \"html_url\": \"https://github.com/CLarsen21\",'+
		'      \"followers_url\": \"https://api.github.com/users/CLarsen21/followers\",'+
		'      \"following_url\": \"https://api.github.com/users/CLarsen21/following{/other_user}\",'+
		'      \"gists_url\": \"https://api.github.com/users/CLarsen21/gists{/gist_id}\",'+
		'      \"starred_url\": \"https://api.github.com/users/CLarsen21/starred{/owner}{/repo}\",'+
		'      \"subscriptions_url\": \"https://api.github.com/users/CLarsen21/subscriptions\",'+
		'      \"organizations_url\": \"https://api.github.com/users/CLarsen21/orgs\",'+
		'      \"repos_url\": \"https://api.github.com/users/CLarsen21/repos\",'+
		'      \"events_url\": \"https://api.github.com/users/CLarsen21/events{/privacy}\",'+
		'      \"received_events_url\": \"https://api.github.com/users/CLarsen21/received_events\",'+
		'      \"type\": \"User\",'+
		'      \"site_admin\": false'+
		'    },'+
		'    \"html_url\": \"https://github.com/CLarsen21/Projects\",'+
		'    \"description\": null,'+
		'    \"fork\": false,'+
		'    \"url\": \"https://api.github.com/repos/CLarsen21/Projects\",'+
		'    \"forks_url\": \"https://api.github.com/repos/CLarsen21/Projects/forks\",'+
		'    \"keys_url\": \"https://api.github.com/repos/CLarsen21/Projects/keys{/key_id}\",'+
		'    \"collaborators_url\": \"https://api.github.com/repos/CLarsen21/Projects/collaborators{/collaborator}\",'+
		'    \"teams_url\": \"https://api.github.com/repos/CLarsen21/Projects/teams\",'+
		'    \"hooks_url\": \"https://api.github.com/repos/CLarsen21/Projects/hooks\",'+
		'    \"issue_events_url\": \"https://api.github.com/repos/CLarsen21/Projects/issues/events{/number}\",'+
		'    \"events_url\": \"https://api.github.com/repos/CLarsen21/Projects/events\",'+
		'    \"assignees_url\": \"https://api.github.com/repos/CLarsen21/Projects/assignees{/user}\",'+
		'    \"branches_url\": \"https://api.github.com/repos/CLarsen21/Projects/branches{/branch}\",'+
		'    \"tags_url\": \"https://api.github.com/repos/CLarsen21/Projects/tags\",'+
		'    \"blobs_url\": \"https://api.github.com/repos/CLarsen21/Projects/git/blobs{/sha}\",'+
		'    \"git_tags_url\": \"https://api.github.com/repos/CLarsen21/Projects/git/tags{/sha}\",'+
		'    \"git_refs_url\": \"https://api.github.com/repos/CLarsen21/Projects/git/refs{/sha}\",'+
		'    \"trees_url\": \"https://api.github.com/repos/CLarsen21/Projects/git/trees{/sha}\",'+
		'    \"statuses_url\": \"https://api.github.com/repos/CLarsen21/Projects/statuses/{sha}\",'+
		'    \"languages_url\": \"https://api.github.com/repos/CLarsen21/Projects/languages\",'+
		'    \"stargazers_url\": \"https://api.github.com/repos/CLarsen21/Projects/stargazers\",'+
		'    \"contributors_url\": \"https://api.github.com/repos/CLarsen21/Projects/contributors\",'+
		'    \"subscribers_url\": \"https://api.github.com/repos/CLarsen21/Projects/subscribers\",'+
		'    \"subscription_url\": \"https://api.github.com/repos/CLarsen21/Projects/subscription\",'+
		'    \"commits_url\": \"https://api.github.com/repos/CLarsen21/Projects/commits{/sha}\",'+
		'    \"git_commits_url\": \"https://api.github.com/repos/CLarsen21/Projects/git/commits{/sha}\",'+
		'    \"comments_url\": \"https://api.github.com/repos/CLarsen21/Projects/comments{/number}\",'+
		'    \"issue_comment_url\": \"https://api.github.com/repos/CLarsen21/Projects/issues/comments{/number}\",'+
		'    \"contents_url\": \"https://api.github.com/repos/CLarsen21/Projects/contents/{+path}\",'+
		'    \"compare_url\": \"https://api.github.com/repos/CLarsen21/Projects/compare/{base}...{head}\",'+
		'    \"merges_url\": \"https://api.github.com/repos/CLarsen21/Projects/merges\",'+
		'    \"archive_url\": \"https://api.github.com/repos/CLarsen21/Projects/{archive_format}{/ref}\",'+
		'    \"downloads_url\": \"https://api.github.com/repos/CLarsen21/Projects/downloads\",'+
		'    \"issues_url\": \"https://api.github.com/repos/CLarsen21/Projects/issues{/number}\",'+
		'    \"pulls_url\": \"https://api.github.com/repos/CLarsen21/Projects/pulls{/number}\",'+
		'    \"milestones_url\": \"https://api.github.com/repos/CLarsen21/Projects/milestones{/number}\",'+
		'    \"notifications_url\": \"https://api.github.com/repos/CLarsen21/Projects/notifications{?since,all,participating}\",'+
		'    \"labels_url\": \"https://api.github.com/repos/CLarsen21/Projects/labels{/name}\",'+
		'    \"releases_url\": \"https://api.github.com/repos/CLarsen21/Projects/releases{/id}\",'+
		'    \"deployments_url\": \"https://api.github.com/repos/CLarsen21/Projects/deployments\",'+
		'    \"created_at\": \"2023-06-09T19:40:43Z\",'+
		'    \"updated_at\": \"2023-07-31T20:13:44Z\",'+
		'    \"pushed_at\": \"2024-01-04T20:30:42Z\",'+
		'    \"git_url\": \"git://github.com/CLarsen21/Projects.git\",'+
		'    \"ssh_url\": \"git@github.com:CLarsen21/Projects.git\",'+
		'    \"clone_url\": \"https://github.com/CLarsen21/Projects.git\",'+
		'    \"svn_url\": \"https://github.com/CLarsen21/Projects\",'+
		'    \"homepage\": null,'+
		'    \"size\": 206,'+
		'    \"stargazers_count\": 0,'+
		'    \"watchers_count\": 0,'+
		'    \"language\": \"Apex\",'+
		'    \"has_issues\": true,'+
		'    \"has_projects\": true,'+
		'    \"has_downloads\": true,'+
		'    \"has_wiki\": false,'+
		'    \"has_pages\": false,'+
		'    \"has_discussions\": false,'+
		'    \"forks_count\": 0,'+
		'    \"mirror_url\": null,'+
		'    \"archived\": false,'+
		'    \"disabled\": false,'+
		'    \"open_issues_count\": 4,'+
		'    \"license\": null,'+
		'    \"allow_forking\": true,'+
		'    \"is_template\": false,'+
		'    \"web_commit_signoff_required\": false,'+
		'    \"topics\": ['+
		''+
		'    ],'+
		'    \"visibility\": \"public\",'+
		'    \"forks\": 0,'+
		'    \"open_issues\": 4,'+
		'    \"watchers\": 0,'+
		'    \"default_branch\": \"main\"'+
		'  },'+
		'  \"sender\": {'+
		'    \"login\": \"CLarsen21\",'+
		'    \"id\": 131187408,'+
		'    \"node_id\": \"U_kgDOB9HC0A\",'+
		'    \"avatar_url\": \"https://avatars.githubusercontent.com/u/131187408?v=4\",'+
		'    \"gravatar_id\": \"\",'+
		'    \"url\": \"https://api.github.com/users/CLarsen21\",'+
		'    \"html_url\": \"https://github.com/CLarsen21\",'+
		'    \"followers_url\": \"https://api.github.com/users/CLarsen21/followers\",'+
		'    \"following_url\": \"https://api.github.com/users/CLarsen21/following{/other_user}\",'+
		'    \"gists_url\": \"https://api.github.com/users/CLarsen21/gists{/gist_id}\",'+
		'    \"starred_url\": \"https://api.github.com/users/CLarsen21/starred{/owner}{/repo}\",'+
		'    \"subscriptions_url\": \"https://api.github.com/users/CLarsen21/subscriptions\",'+
		'    \"organizations_url\": \"https://api.github.com/users/CLarsen21/orgs\",'+
		'    \"repos_url\": \"https://api.github.com/users/CLarsen21/repos\",'+
		'    \"events_url\": \"https://api.github.com/users/CLarsen21/events{/privacy}\",'+
		'    \"received_events_url\": \"https://api.github.com/users/CLarsen21/received_events\",'+
		'    \"type\": \"User\",'+
		'    \"site_admin\": false'+
		'  }'+
		'}';
    }
}