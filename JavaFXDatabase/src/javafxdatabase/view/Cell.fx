/*
 * Cell.fx
 *
 * Created on Dec 22, 2009, 1:23:18 PM
 */

package javafxdatabase.view;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.control.Label;
import javafx.scene.Group;
import javafx.scene.layout.Resizable;
import javafx.scene.paint.Paint;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;

/**
 * @author Rakesh Menon
 */

def margin = 3;

public class Cell extends CustomNode, Resizable {
    
    public var text : String;
    public var graphic: Node;
    public var selected = false;

    public var fill: Paint = Color.WHITE;
    public var selectedFill: Paint = Color.rgb(0, 147, 255);
    public var textFill: Paint = Color.BLACK;
    public var selectedTextFill: Paint = Color.WHITE;
    public var font: Font = Font.font("sansserif", FontWeight.REGULAR, 12);

    def background = Rectangle {
        fill: bind if(selected) selectedFill else fill
        width: bind width
        height: bind height
    }

    def label = Label {
        layoutX: margin
        layoutY: margin
        text: bind "{text}"
        graphic: bind graphic
        width: bind width - (margin * 2)
        font: bind font
        textFill: bind if(selected) selectedTextFill else textFill
    }

    override function create() : Node {
        Group { content: [ background, label ] }
    }

    override function getPrefHeight(width: Number) {
        label.getPrefHeight(width);
    }

    override function getPrefWidth(height: Number) {
        label.getPrefWidth(height);
    }
}
