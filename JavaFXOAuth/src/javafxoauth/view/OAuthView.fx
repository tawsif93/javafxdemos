/*
 * OAuthView.fx
 *
 * Created on Apr 12, 2010, 11:08:13 AM
 */

package javafxoauth.view;

import javafx.scene.control.ToggleGroup;
import javafx.scene.control.RadioButton;
import javafx.scene.control.Label;
import javafx.scene.control.TextBox;
import javafx.scene.control.Button;
import javafx.scene.layout.Container;
import javafx.scene.layout.HBox;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.paint.Stop;
import javafx.scene.paint.LinearGradient;
import javafx.scene.text.Font;
import javafx.data.Pair;
import javafx.util.Math;

import javafx.ext.swing.SwingComponent;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

import javafxoauth.api.OAuthAPI;

public class OAuthView extends Container {

    var oauthAPI:OAuthAPI;

    def background = Rectangle {
        fill: Color.WHITE
    }

    def titleBG = Rectangle {
        fill: LinearGradient {
            startX: 0.0 startY: 0.0
            endX: 0.0 endY: 1.0
            proportional: true
            stops: [
                Stop { offset: 0 color: Color.web("#A3B4C2") },
                Stop { offset: 0.5 color: Color.web("#6A819F") },
                Stop { offset: 1.0 color: Color.web("#60718C") }
            ]
        }
    }

    def titleLabel = Label {
        text: "Open Authorization [ OAuth ]"
        font: Font { size: 14 }
        textFill: Color.WHITE
    }

    def serviceProviderGroup = ToggleGroup { };

    def radioBox = HBox {
        spacing: 10
        content: [
            RadioButton { text: "Twitter" toggleGroup: serviceProviderGroup selected: true },
            RadioButton { text: "LinkedIn" toggleGroup: serviceProviderGroup },
            RadioButton { text: "Yahoo" toggleGroup: serviceProviderGroup }
        ];
    };

    def consumerKeyLabel = Label {
        text: "oauth_consumer_key:"
    }
    def consumerKeyText = TextBox {
        promptText: "oauth_consumer_key"
    }

    def consumerSecretLabel = Label {
        text: "oauth_consumer_secret:"
    }
    def consumerSecretText = TextBox {
        promptText: "oauth_consumer_secret"
    }

    def verifierLabel = Label {
        text: "oauth_verifier:"
    }
    def verifierText = TextBox {
        promptText: "oauth_verifier"
        disable: true
    }

    def actionButton : Button = Button {
        text: "Request Token"
        action: handleButtonAction
    }

    def textArea = new JTextArea();
    def scrollPane = new JScrollPane(textArea);
    def console = SwingComponent.wrap(scrollPane);

    init {

        textArea.setBorder(null);
        textArea.setColumns(12);
        textArea.setEditable(false);
        textArea.setWrapStyleWord(true);

        scrollPane.setHorizontalScrollBarPolicy(
            JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        scrollPane.setVerticalScrollBarPolicy(
            JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        
        content = [
            background, titleBG, titleLabel, radioBox,
            consumerKeyLabel, consumerKeyText,
            consumerSecretLabel, consumerSecretText,
            verifierLabel, verifierText, console,
            actionButton
        ];
    }

    override function doLayout() : Void {

        def margin = 10.0;

        background.width = width;
        background.height = height;
        
        var x = margin;
        var y = margin;
        var w = (width - (margin * 2));
        var h = getNodePrefHeight(titleLabel);

        titleBG.width = width;
        titleBG.height = h + (margin * 2);

        layoutNode(titleLabel, x, y, w, h);

        y += (titleBG.height);
        h = getNodePrefHeight(radioBox);
        layoutNode(radioBox, x, y, w, h);

        var labelW = Math.max(
            getNodePrefWidth(consumerKeyLabel),
            getNodePrefWidth(consumerSecretLabel)
        );
        var textW = (width - labelW - (margin * 3));

        w = labelW;
        y += (h + margin);
        h = getNodePrefHeight(consumerKeyText);

        layoutNode(consumerKeyLabel, x, y, w, h);
        layoutNode(consumerKeyText, x + w + margin, y, textW, h);

        y += (h + margin);

        layoutNode(consumerSecretLabel, x, y, w, h);
        layoutNode(consumerSecretText, x + w + margin, y, textW, h);

        y += (h + margin);

        layoutNode(verifierLabel, x, y, w, h);
        layoutNode(verifierText, x + w + margin, y, textW, h);

        w = (width - (margin * 2))/2.0;
        h = getNodePrefHeight(actionButton);
        y += (h + margin);
        x = (width - w)/2.0;
        layoutNode(actionButton, x, y, w, h);

        x = margin;
        y += (h + margin);
        h = (height - y - margin);
        w = (width - (margin * 2));
        
        scrollPane.setSize(w, h);
        layoutNode(console, x, y, w, h);
    }
    
    function handleButtonAction() : Void {

        if("Request Token".equals(actionButton.text)) {

            verifierText.text = "";
            verifierText.disable = true;
            consumerKeyText.disable = true;
            consumerSecretText.disable = true;
            actionButton.disable = true;

            oauthAPI = OAuthAPI.getInstance(
                serviceProviderGroup.selectedButton.text,
                consumerKeyText.rawText,
                consumerSecretText.rawText
            );
            oauthAPI.onRequestToken = onRequestToken;
            oauthAPI.onAccessToken = onAccessToken;

            oauthAPI.requestToken();

        } else if("Access Token".equals(actionButton.text)) {

            consumerKeyText.disable = true;
            consumerSecretText.disable = true;
            verifierText.disable = true;
            actionButton.disable = true;

            oauthAPI.accessToken(verifierText.rawText);
        }
    }

    function onRequestToken(response:String) : Void {

        println(response);
        textArea.append("\n[RequestToken] {response}\n");

        def args : Pair[] = oauthAPI.decodeParameters(response);
        for(arg in args) {
            textArea.append("{arg.name} = {arg.value}\n");
        }
        textArea.append("\n");

        if(oauthAPI.browserURL != null) {

            textArea.append("Please visit below URL\n");
            textArea.append("\"{oauthAPI.browserURL}\"\n");
            textArea.append("to grant permission for this application\n");
            textArea.append("and obtain \"oauth_verifier\" number.\n");
            textArea.append("Enter the number in above TextBox.\n");
            textArea.append("and click \"Access Token\"\n");

            verifierText.disable = false;
            actionButton.disable = false;
            actionButton.text = "Access Token";

            verifierText.requestFocus();

        } else {

            consumerKeyText.disable = false;
            consumerSecretText.disable = false;
            verifierText.disable = true;
            actionButton.disable = false;
            actionButton.text = "Request Token";

            consumerKeyText.requestFocus();
        }
    }

    function onAccessToken(response:String) : Void {

        consumerKeyText.disable = false;
        consumerSecretText.disable = false;
        verifierText.disable = true;
        actionButton.disable = false;
        actionButton.text = "Request Token";

        println(response);

        textArea.append("\n[AccessToken] {response}\n");
        def args : Pair[] = oauthAPI.decodeParameters(response);
        for(arg in args) {
            textArea.append("{arg.name} = {arg.value}\n");
        }
        textArea.append("\n");

        consumerKeyText.requestFocus();
    }
}
