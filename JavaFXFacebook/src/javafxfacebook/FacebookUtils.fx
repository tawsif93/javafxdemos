/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package javafxfacebook;
import javafx.io.http.HttpRequest;
import javafx.data.pull.PullParser;
import javafx.data.Pair;

/**
 * @author Rakesh Menon
 */

public class FacebookUtils {

    public-init var client_id : String;
    public-init var access_token : String;

    public function getAuthorizeURL() : String {

        "https://graph.facebook.com/oauth/authorize?"
        "client_id={client_id}&"
        "redirect_uri=http://javafxdemos.googlecode.com/hg/resource/JavaFXFacebook/JavaFXFacebook.html&"
        "type=user_agent&"
        "display=popup";
    }

    /**
     * {
     *    "id": "1234",
     *    "name": "User Name",
     *    "first_name": "First-Name",
     *    "last_name": "Last-Name",
     *    "link": "http://www.facebook.com/username",
     * }
     */
    public function getUserInfo(id : String, onUserInfo:function(User)) {

        var user : User;

        def httpRequest = HttpRequest {

            location: "https://graph.facebook.com/{id}?access_token={access_token}"

            onInput: function(input) {

                def parser = PullParser {
                    input: input
                    documentType: PullParser.JSON
                };

                user = User {
                    id: "{parser.seek("id").forward().event.text}"
                    name: "{parser.seek("name").forward().event.text}"
                    firstName: "{parser.seek("first_name").forward().event.text}"
                    lastName: "{parser.seek("last_name").forward().event.text}"
                    link: "{parser.seek("link").forward().event.text}"
                    access_token: access_token
                }
                
                input.close();
            }
            
            onError: function(input) {
                println(IOUtils.getStreamAsString(input));
                input.close();
            }

            onDone: function() {
                onUserInfo(user);
            }
        };

        httpRequest.start();
    }
    
    /**
     * {
     *    "data": [
     *       {
     *          "name": "Friend A",
     *          "id": "123456"
     *       },
     *       {
     *          "name": "Friend A",
     *          "id": "123456"
     *       }
     *    ]
     * }
     */
    public function getMyFriends(onFriendInfo:function(User)) {

        def httpRequest = HttpRequest {

            location: "http://graph.facebook.com/me/friends?access_token={access_token}"

            onInput: function(input) {

                //println(IOUtils.getStreamAsString(input));

                def parser = PullParser {

                    input: input
                    documentType: PullParser.JSON

                    onEvent: function(event) {
                        if(event.type == PullParser.END_VALUE) {
                            if (event.name == "id") {
                                getUserInfo("{event.text}", onFriendInfo);
                            }
                        }
                    }
                };
                parser.parse();

                input.close();
            }

            onError: function(input) {
                println(IOUtils.getStreamAsString(input));
                input.close();
            }

            onDone: function() {

            }
        };

        httpRequest.start();
    }
}
