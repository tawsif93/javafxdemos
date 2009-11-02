/*
 * PhotoPullParser.fx
 *
 * Created on Nov 2, 2009, 6:00:54 PM
 */

package carousel.parser;

import java.io.InputStream;
import javafx.data.pull.Event;
import javafx.data.pull.PullParser;
import javafx.data.xml.QName;
import carousel.model.Photo;

public class PhotoPullParser {

    // Error Message (if any)
    public var errorMessage = "";

    // Information about all interesting photos
    var photos: Photo[];

    // Completion callback that also delivers parsed photo metadata
    public var onDone: function(data : Photo[]) = null;

    public function parse(input: InputStream) {

        // Parse the input data (Photo Metadata) and construct Photo instance
        def parser = PullParser {

            input: input

            onEvent: function(event: Event) {
                if (event.type == PullParser.START_ELEMENT) {
                    if(event.qname.name == "photo" and event.level == 2) {
                        def photo = Photo {
                            id:     event.getAttributeValue(QName{name:"id"}) as String;
                            owner:  event.getAttributeValue(QName{name:"owner"}) as String;
                            secret: event.getAttributeValue(QName{name:"secret"}) as String;
                            server: event.getAttributeValue(QName{name:"server"}) as String;
                            farm:   event.getAttributeValue(QName{name:"farm"}) as String;
                            title:  event.getAttributeValue(QName{name:"title"}) as String;
                        }
                        insert photo into photos;
                    } else if(event.qname.name == "err" and event.level == 1) {
                        errorMessage = event.getAttributeValue(QName{name:"msg"});
                    }
                } else if (event.type == PullParser.END_DOCUMENT) {
                    if (onDone != null) { onDone(photos); }
                }
            }
        }

        parser.parse();
    }
}
