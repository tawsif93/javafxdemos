   /*
 * Main.fx
 *
 * Created on 16 Mar, 2009, 11:01:03 AM
 */

package lighteffect;

import javafx.ext.swing.SwingComponent;
import javafx.scene.Group;
import javafx.scene.image.ImageView;
import javafx.scene.paint.Color;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javax.swing.border.EmptyBorder;
import javax.swing.JTextArea;
import lighteffect.ControlPanel;
import lighteffect.LightChoice;
import javafx.scene.layout.VBox;
import javafx.scene.layout.HBox;
import javafx.scene.image.Image;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Rectangle;
import javafx.scene.control.Button;
import colorpicker.ColorPicker;

var lightColor = Text {
    translateY: 5
    font: Font.font("sansserif", FontWeight.REGULAR, 12)
    content: "Light Color"
    textOrigin: TextOrigin.TOP
};

var colorPicker : ColorPicker = ColorPicker {
    color: Color.WHITE
    blocksMouse: true
};

var colorBox = HBox {
    layoutX: 30
    layoutY: bind effectNode.layoutBounds.height + 30
    spacing: 5
    content: [ lightColor, colorPicker ]
    visible: bind controls.visible
}

var lightChoice: LightChoice = LightChoice {
    translateX: 150
    translateY: 10
}
var controlPanel: ControlPanel = ControlPanel {
    color: bind colorPicker.color
    colorDef: bind "{colorPicker.color}"
    translateX: 20
}
lightChoice.updateLight = controlPanel.updateLight;

var effectNode: HBox = HBox {

    var skyImage: ImageView;

    spacing: 20

    content: [
        Group {
            content: [
                skyImage = ImageView {
                    image: Image {
                        url: "{__DIR__}images/sky.jpg"
                        width: 200
                        height: 200
                    }
                },
                ImageView {
                    image: Image {
                        url: "{__DIR__}images/SwingingDuke.png"
                        width: 200
                        height: 200
                    }
                    effect: bind controlPanel.lighting
                }
            ]
        },
        VBox {
            spacing: 10
            content: [
                Text {
                    textOrigin: TextOrigin.TOP
                    x: 20
                    y: 310
                    content: "LIGHT"
                    fill: bind controlPanel.lighting.light.color
                    font: Font.font("sansserif", FontWeight.BOLD, 60);
                    effect: bind controlPanel.lighting
                },
                Circle {
                    fill: Color.TRANSPARENT
                    stroke: Color.RED
                    strokeWidth: 40
                    radius: 40
                    effect: bind controlPanel.lighting
                }
            ]
        }
    ]

    layoutX: 10
    translateY: 10

    onMousePressed: function(e) {
        // Toggle visibility of sky
        skyImage.visible = not skyImage.visible
    }
};

var textArea = new JTextArea("");
textArea.setEditable(false);
textArea.setBorder(new EmptyBorder(5, 5, 5, 5));
var fxTextArea = SwingComponent.wrap(textArea);
fxTextArea.height = 250;
fxTextArea.width = 470;
var lightingCode = bind controlPanel.lightingCode on replace {
    textArea.setText(lightingCode);
};

var textAreaGroup = Group {
    layoutX: 10
    layoutY: bind effectNode.layoutBounds.height + 20
    content: [ fxTextArea ]
    visible: false
}

var controls = VBox {
    layoutX: 10
    layoutY: bind effectNode.layoutBounds.height + 20
    content: [ lightChoice, controlPanel ]
    spacing: 20
    visible: bind not textAreaGroup.visible
}

var button : Button = Button {
    layoutX: bind bgRect.width - button.layoutBounds.width - 10
    layoutY: bind effectNode.layoutBounds.height - button.layoutBounds.height + 10
    text: "View Source"
    action: function() {
        if(textAreaGroup.visible) {
            button.text = "View Source"
        } else {
            button.text = "View Controls"
        }
        textAreaGroup.visible = not textAreaGroup.visible;
    }
}

var bgRect = Rectangle {
    width: bind effectNode.layoutBounds.width + 40
    height: bind effectNode.layoutBounds.height + 20
}

Stage {
    scene: Scene {
        content: [ bgRect, effectNode, controls, textAreaGroup, button, colorBox ]
        fill: Color.WHITE
        height: 680
        width: 445
    }
    title: "Light Effect"
}
