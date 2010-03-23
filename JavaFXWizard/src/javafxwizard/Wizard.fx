/*
 * Wizard.fx
 *
 * Created on Mar 19, 2010, 4:23:36 PM
 */

package javafxwizard;

import javafx.scene.Group;
import javafx.scene.layout.Container;
import javafx.scene.shape.Rectangle;
import javafx.scene.control.Button;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.util.Math;
import javafx.scene.layout.LayoutInfo;

/**
 * @author Rakesh Menon
 */

public class Wizard extends Container {

    public var panels: WizardPanel[] on replace {
        if((sizeof panels) > 0) {
            selectedIndex = 0;
        }
        for(panel in panels) {
            panel.wizard = this;
        }
    }

    // This instance will be updated based on selected-index
    var selectedPanel : WizardPanel;

    public-read var selectedIndex = -1 on replace {
        if((selectedIndex >= 0) and (selectedIndex < (sizeof panels))) {
            selectedPanel = panels[selectedIndex];
            layoutNode(selectedPanel, 0, 0, width, height - outerBorder.height);
        }
    }

    def outerBorder = Rectangle {
        fill: Theme.outerBorderFill
        height: 80
    }
    def innerBorder = Rectangle {
        x: 2
        fill: Theme.innerBorderFill
        height: 76
    }
    def body = Rectangle {
        x: 4
        fill: Theme.bodyFill
        height: 72
    }

    public-read def backButton = Button {
        text: "< Back"
        action: function() {
            selectedIndex--;
        }
        disable: bind (selectedIndex <= 0)
    }

    public-read def nextButton = Button {
        text: "Next >"
        action: function() {
            selectedIndex++;
        }
        disable: bind (selectedIndex >= ((sizeof panels) - 1))
    }
    
    public-read def cancelButton = Button {
        text: "Cancel"
        action: function() {
            if("{__PROFILE__}" == "browser") {
                selectedIndex = 0;
            } else {
                scene.stage.close();
            }
        }
    }

    def buttons = [ backButton, cancelButton, nextButton ];

    // bind with content, since value of selectedPanel will change
    override var content = bind [
        outerBorder, innerBorder, body,
        selectedPanel, buttons
    ];
    
    override function doLayout() : Void {

        var buttonHeight = getNodePrefHeight(cancelButton);
        var buttonWidth = getMaxButtonWidth();

        outerBorder.height = buttonHeight + 14;
        outerBorder.y = height - outerBorder.height;
        outerBorder.width = width;

        innerBorder.y = outerBorder.y + 2;
        innerBorder.width = width - 4;
        innerBorder.height = outerBorder.height - 4;

        body.y = innerBorder.y + 2;
        body.width = width - 8;
        body.height = outerBorder.height - 8;

        layoutNode(selectedPanel, 0, 0, width, height - outerBorder.height);
        
        var space = 10;
        var cancelSpace = 50;

        var buttonX = width - ((buttonWidth + space) * 3) - cancelSpace;
        layoutNode(backButton, buttonX, body.y + 4, buttonWidth,
            buttonHeight, HPos.CENTER, VPos.CENTER);

        buttonX += (buttonWidth + space);
        layoutNode(nextButton, buttonX, body.y + 4, buttonWidth,
            buttonHeight, HPos.CENTER, VPos.CENTER);

        buttonX += (buttonWidth + cancelSpace);
        layoutNode(cancelButton, buttonX, body.y + 4, buttonWidth,
            buttonHeight, HPos.CENTER, VPos.CENTER);
    }

    function getMaxButtonWidth() : Number {

        var maxWidth = 0.0;

        for(button in buttons) {
            maxWidth = Math.max(maxWidth, getNodePrefWidth(button));
        }

        return maxWidth;
    }

}
