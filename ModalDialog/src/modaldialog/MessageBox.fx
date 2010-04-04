/*
 * MessageBox.fx
 *
 * Created on Apr 2, 2010, 2:41:25 PM
 */

package modaldialog;

import javafx.scene.control.Button;
import javafx.scene.Node;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.geometry.HPos;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;
import javafx.scene.control.TextBox;
import javafx.scene.layout.LayoutInfo;

/**
 * @author Rakesh Menon
 */

def eventQueueUtils = new EventQueueUtils();

/**
 * MessageBox Implementation
 */
public class MessageBox {

    public-init var title: String;
    public-init var message: Node;
    public-init var options: String[];
    public-init var functions: function()[];
    public-init var blockEDT = true;
    public-read var selectedOption : String;

    var content : Node[];
    def window : Window = Window {
        title: bind title
        nodes: bind content
        onClose: hide
    }

    postinit {

        var buttons : Button[] = [];
        for(i in [0..((sizeof options) - 1)]) {
            insert Button {
                text: "{options[i]}"
                action: function() {
                    selectedOption = "{options[i]}";
                    window.hide();
                    functions[i]();
                }
            } into buttons;
        }

        def buttonBox = HBox {
            spacing: 10
            content: buttons
            hpos: HPos.CENTER
            layoutInfo: LayoutInfo { hpos: HPos.CENTER }
        }

        def vBox = VBox {
            spacing: 10
            content: [ message, buttonBox ]
        }

        content = vBox;
    }

    public function show(scene : Scene) : Void {
        window.show(scene);
        if(blockEDT) {
            eventQueueUtils.blockEDT();
        }
    }

    public function hide() : Void {
        if(blockEDT) {
            eventQueueUtils.unblockEDT();
        }
        window.hide();
    }
}

/**
 * MessageBox Implementation - Blocks EDT
 */

public function showMessageDialog(
    scene : Scene, message : String, title : String) : Void {

    def label = Label {
        text: message
        graphic: ImageView {
            image: Image {
                url: "{__DIR__}images/info.png"
            }
        }
    }

    def messageBox = MessageBox {
        message: label
        title: title
        options: [ "OK" ]
    };
    messageBox.show(scene);
}

public function showConfirmDialog(
    scene : Scene, message : String, title : String, options : String[]) : String {

    def label = Label {
        text: message
        graphic: ImageView {
            image: Image {
                url: "{__DIR__}images/confirm.png"
            }
        }
    }

    def messageBox = MessageBox {
        message: label
        title: title
        options: options
    };
    messageBox.show(scene);
    messageBox.selectedOption;
}

public function showInputDialog(
    scene : Scene, message : String, title : String) : String {

    def label = Label {
        text: message
        graphic: ImageView {
            image: Image {
                url: "{__DIR__}images/input.png"
            }
        }
    }

    def textBox : TextBox = TextBox {
        promptText: message
        layoutInfo: LayoutInfo {
            width: bind (label.width)
        }
    }

    def vBox = VBox {
        spacing: 5
        content: [ label, textBox ]
    }

    def messageBox = MessageBox {
        message: vBox
        title: title
        options: [ "OK" ]
    };
    messageBox.show(scene);

    textBox.rawText;
}

/**
 * MessageBox Implementation - Branch to various functions
 */

public function showMessageDialog(
    scene : Scene, message : String, title : String,
    action: function() : Void) : Void {

    def label = Label {
        text: message
        graphic: ImageView {
            image: Image {
                url: "{__DIR__}images/info.png"
            }
        }
    }

    def messageBox = MessageBox {
        message: label
        title: title
        options: [ "OK" ]
        functions: action
        blockEDT: false
    };
    messageBox.show(scene);
}

public function showOptionsDialog(
    scene : Scene, message : String, title : String,
    options : String[],
    functions:function()[]) : Void {

    def label = Label {
        text: message
        graphic: ImageView {
            image: Image {
                url: "{__DIR__}images/confirm.png"
            }
        }
    }

    def messageBox = MessageBox {
        message: label
        title: title
        options: options
        functions: functions
        blockEDT: false
    };
    messageBox.show(scene);
}

public function showInputDialog(
    scene : Scene, message : String, title : String,
    action: function(String) : Void) : String {

    def label = Label {
        text: message
        graphic: ImageView {
            image: Image {
                url: "{__DIR__}images/input.png"
            }
        }
    }

    def textBox : TextBox = TextBox {
        promptText: message
        action: function() {
            messageBox.hide();
            action(textBox.rawText);
        }
        layoutInfo: LayoutInfo {
            width: bind (label.width)
        }
    }

    def vBox = VBox {
        spacing: 5
        content: [ label, textBox ]
    }

    def messageBox = MessageBox {
        message: vBox
        title: title
        options: [ "OK" ]
        functions: function() {
            action(textBox.rawText);
        }
        blockEDT: false
    };
    messageBox.show(scene);

    textBox.rawText;
}
