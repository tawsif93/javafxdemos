/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package filebrowser;

import javafx.stage.Stage;
import javafx.scene.Scene;

/**
 * @author Rakesh Menon
 */

def fileBrowser : FileBrowser = FileBrowser {
    width: bind fileBrowser.scene.width
    height: bind fileBrowser.scene.height
}

Stage {
    title: "File Browser"
    scene: Scene {
        width: 320
        height: 320
        content: [ fileBrowser ]
    }
}
