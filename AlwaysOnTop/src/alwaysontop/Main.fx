
package alwaysontop;

import calendar.theme.Theme;
import calendar.view.FXCalendar;
import javafx.lang.FX;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.paint.Color;
import javafx.scene.Scene;
import javafx.scene.shape.Rectangle;
import javafx.stage.Stage;
import javafx.stage.StageStyle;

// Default application bounds
var stage : Stage;
var startX = 0.0;
var startY = 0.0;

var fxCalendar = FXCalendar {
    theme: Theme { };
};
// Center align for Mobile
if("{__PROFILE__}" == "mobile") {
    fxCalendar.translateX = 9.5;
    fxCalendar.translateY = 35.5;
}

// Drag Bar
var dragBar = Rectangle {

    width: fxCalendar.width
    height: 40
    fill: Color.TRANSPARENT
    visible: bind ("{__PROFILE__}" != "browser")

    onMousePressed: function(e) {
        startX = stage.x;
        startY = stage.y;
    }

    onMouseDragged: function(e) {
        stage.x = startX + e.dragX;
        stage.y = startY + e.dragY;
    }
}

var closeButton = ImageView {
    layoutX: fxCalendar.width - 19
    layoutY: 4
    image: Image {
        url: "{__DIR__}images/close.png"
    }
    onMousePressed: function(e) {
        FX.exit();
    }
}

FXDialogUtils { };

stage = Stage {

    width: fxCalendar.width
    height: fxCalendar.height
    title: "Calendar"

    scene: Scene {
        content: [ dragBar, fxCalendar, closeButton ]
        fill: Color.TRANSPARENT
    }
    style: StageStyle.TRANSPARENT
}
fxCalendar.requestFocus();
