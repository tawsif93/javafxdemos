package scrollpane;

import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.stage.Stage;
import javafx.scene.layout.ClipView;
import javafx.scene.control.ScrollBar;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.Cursor;

var imageView = ImageView {
   image: Image {
       url: "{__DIR__}earth_lights.jpg"
   }
}

/**
 * ClipView using ScrollBars
 */
var scrollClipView : ClipView = ClipView {
    clipX: bind hScroll.value
    clipY: bind vScroll.value
    node: imageView
    pannable: false
    layoutInfo: LayoutInfo {
        width: 300
        height: 200
    }
}

var hScroll = ScrollBar {
    min: 0
    max: imageView.image.width - 300
    value: 0
    vertical: false
    layoutInfo: LayoutInfo {
        width: 312
    }
}

var vScroll = ScrollBar {
    min: 0
    max: imageView.image.height - 200
    value: 0
    vertical: true
    layoutInfo: LayoutInfo {
        height: 200
    }
}

var hBox = HBox {
    content: [
        vScroll, scrollClipView
    ]
}

/**
 * PaneClipView
 */
var paneClipView : ClipView = ClipView {
    node: ImageView {
        image: imageView.image
        cursor: Cursor.HAND
    }
    pannable: true
    layoutInfo: LayoutInfo {
        width: 312
        height: 200
    }
}

var vBox = VBox {
    content: [
        hBox, hScroll, paneClipView
    ]
}

Stage {
    title: "ClipView - Scroll & Pane"
    scene: Scene {
        width: 312
        height: 410
        content: [ vBox ]
    }
    resizable: false
}
