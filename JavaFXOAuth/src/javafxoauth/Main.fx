/*
 * Main.fx
 *
 * Created on Apr 12, 2010, 11:08:13 AM
 */

package javafxoauth;

import javafx.scene.Scene;
import javafx.stage.Stage;
import javafxoauth.view.OAuthView;

def oauthView : OAuthView = OAuthView {
    width: bind oauthView.scene.width
    height: bind oauthView.scene.height
};

Stage {
    title: "Open Authorization [ OAuth ]"
    scene: Scene {
        width: 500
        height: 500
        content: [ oauthView ]
    }
}
