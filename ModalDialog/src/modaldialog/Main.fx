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
import javafx.scene.layout.VBox;
import javafx.scene.layout.HBox;
import javafx.scene.control.Label;

/**
 * @author Rakesh Menon
 */

def textBox : TextBox = TextBox {
    text: "JavaFX Modal Dialog"
    width: bind textBox.scene.width - 40
};

var userName : String = "User-Name";

//
// Using Block EDT Approach
//
def showEDTInputButton : Button = Button {
    
    text: "Input"

    action: function() {

        println("Before Modal-Dialog Show!");

        userName = MessageBox.showInputDialog(
            showEDTInputButton.scene,
            "What is your Name?",
            "JavaFX - Input"
        );
        
        println("After Modal-Dialog Show!");
    }
}

def showEDTConfirmButton : Button = Button {

    text: "Confirm"

    action: function() {

        println("Before Modal-Dialog Show!");

        // OK Action Block
        def selectedOption = MessageBox.showConfirmDialog(
            showEDTConfirmButton.scene,
            "{userName}, do you like \"JavaFX\"?",
            "JavaFX - Confirm", ["Yes", "No"]);

        if("Yes".equals(selectedOption)) {
            textBox.text = "Cool! {userName} likes JavaFX!";
        } else {
            textBox.text = "Oh! No! {userName} don't like JavaFX!";
        }

        println("After Modal-Dialog Show!");
    }
}

def showEDTMessageButton : Button = Button {

    text: "Message"

    action: function() {

        println("Before Modal-Dialog Show!");

        MessageBox.showMessageDialog(
            showEDTMessageButton.scene,
            "{textBox.text}",
            "JavaFX - Message");

        println("After Modal-Dialog Show!");
    }
}

def edtButtonBox = HBox {
    spacing: 5
    content: [
        Label { text: "Block EDT: " },
        showEDTInputButton, showEDTConfirmButton, showEDTMessageButton
    ]
}

//
// Using Function Branch Approach
//
def showBranchButton : Button = Button {

    text: "Modal Dialog - No Block"

    action: function() {

        // OK Action Block
        def okAction = function(input : String) : Void {

            userName = input;

            MessageBox.showOptionsDialog(
                showBranchButton.scene,
                "{userName}, do you like \"JavaFX\"?",
                "JavaFX - Confirm", ["Yes", "No"],
                [ yesAction, noAction ]);
        };

        MessageBox.showInputDialog(
            showBranchButton.scene, "What is your Name?",
            "JavaFX - Input", okAction
        );

        // Yes Action Block
        def yesAction = function() {
            MessageBox.showMessageDialog(
                showBranchButton.scene,
                "Cool! {userName} likes JavaFX!",
                "JavaFX - Message", null);
        }

        // No Action Block
        def noAction = function() {
            MessageBox.showMessageDialog(
                showBranchButton.scene,
                "Oh! No! {userName} don't like JavaFX!",
                "JavaFX - Message", null);
        }
    }
}

Stage {

    title: "JavaFX Modal Dialog"

    scene: Scene {

        width: 300
        height: 200

        content: VBox {
            layoutX: 20
            layoutY: 20
            spacing: 20
            content: [
                textBox,
                edtButtonBox,
                showBranchButton
            ]
        }
    }
}
