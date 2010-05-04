/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package javafxfacebook;

import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.control.ListView;
import javafx.scene.control.Label;
import javafx.scene.control.ListCell;
import javafx.scene.image.ImageView;
import javafx.scene.layout.LayoutInfo;
import javafx.stage.AppletStageExtension;
import javafx.scene.text.Font;

/**
 * @author Rakesh Menon
 */

def font = Font { name: "Amble" size: 14 };

def userList : ListView = ListView {

    cellFactory: function() {

        def cell:ListCell = ListCell {
            node: Label {
                text: bind if (cell.empty) then "" else "{(cell.item as User).name}"
                graphic: ImageView {
                    image: bind if (cell.empty) then null else (cell.item as User).image
                }
                font: font
                layoutInfo: LayoutInfo { height: 50 }
            }
        }
    }

    width: bind userList.scene.width
    height: bind userList.scene.height

    onMouseReleased: function(e) {
        if(userList.selectedIndex > 0) {
            def link = (userList.selectedItem as User).link;
            if(link != null) {
                AppletStageExtension.showDocument(link, "_blank");
            }
        }
    }
}

/**
 * Facebook API
 */
def facebookUtils = FacebookUtils {
    client_id: "{FX.getArgument("client_id")}"
    access_token: "{FX.getArgument("access_token")}"
};

def onUserInfo = function(user : User) : Void {
    insert user into userList.items;
}

def onFriendInfo = function(user : User) : Void {
    insert user into userList.items;
}

println(facebookUtils.getAuthorizeURL());
facebookUtils.getUserInfo("me", onUserInfo);
facebookUtils.getMyFriends(onFriendInfo);

Stage {
    title: "JavaFX + Facebook"
    scene: Scene {
        width: 240
        height: 320
        content: [ userList ]
    }
}
