/*
 * Carousel.fx
 *
 * Created on 5 Mar, 2010, 3:52:01 PM
 */

package flatcarousel;

import javafx.animation.Interpolator;
import javafx.animation.Timeline;
import javafx.scene.Cursor;
import javafx.scene.layout.ClipView;
import javafx.scene.layout.Container;
import javafx.scene.layout.HBox;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;

/**
 * @author Rakesh Menon
 */

public class Carousel extends Container {

    def hBox = HBox {
        spacing: 5
        content: for(i in [0..50]) {
            Item { text: "{i}" }
        }
        cursor: Cursor.HAND
    }

    var clipX = 0.0;
    var dragEndX = 0.0;
    var startX = 0.0;

    def carousel = ClipView {

        layoutY: 20
        
        pannable: false
        node: hBox
        width: width
        height: height - 40
        
        clipX: bind clipX
        onMousePressed: function(e) {
            startX = clipX;
        }
        onMouseDragged: function(e) {
            dragEndX = startX + e.dragX;
            if(dragEndX > 0) {
                timeline.playFromStart();
            } else {
                dragEndX = 0;
            }
        }
    }

    def background = Rectangle {
        fill: LinearGradient {
            startX: 0.0 startY: 0.0
            endX: 0.0 endY: 1.0
            stops: [
                Stop { offset: 0.0 color: Color.GREY },
                Stop { offset: 0.2 color: Color.BLACK },
                Stop { offset: 0.8 color: Color.BLACK },
                Stop { offset: 1.0 color: Color.GREY }
            ]
        }
    }

    def leftArrow = ArrowButton {
        action: function() {
            startX = clipX;
            dragEndX = clipX + width;
            timeline.playFromStart();
        }
    };

    def rightArrow = ArrowButton {
        action: function() {
            startX = clipX;
            dragEndX = clipX - width;
            if(dragEndX < 0) { dragEndX = 0; }
            timeline.playFromStart();
        }
    };
    
    def timeline = Timeline {
        keyFrames: [
            at(0s) { clipX => startX },
            at(1s) { clipX => dragEndX tween Interpolator.EASEIN }
        ]
    }

    init {
        content = [ background, carousel, leftArrow, rightArrow ];
    }

    override function doLayout() : Void {
        
        background.width = width;
        background.height = height;

        rightArrow.height = height;
        leftArrow.height = height;
        
        rightArrow.layoutX = width - getNodePrefWidth(rightArrow);
        carousel.layoutX = getNodePrefWidth(leftArrow);
    }
    
    public function setInitialX(initX : Number) : Void {
        dragEndX = initX;
        timeline.playFromStart();
    }
}
