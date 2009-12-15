/*
 * Main.fx
 *
 * Created on Dec 11, 2009, 3:32:08 PM
 */

package panellayout;

import javafx.stage.Stage;
import javafx.scene.Scene;

/**
 * @author Rakesh Menon
 */

Stage {
    title: "JavaFX Application"
    scene: Scene {
        width: 300
        height: 320
        content: [ InputForm { } ]
    }
}
