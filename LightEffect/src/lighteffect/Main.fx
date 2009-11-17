   /*
 * Main.fx
 *
 * Created on 16 Mar, 2009, 11:01:03 AM
 */

package lighteffect;

import javafx.ext.swing.SwingComponent;
import javafx.scene.Group;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.paint.Color;
import javafx.scene.Scene;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;
import javafx.stage.Stage;
import javax.swing.border.EmptyBorder;
import javax.swing.JTextArea;
import lighteffect.ColorChooser;
import lighteffect.ControlPanel;
import lighteffect.LightChoice;

var colorChooser: ColorChooser = ColorChooser {
    translateX: 10
    translateY: bind controlPanel.boundsInLocal.height + 10
};

var lightChoice: LightChoice = LightChoice {
    translateY: bind effectNode.boundsInLocal.height + 30
    translateX: 10
}

var controlPanel: ControlPanel = ControlPanel {
    translateX: 250
    color: bind colorChooser.color
    colorDef: bind colorChooser.colorDef
}
lightChoice.updateLight = controlPanel.updateLight;

var effectNode: Group = Group {

    var skyImage: ImageView;

    content: [
        skyImage = ImageView {
            image: Image {
                url: "{__DIR__}images/sky.jpg"
            }
        },
        ImageView {
            image: Image {
                url: "{__DIR__}images/statue.png"
            }
            effect: bind controlPanel.lighting
        },
        Text {
            textOrigin: TextOrigin.TOP
            x: 10
            y: 310
            content: "LIGHT"
            fill: bind controlPanel.lighting.light.color
            font: Font.font(null, FontWeight.BOLD, 60);
            effect: bind controlPanel.lighting
        }
    ]

    translateX: 10
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
    content: [ fxTextArea ]
    translateY: bind colorChooser.translateY + 85;
    translateX: 5
}

Stage {
    scene: Scene {
        content: [ effectNode, lightChoice, controlPanel, colorChooser, textAreaGroup ]
        fill: Color.BLACK
        height: 840
        width: 480
    }
    title: "Light Effect"
    resizable: false
}
