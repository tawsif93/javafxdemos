/*
 * Main.fx
 *
 * Created on Aug 31, 2009, 12:10:02 PM
 */

package startup;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.Text;
import javafx.scene.text.Font;
import java.applet.Applet;
import javascript.JavaScriptUtil;

import javafx.scene.layout.VBox;

/**
 * @author Rakesh Menon
 */

/**
 * Applet Startup Time
 * Obtain the time taken to load HTML page and compare it with current time
 */

var loadTime = 0.0;
try {
    var applet: Applet = FX.getArgument("javafx.applet") as Applet;
    var loadDate = java.lang.System.currentTimeMillis();
    var jsUtil = new JavaScriptUtil(applet);
    var startDate = jsUtil.call("getStartDate", []);
    var startDateLong = Long.parseLong(startDate.toString());
    loadTime = (loadDate - startDateLong);
    println("HTML_TIME  : {startDateLong}");
    println("APPLET_TIME: {loadDate}");
    println("LOAD_TIME  : {loadTime} Milli-Seconds");
} catch (e : java.lang.Exception) {
    println("ERROR: {e}");
}

var vBox : VBox = VBox {
    layoutX: bind (200 - vBox.layoutBounds.width) / 2.0
    layoutY: bind (200 - vBox.layoutBounds.height) / 2.0
    content: [
        Text {
            font : Font { size : 16 }
            content: "Startup Time:"
        }, 
        Text {
            font : Font { size : 24 }
            content: "{loadTime/1000.0} s"
        }
    ]
}

Stage {
    scene: Scene {
        width: 200
        height: 200
        content: [ vBox ]
    }
}