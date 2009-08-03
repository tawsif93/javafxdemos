/*
 * YTDataTask.fx
 *
 * Created on 31 Jul, 2009, 10:37:02 AM
 */

package javafxyt;

import javafx.data.feed.atom.AtomTask;
import javafx.data.feed.atom.Entry;
import javafx.data.feed.atom.Feed;
import java.lang.Exception;
import javafx.data.pull.Event;
import javafx.data.pull.PullParser;
import javafx.data.xml.QName;
import javafxyt.model.Video;
import javafxyt.model.Thumbnail;

/**
 * @author Rakesh Menon
 */

public class YTDataTask {

    var atomTask : AtomTask;

    public-init var maxResults = 10;
    public-init var interval = 5m;
    public-init var onStart: function() = null;
    public-init var onDone: function(videos : Video[]) = null;
    public-init var onException: function(e : Exception) = null;
    
    public-read var videos : Video[];
    var video : Video;

    public var tag = "javafx" on replace {
        
        if(atomTask != null) {
            atomTask.stop();
        }
        
        atomTask = AtomTask {
            location: "http://gdata.youtube.com/feeds/api/videos?v=2&lr=en&"
            "format=5&orderby=published&safeSearch=strict&q={tag}&max-results={maxResults}";
            interval: interval
            onEntry: onEntry
            onFeed: onFeed
            onForeignEvent: onForeignEvent
            onDone: function() {
                if(onDone != null) {
                    onDone(videos);
                }
            }

        };
        
        if(onException != null) {
            atomTask.onException = onException;
        }
    }

    public function start() : Void {
        if(atomTask == null) { return; }
        atomTask.start();
    }

    public function stop() : Void {
        if(atomTask == null) { return; }
        atomTask.stop();
    }

    /**
     *   <feed xmlns='http://www.w3.org/2005/Atom' xmlns:media='http://search.yahoo.com/mrss/' xmlns:openSearch='http://a9.com/-/spec/opensearch/1.1/' xmlns:gd='http://schemas.google.com/g/2005' xmlns:yt='http://gdata.youtube.com/schemas/2007' gd:etag='W/&quot;D04ER3g4fyp7ImA9WxJaEEw.&quot;'>
     *       <id>tag:youtube.com,2008:videos</id>
     *       <updated>2009-07-31T04:51:46.637Z</updated>
     *       <category scheme='http://schemas.google.com/g/2005#kind' term='http://gdata.youtube.com/schemas/2007#video'/>
     *       <title>YouTube Videos matching query: javafx</title>
     *       <logo>http://www.youtube.com/img/pic_youtubelogo_123x63.gif</logo>
     *       <link rel='alternate' type='text/html' href='http://www.youtube.com'/>
     *       <link rel='http://schemas.google.com/g/2005#feed' type='application/atom+xml' href='http://gdata.youtube.com/feeds/api/videos?v=2'/>
     *       <link rel='http://schemas.google.com/g/2005#batch' type='application/atom+xml' href='http://gdata.youtube.com/feeds/api/videos/batch?v=2'/>
     *       <link rel='self' type='application/atom+xml' href='http://gdata.youtube.com/feeds/api/videos?q=javafx&amp;start-index=1&amp;max-results=2&amp;orderby=published&amp;v=2'/>
     *       <link rel='service' type='application/atomsvc+xml' href='http://gdata.youtube.com/feeds/api/videos?alt=atom-service&amp;v=2'/>
     *       <link rel='next' type='application/atom+xml' href='http://gdata.youtube.com/feeds/api/videos?q=javafx&amp;start-index=3&amp;max-results=2&amp;orderby=published&amp;v=2'/>
     *       <author>
     *           <name>YouTube</name>
     *           <uri>http://www.youtube.com/</uri>
     *       </author>
     *       <generator version='2.0' uri='http://gdata.youtube.com/'>YouTube data API</generator>
     *       <openSearch:totalResults>229</openSearch:totalResults>
     *       <openSearch:startIndex>1</openSearch:startIndex>
     *       <openSearch:itemsPerPage>2</openSearch:itemsPerPage>
     *       <entry>
     *           ...
     *       </entry>
     *   </feed>
     **/
    function onFeed(feed : Feed) : Void {
        delete videos;
        video = null;
    }
    
