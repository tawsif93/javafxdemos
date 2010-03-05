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

    var paddingTop = 20.0;
    var paddingLeft = 20.0;
    var paddingBottom = 20.0;
    var paddingRight = 20.0;

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
        var gridW = 50.0;
        var gridH = 25.0;

        idLabel.height = gridH;
        var w = panel.getNodePrefWidth(idLabel);
        var x = (paddingLeft + gridW) - w;
        var y = paddingTop;
        var h = gridH;
        panel.layoutNode(idLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = 50;
        panel.layoutNode(idText, x, y, w, h);

        w = panel.getNodePrefWidth(nameLabel);
        x = (paddingLeft + gridW) - w;
        y = idLabel.layoutY + gridH + vSpacing;
        panel.layoutNode(nameLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = 150;
        panel.layoutNode(nameText, x, y, w, h);

        w = panel.getNodePrefWidth(addressLabel);
        x = (paddingLeft + gridW) - w;
        y = nameLabel.layoutY + gridH + vSpacing;
        panel.layoutNode(addressLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        y = addressLabel.layoutY;
        w = scene.width - paddingLeft - paddingRight - gridW - hSpacing;
        panel.layoutNode(address1Text, x, y, w, h);

        y = address1Text.layoutY + gridH + vSpacing;
        panel.layoutNode(address2Text, x, y, w, h);
        
        y = address2Text.layoutY + gridH + vSpacing;
        panel.layoutNode(address3Text, x, y, w, h);

        y = address3Text.layoutY + gridH + vSpacing;
        panel.layoutNode(address4Text, x, y, w, h);

        w = panel.getNodePrefWidth(emailLabel);
        x = (paddingLeft + gridW) - w;
        y = address4Text.layoutY + gridH + vSpacing;
        panel.layoutNode(emailLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = 120;
        panel.layoutNode(emailText, x, y, w, h);

        w = panel.getNodePrefWidth(prefComnLabel);
        x = (paddingLeft + gridW) - w;
        y = emailLabel.layoutY + gridH + vSpacing;
        panel.layoutNode(prefComnLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = panel.getNodePrefWidth(smailRadio);
        panel.layoutNode(smailRadio, x, y, w, h);

        x = smailRadio.layoutX + w + hSpacing;
        w = panel.getNodePrefWidth(emailRadio);
        panel.layoutNode(emailRadio, x, y, w, h);

        w = panel.getNodePrefWidth(cancelButton);
        var buttonPanelWidth = (w * 2) + hSpacing;
        x = (scene.width - buttonPanelWidth)/2.0;
        y = emailRadio.layoutY + (gridH * 2);
        panel.layoutNode(saveButton, x, y, w, h);

        x = saveButton.layoutX + hSpacing + w;
        panel.layoutNode(cancelButton, x, y, w, h);
    }
}
