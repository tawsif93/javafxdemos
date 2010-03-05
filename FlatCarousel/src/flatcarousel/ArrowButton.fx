/*
 * ArrowButton.fx
 *
 * Created on 5 Mar, 2010, 4:16:10 PM
 */

package flatcarousel;

import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;
import javafx.scene.layout.Container;
import javafx.scene.Cursor;

/**
 * @author Rakesh Menon
 */

public class ArrowButton extends Container {

    public var action : function();
    
    def background = Rectangle {
        width: 20
        fill: LinearGradient {
            startX: 0.0 startY: 0.0
            endX: 1.0 endY: 0.0
            stops: [
                Stop { offset: 0.0 color: Color.GREY },
                Stop { offset: 0.5 color: Color.BLACK },
                Stop { offset: 1.0 color: Color.GREY }
            ]
        }
    }

    init {
        blocksMouse = true;
        cursor = Cursor.HAND;
        content = [ background ];
    }

    override var onMouseReleased = function(e) {
        action();
    }

    override function doLayout() : Void {
        background.height = height;
    }
}
