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

/**
 * @author Rakesh Menon
 */

//
// Using Block EDT Approach
//
def showEDTButton : Button = Button {
    
    text: "Modal Dialog - Block EDT"

    action: function() {

        println("Before Modal-Dialog Show!");

        def userName = MessageBox.showInputDialog(
            showEDTButton.scene, "What is your Name?",
            "JavaFX - Input"
        );

        // OK Action Block
        def selectedOption = MessageBox.showConfirmDialog(
            showEDTButton.scene, "{userName}, do you like \"JavaFX\"?",
            "JavaFX - Confirm", ["Yes", "No"]);

        if("Yes".equals(selectedOption)) { // Yes Action Block
            MessageBox.showMessageDialog(
                showEDTButton.scene, "Cool! {userName} likes JavaFX!",
                "JavaFX - Message");
        } else { // No Action Block
            MessageBox.showMessageDialog(
                showEDTButton.scene, "Oh! No! {userName} don't like JavaFX!",
                "JavaFX - Message");
        }
        
        println("After Modal-Dialog Show!");
    }
}

//
// Using Function Branch Approach
//
def showBranchButton : Button = Button {

    text: "Modal Dialog - No Block"

    action: function() {

        var userName : String = "";

        // OK Action Block
        def okAction = function(input : String) : Void {

            userName = input;

            MessageBox.showOptionsDialog(
                showBranchButton.scene, "{userName}, do you like \"JavaFX\"?",
                "JavaFX - Confirm", ["Yes", "No"],
                [ yesAction, noAction ]);
        };

        MessageBox.showInputDialog(
            showEDTButton.scene, "What is your Name?",
            "JavaFX - Input", okAction
        );

        // Yes Action Block
        def yesAction = function() {
            MessageBox.showMessageDialog(
                showBranchButton.scene, "Cool! {userName} likes JavaFX!",
                "JavaFX - Message", null);
        }

        // No Action Block
        def noAction = function() {
            MessageBox.showMessageDialog(
                showBranchButton.scene, "Oh! No! {userName} don't like JavaFX!",
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
            spacing: 10
            content: [
                TextBox { text: "JavaFX Modal Dialog" },
                showEDTButton,
                showBranchButton
            ]
        }
    }
}
