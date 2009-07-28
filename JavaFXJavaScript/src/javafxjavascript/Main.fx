/*
 * Main.fx
 *
 * Created on 27 Jul, 2009, 1:09:04 PM
 */

package javafxjavascript;

import java.applet.Applet;
import javax.swing.JOptionPane;

import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.control.Button;
import javafx.scene.control.TextBox;
import javafx.scene.layout.VBox;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;

/**
 * @author Rakesh Menon
 */

var applet: Applet = FX.getArgument("javafx.applet") as Applet;
var jsObject = new JavaScriptUtil(applet);

public function showAlert() : Void {
    JOptionPane.showMessageDialog(null, "FX: I am an alert box!");
}

public function showMessage(message : String) : Void {
   JOptionPane.showMessageDialog(null, "FX: Message: \"{message}\"");
}

public function showConfirm() : Integer {
    return JOptionPane.showConfirmDialog(
        null, "FX: Press a button", "Confirm", JOptionPane.OK_CANCEL_OPTION);
}

public function showPrompt() : String {
    var message = JOptionPane.showInputDialog(null, "Please enter your name", "Rakesh Menon");
    if (message != null) {
        return message;
    } else {
        return "";
    }
}

var alertButton = Button {
    text: "Alert"
    action: function() {
        jsObject.call("show_alert", []);
    }
}

var confirmButton = Button {
    text: "Confirm"
    action: function() {
        var option = jsObject.call("show_confirm", []);
        if(option == true) {
            JOptionPane.showMessageDialog(null, "FX: You pressed \"OK\"");
        } else {
            JOptionPane.showMessageDialog(null, "FX: You pressed \"Cancel\"");
        }
    }
}

var messageText = TextBox {
    text: "Java <-> JavaScript"
    layoutInfo: LayoutInfo { width: 150 }
}

var messageButton = Button {
    text: "Message"
    action: function() {
        jsObject.call("show_message", [ messageText.rawText ]);
    }
}

var promptText = TextBox {
    text: ""
    layoutInfo: LayoutInfo { width: 150 }
}

var promptButton = Button {
    text: "Prompt"
    action: function() {
        var message = jsObject.call("show_prompt", []);
        promptText.text = "{message}";
    }
}

var firstCol = VBox {
    spacing: 10
    content: [ 
        alertButton, messageText, promptText
    ]
}

var secondCol = VBox {
    spacing: 10
    content: [ 
        confirmButton, messageButton, promptButton
    ]
}

var hBox = HBox {
    translateX: 10
    translateY: 10
    spacing: 10
    content: [
        firstCol, secondCol
    ]
}

function run() {
    Stage {
        scene: Scene {
            content: hBox
        }
    }
}
