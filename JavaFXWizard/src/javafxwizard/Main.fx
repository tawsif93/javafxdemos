/*
 * Main.fx
 *
 * Created on Mar 19, 2010, 4:04:26 PM
 */

package javafxwizard;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.LayoutInfo;
import javafx.fxd.FXDLoader;

/**
 * @author Rakesh Menon
 */


def panels : WizardPanel[] = [
    WizardPanel {
        graphic: FXDLoader.load("{__DIR__}fxz/Duke.fxz")
        title: "Duke"
        text: "Duke was originally created Joe Palrang to be the \"agent\" for "
        "the Green Project at Sun. Duke became the Java mascot when Java technology "
        "was first announced, right around the same time that the first Java cup logo "
        "was commissioned. "
    },
    WizardPanel {
        graphic: FXDLoader.load("{__DIR__}fxz/Lamborghini.fxz")
        title: "Lamborghini"
        text: "Lamborghini is an Italian automaker based in the small township of "
        "Sant'Agata Bolognese. The company was founded in 1963 by manufacturing "
        "magnate Ferruccio Lamborghini."
    },
    WizardPanel {
        graphic: FXDLoader.load("{__DIR__}fxz/Tiger.fxz")
        title: "Tiger"
        text: "The tiger (Panthera tigris) is a member of the Felidae family; the "
        "largest of the four \"big cats\" in the genus Panthera. Native to much "
        "of eastern and southern Asia, the tiger is an apex predator and an obligate "
        "carnivore."
    }
];

def wizard = Wizard {
    width: 380
    height: 250
    layoutInfo: LayoutInfo {
        width: 380
        height: 250
    }
    panels: panels
}

Stage {
    title: "JavaFX Wizard"
    scene: Scene {
        content: [ wizard ]
    }
    resizable: false
}
