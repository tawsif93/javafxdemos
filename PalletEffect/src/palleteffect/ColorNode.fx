/*
 * ColorNode.fx
 *
 * Created on 1 Mar, 2009, 10:15:51 AM
 */

package palleteffect;

import javafx.scene.Cursor;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;

/**
 * @author Rakesh Menon
 */

public def size = 31;

public class ColorNode extends CustomNode {
    
    public var fill = Color.BLACK;
    public var stroke = Color.BLACK;
    
    public var repeatCount = 1 on replace {
        if(repeatCount < 1) {
            repeatCount = 1;
        }
    }
    
    public var rate = 1;
    public var count = 0;
    
    public var row = 0 on replace {
        layoutY = row * size;
    }
    
    public var column = 0 on replace {
        layoutX = column * size;
    }
    
    var rectangle = Rectangle {
        width: size
        height: size
        strokeWidth: 1.0
        stroke: bind stroke
        cursor: Cursor.HAND
    };
    
    public var transparent = false on replace {
        if(transparent) {
            rectangle.fill = Color.TRANSPARENT;
        } else {
            rectangle.fill = fill;
        }
    };
    
    override function create() : Node {
        rectangle;
    }
}
