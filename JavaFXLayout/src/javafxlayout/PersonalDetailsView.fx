/*
 * PersonalDetailsView.fx
 *
 * Created on 8 Mar, 2010, 9:31:32 AM
 */

package javafxlayout;

import javafx.scene.control.Label;
import javafx.scene.control.TextBox;
import javafx.scene.layout.Container;
import javafx.scene.control.Button;
import javafx.util.Math;

/**
 * @author Rakesh Menon
 */

public class PersonalDetailsView extends Container {

    def lastNameLabel = Label { text: "Last Name" };
    def firstNameLabel = Label { text: "First Name" };
    def emailLabel = Label { text: "Email" };
    def phoneLabel = Label { text: "Phone" };
    def address1Label = Label { text: "Address 1" };
    def address2Label = Label { text: "Address 2" };
    def cityLabel = Label { text: "City" };
    def stateLabel = Label { text: "State" };
    def postalCodeLabel = Label { text: "Postal Code" };
    def countryLabel = Label { text: "Country" };
    def labelArray = [
        lastNameLabel, firstNameLabel, emailLabel,
        phoneLabel, address1Label, address2Label,
        cityLabel, stateLabel, postalCodeLabel, countryLabel
    ];

    def lastNameText = TextBox { text: "Last Name" };
    def firstNameText = TextBox { text: "First Name" };
    def emailText = TextBox { text: "Email" };
    def phoneText = TextBox { text: "Phone" };
    def address1Text = TextBox { text: "Address 1" };
    def address2Text = TextBox { text: "Address 2" };
    def cityText = TextBox { text: "City" };
    def stateText = TextBox { text: "State" };
    def postalCodeText = TextBox { text: "Postal Code" };
    def countryText = TextBox { text: "Country" };

    def newButton = Button { text: "New" };
    def deleteButton = Button { text: "Delete" };
    def editButton = Button { text: "Edit" };
    def saveButton = Button { text: "Save" };
    def cancelButton = Button { text: "Cancel" };
    
    def buttonArray = [
        newButton, deleteButton, editButton, saveButton
    ];
    
    init {
        content = [
            labelArray,
            lastNameText, firstNameText,
            emailText, phoneText,
            address1Text, address2Text,
            cityText, stateText,
            postalCodeText, countryText,
            buttonArray, cancelButton
        ]
    }

    override function doLayout() : Void {

        /**
         * Layout Settings
         */
        def paddingX = 10.0;
        def paddingY = 5.0;
        def labelColumnWidth = getLabelColumnWidth();
        def rowHeight = getNodePrefHeight(lastNameText);
        def viewWidth = width - (5 * paddingX);
        def textColumnWidth = (viewWidth - (2 * labelColumnWidth))/2.0;

        /**
         * Layout Last-Name & First-Name
         */
        var x = paddingX;
        var y = paddingY;
        layoutNode(lastNameLabel, x, y, labelColumnWidth, rowHeight);
        x = x + labelColumnWidth + paddingX;
        layoutNode(lastNameText, x, y, textColumnWidth, rowHeight);
        x = x + textColumnWidth + paddingX;
        layoutNode(firstNameLabel, x, y, labelColumnWidth, rowHeight);
        x = x + labelColumnWidth + paddingX;
        layoutNode(firstNameText, x, y, textColumnWidth, rowHeight);

        /**
         * Layout Phone & Email
         */
        x = paddingX;
        y = y + rowHeight + paddingY;
        layoutNode(phoneLabel, x, y, labelColumnWidth, rowHeight);
        x = x + labelColumnWidth + paddingX;
        layoutNode(phoneText, x, y, textColumnWidth, rowHeight);
        x = x + textColumnWidth + paddingX;
        layoutNode(emailLabel, x, y, labelColumnWidth, rowHeight);
        x = x + labelColumnWidth + paddingX;
        layoutNode(emailText, x, y, textColumnWidth, rowHeight);

        /**
         * Layout Address
         * Note: Width of Address TextBox spans entire view
         * Space before Label + Space after Label + Space after TextBox = (3* paddingX)
         */
        def addressTextWidth = width - labelColumnWidth - (3 * paddingX);
        
        x = paddingX;
        y = y + rowHeight + paddingY;
        layoutNode(address1Label, x, y, labelColumnWidth, rowHeight);
        x = x + labelColumnWidth + paddingX;
        layoutNode(address1Text, x, y, addressTextWidth, rowHeight);

        x = paddingX;
        y = y + rowHeight + paddingY;
        layoutNode(address2Label, x, y, labelColumnWidth, rowHeight);
        x = x + labelColumnWidth + paddingX;
        layoutNode(address2Text, x, y, addressTextWidth, rowHeight);

        /**
         * Layout City
         */
        x = paddingX;
        y = y + rowHeight + paddingY;
        layoutNode(cityLabel, x, y, labelColumnWidth, rowHeight);
        x = x + labelColumnWidth + paddingX;
        layoutNode(cityText, x, y, textColumnWidth, rowHeight);

        /**
         * Layout State & Postal Code
         */
        x = paddingX;
        y = y + rowHeight + paddingY;
        layoutNode(stateLabel, x, y, labelColumnWidth, rowHeight);
        x = x + labelColumnWidth + paddingX;
        layoutNode(stateText, x, y, textColumnWidth, rowHeight);
        x = x + textColumnWidth + paddingX;
        layoutNode(postalCodeLabel, x, y, labelColumnWidth, rowHeight);
        x = x + labelColumnWidth + paddingX;
        layoutNode(postalCodeText, x, y, textColumnWidth, rowHeight);

        /**
         * Layout Country
         */
        x = paddingX;
        y = y + rowHeight + paddingY;
        layoutNode(countryLabel, x, y, labelColumnWidth, rowHeight);
        x = x + labelColumnWidth + paddingX;
        layoutNode(countryText, x, y, textColumnWidth, rowHeight);

        /**
         * Layout Buttons as in HBox
         */
        x = paddingX;
        y = y + rowHeight + (paddingY * 3);
        def buttonWidth = getButtonWidth();
        def buttonHeight = getNodePrefHeight(buttonArray[0]);
        
        for(button in buttonArray) {
            layoutNode(button, x, y, buttonWidth, buttonHeight);
            x = x + buttonWidth + paddingX;
        }

        /**
         * Right Align "Cancel" Button
         */
        x = width - buttonWidth - paddingX;
        layoutNode(cancelButton, x, y, buttonWidth, buttonHeight);
    }

    /**
     * Return width as label with maximum width
     */
    function getLabelColumnWidth() : Number {
        var columnWidth = 0.0;
        for(label in labelArray) {
            columnWidth = Math.max(
                getNodePrefWidth(label), columnWidth);
        }
        columnWidth;
    }

    /**
     * Return width as button with maximum width
     */
    function getButtonWidth() : Number {
        var buttonWidth = 0.0;
        for(button in buttonArray) {
            buttonWidth = Math.max(
                getNodePrefWidth(button), buttonWidth);
        }
        Math.max(buttonWidth, getNodePrefWidth(cancelButton));
    }
}
