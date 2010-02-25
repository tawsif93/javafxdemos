/*
 * WeatherView.fx
 *
 * Created on Feb 24, 2010, 10:05:42 AM
 */

package weather;

import javafx.scene.paint.Color;
import javafx.scene.input.MouseEvent;
import javafx.scene.image.Image;

/**
 * @author javafx
 */
public class WeatherView {

    public var weatherInfo = WeatherInfo { };
    public var onCityChange : function(String) : Void;
    public var closeButtonVisible = true;

    public-read var background: javafx.scene.shape.Rectangle;//GEN-BEGIN:main
    public-read var tempLabel: javafx.scene.control.Label;
    public-read var cityLabel: javafx.scene.control.Label;
    public-read var tempImageView: javafx.scene.image.ImageView;
    public-read var closeImageView: javafx.scene.image.ImageView;
    public-read var cityText: javafx.scene.control.TextBox;
    public-read var scene: javafx.scene.Scene;
    public-read var linearGradient: javafx.scene.paint.LinearGradient;
    public-read var tempFont: javafx.scene.text.Font;
    public-read var closeImage: javafx.scene.image.Image;
    
    public-read var currentState: org.netbeans.javafx.design.DesignState;
    
    // <editor-fold defaultstate="collapsed" desc="Generated Init Block">
    init {
        cityLabel = javafx.scene.control.Label {
            layoutX: 65.0
            layoutY: 106.0
            width: 175.0
            height: 15.0
            layoutInfo: javafx.scene.layout.LayoutInfo {
                width: bind cityLabel.width
                height: bind cityLabel.height
            }
            text: bind "{weatherInfo.locationCity}"
            textAlignment: javafx.scene.text.TextAlignment.RIGHT
            textWrap: true
            hpos: javafx.geometry.HPos.RIGHT
            textFill: Color.WHITE
        };
        tempImageView = javafx.scene.image.ImageView {
            image: bind getImage(weatherInfo.conditionCode)
        };
        cityText = javafx.scene.control.TextBox {
            visible: false
            layoutX: 67.0
            layoutY: 77.0
            width: 173.0
            height: 23.0
            layoutInfo: javafx.scene.layout.LayoutInfo {
                width: bind cityText.width
                height: bind cityText.height
            }
            promptText: "City"
            text: "Bangalore"
            action: cityTextAction
        };
        linearGradient = javafx.scene.paint.LinearGradient {
            endX: 0.0
            startY: 0.0
            stops: [ javafx.scene.paint.Stop { offset: 0.0, color: javafx.scene.paint.Color.web ("#9DBEEF") }, javafx.scene.paint.Stop { offset: 1.0, color: javafx.scene.paint.Color.web ("#2F73D3") }, ]
        };
        background = javafx.scene.shape.Rectangle {
            opacity: 1.0
            cursor: javafx.scene.Cursor.HAND
            layoutX: 60.0
            layoutY: 56.0
            onMouseClicked: rectangleOnMouseClicked
            onMouseDragged: rectangleOnMouseDragged
            onMousePressed: rectangleOnMousePressed
            fill: linearGradient
            stroke: Color.web("#4882D2")
            width: 190.0
            height: 67.0
            arcWidth: 10.0
            arcHeight: 10.0
        };
        tempFont = javafx.scene.text.Font {
            name: "sansserif"
            size: 40.0
            oblique: false
            embolden: false
            autoKern: false
            ligatures: false
        };
        tempLabel = javafx.scene.control.Label {
            layoutX: 157.0
            layoutY: 60.0
            width: 89.0
            height: 34.0
            layoutInfo: javafx.scene.layout.LayoutInfo {
                width: bind tempLabel.width
                height: bind tempLabel.height
                hpos: javafx.geometry.HPos.RIGHT
            }
            text: bind "{weatherInfo.conditionTemp}\u00B0"
            font: tempFont
            textAlignment: javafx.scene.text.TextAlignment.RIGHT
            hpos: javafx.geometry.HPos.RIGHT
            textFill: Color.WHITE
        };
        closeImage = javafx.scene.image.Image {
            url: "{__DIR__}close.gif"
        };
        closeImageView = javafx.scene.image.ImageView {
            visible: bind closeButtonVisible
            cursor: javafx.scene.Cursor.HAND
            layoutX: 232.0
            layoutY: 42.0
            onMouseClicked: closeImageViewOnMouseClicked
            image: closeImage
        };
        scene = javafx.scene.Scene {
            width: 256.0
            height: 129.0
            content: javafx.scene.layout.Panel {
                content: getDesignRootNodes ()
            }
            fill: javafx.scene.paint.Color.TRANSPARENT
        };
        
        currentState = org.netbeans.javafx.design.DesignState {
            names: [ ]
            stateChangeType: org.netbeans.javafx.design.DesignStateChangeType.PAUSE_AND_PLAY_FROM_START
            createTimeline: function (actual) {
                null
            }
        }
    }// </editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="Generated Design Functions">
    public function getDesignRootNodes () : javafx.scene.Node[] {
        [ background, tempLabel, cityLabel, tempImageView, closeImageView, cityText, ]
    }
    
    public function getDesignScene (): javafx.scene.Scene {
        scene
    }// </editor-fold>//GEN-END:main

    function cityTextAction(): Void {
        cityText.visible = false;
        onCityChange(cityText.rawText);
    }

    function closeImageViewOnMouseClicked(
        event: javafx.scene.input.MouseEvent): Void {
        scene.stage.close();
    }

    var rectangleFill: javafx.scene.paint.Paint = null;

    var stageDragX = 0.0;
    var stageDragY = 0.0;

    function rectangleOnMousePressed(e : MouseEvent) : Void {
        stageDragX = e.screenX - scene.stage.x;
        stageDragY = e.screenY - scene.stage.y;
    }

    function rectangleOnMouseDragged(e : MouseEvent) : Void {
        scene.stage.x = e.screenX - stageDragX;
        scene.stage.y = e.screenY - stageDragY;
    }

    function rectangleOnMouseClicked(e : MouseEvent) : Void {
        if (e.clickCount >= 2) {
           cityText.visible = true;
        }
    }

    var lastConditionCode = "";
    var lastConditionImage : Image;

    function getImage(conditionCode : String) : Image {

        if(conditionCode == lastConditionCode) {
            return lastConditionImage;
        }
        lastConditionCode = conditionCode;

        lastConditionImage = Image {
            placeholder: lastConditionImage
            url: "{Utils.getForecastImageURL(lastConditionCode)}"
            backgroundLoading: true
        }
    }
}
