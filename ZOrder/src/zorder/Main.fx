/*
 * Main.fx
 *
 * Created on Oct 26, 2009, 10:29:16 PM
 */

package zorder;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.Group;
import javafx.scene.paint.Color;
import javafx.scene.Node;
import javafx.scene.input.MouseEvent;
import javafx.util.Sequences;

/**
 * @author Rakesh Menon
 */

var topIndex = 0;

var nodes : NodeZ[] = [
    NodeZ { zOrder: 9 fill: Color.AQUAMARINE onMouseReleased: onMouseReleased },
    NodeZ { zOrder: 8 fill: Color.BLUE       onMouseReleased: onMouseReleased },
    NodeZ { zOrder: 7 fill: Color.RED        onMouseReleased: onMouseReleased },
    NodeZ { zOrder: 6 fill: Color.GOLD       onMouseReleased: onMouseReleased },
    NodeZ { zOrder: 5 fill: Color.PURPLE     onMouseReleased: onMouseReleased },
    NodeZ { zOrder: 4 fill: Color.GREEN      onMouseReleased: onMouseReleased },
    NodeZ { zOrder: 3 fill: Color.TURQUOISE  onMouseReleased: onMouseReleased },
    NodeZ { zOrder: 2 fill: Color.INDIGO     onMouseReleased: onMouseReleased },
    NodeZ { zOrder: 1 fill: Color.KHAKI      onMouseReleased: onMouseReleased },
    NodeZ { zOrder: 0 fill: Color.MAROON     onMouseReleased: onMouseReleased }
];

var group = Group {
    content: nodes
}

function onMouseReleased(me : MouseEvent) : Void {

    for(nz in nodes) {
        if(nz.zOrder == 0) {
            nz.zOrder = (me.node as NodeZ).zOrder;
            // Bring node to top
            (me.node as NodeZ).zOrder = 0;
        }
    }
    
    group.content = Sequences.sort(nodes) as Node[];
}

Stage {
    title: "ZOrder"
    scene: Scene {
        width: 300
        height: 300
        fill: Color.WHITE
        content: group
    }
}
