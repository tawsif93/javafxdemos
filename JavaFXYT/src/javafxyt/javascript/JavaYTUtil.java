/*
 * JavaYTUtil.java
 *
 * Created on 31 Jul, 2009, 10:35:57 AM
 */

package javafxyt.javascript;

import java.applet.Applet;

/**
 *
 * @author Rakesh Menon
 */
public class JavaYTUtil {
    
    private static final String[] EMPTY_STRING_ARRAY = new String[] { };
    
    private JavaScriptUtil javascript = null;
        
    public JavaYTUtil(Applet applet) throws Exception {
        javascript = new JavaScriptUtil(applet);
    }
    
    public void onYouTubePlayerReady(String playerId) {
        System.out.println("onYouTubePlayerReady: " + playerId);
    }
    
    public void onPlayerError(String errorCode) {
        System.out.println("onPlayerError: " + errorCode);
    }
    
    public void onPlayerStateChange(String newState) {
        System.out.println("onPlayerStateChange: " + newState);
    }

    // functions for the api calls
    public void loadNewVideo(String id, String startSeconds) throws Exception {
        javascript.call("loadNewVideo", new String[] { id, startSeconds } );
    }
    
    public void cueNewVideo(String id, String startSeconds) throws Exception {
        javascript.call("cueNewVideo", new String[] { id, startSeconds } );
    }
    
    public void play() throws Exception {
        javascript.call("play", EMPTY_STRING_ARRAY );
    }
    
    public void pause() throws Exception {
        javascript.call("pause", EMPTY_STRING_ARRAY );
    }
    
    public void stop() throws Exception {
        javascript.call("stop", EMPTY_STRING_ARRAY );
    }
    
    public String getPlayerState() throws Exception {
        return "" + javascript.call("getPlayerState", EMPTY_STRING_ARRAY );
    }
    
    public void seekTo(String seconds) throws Exception {
        javascript.call("seekTo", new String[] { seconds } );
    }
    
    public String getBytesLoaded() throws Exception {
        return "" + javascript.call("getBytesLoaded", EMPTY_STRING_ARRAY );
    }
    
    public String getBytesTotal() throws Exception {
        return "" + javascript.call("getBytesTotal", EMPTY_STRING_ARRAY );
    }
    
    public String getCurrentTime() throws Exception {
        return "" + javascript.call("getCurrentTime", EMPTY_STRING_ARRAY );
    }
    
    public String getDuration() throws Exception {
        return "" + javascript.call("getDuration", EMPTY_STRING_ARRAY );
    }
    
    public String getStartBytes() throws Exception {
        return "" + javascript.call("getStartBytes", EMPTY_STRING_ARRAY );
    }
    
    public void mute() throws Exception {
        javascript.call("mute", EMPTY_STRING_ARRAY );
    }
    
    public void unMute() throws Exception {
        javascript.call("unMute", EMPTY_STRING_ARRAY );
    }
    
    public void setMute(boolean mute) throws Exception {
        if(mute) {
            mute();
        } else {
            unMute();
        }
    }
    
    public String getEmbedCode() throws Exception {
        return "" + javascript.call("play", EMPTY_STRING_ARRAY );
    }

    public String getVideoUrl() throws Exception {
        return "" + javascript.call("play", EMPTY_STRING_ARRAY );
    }
        
    public void setVolume(String newVolume) throws Exception {
        javascript.call("setVolume", new String[] { newVolume } );
    }
    
    public String getVolume() throws Exception {
        return "" + javascript.call("getVolume", EMPTY_STRING_ARRAY );
    }
    
    public void clearVideo() throws Exception {
        javascript.call("clearVideo", EMPTY_STRING_ARRAY );
    }
}
