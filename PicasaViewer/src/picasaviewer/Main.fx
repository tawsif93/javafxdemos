/*
 * Main.fx
 *
 * Created on Nov 17, 2009, 9:56:38 AM
 */

package picasaviewer;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.paint.Color;
import javafx.animation.Timeline;
import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;


/**
 * @author Rakesh Menon
 */

def width = 420;
def height = 280;

var loadingText : Text = Text {
    layoutX: bind (width - loadingText.layoutBounds.width)/2.0
    layoutY: bind (height - loadingText.layoutBounds.height)/2.0
    font: Font { size: 20 }
    fill: Color.GRAY
    textOrigin: TextOrigin.TOP
    content: "Loading Photos..."
}

var images : Image[];

var x = 1.0;
var imageView1 = ImageView {
    layoutX: bind width + x
};
var imageView2 = ImageView {
    layoutX: bind x
};

var index = 0;

var fadeTransition = Timeline {

    repeatCount: Timeline.INDEFINITE
    autoReverse: false

    keyFrames: [
        KeyFrame {
            time: 0s
            values: [ x => -width ]
            action: function() {
                if(index >= (sizeof images - 1)) {
                    index = 0;
                }
                imageView1.image = images[index];
                imageView2.image = images[index + 1];
                index++;
            }
        },
        KeyFrame {
            time: 2s
            values: [ x => 0 tween Interpolator.EASEBOTH ]
            canSkip: true
        },
        KeyFrame {
            time: 5s
            values: [ x => 0 ]
            canSkip: true
        }
    ]
}

var feedParser = FeedParser {

    onPhotos: function(photos : Photo[]) {

        delete images;

        for(photo in photos) {

            var w:Number = Integer.parseInt(photo.width);
            var h:Number = Integer.parseInt(photo.height);

            if(h > w) { continue; }

            insert Image {
                url: photo.url
                width: width
                height: height
                backgroundLoading: (sizeof images > 5)
            } into images;
        }

        fadeTransition.playFromStart();
        loadingText.visible = false;
    }
}
feedParser.start();

Stage {
    title: "Picasa Viewer"
    scene: Scene {
        fill: Color.WHITE
        width: width
        height: height
        content: [ imageView1, imageView2, loadingText ]
    }
}
