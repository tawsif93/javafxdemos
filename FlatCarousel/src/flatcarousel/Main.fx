/*
 * Main.fx
 *
 * Created on 5 Mar, 2010, 3:06:46 PM
 */

package flatcarousel;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.stage.StageStyle;

/**
 * @author Rakesh Menon
 */

def carousel = Carousel {
    width: 380
    height: 140
}

Stage {
    scene: Scene {
        width: 380
        height: 140
        content: [ carousel ]
    }
    style: StageStyle.UNDECORATED
}

carousel.setInitialX(300);
