/*
 * Main.fx
 *
 * Created on 18 Nov, 2009, 10:20:07 AM
 */

package texteffect;

import javafx.scene.text.Font;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.text.FontWeight;
import javafx.scene.control.TextBox;
import javafx.scene.control.CheckBox;


/**
 * @author Rakesh Menon
 */

def width = 350;
def height = 150;

var checkbox = CheckBox {
    layoutX: 10
    layoutY: 10
    text: "Emboss"
}

var embossText = EmbossText {
    content: bind textBox.rawText
    font: Font.font("sansserif", FontWeight.BOLD, 45)
    fill: Color.GRAY
    width: width
    height: height - 30
    visible: bind checkbox.selected
}

var engraveText = EngraveText {
    content: bind textBox.rawText
    font: Font.font("sansserif", FontWeight.BOLD, 45)
    fill: Color.GRAY
    darkShadowFill: Color.BLACK
    liteShadowFill: Color.WHITE
    width: width
    height: height - 30
    visible: bind not checkbox.selected
}

var textBox: TextBox = TextBox {
    text: "Text Effect"
    layoutX: 10
    layoutY: bind (height - textBox.layoutBounds.height - 10)
    width: width - 20
}

var bgRect = Rectangle {
    width: width
    height: height
    fill: LinearGradient {
        startX: 0.0, startY: 0.0, endX: 0.0, endY: 1.0
        stops: [
            Stop { offset: 0.0 color: Color.WHITE },
            Stop { offset: 1.0 color: Color.GRAY }
        ]
    }
}

Stage {
    title: "Text Effect"
    scene: Scene {
        content: [ bgRect, embossText, engraveText, textBox, checkbox ]
    }
    resizable: false
}
