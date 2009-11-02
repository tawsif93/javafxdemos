/*
 * Carousel.fx
 *
 * Created on Nov 2, 2009, 5:58:59 PM
 */

package carousel;

import carousel.model.Photo;
import carousel.parser.PhotoPullParser;
import carousel.ThumbImage;
import java.lang.Exception;
import javafx.io.http.HttpRequest;
import javafx.scene.Cursor;
import javafx.scene.CustomNode;
import javafx.scene.effect.Reflection;
import javafx.scene.Group;
import javafx.scene.Node;

def apiKey = "<Your Flickr API Key>";
def url = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key={apiKey}"
          "&sort=interestingness-desc&tags=garden&license=Attribution-NonCommercial-ShareAlike&per_page=100";

public class Carousel extends CustomNode {

    var thumbImage : ThumbImage[];
    var photos: Photo[];
    var photoIndex = 0;
    var nextIndex = 0;

    public var selectedThumbImage : ThumbImage;

    public override function create(): Node {

        cursor = Cursor.HAND;

        for(i in [0..6]) {
            insert ThumbImage {
                index: i
                carousel: this;
            } into thumbImage;
        }
        selectedThumbImage = thumbImage[3];

        return Group {
            content: thumbImage
            effect: Reflection {
                fraction: 0.5
            }
        };
    }

    public function next() {

        for(tb in thumbImage) {
            tb.next();
        }

        if(nextIndex == 7) {
            photoIndex += 7;
            updateImages();
            nextIndex = 0;
        } else {
            nextIndex++;
        }
    }

    override var onMousePressed = function(e) {
        next();
    }

    var loadComplete = false;
    public function loadImageMetadata() {

        println("Loading image metadata...");

        var httpRequestError: Boolean = false;

        // Submit HttpRequest
        var request: HttpRequest = HttpRequest {

            location: url
            method: HttpRequest.GET

            onRead: function(bytes: Long) {
                // The toread variable is non negative only if the server provides the content length
                def loadProgress = if (request.toread > 0) "{(bytes * 100 / request.toread)}%" else "";
            }

            onException: function(exception: Exception) {
                exception.printStackTrace();
                println("Error - {exception}");
                httpRequestError = true;
            }

            onResponseCode: function(responseCode:Integer) {
                if (responseCode != 200) {
                    println("failed, response: {responseCode} {request.responseMessage}");
                }
            }

            onInput: function(input: java.io.InputStream) {

                try {

                    var parser = PhotoPullParser {
                        onDone: function( data:Photo[] ) {
                            photos = data;
                            if(not httpRequestError) {
                                loadComplete = true;
                                updateImages();
                            }
                        }
                    };
                    parser.parse(input);
                    if(parser.errorMessage.length() > 0) {
                        println("Error - {parser.errorMessage}");
                        httpRequestError = true;
                    }

                } finally {
                    input.close();
                }
            }
        }

        request.start();
    }

    function updateImages() {
        var index = 0;
        for(tb in thumbImage) {
            var photo = photos[photoIndex + index];
            tb.url = "http://farm{photo.farm}.static.flickr.com/{photo.server}/{photo.id}_{photo.secret}";
            index++;
        }
    }
}
