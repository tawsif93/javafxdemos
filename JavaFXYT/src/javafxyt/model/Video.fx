/*
 * Video.fx
 *
 * Created on 31 Jul, 2009, 3:32:49 PM
 */

package javafxyt.model;

/**
 * @author Rakesh Menon
 */

public class Video {
    
    public var videoid : String;
    public var title : String;
    public var description : String;
    public var duration : String;
    public var keywords : String;
    public var player : String;
    public var credit : String;
    public var category : String;
    public var uploaded : String;
    public var thumbnail : Thumbnail[];

    override function toString() : String {
        "[Video videoid={videoid}, credit={credit}, category={category}, thumbnail={sizeof thumbnail}]";
    }
}
