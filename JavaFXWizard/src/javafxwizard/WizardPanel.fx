/*
 * WizardPanel.fx
 *
 * Created on Mar 19, 2010, 4:04:45 PM
 */

package javafxwizard;

import javafx.scene.layout.Container;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;
import javafx.scene.shape.Rectangle;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.transform.Scale;
import javafx.util.Math;

/**
 * @author Rakesh Menon
 */

public class WizardPanel extends Container {

    public-init var graphic: Node;
    public-init var title: String;
    public-init var text: String;
    public var wizard : Wizard;

    def outerBorder = Rectangle {
        fill: Theme.outerBorderFill
    }
    def innerBorder = Rectangle {
        x: 2
        y: 2
        fill: Theme.innerBorderFill
    }
    def body = Rectangle {
        x: 4
        y: 4
        fill: Theme.bodyFill
    }
    def graphicBody = Rectangle {
        fill: Theme.outerBorderFill
        stroke: Color.WHITE
        strokeWidth: 5
        width: 150
    }

    def titleView = Text {
        textOrigin: TextOrigin.TOP
        content: bind title
        font: Theme.titleFont
    }
    def textView = Text {
        textOrigin: TextOrigin.TOP
        content: bind text
    }

    def titleBG = Rectangle {
        fill: Theme.bodyFill
        stroke: Color.WHITE
        strokeWidth: 1
    }

    init {
        content = [
            outerBorder, innerBorder,
            body, graphicBody, titleBG,
            graphic, titleView, textView
        ]
    }

    override function doLayout() : Void {

        outerBorder.width = width;
        outerBorder.height = height;

        innerBorder.width = width - 4;
        innerBorder.height = height - 4;

        body.width = width - 8;
        body.height = height - 8;

        graphicBody.x = body.x + 10;
        graphicBody.y = body.y + 10;
        graphicBody.height = body.height - 20;

        /**
         * Some not so interesting calculations just
         * to resize and center align the graphic node
         */
        var graphicW = getNodePrefWidth(graphic);
        var graphicH = getNodePrefHeight(graphic);
        var graphicScaleX = (graphicBody.width - 20)/graphicW;
        var graphicScaleY = (graphicBody.height - 20)/graphicH;
        var scale = Math.min(graphicScaleX, graphicScaleY);

        // Scale the graphic node to fit into graphic area
        graphicW = getNodePrefWidth(graphic) * scale;
        graphicH = getNodePrefHeight(graphic) * scale;
        graphic.transforms = Scale { x: scale y: scale };
        
        graphic.layoutX = graphicBody.x + (graphicBody.width - graphicW)/2.0;
        graphic.layoutY = graphicBody.y + (graphicBody.height - graphicH)/2.0;

        titleBG.x = graphicBody.x + graphicBody.width + 2;
        titleBG.y = graphicBody.y + 10;
        titleBG.width = width - titleBG.x - 10;
        titleBG.height = getNodePrefHeight(titleView) + 4;
        
        titleView.layoutX = titleBG.x + 10;
        titleView.layoutY = titleBG.y + 4;

        textView.layoutX = titleView.layoutX;
        textView.layoutY = titleBG.y + titleBG.height + 10;
        textView.wrappingWidth = titleBG.width - 10;
    }
}
