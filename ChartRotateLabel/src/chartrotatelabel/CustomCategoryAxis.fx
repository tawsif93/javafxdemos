/*
 * CustomCategoryAxis.fx
 *
 * Created on 11 Jun, 2010, 9:58:52 PM
 */

package chartrotatelabel;

import javafx.scene.Group;
import javafx.scene.control.Label;
import javafx.scene.transform.Rotate;
import javafx.scene.chart.part.CategoryAxis;

/**
 * @author Rakesh Menon
 */

public class CustomCategoryAxis extends CategoryAxis {

    override function layoutAxis() : Void {

        super.layoutAxis();

        //
        // FIXME: Its assumed that first entry is group of labels!
        //
        def markNodes = children[0] as Group;
        for(tickMark in markNodes.content) {
            tickMark.transforms = [ Rotate { angle: 45 }];
            tickMark.layoutY = 0;
            tickMark.layoutX = tickMark.layoutX + (tickMark as Label).width/2.0;
        }
    }
}
