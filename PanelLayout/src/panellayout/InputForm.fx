/*
 * InputForm.fx
 *
 * Created on Dec 11, 2009, 3:32:47 PM
 */

package panellayout;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.layout.Panel;
import javafx.scene.control.Label;
import javafx.scene.control.TextBox;
import javafx.scene.control.RadioButton;
import javafx.scene.control.ToggleGroup;
import javafx.scene.control.Button;

/**
 * @author Rakesh Menon
 */

public class InputForm extends CustomNode {

    def width = bind scene.width on replace {
        panel.requestLayout();
    }
    def height = bind scene.height on replace {
        panel.requestLayout();
    }

    var paddingTop = 20;
    var paddingLeft = 20;
    var paddingBottom = 20;
    var paddingRight = 20;

    var panel : Panel;

    var idLabel = Label { text: "ID" };
    var idText = TextBox { };
    var nameLabel = Label { text: "Name" };
    var nameText = TextBox { };
    var addressLabel = Label { text: "Address" };
    var address1Text = TextBox { };
    var address2Text = TextBox { };
    var address3Text = TextBox { };
    var address4Text = TextBox { };
    var emailLabel = Label { text: "E-Mail" };
    var emailText = TextBox { };
    var prefComnLabel = Label { text: "Preferred" };
    var prefComnToggle = ToggleGroup { };
    var smailRadio = RadioButton { text: "Snail Mail" selected: true toggleGroup: prefComnToggle };
    var emailRadio = RadioButton { text: "E-Mail" toggleGroup: prefComnToggle };
    var saveButton = Button { text: "Save" }
    var cancelButton = Button { text: "Cancel" }

    override function create() : Node {
        panel = Panel {
            content: [
                idLabel, idText,
                nameLabel, nameText,
                addressLabel, address1Text, address2Text,
                address3Text, address4Text,
                emailLabel, emailText,
                prefComnLabel, smailRadio, emailRadio,
                saveButton, cancelButton
            ]
            onLayout: onLayout
        }
    }

    function onLayout() : Void {

        var hSpacing = 10.0;
        var vSpacing = 5.0;
        var gridW = 50;
        var gridH = 25;

        idLabel.height = gridH;
        panel.positionNode(idLabel, (paddingLeft + gridW) - idLabel.layoutBounds.width, paddingTop);
        panel.resizeNode(idText, 50, gridH);
        panel.positionNode(idText, paddingLeft + gridW + hSpacing, paddingTop);

        nameLabel.height = gridH;
        panel.positionNode(nameLabel, (paddingLeft + gridW) - nameLabel.layoutBounds.width, idLabel.layoutY + gridH + vSpacing);
        panel.positionNode(nameText, paddingLeft + gridW + hSpacing, nameLabel.layoutY);
        panel.resizeNode(nameText, 150, gridH);

        addressLabel.height = gridH;
        panel.positionNode(addressLabel, (paddingLeft + gridW) - addressLabel.layoutBounds.width, nameLabel.layoutY + gridH + vSpacing);
        panel.positionNode(address1Text, paddingLeft + gridW + hSpacing, addressLabel.layoutY);
        panel.resizeNode(address1Text, scene.width - paddingLeft - paddingRight - gridW - hSpacing, gridH);
        panel.positionNode(address2Text, address1Text.layoutX, address1Text.layoutY + gridH + vSpacing);
        panel.resizeNode(address2Text, address1Text.layoutBounds.width, gridH);
        panel.positionNode(address3Text, address2Text.layoutX, address2Text.layoutY + gridH + vSpacing);
        panel.resizeNode(address3Text, address2Text.layoutBounds.width, gridH);
        panel.positionNode(address4Text, address3Text.layoutX, address3Text.layoutY + gridH + vSpacing);
        panel.resizeNode(address4Text, address3Text.layoutBounds.width, gridH);

        emailLabel.height = gridH;
        panel.positionNode(emailLabel, (paddingLeft + gridW) - emailLabel.layoutBounds.width, address4Text.layoutY + gridH + vSpacing);
        panel.positionNode(emailText, paddingLeft + gridW + hSpacing, emailLabel.layoutY);
        panel.resizeNode(emailText, 150, gridH);

        prefComnLabel.height = gridH;
        panel.positionNode(prefComnLabel, (paddingLeft + gridW) - prefComnLabel.layoutBounds.width, emailLabel.layoutY + gridH + vSpacing);
        smailRadio.height = gridH;
        panel.positionNode(smailRadio, paddingLeft + gridW + hSpacing, prefComnLabel.layoutY);
        emailRadio.height = gridH;
        panel.positionNode(emailRadio, smailRadio.layoutX + smailRadio.layoutBounds.width + hSpacing, prefComnLabel.layoutY);

        saveButton.width = cancelButton.width;
        var buttonPanelWidth = (saveButton.width * 2) + hSpacing;
        panel.positionNode(saveButton, (scene.width - buttonPanelWidth)/2.0, emailRadio.layoutY + (gridH * 2));
        
        panel.positionNode(cancelButton, saveButton.layoutX + hSpacing + saveButton.layoutBounds.width, saveButton.layoutY);
    }
}
