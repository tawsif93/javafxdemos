/*
 * InputForm.fx
 *
 * Created on Dec 11, 2009, 3:32:47 PM
 */

package javafxdatabase.view;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.layout.Panel;
import javafx.scene.control.Label;
import javafx.scene.control.TextBox;
import javafx.scene.control.Button;
import javafxdatabase.modal.Customer;
import javafxdatabase.Main;
import javafx.stage.Alert;

/**
 * @author Rakesh Menon
 */

public class InputForm extends CustomNode {

    public var customer : Customer on replace {
        if(customer != null) {
            idText.text = "{customer.getCustomerID()}";
            nameText.text = "{customer.getName()}";
            address1Text.text = "{customer.getAddressLine1()}";
            address2Text.text = "{customer.getAddressLine2()}";
            cityText.text = "{customer.getCity()}";
            stateText.text = "{customer.getState()}";
            zipText.text = "{customer.getZip()}";
            phoneText.text = "{customer.getPhone()}";
            emailText.text = "{customer.getEmail()}";
            creditLimitText.text = "{customer.getCreditLimit()}";
        }
    }

    public var edit = false;

    var paddingTop = 20.0;
    var paddingLeft = 20.0;
    var paddingBottom = 20.0;
    var paddingRight = 20.0;

    var panel : Panel;

    var idLabel = Label { text: "ID" };
    var idText = TextBox { columns: 4 editable: bind (not edit) };
    var nameLabel = Label { text: "Name" };
    var nameText = TextBox { columns: 20 };
    var addressLabel = Label { text: "Address" };
    var address1Text = TextBox { columns: 20 };
    var address2Text = TextBox { columns: 20 };
    var cityLabel = Label { text: "City" };
    var cityText = TextBox { columns: 15 };
    var stateLabel = Label { text: "State" };
    var stateText = TextBox { columns: 2 };
    var zipLabel = Label { text: "Zip" };
    var zipText = TextBox { columns: 10 };
    var phoneLabel = Label { text: "Phone" };
    var phoneText = TextBox { columns: 12 };
    var emailLabel = Label { text: "E-Mail" };
    var emailText = TextBox { columns: 20 };
    var creditLimitLabel = Label { text: "Credit Limit" };
    var creditLimitText = TextBox { columns: 10 };

    var saveButton = Button { 
        text: "Save"
        action: function() {

            try {

                customer.setCustomerID(Integer.parseInt(idText.rawText));
                customer.setName(nameText.rawText);
                customer.setAddressLine1(address1Text.rawText);
                customer.setAddressLine2(address2Text.rawText);
                customer.setCity(cityText.rawText);
                customer.setState("{stateText.rawText}");
                customer.setZip(zipText.rawText);
                customer.setPhone(phoneText.rawText);
                customer.setEmail(emailText.rawText);
                customer.setCreditLimit(Integer.parseInt(creditLimitText.rawText));

                if(edit) {
                    Main.dbUtils.editCustomer(customer);
                    Main.customerTable.setRow(customer, Main.customerTable.selectedIndex);
                } else {
                    Main.dbUtils.saveCustomer(customer);
                    Main.customerTable.addRow(customer);
                }

                Main.inputFormWindow.visible = false;

            } catch (e : java.lang.Exception) {
                Alert.inform("Save - Customer", "{e.getMessage()}");
                //e.printStackTrace();
            }
        }
    }

    var cancelButton = Button {
        text: "Cancel"
        action: function() {
            Main.inputFormWindow.visible = false;
        }
    }

    override function create() : Node {

        customer = new Customer();
        
        panel = Panel {
            content: [
                idLabel, idText,
                nameLabel, nameText,
                addressLabel, address1Text, address2Text,
                cityLabel, cityText,
                stateLabel, stateText,
                zipLabel, zipText,
                phoneLabel, phoneText,
                emailLabel, emailText,
                creditLimitLabel, creditLimitText,
                saveButton, cancelButton
            ]
            onLayout: onLayout
        }
    }

    var performLayout = true;
    function onLayout() : Void {

        if(not performLayout) { return; }
        performLayout = false;

        var hSpacing = 10.0;
        var vSpacing = 5.0;
        var gridW = 80.0;
        var gridH = 25.0;

        idLabel.height = gridH;
        var x = (paddingLeft + gridW) - idLabel.layoutBounds.width;
        var y = paddingTop;
        var w = idLabel.layoutBounds.width;
        var h = gridH;
        panel.layoutNode(idLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = idText.width;
        panel.layoutNode(idText, x, y, w, h);

        x = (paddingLeft + gridW) - nameLabel.layoutBounds.width;
        y = idLabel.layoutY + gridH + vSpacing;
        w = nameLabel.layoutBounds.width;
        panel.layoutNode(nameLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = nameText.width;
        panel.layoutNode(nameText, x, y, w, h);

        x = (paddingLeft + gridW) - addressLabel.layoutBounds.width;
        y = nameLabel.layoutY + gridH + vSpacing;
        w = addressLabel.layoutBounds.width;
        panel.layoutNode(addressLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        y = addressLabel.layoutY;
        w = address1Text.width;
        panel.layoutNode(address1Text, x, y, w, h);

        y = address1Text.layoutY + gridH + vSpacing;
        w = address2Text.width;
        panel.layoutNode(address2Text, x, y, w, h);
        
        x = (paddingLeft + gridW) - cityLabel.layoutBounds.width;
        y = address2Text.layoutY + gridH + vSpacing;
        w = cityLabel.layoutBounds.width;
        panel.layoutNode(cityLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = cityText.width;
        panel.layoutNode(cityText, x, y, w, h);

        x = (paddingLeft + gridW) - stateLabel.layoutBounds.width;
        y = cityLabel.layoutY + gridH + vSpacing;
        w = stateLabel.layoutBounds.width;
        panel.layoutNode(stateLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = stateText.width;
        panel.layoutNode(stateText, x, y, w, h);

        x = (paddingLeft + gridW) - zipLabel.layoutBounds.width;
        y = stateLabel.layoutY + gridH + vSpacing;
        w = zipLabel.layoutBounds.width;
        panel.layoutNode(zipLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = zipText.width;
        panel.layoutNode(zipText, x, y, w, h);

        x = (paddingLeft + gridW) - phoneLabel.layoutBounds.width;
        y = zipLabel.layoutY + gridH + vSpacing;
        w = phoneLabel.layoutBounds.width;
        panel.layoutNode(phoneLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = phoneText.width;
        panel.layoutNode(phoneText, x, y, w, h);

        x = (paddingLeft + gridW) - emailLabel.layoutBounds.width;
        y = phoneLabel.layoutY + gridH + vSpacing;
        w = emailLabel.layoutBounds.width;
        panel.layoutNode(emailLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = emailText.width;
        panel.layoutNode(emailText, x, y, w, h);
        
        x = (paddingLeft + gridW) - creditLimitLabel.layoutBounds.width;
        y = emailLabel.layoutY + gridH + vSpacing;
        w = creditLimitLabel.layoutBounds.width;
        panel.layoutNode(creditLimitLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = creditLimitText.width;
        panel.layoutNode(creditLimitText, x, y, w, h);

        var buttonPanelWidth = (saveButton.width * 2) + hSpacing;
        x = (panel.boundsInLocal.width - buttonPanelWidth)/2.0;
        y = creditLimitLabel.layoutY + (gridH * 2);
        w = saveButton.width;
        panel.layoutNode(saveButton, x, y, w, h);

        x = saveButton.layoutX + hSpacing + saveButton.layoutBounds.width;
        panel.layoutNode(cancelButton, x, y, w, h);
    }
}
