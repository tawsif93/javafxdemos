/*
 * ThumbView.fx
 *
 * Created on 31 Jul, 2009, 5:32:58 PM
 */

package javafxyt.view;

import javafxyt.model.Video;
import javafx.scene.image.Image;
import javafx.scene.Cursor;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.image.ImageView;
import javafx.scene.Group;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafxyt.Main;

/**
 * @author Rakesh Menon
 */

def loadingImage = Image {
    url: "{__DIR__}images/loading.png"
    width: 120
    height: 90
};

def ORANGE = Color.web("#FD811D");
def BLUE = Color.web("#97CD0A");

public class ThumbView extends CustomNode {
    
    var imageView = ImageView {
        layoutX: 2
        layoutY: 2
    };

    public var selected = false;
    
    public-init var index = 0;
    public-init var video : Video on replace {
        if(video != null) {
            imageView.image = Image {
                backgroundLoading: true
                url: video.thumbnail[0].url
                placeholder: loadingImage
            }
        }
    };
    
    init {
        cursor = Cursor.HAND;
    }

    var border = Rectangle {
        width: 124
        height: 94
        fill: Color.TRANSPARENT
        stroke: bind if(selected) { BLUE } else if(hover) { ORANGE } else { Color.GRAY }
        strokeWidth: 2
        arcWidth: 10
        arcHeight: 10
        smooth: true
    }
    
    override function create() : Node {
        Group {
            content: [ imageView, border ]
        }
    }

    override var onMouseReleased = function(e) {
        Main.thumbnailBar.selectedIndex = index;
    }
}
