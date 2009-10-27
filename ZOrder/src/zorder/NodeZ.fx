/*
 * NodeZ.fx
 *
 * Created on Oct 26, 2009, 10:29:48 PM
 */

package zorder;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import java.lang.Comparable;

/**
 * @author Rakesh Menon
 */

def random = new java.util.Random();
var count = 1.0;

public class NodeZ extends CustomNode, Comparable {

    // z order index
    public var zOrder : Integer;

    public var fill = Color.RED;

    override var rotate = count * 15;
    override var layoutX = 30 + count * 10;
    override var layoutY = 30 + count * 10;

    override function create() : Node {

        count++;

        blocksMouse = true;

        Rectangle {
            fill: bind fill
            width: 120
            height: 120
            arcWidth: 10
            arcHeight: 10
            strokeWidth: 3
            stroke: Color.LIGHTGRAY
        };
    }

    // Compare Z-Order and Sort
    override function compareTo(nodeZ : Object) : Integer{
        if(nodeZ == null) { return -1; }
        return (nodeZ as NodeZ).zOrder.compareTo(zOrder);
    }

    var startX = 0.0;
    var startY = 0.0;

    override var onMousePressed = function(e) {
        startX = layoutX;
        startY = layoutY;
    }

    override var onMouseDragged = function(e) {
        layoutX = startX + e.dragX;
        layoutY = startY + e.dragY;
    }
}
