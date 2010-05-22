/*
 * TableHeader.fx
 *
 * Created on Mar 18, 2010, 11:54:50 AM
 */

package javafxtable.control.skin;

import javafx.scene.layout.Container;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.control.Label;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.geometry.HPos;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.Cursor;

/**
 * @author Rakesh Menon
 */

def font = Font.font("Amble Cn", FontWeight.REGULAR, 14);

def outerBorderFill = LinearGradient {
    startX: 0.0 startY: 0.0 endX: 0.0 endY: 1.0
    stops: [
        Stop { offset: 0.0 color: Color.web("#B4B4B4") },
        Stop { offset: 0.5 color: Color.web("#9C9C9C") }
    ]
};
def innerBorderFill = LinearGradient {
    startX: 0.0 startY: 0.0 endX: 0.0 endY: 1.0
    stops: [
        Stop { offset: 0.0 color: Color.web("#F4F4F4") },
        Stop { offset: 0.5 color: Color.web("#BCBCBC") }
    ]
};
def bodyFill = LinearGradient {
    startX: 0.0 startY: 0.0 endX: 0.0 endY: 1.0
    stops: [
        Stop { offset: 0.0 color: Color.web("#DCDCDC") },
        Stop { offset: 0.5 color: Color.web("#B4B4B4") }
    ]
};

public class TableHeader extends Container {

    public-init var tableColumn : TableColumn;
    
    public var text : String;

    def outerBorder = Rectangle {
        fill: outerBorderFill
    }
    def innerBorder = Rectangle {
        x: 1
        y: 1
        fill: innerBorderFill
    }
    def body = Rectangle {
        x: 2
        y: 2
        fill: bodyFill
    }

    def label = Label {
        text: bind text
        textFill: Color.BLACK
        font: font
        hpos: HPos.CENTER
    }

    var resize = false;
    override var cursor = bind if(resize) { Cursor.E_RESIZE } else { Cursor.HAND };

    init {
        content = [ outerBorder, innerBorder, body, label ];
        blocksMouse = true;
    }

    override function doLayout() : Void {

        outerBorder.width = width;
        outerBorder.height = height;
        innerBorder.width = width - 1;
        innerBorder.height = height - 1;
        body.width = width - 2;
        body.height = height - 2;

        layoutNode(label, 2, 2, width - 4, height - 4);
    }

    var startX = 0.0;
    var startW = 0.0;

    override var onMousePressed = function(me) : Void {
        if(resize) {
            startW = tableColumn.width;
        } else {
            startX = tableColumn.translateX;
            tableColumn.toFront();
            tableColumn.opacity = 0.5;
        }
    }

    override var onMouseDragged = function(me) : Void {
        if(resize) {
            tableColumn.columnWidth = startW + me.dragX;
            tableColumn.tableView.requestLayout();
        } else {
            def x = startX + me.dragX;
            def inUpperBound = (tableColumn.layoutX + x + width + 10) < tableColumn.tableView.width;
            def inLowerBound = (tableColumn.layoutX + x > tableColumn.tableView.layoutX);
            if(inUpperBound and inLowerBound) {
                tableColumn.translateX = x;
            }
        }
    }
    
    override var onMouseReleased = function(me) : Void {
        
        var newIndex = 0;
        var x = 0.0;

        for(tc in tableColumn.tableView.tableColumns) {
            if((tableColumn.layoutX + tableColumn.translateX) < x) {
                break;
            }
            x = x + tc.width;
            newIndex++;
        }

        tableColumn.tableView.reorderColumn(
            tableColumn, newIndex);

        tableColumn.translateX = 0;
        tableColumn.opacity = 1.0;
        tableColumn.tableView.requestLayout();
    }
    
    def resizeWidth = 5;
    override var onMouseMoved = function(me) : Void {
        if(me.x > (width - resizeWidth)) {
            resize = true;
        } else {
            resize = false;
        }
    }
}
