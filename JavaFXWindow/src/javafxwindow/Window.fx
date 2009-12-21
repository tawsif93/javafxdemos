/*
 * FXWindow.fx
 *
 * Created on Nov 20, 2009, 10:12:56 AM
 */

package javafxwindow;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.paint.Paint;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.Group;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;
import javafx.scene.text.FontWeight;
import javafx.scene.effect.DropShadow;
import javafx.scene.shape.HLineTo;
import javafx.scene.shape.LineTo;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.Path;
import javafx.scene.shape.VLineTo;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.util.Math;
import javafx.scene.Cursor;
import javafx.scene.layout.Panel;

/**
 * @author Rakesh Menon
 */

public class Window extends CustomNode {
    
    public var content : Node[];
    public-init var fill: Paint = Color.GRAY;

    public var title = "";

    public var x = 0.0;
    public var y = 0.0;
    public var width = 180.0;
    public var height = 180.0;
    public var minWidth = 180.0;
    public var minHeight = 180.0;
    public-init var autoResize = false;
    
    def margin = 5;
    def arcSize = 8;

    def windowVisible = bind visible on replace {
        if(visible) { toFront(); }
    }

    def titleText : Text = Text {
        content: bind title
        font: Font.font("sansserif", FontWeight.BOLD, 12)
        fill: Color.WHITE
        textOrigin: TextOrigin.TOP
    }

    def contentClipRect = Rectangle {
        x: 2
        y: 2
    }

    def contentGroup = Group {
        content: bind content
        clip: contentClipRect
    }
    
    var startDragX = 0.0;
    var startDragY = 0.0;
    var startDragW = 0.0;
    var startDragH = 0.0;
    var dragDirection = -1;
    
    def bgRect : Rectangle = Rectangle {

        fill: fill
        arcWidth: arcSize
        arcHeight: arcSize

        onMouseMoved: function(e) {

            if(autoResize) { return; }
            
            if(((width - e.x) < 10) and ((height - e.y) < 10)) {
                dragDirection = 0;
                bgRect.cursor = Cursor.SE_RESIZE;
            } else if((width - e.x) < margin) {
                dragDirection = 1;
                bgRect.cursor = Cursor.H_RESIZE;
            } else if((height - e.y) < margin) {
                dragDirection = 2;
                bgRect.cursor = Cursor.V_RESIZE;
            } else {
                dragDirection = -1;
                bgRect.cursor = null;
            }
        }
        
        onMousePressed: function(e) {
            toFront();
            startDragX = x;
            startDragY = y;
            startDragW = width;
            startDragH = height;            
        }
        
        onMouseDragged: function(e) {

            if(not autoResize) {

                if(dragDirection == 0) {
                    width = Math.max(minWidth, startDragW + e.dragX);
                    height = Math.max(minHeight, startDragH + e.dragY);
                } else if(dragDirection == 1) {
                    width = Math.max(minWidth, startDragW + e.dragX);
                } else if(dragDirection == 2) {
                    height = Math.max(minHeight, startDragH + e.dragY);
                } else {
                    x = startDragX + e.dragX;
                    y = startDragY + e.dragY;
                }
                
            } else {
                x = startDragX + e.dragX;
                y = startDragY + e.dragY;
            }

            window.requestLayout();
        }

        onMouseReleased: function(e) {
            bgRect.cursor = null;
        }
        
        effect: DropShadow { }
    }

    def closeButton : Path = Path {
        elements: [
            MoveTo { x: 0  y: 0 },
            HLineTo { x: 3 },
            LineTo { x: 5  y: 2 },
            LineTo { x: 7  y: 0 },
            HLineTo { x: 10 },
            VLineTo { y: 1 },
            LineTo { x: 7  y: 4 },
            VLineTo { y: 5 },
            LineTo { x: 10  y: 8 },
            VLineTo { y: 9 },
            HLineTo { x: 7 },
            LineTo { x: 5  y: 7 },
            LineTo { x: 3  y: 9 },
            HLineTo { x: 0 },
            VLineTo { y: 8 },
            LineTo { x: 3  y: 5 },
            VLineTo { y: 4 },
            LineTo { x: 0  y: 1 },
            VLineTo { y: 0 }
        ]
        fill: fill
        strokeWidth: 0
        stroke: Color.TRANSPARENT
    }

    def closeButtonBorder = Rectangle {
        width: 16
        height: 15
        fill: Color.DARKGRAY
        cursor: Cursor.HAND
        onMouseReleased: function(e) {
            visible = false;
        }
    }

    def closeButtonBG = Rectangle {
        width: 14
        height: 13
        fill: LinearGradient {
            startX: 0.0, startY: 0.0, endX: 0.0, endY: 13
            proportional: false
            stops: [
                Stop { offset: 0.0 color: Color.LIGHTGRAY },
                Stop { offset: 1.0 color: Color.WHITE }
            ]
        }
    }
    
    def contentOuterBorder = Rectangle { fill: Color.DARKGREY }
    def contentInnerBorder = Rectangle { fill: Color.LIGHTGRAY }
    def contentAreaBG = Rectangle { 
        fill: Color.WHITE
        blocksMouse: true
        onMousePressed: function(e) {
            toFront();
        }
    }

    def window = Panel {
        layoutX: bind x
        layoutY: bind y
        onLayout: onLayout
        content: [
            bgRect, contentOuterBorder, contentInnerBorder,
            contentAreaBG, titleText, contentGroup,
            closeButtonBorder, closeButtonBG, closeButton
        ]
        blocksMouse: true
    }

    override function create() : Node {
        window;
    }
    
    function onLayout() : Void {

        var titleHeight = titleText.layoutBounds.height + margin + 3;

        if(autoResize) {
            width = Math.max(minWidth, contentGroup.layoutBounds.width + (margin + 2) * 2 + 30);
            height = Math.max(minHeight, contentGroup.layoutBounds.height + (margin * 3) + titleHeight + 30);
            contentGroup.clip = null;
        } else {
            contentClipRect.width = width - 4;
            contentClipRect.height = height - 12;
        }     
        
        titleText.layoutX = margin + 3;
        titleText.layoutY = margin + 3;

        contentGroup.layoutY = titleHeight + margin;
        contentGroup.layoutX = margin;

        bgRect.width = width;
        bgRect.height = height;

        closeButton.layoutX = width - margin - closeButton.layoutBounds.width - 3;
        closeButton.layoutY = (margin + titleHeight - closeButton.layoutBounds.height)/2.0;

        closeButtonBorder.layoutX = closeButton.layoutX - 3;
        closeButtonBorder.layoutY = closeButton.layoutY - 3;
        closeButtonBG.layoutX = closeButtonBorder.layoutX + 1;
        closeButtonBG.layoutY = closeButtonBorder.layoutY + 1;

        contentOuterBorder.layoutX = margin;
        contentOuterBorder.layoutY = margin + titleHeight;
        contentOuterBorder.width = width - (margin * 2);
        contentOuterBorder.height = height - titleHeight - (margin * 2);

        contentInnerBorder.layoutX = margin + 1;
        contentInnerBorder.layoutY = margin + titleHeight + 1;
        contentInnerBorder.width = width - (margin * 2) - 2;
        contentInnerBorder.height = height - titleHeight - (margin * 2) - 2;
        
        contentAreaBG.layoutX = margin + 2;
        contentAreaBG.layoutY = margin + titleHeight + 2;
        contentAreaBG.width = width - (margin * 2) - 4;
        contentAreaBG.height = height - titleHeight - (margin * 2) - 4;
    }
}
