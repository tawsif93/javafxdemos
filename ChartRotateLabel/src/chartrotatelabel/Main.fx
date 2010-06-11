/*
 * Main.fx
 *
 * Created on 11 Jun, 2010, 9:55:55 PM
 */

package chartrotatelabel;

import javafx.stage.Stage;
import javafx.scene.Scene;

/**
 * @author Rakesh Menon
 */

def customChart : CustomChart = CustomChart {
    layoutX: 10
    layoutY: 10
    width: bind customChart.scene.width - 20
    height: bind customChart.scene.height - 20
}

Stage {
    title: "Chart - Rotate Axis Label"
    scene: Scene {
        width: 300
        height: 300
        content: customChart
    }
    resizable: false
}
