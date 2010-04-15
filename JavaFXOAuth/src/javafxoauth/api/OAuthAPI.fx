/*
 * OAuthAPI.fx
 *
 * Created on Apr 12, 2010, 11:09:02 AM
 */

package javafxoauth.api;

import javafx.io.http.HttpRequest;
import javafx.io.http.URLConverter;
import javafx.util.Math;
import javafx.io.http.HttpHeader;
import javafx.data.Pair;
import java.lang.System;
import java.util.Random;

import javafxoauth.api.util.IOUtils;
import javafxoauth.api.util.SignUtils;
import java.lang.IllegalArgumentException;

/**
 *
 * http://developer.yahoo.com/oauth/guide/oauth-auth-flow.html
 * http://developer.yahoo.com/oauth/guide/oauth-guide.html
 * http://apiwiki.twitter.com/OAuth-FAQ
 * http://developer.linkedin.com/docs/DOC-1008
 *
 * @author Rakesh Menon
 */

public class OAuthAPI {

    public-init protected var requestTokenURL:String;
    public-init protected var authorizeURL:String;
    public-init protected var accessTokenURL:String;

    protected var requestTokenMethod:String = HttpRequest.GET;
    protected var accessTokenMethod:String = HttpRequest.GET;
    
    public var onRequestToken : function(response:String) : Void;
    public var onAccessToken : function(response:String) : Void;

    public-init protected var realm:String;

    public-init protected var oauth_consumer_key:String;
    public-init protected var oauth_consumer_secret:String;
    public-read protected var oauth_token:String;
    public-read protected var oauth_token_secret:String;
    public-read protected var browserURL:String;

    public-read def oauth_signature_method:String = "HMAC-SHA1";
    public-read def oauth_version:String = "1.0";

    protected def urlConverter = URLConverter { };
    protected def random = new Random();

    public function requestToken() : Void {

        def oauth_nonce = "{Math.abs(random.nextLong())}";
        def oauth_timestamp = "{System.currentTimeMillis()/1000}";

        /**
         * POST&
         * https%3A%2F%2Fapi.linkedin.com%2Fuas%2Foauth%2FrequestToken&
         * oauth_consumers%252Ftaylor_singletary%252Fcallback%26
         * oauth_consumer_key%3DdTgSkaRKZjEnS1vAUu6e7-aYC00UilBTwnXHpLH7NyL2e-klzBC1a4TKCnSgClWV%26
         * oauth_nonce%3DoqwgSYFUD87MHmJJDv7bQqOF2EPnVus7Wkqj5duNByU%26
         * oauth_signature_method%3DHMAC-SHA1%26
         * oauth_timestamp%3D1259178158%26
         * oauth_version%3D1.0
         **/
        def args =
            "oauth_consumer_key={urlConverter.encodeString(oauth_consumer_key)}"
            "&oauth_nonce={oauth_nonce}"
            "&oauth_signature_method={oauth_signature_method}"
            "&oauth_timestamp={oauth_timestamp}"
            "&oauth_version={oauth_version}";

        def signatureArgs = "{requestTokenMethod}&{urlConverter.encodeString(requestTokenURL)}&"
            "{urlConverter.encodeString(args)}";
        def oauth_signature = SignUtils.createSignature(
            signatureArgs, "{oauth_consumer_secret}&");

        def signedArgs =
            "oauth_consumer_key={oauth_consumer_key}"
            "&oauth_nonce={oauth_nonce}"
            "&oauth_signature={oauth_signature}"
            "&oauth_signature_method={oauth_signature_method}"
            "&oauth_timestamp={oauth_timestamp}"
            "&oauth_version={oauth_version}";

        submitHttpRequest(requestTokenURL, requestTokenMethod, null,
            signedArgs, requestTokenCallback);
    }

    def requestTokenCallback = function(response : String) : Void {

        def args : Pair[] = decodeParameters(response);
        for(arg in args) {
            if("oauth_token".equals(arg.name)) {
                oauth_token = arg.value;
                browserURL = "{authorizeURL}?oauth_token={oauth_token}";
                println(browserURL);
            } else if("oauth_token_secret".equals(arg.name)) {
                oauth_token_secret = arg.value;
            }
        }

        onRequestToken(response);
    }

