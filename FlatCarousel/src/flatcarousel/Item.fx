/*
 * Item.fx
 *
 * Created on 5 Mar, 2010, 3:51:22 PM
 */

package flatcarousel;

import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.control.Label;
import javafx.scene.layout.Container;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;

/**
 * @author Rakesh Menon
 */

def font = Font.font("sansserif", FontWeight.BOLD, 60);

public class Item extends Container {

    public var text = "";

    var label = Label {
        text: bind "{text}"
        hpos: HPos.CENTER
        vpos: VPos.CENTER
        font: font
    }

    var border = Rectangle {
        width: 100
        height: 100
        fill: Color.GREY
        arcWidth: 20
        arcHeight: 20
    };

    var background = Rectangle {
        x: 5
        y: 5
        width: 90
        height: 90
        fill: Color.WHITE
        arcWidth: 20
        arcHeight: 20
    };

    init {
        content = [ border, background, label ]
    }

    override function doLayout() : Void {
        resizeNode(label, 100, 100);
    }
}
