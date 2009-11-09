/**
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * Thumbnail.fx
 *
 * Created on 7 Nov, 2009, 10:17:50 AM
 */

package javafxfpsmeter;

import javafx.scene.Node;
import javafx.scene.image.ImageView;
import javafx.scene.transform.Scale;
import javafx.util.Math;
import java.lang.Comparable;

/**
 * @author Rakesh Menon
 */

public class Thumbnail extends ImageView, Comparable {

    var scale = 1.0;
    
    public function update(index : Integer) : Void {

        // calculate the angle of the image
        var angle = ((Canvas.speedCounter/180.0) +
            ((index/(Canvas.count as Number)) * 2.0)) * Math.PI;

        // scale the image
        scale = (Canvas.SCALE_MAX + Canvas.SCALE_MIN )/2.0  +
            (Canvas.SCALE_MAX - Canvas.SCALE_MIN)/2.0 * Math.cos(angle);
        
        transforms = Scale {
            x: scale
            y: scale
        };
        
        layoutX = Canvas.WIDTH/2.0 + (Math.sin(angle) *
            Canvas.HORIZONTAL_RADIUS) - layoutBounds.width/2.0 * scale;
        layoutY = Canvas.HEIGHT/2.0 + (Math.cos(angle) *
            Canvas.VERTICAL_RADIUS) - layoutBounds.height/2.0 * scale;
    }
    
    // Compare Z-Order and Sort
    override function compareTo(thumbNail : Object) : Integer{
        if(thumbNail == null) { return 0; }
        return scale.compareTo((thumbNail as Thumbnail).scale);
    }
}
