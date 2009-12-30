/*
 * Main.fx
 *
 * Created on Dec 30, 2009, 9:18:57 AM
 */

package imageviewer;

/**
 * @author Rakesh Menon
 */

import javafx.animation.transition.ScaleTransition;
import javafx.animation.transition.TranslateTransition;
import javafx.scene.Group;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.paint.Color;
import javafx.scene.Scene;
import javafx.scene.shape.Rectangle;
import javafx.stage.Stage;

var carousel = Carousel {
    layoutX: 30
    layoutY: 440
};

var rectangle = Rectangle {
    x: 150
    y: 30
    width: 500
    height: 375
    stroke: Color.GRAY
    strokeWidth: 5.0
    arcWidth: 20
    arcHeight: 20
};

var imageView = ImageView {
    layoutX: rectangle.x + 4
    layoutY: rectangle.y + 4
    fitWidth: rectangle.width - 7
    fitHeight: rectangle.height - 7
    cache: true
}

var zoomImage = Group {
    content: [ rectangle, imageView ]
};

var scaleTransition : ScaleTransition = ScaleTransition {
    duration: 500ms
    node: zoomImage
    fromX: 1.0
    fromY: 1.0
    toX: 0.3
    toY: 0.3
    autoReverse: true
    repeatCount: 2
    action: function() {
        imageView.image = Image {
            url: "{thumbImage.url}.jpg"
            placeholder: thumbImage.imageView.image
            backgroundLoading: true
        }
    }
};

var translateTransition = TranslateTransition {
    duration: 500ms
    node: zoomImage
    fromY: 0
    toY: 280
    autoReverse: true
    repeatCount: 2
};

var thumbImage = bind carousel.selectedThumbImage on replace {
    scaleTransition.playFromStart();
    translateTransition.playFromStart();
}

var stage = Stage {
    title: "JavaFX Image Viewer"
    width: 800
    height: 650
    scene: Scene {
        fill: Color.BLACK
        content: [
            carousel, zoomImage
        ]
    }
    resizable: false
}
