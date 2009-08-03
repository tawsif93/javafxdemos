/*
 * Main.fx
 *
 * Created on 31 Jul, 2009, 10:35:57 AM
 */

package javafxyt;

import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.layout.LayoutInfo;
import javafx.geometry.HPos;
import java.applet.Applet;
import javafxyt.model.Video;
import javafxyt.view.SearchView;
import javafxyt.view.PlayerControls;
import javafxyt.view.ThumbnailBar;
import javafxyt.javascript.JavaYTUtil;
import java.lang.Exception;

/**
 * @author Rakesh Menon
 */

var applet = FX.getArgument("javafx.applet") as Applet;
public-read  var javaYTUtil : JavaYTUtil;
public-read var thumbnailBar = ThumbnailBar { };

var searchView : SearchView = SearchView {
    layoutX: 8
    layoutY: 48
    action: function() {
        searchTag(searchView.tag);
    }
};

var playerControls = PlayerControls {
    layoutInfo: LayoutInfo {
        hpos: HPos.CENTER
    }
};

var controlBox = VBox {
    spacing: 10
    content: [ playerControls, thumbnailBar ]
}

function searchTag(tag : String) {

    thumbnailBar.videos = null;
    
    var ytDataTask : YTDataTask = YTDataTask {
        maxResults: 40
        tag: tag
        onDone: function(videos : Video[]) {
            thumbnailBar.videos = videos;
            ytDataTask.stop();
        }
    };

    ytDataTask.start();
}

public function loadVideo(
    videoid : String, title: String, index : Integer) {
    Main.javaYTUtil.loadNewVideo(videoid, "5");
    playerControls.play = true;
    playerControls.selectedIndex = index;
    playerControls.titleText.content = "{title}";
}

function run() {

    try {
         javaYTUtil = new JavaYTUtil(applet);
    } catch (e : Exception) { }

    Stage {
        title: "JavaFX - YouTube"
        scene: Scene {
            content: [ controlBox, searchView ]
            fill: Color.BLACK
        }
        style: javafx.stage.StageStyle.UNDECORATED
    }

    searchTag("javafx");
}
