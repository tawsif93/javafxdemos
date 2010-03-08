/*
 * Main.fx
 *
 * Created on 8 Mar, 2010, 9:16:14 AM
 */

package javafxlayout;

import javafx.stage.Stage;
import javafx.scene.Scene;

/**
 * @author Rakesh Menon
 */

def scene = Scene {
    width: 380
    height: 260
};
def personalDetailsView = PersonalDetailsView {
    width: bind scene.width
    height: bind scene.height
}
scene.content = [ personalDetailsView ];
Stage {
    title: "Personal Details View"
    scene: scene
}
