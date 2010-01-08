/*
 * FeedParser.fx
 *
 * Created on Nov 3, 2009, 9:00:11 AM
 */

package javafxswing;

import javafx.data.feed.rss.RssTask;
import javafx.data.feed.rss.Channel;
import javafx.data.feed.rss.Item;

/**
 * @author Rakesh Menon
 */

public class FeedParser {

    public-init var onChannel: function(channel : Channel);
    public-init var onItem: function(item : Item);

    var rssTask = RssTask {

        location: "http://rss.news.yahoo.com/rss/world"
        interval: 300s

        onException: function(e) {
            e.printStackTrace();
        }

        onChannel: function(channel) {
            onChannel(channel);
        }

        onItem: function(item) {
            onItem(item);
        }
    }

    public function start() : Void {
        rssTask.start();
    }
}
