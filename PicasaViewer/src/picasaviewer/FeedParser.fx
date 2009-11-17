/*
 * FeedParser.fx
 *
 * Created on Nov 17, 2009, 9:56:57 AM
 */

package picasaviewer;

import javafx.io.http.HttpRequest;
import java.lang.Exception;
import java.io.InputStream;

/**
 * @author Rakesh Menon
 */

// Please update user-id ad album-id
def userId = "<user-id>";
def albumId = "<album-id>";
def url = "http://picasaweb.google.com/data/feed/api/user/{userId}/albumid/{albumId}?imgmax=912";

public class FeedParser {

    public-init var onPhotos : function(Photo[]);

    // Submit HttpRequest
    var request: HttpRequest = HttpRequest {

        location: "{url}"
        method: HttpRequest.GET

        onException: function(exception: Exception) {
            exception.printStackTrace();
        }

        onResponseCode: function(responseCode:Integer) {
            if (responseCode != 200) {
                println("failed, response: {responseCode} {request.responseMessage}");
            }
        }

        onInput: function(input: InputStream) {
            try {
                var parser = PhotoPullParser {
                    onDone: onPhotos
                };
                parser.parse(input);
            } finally {
                input.close();
            }
        }
    }

    public function start() : Void {
        request.start();
    }
}
