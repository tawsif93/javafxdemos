/*
 * LinkedInAPI.fx
 *
 * Created on Apr 14, 2010, 11:10:37 AM
 */

package javafxoauth.api;

import javafx.io.http.HttpHeader;
import javafx.io.http.HttpRequest;


/**
 * http://developer.linkedin.com/docs/DOC-1008
 *
 * @author Rakesh Menon
 */

public class LinkedInAPI extends OAuthAPI {

    init {

        requestTokenURL = "https://api.linkedin.com/uas/oauth/requestToken";
        authorizeURL = "https://api.linkedin.com/uas/oauth/authorize";
        accessTokenURL = "https://api.linkedin.com/uas/oauth/accessToken";

        requestTokenMethod = HttpRequest.POST;
        accessTokenMethod = HttpRequest.POST;

        realm = "http://api.linkedin.com";
    }
    
    public function getBasicMemberProfile(
        callback : function(response:String):Void) : Void {

        def url = "https://api.linkedin.com/v1/people/~";
        def method = HttpRequest.GET;

        def authHttpHeader = createOAuthHeader(url, method);

        def headers = [
            authHttpHeader,
            HttpHeader {
                name: HttpHeader.CONTENT_TYPE value: "text/xml"
            }
        ];

        submitHttpRequest(url, method, headers, null, callback);
    }
}
