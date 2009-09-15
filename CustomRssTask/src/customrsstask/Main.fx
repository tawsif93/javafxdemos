
/*
 * Main.fx
 *
 * Created on 18 Jun, 2009, 1:14:12 PM
 */

package customrsstask;

import javafx.data.feed.rss.RssTask;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.scene.Scene;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import javafx.scene.text.FontWeight;
import javafx.scene.layout.HBox;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;
import javafx.stage.StageStyle;
import javafx.data.feed.rss.Channel;
import javafx.data.feed.rss.Factory;
import javafx.data.feed.rss.Item;
import javafx.data.pull.PullParser;

/**
 * @author Rakesh Menon
 */

/**
 * Customize Item so as to override tryParseDate
 */
class CustomItem extends Item {

    public-read var pubDateText : String;

    override function fromXML(parser: PullParser): Void {

        if(parser.event.qname == PUB_DATE) {
            if ((parser.event.type == PullParser.TEXT) or
                (parser.event.type == PullParser.CDATA)) {
                pubDateText = stripCDATA(parser.event.text)
            }
        } else if(parser.event.qname == TITLE) {
            title = stripCDATA(parser.event.text);
        } else {
            super.fromXML(parser);
        }
    }
}

/**
 * Customize Factory so as to return CustomItem
 */
class CustomFactory extends Factory {
    public override function newItem(c: Channel) : Item {
        CustomItem { parent: c channel: c }
    }
}

var itemGroup = HBox {
    translateY: 5
    spacing: 50
    content: bind items
};
var itemGroupBounds = 0.0;
var items : Text[];

var rssTask = RssTask {

    // set custom factory
    factory: CustomFactory { }

    location: "http://www.engadget.com/rss.xml"
    //location: "http://feeds.gawker.com/gizmodo/full"
    interval: 300s

    onException: function(e) {
        e.printStackTrace();
    }

    onChannel: function(channel) {
        delete items;
        itemGroupBounds = 0;
    }

    onItem: function(item) {

        insert Text {
            font : Font.font("dialog", FontWeight.BOLD, 12)
            content: "{item.title}"
            fill: Color.WHITE
        } into items;

        itemGroupBounds += itemGroup.boundsInLocal.width;
    }
}
rssTask.start();

var bgRect : Rectangle = Rectangle {

    width: bind scene.width
    height: bind scene.height

    fill: LinearGradient {
        proportional: true
        startX: 0.0, startY: 0.0, endX: 0.0, endY: 1.0
        stops: [
            Stop { offset: 0.0 color: Color.GRAY },
            Stop { offset: 0.8 color: Color.BLACK }
        ]
    }

    onMouseDragged: function(e) {
        if("{__PROFILE__}" != "browser") {
            stage.x = stage.x + e.dragX;
            stage.y = stage.y + e.dragY;
        }
    }
}

var scene = Scene {
    width: 400
    height: 40
    content: [ bgRect, itemGroup ]
}

var timeline : Timeline = Timeline {
    repeatCount: Timeline.INDEFINITE
    keyFrames: [
        KeyFrame {
            canSkip: true
            time: 40ms
            action: function() {
                itemGroup.translateX -= 1;
                if(itemGroup.translateX < -itemGroupBounds) {
                    itemGroup.translateX = scene.width;
                 }
            }
        }
    ]
};
timeline.play();

var stage = Stage {
    title: "RSS Ticker"
    scene: scene
    resizable: false
    style: StageStyle.UNDECORATED
}
