/*
 * Window.fx
 *
 * Created on Nov 20, 2009, 10:12:56 AM
 */

package modaldialog;

import javafx.scene.Node;
import javafx.scene.paint.Paint;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;
import javafx.scene.text.FontWeight;
//import javafx.scene.effect.DropShadow;
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
import javafx.scene.Scene;
import javafx.scene.layout.Container;
import javafx.scene.Group;

/**
 * @author Rakesh Menon
 */

public class Window extends Container {
    
    public var nodes : Node[];

    public-init var fill: Paint = Color.GRAY;
    public-init var onClose: function();

    public var title = "";

    /**
     * Window X, Y, W, H
     */
    public var windowX = 0.0;
    public var windowY = 0.0;
    public var windowW = 200.0;
    public var windowH = 150.0;
    public var windowMinW = 100.0;
    public var windowMinH = 100.0;

    def margin = 5;
    def arcSize = 8;

    def titleText : Text = Text {
        content: bind title
        font: Font.font("sansserif", FontWeight.BOLD, 12)
        fill: Color.WHITE
        textOrigin: TextOrigin.TOP
    }

    def contentPanel : Group = Group {
        layoutX: 10
        layoutY: 10
        content: bind nodes
    }
    
    var startDragX = 0.0;
    var startDragY = 0.0;
    var startDragW = 0.0;
    var startDragH = 0.0;
    var dragDirection = -1;

    def mouseRect = Rectangle {
        fill: Color.LIGHTGRAY
        width: bind scene.width
        height: bind scene.height
        blocksMouse: true
        opacity: 0.5
    }

    def bgRect : Rectangle = Rectangle {

        fill: fill
        arcWidth: arcSize
        arcHeight: arcSize

        onMousePressed: function(e) {
            toFront();
            startDragX = windowX;
            startDragY = windowY;
            startDragW = windowW;
            startDragH = windowH;
        }
        
        onMouseDragged: function(e) {

            if(dragDirection == 0) {
                windowW = Math.max(windowMinW, startDragW + e.dragX);
                windowH = Math.max(windowMinH, startDragH + e.dragY);
            } else if(dragDirection == 1) {
                windowW = Math.max(windowMinW, startDragW + e.dragX);
            } else if(dragDirection == 2) {
                windowH = Math.max(windowMinH, startDragH + e.dragY);
            } else {
                windowX = startDragX + e.dragX;
                windowY = startDragY + e.dragY;
            }
                
            window.requestLayout();
        }

        onMouseReleased: function(e) {
            bgRect.cursor = null;
        }
        
        //effect: DropShadow { }
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
            hide();
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

    def window : Panel = Panel {
        layoutX: bind windowX
        layoutY: bind windowY
        onLayout: onLayout
        content: [
            bgRect, contentOuterBorder, contentInnerBorder,
            contentAreaBG, titleText, contentPanel,
            closeButtonBorder, closeButtonBG, closeButton
        ]
        blocksMouse: true
    }

    /**
     * Handle Modality
     */
    var focusCycleRoot = FocusCycleRoot {
        content: bind nodes
    }

    init {

        visible = false;
        blocksMouse = true;

        content = [ mouseRect, window ];
    }
    
    function onLayout() : Void {

        var titleHeight = titleText.layoutBounds.height + margin + 3;

        contentPanel.requestLayout();

        def contentMargin = 10;
        def contentW = window.getNodePrefWidth(contentPanel) + (2 * contentMargin);
        def contentH = window.getNodePrefHeight(contentPanel) + (2 * contentMargin);

        windowW = Math.max(windowMinW, contentW + (margin * 2));
        windowH = Math.max(windowMinH, contentH + (margin * 3) + titleHeight);

        titleText.layoutX = margin + 3;
        titleText.layoutY = margin + 3;

        contentPanel.layoutY = titleHeight + margin + contentMargin;
        contentPanel.layoutX = margin + contentMargin;

        bgRect.width = windowW;
        bgRect.height = windowH;

        closeButton.layoutX = windowW - margin - closeButton.layoutBounds.width - 3;
        closeButton.layoutY = (margin + titleHeight - closeButton.layoutBounds.height)/2.0;

        closeButtonBorder.layoutX = closeButton.layoutX - 3;
        closeButtonBorder.layoutY = closeButton.layoutY - 3;
        closeButtonBG.layoutX = closeButtonBorder.layoutX + 1;
        closeButtonBG.layoutY = closeButtonBorder.layoutY + 1;

        contentOuterBorder.layoutX = margin;
        contentOuterBorder.layoutY = margin + titleHeight;
        contentOuterBorder.width = windowW - (margin * 2);
        contentOuterBorder.height = windowH - titleHeight - (margin * 2);

        contentInnerBorder.layoutX = margin + 1;
        contentInnerBorder.layoutY = margin + titleHeight + 1;
        contentInnerBorder.width = windowW - (margin * 2) - 2;
        contentInnerBorder.height = windowH - titleHeight - (margin * 2) - 2;
        
        contentAreaBG.layoutX = margin + 2;
        contentAreaBG.layoutY = margin + titleHeight + 2;
        contentAreaBG.width = windowW - (margin * 2) - 4;
        contentAreaBG.height = windowH - titleHeight - (margin * 2) - 4;
    }

    public function show(mainScene : Scene) : Void {

        if(visible) { return; }

        insert this into mainScene.content;
        window.requestLayout();
        requestLayout();

        windowX = (scene.width - windowW)/2.0;
        windowY = (scene.height - windowH)/2.0;

        visible = true;

        focusCycleRoot.requestFocusOnDefault();
    }

    public function hide() : Void {
        if(not visible) { return; }
        visible = false;
        delete this from scene.content;
        onClose();
    }
}
