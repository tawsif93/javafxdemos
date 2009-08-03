/*
 * PlayerControls.fx
 *
 * Created on 31 Jul, 2009, 3:41:38 PM
 */

package javafxyt.view;

import javafx.geometry.HPos;
import javafx.scene.Cursor;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseButton;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.stage.AppletStageExtension;
import java.lang.Exception;
import javafxyt.Main;

/**
 * @author Rakesh Menon
 */

public class PlayerControls extends CustomNode {

    public var selectedIndex = 0;

    public var titleText =  Text {
        layoutX: 10
        layoutY: 15
        font: Font { name: "sansserif" size: 10 }
        fill: Color.LIGHTGREY
        wrappingWidth: 280
    }

    public-read var backButton = ImageButton {
        normalImage: Image { url: "{__DIR__}images/BackNormal.png" }
        hotImage: Image { url: "{__DIR__}images/BackHot.png" }
        pressedImage: Image { url: "{__DIR__}images/BackPressed.png" }
        action: function() {
            stop();
            if(selectedIndex > 0) {
                selectedIndex--;
                var video = Main.thumbnailBar.videos[selectedIndex];
                Main.loadVideo(video.videoid, video.title, selectedIndex);
                playButton.image = pauseNormal;
            }
        }
    }

    public-read var rewindButton = ImageButton {
        normalImage: Image { url: "{__DIR__}images/RewindNormal.png" }
        hotImage: Image { url: "{__DIR__}images/RewindHot.png" }
        pressedImage: Image { url: "{__DIR__}images/RewindPressed.png" }
        action: function() {
            seekTo(-15);
        }
    }

    var playNormal = Image { url: "{__DIR__}images/PlayNormal.png" };
    var playHot = Image { url: "{__DIR__}images/PlayHot.png" };
    var playPressed = Image { url: "{__DIR__}images/PlayPressed.png" };
    var pauseNormal = Image { url: "{__DIR__}images/PauseNormal.png" };
    var pauseHot = Image { url: "{__DIR__}images/PauseHot.png" };
    var pausePressed = Image { url: "{__DIR__}images/PausePressed.png" };

    public var play = false on replace {
        if(play) {
            playButton.normalImage = pauseNormal;
            playButton.hotImage = pauseHot;
            playButton.pressedImage = pausePressed;
        } else {
            playButton.normalImage = playNormal;
            playButton.hotImage = playHot;
            playButton.pressedImage = playPressed;
        }
    }
    
    public-read var playButton : ImageButton = ImageButton {
        
        normalImage: playNormal
        hotImage: playHot
        pressedImage: playPressed
        action: function() {

            play = not play;
            
            if(play) {
                playButton.image = pauseHot;
                Main.javaYTUtil.play();
            } else {
                playButton.image = playHot;
                Main.javaYTUtil.pause();
            }
        }
    }
    
    public-read var stopButton = ImageButton {
        normalImage: Image { url: "{__DIR__}images/StopNormal.png" }
        hotImage: Image { url: "{__DIR__}images/StopHot.png" }
        pressedImage: Image { url: "{__DIR__}images/StopPressed.png" }
        action: function() {
            stop();
        }
    }

    public-read var forwardButton = ImageButton {
        normalImage: Image { url: "{__DIR__}images/ForwardNormal.png" }
        hotImage: Image { url: "{__DIR__}images/ForwardHot.png" }
        pressedImage: Image { url: "{__DIR__}images/ForwardPressed.png" }
        action: function() {
            seekTo(15);
        }
    }
    
    public-read var nextButton = ImageButton {
        normalImage: Image { url: "{__DIR__}images/NextNormal.png" }
        hotImage: Image { url: "{__DIR__}images/NextHot.png" }
        pressedImage: Image { url: "{__DIR__}images/NextPressed.png" }
        action: function() {
            stop();
            if(selectedIndex < (sizeof Main.thumbnailBar.videos) - 1) {
                selectedIndex++;
                var video = Main.thumbnailBar.videos[selectedIndex];
                Main.loadVideo(video.videoid, video.title, selectedIndex);
                playButton.image = pauseNormal;
            }
        }
    }

    function stop() : Void {
        play = false;
        Main.javaYTUtil.stop();
        Main.javaYTUtil.clearVideo();
    }

    function seekTo(diff : Long) {
        
        var seekTo = "0";

        try {
            var currentTimeStr = Main.javaYTUtil.getCurrentTime();
            var currentTime = Number.parseFloat(currentTimeStr);
            currentTime += diff;
            if(currentTime < 0) { currentTime = 0; }
            seekTo = "{currentTime}";
        } catch (e : Exception) { }

        Main.javaYTUtil.seekTo(seekTo);
    }
    
    override function create() : Node {
        
        var infoBox = Group {
            content: [
                Rectangle {
                    width: 300
                    height: 43
                    fill: Color.BLACK
                },
                titleText
            ]
        }
        
        var controlBox = HBox {
            spacing: 1
            content: [
                backButton, rewindButton, playButton,
                stopButton, forwardButton, nextButton
            ]
            layoutInfo: LayoutInfo {
                hpos: HPos.RIGHT
            }
        };
        
        var vBox = VBox {
            spacing: 5
            content: [ infoBox, controlBox ]
        }

        var logoImage : ImageView = ImageView {
            image: Image {
                url: "{__DIR__}images/logo.png"
            }
            cursor: Cursor.HAND
            onMousePressed: function(e) {
                if(e.button == MouseButton.PRIMARY) {
                    AppletStageExtension.showDocument("http://javafx.com/")
                }
            }
        }

        HBox {
            content: [ vBox, logoImage ]
        }
    }
}
