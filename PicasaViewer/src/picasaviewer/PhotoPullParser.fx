/*
 * PhotoPullParser.fx
 *
 * Created on Nov 17, 2009, 10:03:30 AM
 */

package picasaviewer;

/**
 * @author Rakesh Menon
 */

import java.io.InputStream;
import javafx.data.pull.Event;
import javafx.data.pull.PullParser;
import javafx.data.xml.QName;

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

                if (event.type == PullParser.START_ELEMENT and event.level == 3) {

                    if(event.qname.name == "content") {

                        def photo = Photo {
                            medium: event.getAttributeValue(QName{name:"medium"}) as String;
                            type:   event.getAttributeValue(QName{name:"type"}) as String;
                            width:  event.getAttributeValue(QName{name:"width"}) as String;
                            height: event.getAttributeValue(QName{name:"height"}) as String;
                            url:    event.getAttributeValue(QName{name:"url"}) as String;
                            title:  event.getAttributeValue(QName{name:"title"}) as String;
                        }
                        insert photo into photos;

                    }

                } else if (event.type == PullParser.END_DOCUMENT) {
                    if (onDone != null) { onDone(photos); }
                }
            }
        }

        parser.parse();
    }
}
