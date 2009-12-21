/*
 * Main.fx
 *
 * Created on Nov 20, 2009, 10:12:37 AM
 */

package javafxwindow;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.control.Button;
import javafx.scene.control.TextBox;

/**
 * @author Rakesh Menon
 */

var inputForm = Window {
    x: 10
    y: 10
    autoResize: true
    title: "Input Form"
    content: [ InputForm { } ]
}

var dialog1 = Window {
    x: 150
    y: 320
    title: "Dialog - ONE"
    content: [
        Rectangle { x: 20 y: 20 width: 50 height: 50 fill: Color.RED }
    ]
}

var dialog2 = Window {
    x: 15
    y: 280
    title: "Dialog - TWO"
    visible: false
    content: [
        Rectangle { x: 10 y: 20 width: 50 height: 50 fill: Color.BLUE },
        TextBox { layoutX: 10 layoutY: 80 }
    ]
}

var button = Button {
    layoutX: 15
    layoutY: 420
    text: "Show Dialog"
    action: function() {
        dialog2.visible = true;
    }
}

var rect = Rectangle {
    width: 350
    height: 510
    fill: Color.WHITE
}

Stage {
    title: "JavaFX Window"
    scene: Scene {
        content: [
            rect, inputForm, dialog1, dialog2, button
        ]
    }
}