    /**
     *   <entry gd:etag='W/&quot;CkEHRX47eCp7ImA9WxJbGU4.&quot;'>
     *       <id>tag:youtube.com,2008:video:Tlix0TUAhq4</id>
     *       <published>2009-07-30T04:58:11.000Z</published>
     *       <updated>2009-07-30T05:10:34.000Z</updated>
     *       <category scheme='http://schemas.google.com/g/2005#kind' term='http://gdata.youtube.com/schemas/2007#video'/>
     *       <category scheme='http://gdata.youtube.com/schemas/2007/categories.cat' term='Education' label='Education'/>
     *       <category scheme='http://gdata.youtube.com/schemas/2007/keywords.cat' term='java'/>
     *       <category scheme='http://gdata.youtube.com/schemas/2007/keywords.cat' term='javafx'/>
     *       <category scheme='http://gdata.youtube.com/schemas/2007/keywords.cat' term='teaching'/>
     *       <title>Tor Norbye Shows JavaFX</title>
     *       <content type='application/x-shockwave-flash' src='http://www.youtube.com/v/Tlix0TUAhq4&amp;f=videos&amp;app=youtube_gdata'/>
     *       <link rel='alternate' type='text/html' href='http://www.youtube.com/watch?v=Tlix0TUAhq4'/>
     *       <link rel='http://gdata.youtube.com/schemas/2007#video.responses' type='application/atom+xml' href='http://gdata.youtube.com/feeds/api/videos/Tlix0TUAhq4/responses?v=2'/>
     *       <link rel='http://gdata.youtube.com/schemas/2007#video.related' type='application/atom+xml' href='http://gdata.youtube.com/feeds/api/videos/Tlix0TUAhq4/related?v=2'/>
     *       <link rel='http://gdata.youtube.com/schemas/2007#mobile' type='text/html' href='http://m.youtube.com/details?v=Tlix0TUAhq4'/>
     *       <link rel='self' type='application/atom+xml' href='http://gdata.youtube.com/feeds/api/videos/Tlix0TUAhq4?v=2'/>
     *       <author>
     *           <name>dcbriccetti</name>
     *           <uri>http://gdata.youtube.com/feeds/api/users/dcbriccetti</uri>
     *       </author>
     *       <gd:comments>
     *           <gd:feedLink href='http://gdata.youtube.com/feeds/api/videos/Tlix0TUAhq4/comments?v=2' countHint='0'/>
     *       </gd:comments>
     *       <media:group>
     *           ...
     *       </media:group>
     *   </entry>
     **/
    function onEntry(entry : Entry) : Void {
        if(video != null) {
            video.title = "{entry.title.text}";
            insert video into videos;
        }
        video = null;
    }
    
    /**
     *   <media:group>
     *       <media:category label='Science &amp; Technology' scheme='http://gdata.youtube.com/schemas/2007/categories.cat'>Tech</media:category>
     *       <media:content url='http://www.youtube.com/v/6LdFq8T0Uys&amp;f=videos&amp;app=youtube_gdata' type='application/x-shockwave-flash' medium='video' isDefault='true' expression='full' duration='531' yt:format='5'/>
     *       <media:content url='rtsp://rtsp2.youtube.com/CiILENy73wIaGQkrU_TEq0W36BMYDSANFEgGUgZ2aWRlb3MM/0/0/0/video.3gp' type='video/3gpp' medium='video' expression='full' duration='531' yt:format='1'/>
     *       <media:content url='rtsp://rtsp2.youtube.com/CiILENy73wIaGQkrU_TEq0W36BMYESARFEgGUgZ2aWRlb3MM/0/0/0/video.3gp' type='video/3gpp' medium='video' expression='full' duration='531' yt:format='6'/>
     *       <media:credit role='uploader' scheme='urn:youtube'>terrencebarr</media:credit>
     *       <media:description type='plain'>Terrence Barr demonstrates how to get started with JavaFX Mobile 1.2 EA for Windows Mobile. This is part 1 of 2. Part 2: www.youtube.com For more information, see: weblogs.java.net</media:description>
     *       <media:keywords>JavaFX, JavaFX Mobile</media:keywords>
     *       <media:player url='http://www.youtube.com/watch?v=6LdFq8T0Uys'/>
     *       <media:thumbnail url='http://i.ytimg.com/vi/6LdFq8T0Uys/default.jpg' height='90' width='120' time='00:04:25.500'/>
     *       <media:thumbnail url='http://i.ytimg.com/vi/6LdFq8T0Uys/2.jpg' height='90' width='120' time='00:04:25.500'/>
     *       <media:thumbnail url='http://i.ytimg.com/vi/6LdFq8T0Uys/1.jpg' height='90' width='120' time='00:02:12.750'/>
     *       <media:thumbnail url='http://i.ytimg.com/vi/6LdFq8T0Uys/3.jpg' height='90' width='120' time='00:06:38.250'/>
     *       <media:thumbnail url='http://i.ytimg.com/vi/6LdFq8T0Uys/hqdefault.jpg' height='360' width='480'/>
     *       <media:title type='plain'>Getting Started with JavaFX Mobile 1.2 EA for Windows Mobile, part 1</media:title>
     *       <yt:aspectRatio>widescreen</yt:aspectRatio>
     *       <yt:duration seconds='531'/>
     *       <yt:uploaded>2009-07-28T21:45:00.000Z</yt:uploaded>
     *       <yt:videoid>6LdFq8T0Uys</yt:videoid>
     *   </media:group>
     **/
    function onForeignEvent(event : Event) : Void {

        if(event.level != 3) { return; }
                
        if(event.type == PullParser.TEXT) {

            // Initialize Video
            if(video == null) { video = Video { } };

            if(event.qname.name == "videoid") {
                video.videoid = "{event.text}";
            } else if(event.qname.name == "description") {
                video.description = "{event.text}";
            } else if(event.qname.name == "keywords") {
                video.keywords = "{event.text}";
            } else if(event.qname.name == "player") {
                video.player = "{event.text}";
            } else if(event.qname.name == "credit") {
                video.credit = "{event.text}";
            } else if(event.qname.name == "category") {
                video.category = "{event.text}";
            } else if(event.qname.name == "uploaded") {
                video.uploaded = "{event.text}";
            }
            
        } else if(event.type == PullParser.START_ELEMENT) {
            
            if(event.qname.name == "thumbnail") {
                var thumbnail = Thumbnail {
                    url: event.getAttributeValue(QName{name:"url"})
                    width: event.getAttributeValue(QName{name:"width"})
                    height: event.getAttributeValue(QName{name:"height"})
                 };
                 insert thumbnail into video.thumbnail;
            } else if(event.qname.name == "duration") {
                video.duration = "{event.getAttributeValue(QName{name:"seconds"})}";
            }
        }
    }
}
