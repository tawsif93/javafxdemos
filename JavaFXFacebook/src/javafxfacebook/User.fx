/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package javafxfacebook;
import javafx.scene.image.Image;
import javafx.io.http.HttpRequest;

/**
 * @author javafx
 */

 /**
  * {
  *    "id": "1234",
  *    "name": "User Name",
  *    "first_name": "First-Name",
  *    "last_name": "Last-Name",
  *    "link": "http://www.facebook.com/username"
  * }
  */

public class User {

    public-init protected var id: String;
    public-init protected var name: String;
    public-init protected var firstName: String;
    public-init protected var lastName: String;
    public-init protected var link: String;
    public-init protected var access_token: String;
    public-read var image : Image;
    public-read var imageURL : String;

    public-read def picture = bind 
        "https://graph.facebook.com/{id}/picture?"
        "access_token={access_token}" on replace {
        if(picture != null) { updateImageURL(); }
    }

    /**
     * Facebook redirects to a new URL, which is actual Image URL.
     * Get the redirect url from header and then assign load the Image
     */
    function updateImageURL() : Void {

        def httpRequest : HttpRequest = HttpRequest {

            location: picture

            onInput: function(input) { input.close(); }

            onError: function(input) {
                println(IOUtils.getStreamAsString(input));
                input.close();
            }

            onResponseHeaders: function(headerNames: String[]) {
                for (name in headerNames) {
                    if("location".equalsIgnoreCase(name)) {
                        imageURL = httpRequest.getResponseHeaderValue("location");
                        break;
                    }
                }
            }

            onDone: function() {
                if(imageURL != null) {
                    image = Image {
                        url: imageURL
                        backgroundLoading: true
                    }
                }
            }
        };

        httpRequest.start();
    }

    public override function toString() : String {
        "\{"
        "    id: \"{id}\","
        "    name: \"{name}\","
        "    first_name: \"{firstName}\","
        "    last_name: \"{lastName}\","
        "    link: \"{link}\","
        "    picture: \"{picture}\""
        "\}"
    }
}
