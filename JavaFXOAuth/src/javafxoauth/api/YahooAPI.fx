/*
 * YahooAPI.fx
 *
 * Created on Apr 14, 2010, 12:23:16 PM
 */

package javafxoauth.api;

import javafx.io.http.HttpRequest;

/**
 * http://developer.yahoo.com/oauth/guide/oauth-auth-flow.html
 * http://developer.yahoo.com/oauth/guide/oauth-guide.html
 * http://developer.yahoo.com/oauth/
 *
 * @author Rakesh Menon
 */

public class YahooAPI extends OAuthAPI {

    init {

        requestTokenURL = "https://api.login.yahoo.com/oauth/v2/get_request_token";
        authorizeURL = "https://api.login.yahoo.com/oauth/v2/request_auth";
        accessTokenURL = "https://api.login.yahoo.com/oauth/v2/get_token";

        requestTokenMethod = HttpRequest.POST;
        accessTokenMethod = HttpRequest.POST;

        realm = null;
    }
}
