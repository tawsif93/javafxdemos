/*
 * Thumbnail.fx
 *
 * Created on 31 Jul, 2009, 11:42:27 AM
 */

package javafxyt.model;

/**
 * @author Rakesh Menon
 */

public class Thumbnail {
    
    public-init var url : String;
    public-init var width : String;
    public-init var height : String;

    override function toString() : String {
        "[Thumbnail url={url}, width={width}, height={height}]";
    }
}
