/*
 * Main.fx
 *
 * Created on Feb 23, 2010, 8:30:47 PM
 */

package weather;

import javafx.stage.Stage;
import javafx.stage.StageStyle;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.stage.AppletStageExtension;
import javafx.scene.paint.Color;

/**
 * @author Rakesh Menon
 */

var woeid : String = "";
function getWOEIDCallback(cityWOEID : String) : Void {
    woeid = cityWOEID;
    timeline.playFromStart();
    Utils.getWeatherInfo(woeid, "f", getWeatherInfoCallback);
};

def weatherView : WeatherView = WeatherView {
    onCityChange: function(city : String) : Void {
        Utils.getLocationWOEID(
            weatherView.cityText.text, getWOEIDCallback);
    }
};
function getWeatherInfoCallback(
    weatherInfo : WeatherInfo) : Void {
    weatherView.weatherInfo = weatherInfo;
}

def timeline = Timeline {
    repeatCount: Timeline.INDEFINITE
    keyFrames: KeyFrame {
        time: 60s
        action: function() {
            Utils.getWeatherInfo(
                woeid, "f", getWeatherInfoCallback);
        }
    }
}

// Handle Applet Drag
weatherView.closeButtonVisible = ("browser" != "{__PROFILE__}");

def stage : Stage = Stage {
    title: "JavaFX Weather"
    scene: weatherView.getDesignScene()
    style: StageStyle.TRANSPARENT
    extensions: [
        AppletStageExtension {
            shouldDragStart: function(e): Boolean {
                return e.primaryButtonDown and weatherView.background.hover;
            }
            useDefaultClose: true
        }
    ]
}

Utils.getLocationWOEID(
    weatherView.cityText.text, getWOEIDCallback);
