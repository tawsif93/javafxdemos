/*
 * ThumbnailBar.fx
 *
 * Created on 31 Jul, 2009, 12:21:45 PM
 */

package javafxyt.view;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.layout.HBox;
import javafx.scene.control.ScrollBar;
import javafx.scene.layout.ClipView;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.util.Math;
import javafxyt.Main;
import javafxyt.model.Video;

/**
 * @author Rakesh Menon
 */

public class ThumbnailBar extends CustomNode {

    var beforeInit = true;

    public-init var width = 350;
    public var selectedIndex = 0 on replace {
        if(beforeInit) {
            beforeInit = false;
        } else if(selectedIndex >= 0) {
            selectAndLoadVideo(selectedIndex);
        }
    }
    
    def thumbLayoutInfo = LayoutInfo {
        width: 123
        height: 98
    }
    
    var hBox = HBox {
        spacing: 5
    };

    var statusText = Text {
        layoutX: 10
        font: Font { name: "sansserif" size: 12 }
        fill: Color.LIGHTBLUE
        wrappingWidth: 330
        layoutInfo: LayoutInfo {
            width: width
            height: 20
        }
    }
    
    var hScroll = ScrollBar {
        min: 0
        max: bind Math.max(hBox.boundsInLocal.width - 300, 1)
        layoutInfo: LayoutInfo {
            width: width
            height: 10
        }
    };
    
    var scrollView = ClipView {
        height: thumbLayoutInfo.height
        width: width
        node: hBox
        pannable: false
        layoutInfo: LayoutInfo {
            width: width
            height: thumbLayoutInfo.height
        }
    };
    
    public var videos : Video[] on replace {

        delete hBox.content;

        if(videos != null) {
            var index = 0;
            for(video in videos) {
                insert ThumbView { 
                    video: video
                    index: index
                } into hBox.content;
                index++;
            }
        }
    }
    
    var scrollViewClipX = bind hScroll.value on replace {
        scrollView.clipX = scrollViewClipX;
    }

    override function create() : Node {
        VBox {
            spacing: 5
            content: [ scrollView, hScroll, statusText ]
        };
    }

    function selectAndLoadVideo(index : Integer) {
        var thumbView = hBox.content[index] as ThumbView;
        Main.loadVideo(thumbView.video.videoid, thumbView.video.title, thumbView.index);
        for(tv in hBox.content) {
            (tv as ThumbView).selected = false;
        }
        thumbView.selected = true;
    }
}