    public function accessToken(oauth_verifier : String) : Void {

        def oauth_nonce = "{Math.abs(random.nextLong())}";
        def oauth_timestamp = "{System.currentTimeMillis()/1000}";

        /**
         * POST&
         * https%3A%2F%2Fapi.linkedin.com%2Fuas%2Foauth%2FaccessToken&
         * oauth_consumer_key%3DdTgSkaRKZjEnS1vAUu6e7-aYC00UilBTwnXHpLH7NyL2e-klzBC1a4TKCnSgClWV%26
         * oauth_nonce%3Dwm2h9DH3Njoe62ezioNQS0qPfD11MH4w4paJufkk%26
         * oauth_signature_method%3DHMAC-SHA1%26
         * oauth_timestamp%3D1259178208%26
         * oauth_token%3D94ab03c4-ae2c-45e4-8732-0e6c4899db63%26
         * oauth_verifier%3D27871%26
         * oauth_version%3D1.0
         **/
        def args =
            "oauth_consumer_key={urlConverter.encodeString(oauth_consumer_key)}"
            "&oauth_nonce={oauth_nonce}"
            "&oauth_signature_method={oauth_signature_method}"
            "&oauth_timestamp={oauth_timestamp}"
            "&oauth_token={urlConverter.encodeString(oauth_token)}"
            "&oauth_verifier={urlConverter.encodeString(oauth_verifier)}"
            "&oauth_version={oauth_version}";

        def signatureArgs = "{accessTokenMethod}&{urlConverter.encodeString(accessTokenURL)}&"
            "{urlConverter.encodeString(args)}";
        def oauth_signature = SignUtils.createSignature(
            signatureArgs, "{oauth_consumer_secret}&{oauth_token_secret}");

        /**
         * OAuth
         * oauth_nonce="wm2h9DH3Njoe62ezioNQS0qPfD11MH4w4paJufkk",
         * oauth_signature_method="HMAC-SHA1",
         * oauth_timestamp="1259178208",
         * oauth_consumer_key="dTgSkaRKZjEnS1vAUu6e7-aYC00UilBTwnXHpLH7NyL2e-klzBC1a4TKCnSgClWV",
         * oauth_token="94ab03c4-ae2c-45e4-8732-0e6c4899db63",
         * oauth_verifier="27871",
         * oauth_signature="srWAOowk6Tk4irC9pEMUa7Tx%2BBc%3D",
         * oauth_version="1.0"
         **/
        def realmValue = if(realm == null) { "" } else { "realm=\"{realm}\", " };
        def authHttpHeader =
            "OAuth "
            "{realmValue}"
            "oauth_consumer_key=\"{urlConverter.encodeString(oauth_consumer_key)}\", "
            "oauth_nonce=\"{oauth_nonce}\", "
            "oauth_signature_method=\"{oauth_signature_method}\", "
            "oauth_timestamp=\"{oauth_timestamp}\", "
            "oauth_token=\"{urlConverter.encodeString(oauth_token)}\", "
            "oauth_verifier=\"{urlConverter.encodeString(oauth_verifier)}\", "
            "oauth_signature=\"{urlConverter.encodeString(oauth_signature)}\", "
            "oauth_version=\"{oauth_version}\"";

        def header = HttpHeader {
            name: HttpHeader.AUTHORIZATION value: authHttpHeader
        }

        submitHttpRequest(
            accessTokenURL, accessTokenMethod, header,
            null, accessTokenCallback);
    }

    def accessTokenCallback = function(response : String) : Void {

        def args : Pair[] = decodeParameters(response);
        for(arg in args) {
            if("oauth_token".equals(arg.name)) {
                oauth_token = arg.value;
            } else if("oauth_token_secret".equals(arg.name)) {
                oauth_token_secret = arg.value;
            }
        }
        
        onAccessToken(response);
    }

    public function decodeParameters(response:String) : Pair[] {
        urlConverter.decodeParameters(response);
    }

