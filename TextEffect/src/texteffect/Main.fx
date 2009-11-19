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
import javafx.scene.control.RadioButton;
import javafx.scene.layout.HBox;
import javafx.scene.control.ToggleGroup;


/**
 * @author Rakesh Menon
 */

def width = 350;
def height = 150;

var toggleGroup = ToggleGroup { };

var engraveCheck = RadioButton {
    text: "Engrave"
    selected: true
    toggleGroup: toggleGroup
}

var embossCheck = RadioButton {
    text: "Emboss"
    toggleGroup: toggleGroup
}

var lightCheck = RadioButton {
    text: "Light"
    toggleGroup: toggleGroup
}

var RadioButton = HBox {
    layoutX: 10
    layoutY: 10
    content: [ engraveCheck, embossCheck, lightCheck ]
    spacing: 10
}

var engraveText = EngraveText {
    content: bind textBox.rawText
    font: Font.font("sansserif", FontWeight.BOLD, 45)
    fill: Color.GRAY
    darkShadowFill: Color.BLACK
    liteShadowFill: Color.WHITE
    width: width
    height: height - 10
    visible: bind engraveCheck.selected
}

var embossText = EmbossText {
    content: bind textBox.rawText
    font: Font.font("sansserif", FontWeight.BOLD, 45)
    fill: Color.GRAY
    width: width
    height: height - 10
    visible: bind embossCheck.selected
}

var lightText = LightText {
    content: bind textBox.rawText
    font: Font.font("sansserif", FontWeight.BOLD, 45)
    fill: Color.GRAY
    width: width
    height: height - 10
    visible: bind lightCheck.selected
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
        content: [ bgRect, embossText, engraveText, lightText, textBox, RadioButton ]
        width: 350
        height: 150
    }
    resizable: false
}
