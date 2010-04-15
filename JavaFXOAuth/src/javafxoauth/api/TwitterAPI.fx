/*
 * TwitterAPI.fx
 *
 * Created on Apr 14, 2010, 12:23:16 PM
 */

package javafxoauth.api;

import javafx.io.http.HttpRequest;

/**
 * http://apiwiki.twitter.com/OAuth-FAQ
 *
 * @author Rakesh Menon
 */

public class TwitterAPI extends OAuthAPI {

    init {

        requestTokenURL = "http://twitter.com/oauth/request_token";
        authorizeURL = "http://twitter.com/oauth/authorize";
        accessTokenURL = "http://twitter.com/oauth/access_token";

        requestTokenMethod = HttpRequest.POST;
        accessTokenMethod = HttpRequest.GET;

        realm = null;
    }
}
