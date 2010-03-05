/*
 * InputForm.fx
 *
 * Created on Dec 11, 2009, 3:32:47 PM
 */

package javafxdatabase.view;

import javafx.scene.layout.Panel;
import javafx.scene.control.Label;
import javafx.scene.control.TextBox;
import javafx.scene.control.Button;
import javafxdatabase.modal.Customer;
import javafxdatabase.Main;
import javafx.stage.Alert;
import javafx.scene.layout.Container;

/**
 * @author Rakesh Menon
 */

public class InputForm extends Container {

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
    var stateText = TextBox { columns: 3 };
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

    init {

        customer = new Customer();
        
        content = [
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
        ];
    }

    var performLayout = true;
    override function doLayout() : Void {

        if(not performLayout) { return; }
        performLayout = false;

        var hSpacing = 10.0;
        var vSpacing = 5.0;
        var gridW = 80.0;
        var gridH = 25.0;

        idLabel.height = gridH;
        var w = panel.getNodePrefWidth(idLabel);
        var x = (paddingLeft + gridW) - w;
        var y = paddingTop;
        var h = gridH;
        panel.layoutNode(idLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = panel.getNodePrefWidth(idText);
        panel.layoutNode(idText, x, y, w, h);

        w = panel.getNodePrefWidth(nameLabel);
        x = (paddingLeft + gridW) - w;
        y = idLabel.layoutY + gridH + vSpacing;
        panel.layoutNode(nameLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = panel.getNodePrefWidth(nameText);
        panel.layoutNode(nameText, x, y, w, h);

        w = panel.getNodePrefWidth(addressLabel);
        x = (paddingLeft + gridW) - w;
        y = nameLabel.layoutY + gridH + vSpacing;
        panel.layoutNode(addressLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        y = addressLabel.layoutY;
        w = panel.getNodePrefWidth(address1Text);
        panel.layoutNode(address1Text, x, y, w, h);

        y = address1Text.layoutY + gridH + vSpacing;
        w = panel.getNodePrefWidth(address2Text);
        panel.layoutNode(address2Text, x, y, w, h);

        w = panel.getNodePrefWidth(cityLabel);
        x = (paddingLeft + gridW) - w;
        y = address2Text.layoutY + gridH + vSpacing;
        panel.layoutNode(cityLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = panel.getNodePrefWidth(cityText);
        panel.layoutNode(cityText, x, y, w, h);

        w = panel.getNodePrefWidth(stateLabel);
        x = (paddingLeft + gridW) - w;
        y = cityLabel.layoutY + gridH + vSpacing;
        panel.layoutNode(stateLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = panel.getNodePrefWidth(stateText);
        panel.layoutNode(stateText, x, y, w, h);

        w = panel.getNodePrefWidth(zipLabel);
        x = (paddingLeft + gridW) - w;
        y = stateLabel.layoutY + gridH + vSpacing;
        panel.layoutNode(zipLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = panel.getNodePrefWidth(zipText);
        panel.layoutNode(zipText, x, y, w, h);

        w = panel.getNodePrefWidth(phoneLabel);
        x = (paddingLeft + gridW) - w;
        y = zipLabel.layoutY + gridH + vSpacing;
        panel.layoutNode(phoneLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = panel.getNodePrefWidth(phoneText);
        panel.layoutNode(phoneText, x, y, w, h);

        w = panel.getNodePrefWidth(emailLabel);
        x = (paddingLeft + gridW) - w;
        y = phoneLabel.layoutY + gridH + vSpacing;
        panel.layoutNode(emailLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = panel.getNodePrefWidth(emailText);
        panel.layoutNode(emailText, x, y, w, h);

        w = panel.getNodePrefWidth(creditLimitLabel);
        x = (paddingLeft + gridW) - w;
        y = emailLabel.layoutY + gridH + vSpacing;
        panel.layoutNode(creditLimitLabel, x, y, w, h);

        x = paddingLeft + gridW + hSpacing;
        w = panel.getNodePrefWidth(creditLimitText);
        panel.layoutNode(creditLimitText, x, y, w, h);

        w = panel.getNodePrefWidth(cancelButton);
        var buttonPanelWidth = (w * 2) + hSpacing;
        x = (width - buttonPanelWidth)/2.0;
        y = creditLimitLabel.layoutY + (gridH * 2);
        
        panel.layoutNode(saveButton, x, y, w, h);

        x = saveButton.layoutX + hSpacing + w;
        panel.layoutNode(cancelButton, x, y, w, h);
    }
}
