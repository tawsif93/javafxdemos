/*
 * Carousel.fx
 *
 * Created on Dec 30, 2009, 9:19:08 AM
 */

package imageviewer;

/**
 * @author Rakesh Menon
 */

import javafx.scene.Cursor;
import javafx.scene.CustomNode;
import javafx.scene.effect.Reflection;
import javafx.scene.Group;
import javafx.scene.Node;

def imageURL : String [] = [
    "http://farm3.static.flickr.com/2194/2365950910_22f9c51b37",
    "http://farm4.static.flickr.com/3077/2365118433_593ca9c5d5",
    "http://farm3.static.flickr.com/2071/2365118063_b50b551089",
    "http://farm4.static.flickr.com/3286/2365118123_b0ae6227df",
    "http://farm2.static.flickr.com/1128/1320611251_6184dac634",
    "http://farm2.static.flickr.com/1261/1333507132_6f581b0d4e",
    "http://farm2.static.flickr.com/1254/1320655091_920f119122"
];

public class Carousel extends CustomNode {

    var thumbImage : ThumbImage[];

    public var selectedThumbImage : ThumbImage;

    public override function create(): Node {

        cursor = Cursor.HAND;

        for(i in [0..6]) {
            insert ThumbImage {
                index: i
                url: imageURL[i]
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
    }

    override var onMousePressed = function(e) {
        next();
    }
}
