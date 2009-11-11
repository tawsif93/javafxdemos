/*
 * Main.fx
 *
 * Created on 11 Nov, 2009, 8:42:57 AM
 */

package javafxasync;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.Text;
import javafx.scene.text.Font;
import javafx.stage.Screen;
import javafx.scene.text.TextOrigin;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;

/**
 * @author Rakesh Menon
 */

var status = "";
var count = 1;

var javaTask = JavaTask {

    onStart: function() { status = "Task Started..."; }
    onDone: function() { stage.close(); }
    onFailed: function(cause) { status = "Failed: {cause}"; }
    
    repeatTask: function() : Void {
        status = "RepeatTask: {count}";
        stage.visible = not stage.visible;
        count++;
    }
};

var statusText : Text = Text {
    layoutX: 10
    layoutY: bind (stage.scene.height - statusText.layoutBounds.height)/2.0
    font : Font { size : 20 }
    wrappingWidth: bind Screen.primary.bounds.width - 20
    content: bind status
    textOrigin: TextOrigin.TOP
    fill: Color.BLUE
}

def stage : Stage = Stage {
    title: "JavaFX Async"
    scene: Scene {
        width: Screen.primary.bounds.width
        height: Screen.primary.bounds.height
        content: [
            Rectangle {
                width: bind Screen.primary.bounds.width
                height: bind Screen.primary.bounds.height
                fill: Color.BLACK
                stroke: Color.RED
                strokeWidth: 5.0
            }, 
            statusText
        ]
    }
}

javaTask.start();
