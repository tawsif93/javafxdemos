/*
 * Main.fx
 *
 * Created on 21 Jul, 2009, 8:48:47 AM
 */

package saveasimage;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.Group;
import javafx.scene.control.Button;
import javax.swing.JFileChooser;

/**
 * @author Rakesh Menon
 */

var bgImage = ImageView {
    image: Image {
        url: "{__DIR__}image.png"
        backgroundLoading: true
    }
}

var duke = Duke {
    layoutX: 55
    layoutY: -120
    scaleX: 0.25
    scaleY: 0.25
    opacity: 0.5
};

var jFileChooser = new JFileChooser();
var button : Button = Button {
    text: "Save"
    layoutX: 280
    layoutY: 220
    action: function() {
        if (jFileChooser.showSaveDialog(JavaFX13Utils.getContainer()) == JFileChooser.APPROVE_OPTION) {
            controlGroup.visible = false;
            JavaFX13Utils.saveAsImage(contentGroup, jFileChooser.getSelectedFile());
            controlGroup.visible = true;
        }
    }
}

var controlGroup = Group { content: [ button ] }
var contentGroup = Group {
    content: [
        bgImage, duke
    ]
}

Stage {
    title: "Save As Image"
    resizable: false
    scene: Scene {
        content: [ contentGroup, controlGroup ]
        width: 350
        height: 262
    }
}
