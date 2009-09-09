/*
 * Main.fx
 *
 * Created on 1 Mar, 2009, 10:13:01 AM
 */

package palleteffect;

import javafx.scene.Cursor;
import javafx.scene.Group;
import javafx.scene.paint.Color;
import javafx.scene.Scene;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import palleteffect.ImagePallet;

/**
 * @author Rakesh Menon
 */


var group = Group {

    translateX: 20
    translateY: 20
    
    content: [
        ImagePallet {
            translateX: 0
            translateY: 0
            url: "{__DIR__}images/image_2.jpg"
            width: 400
            height: 267
        },
        ImagePallet {
            translateX: 124
            translateY: 124
            url: "{__DIR__}images/image_4.jpg"
            width: 279
            height: 248
        },
        ImagePallet {
            translateX: 93
            translateY: 0
            url: "{__DIR__}images/image_3.jpg"
            width: 310
            height: 217
        },
        ImagePallet {
            translateX: 0
            translateY: 217
            url: "{__DIR__}images/image_1.jpg"
            width: 155
            height: 155
        }
    ]
};

var bgRect = Rectangle {
    width: 443
    height: 412
}

var closeButton = Text {
    content: "X"
    fill: Color.WHITE
    translateX: 420
    translateY: 10
    textOrigin: TextOrigin.TOP
    font: Font {
        name: "Bitstream Vera Sans Bold"
        size: 18
    }
    cursor: Cursor.HAND
    visible: bind ("{__PROFILE__}" != "browser")
    onMousePressed: function(e) {
        FX.exit();
    }
}

var scene = Scene {
    content: [ bgRect, group, closeButton ]
    width: 443
    height: 412
    fill: Color.BLACK
}

var stage = Stage {
    title: "Pallet Effect"
    scene: scene
    style: StageStyle.UNDECORATED
}
bgRect.onMouseDragged = function(e) {
    stage.x = stage.x + e.dragX;
    stage.y = stage.y + e.dragY;
}
