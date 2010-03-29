/*
 * Main.fx
 *
 * Created on Mar 26, 2010, 8:40:04 PM
 */

package modaldialog;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.control.TextBox;
import javafx.scene.control.Button;
import javafx.scene.Group;
import javafx.scene.layout.HBox;

/**
 * @author javafx
 */

def inputTextBox = TextBox { text: "Input" }

def showButton : Button = Button {
    layoutX: 100
    layoutY: 100
    text: "Show Modal Dialog"
    action: function() {
        println("Before Modal-Dialog Show!");
        window.show(showButton.scene);
        println("After Modal-Dialog Show!");
        println("User Entered: {inputTextBox.rawText}");
    }
}

def window : Window = Window {
    title: "Modal Dialog"
    content: Group {
        content: HBox {
            layoutX: 10
            layoutY: 10
            spacing: 10
            content: [
                inputTextBox,
                Button {
                    text: "OK"
                    action: function() {
                        window.hide();
                    }
                }
            ]
        }
    }
    x: 50
    y: 50
    width: 200
    height: 100
}

Stage {
    scene: Scene {
        width: 300
        height: 300
        content: [ showButton ]
    }
}