    public function createOAuthHeader(
        url:String, method:String) : HttpHeader {

        def oauth_nonce = "{Math.abs(random.nextLong())}";
        def oauth_timestamp = "{System.currentTimeMillis()/1000}";

        /**
         * GET&
         * https%3A%2F%2Fapi.linkedin.com%2Fv1%2Fpeople%2F~&
         * oauth_consumer_key%3DdTgSkaRKZjEnS1vAUu6e7-aYC00UilBTwnXHpLH7NyL2e-klzBC1a4TKCnSgClWV%26
         * oauth_nonce%3DLpggMEZQYFkdTmrw0OixdZLMc6DdjNWDywsIULxVRwo%26
         * oauth_signature_method%3DHMAC-SHA1%26
         * oauth_timestamp%3D1259182582%26
         * oauth_token%3Df862f658-ad89-4fcb-995b-7a4c50554ff6%26
         * oauth_version%3D1.0
         */
        def args =
            "oauth_consumer_key={urlConverter.encodeString(oauth_consumer_key)}"
            "&oauth_nonce={oauth_nonce}"
            "&oauth_signature_method={oauth_signature_method}"
            "&oauth_timestamp={oauth_timestamp}"
            "&oauth_token={urlConverter.encodeString(oauth_token)}"
            "&oauth_version={oauth_version}";

        def signatureArgs = "{method}&{urlConverter.encodeString(url)}&"
            "{urlConverter.encodeString(args)}";
        def oauth_signature = SignUtils.createSignature(
            signatureArgs, "{oauth_consumer_secret}&{oauth_token_secret}");

        /**
         * OAuth
         * oauth_nonce="LpggMEZQYFkdTmrw0OixdZLMc6DdjNWDywsIULxVRwo",
         * oauth_signature_method="HMAC-SHA1",
         * oauth_timestamp="1259182582",
         * oauth_consumer_key="dTgSkaRKZjEnS1vAUu6e7-aYC00UilBTwnXHpLH7NyL2e-klzBC1a4TKCnSgClWV",
         * oauth_token="f862f658-ad89-4fcb-995b-7a4c50554ff6",
         * oauth_signature="udXNypHc%2BbaM0FP1xRdXeyKI2%2Fo%3D",
         * oauth_version="1.0"
         **/
        def authHttpHeader =
            "OAuth "
            "realm=\"{realm}\", "
            "oauth_consumer_key=\"{urlConverter.encodeString(oauth_consumer_key)}\", "
            "oauth_nonce=\"{oauth_nonce}\", "
            "oauth_signature_method=\"{oauth_signature_method}\", "
            "oauth_timestamp=\"{oauth_timestamp}\", "
            "oauth_token=\"{urlConverter.encodeString(oauth_token)}\", "
            "oauth_signature=\"{urlConverter.encodeString(oauth_signature)}\", "
            "oauth_version=\"{oauth_version}\"";

        HttpHeader {
            name: HttpHeader.AUTHORIZATION
            value: authHttpHeader
        }
    }
}

/**
 * Handle all HttpRequest and invoke callback method with response
 */
protected function submitHttpRequest(
    url:String,
    method:String,
    headers:HttpHeader[],
    args:String,
    callback:function(String)) : Void {

    var response : String;

    def httpRequest = HttpRequest {

        location: url
        method: method
        headers: headers

        onOutput: function(output) {
            if(args != null) {
                output.write(args.getBytes());
            }
            output.close();
        }

        onInput: function(input) {
            response = IOUtils.getStreamAsString(input);
            input.close();
        }

        onError: function(input) {
            response = IOUtils.getStreamAsString(input);
            input.close();
        }

        onDone: function() {
            callback(response);
        }
    };

    httpRequest.start();
}

public function getInstance(
    serviceProvider:String,
    oauth_consumer_key:String,
    oauth_consumer_secret:String) : OAuthAPI {

    var oauthAPI : OAuthAPI;

    if("Twitter".equalsIgnoreCase(serviceProvider)) {
        oauthAPI = TwitterAPI {
            oauth_consumer_key: oauth_consumer_key
            oauth_consumer_secret: oauth_consumer_secret
        }
    } else if("LinkedIn".equalsIgnoreCase(serviceProvider)) {
        oauthAPI = LinkedInAPI {
            oauth_consumer_key: oauth_consumer_key
            oauth_consumer_secret: oauth_consumer_secret
        }
    } else if("Yahoo".equalsIgnoreCase(serviceProvider)) {
        oauthAPI = YahooAPI {
            oauth_consumer_key: oauth_consumer_key
            oauth_consumer_secret: oauth_consumer_secret
        }
    } else {
        throw new IllegalArgumentException(
            "Unsupported Service Provider - \"{serviceProvider}\"");
    }

    return oauthAPI;
}
