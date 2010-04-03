/*
 * FocusCycleRoot.fx
 *
 * Created on Mar 28, 2010, 9:39:05 AM
 */

package modaldialog;

import javafx.scene.Node;
import javafx.scene.layout.Container;
import javafx.scene.Group;
import javafx.scene.control.Control;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.KeyCode;

/**
 * @author Rakesh Menon
 */

public class FocusCycleRoot {

    public var content : Node[] on replace {

        delete controls;

        if(content != null) {
            for(node in content) {
                findControls(node);
            }
        }

        focusIndex = 0;
    }
    
    var controls : Control[];
    var focusIndex = -1 on replace {
        controls[focusIndex].requestFocus();
    }

    function findControls(node : Node) : Void {

        if((node instanceof Control) and node.focusTraversable) {
            insert (node as Control) into controls;
            node.focusTraversable = false;
            node.onKeyPressed = onKeyPressed;
        } else if(node instanceof Container) {
            var container = node as Container;
            for(c in container.content) {
                findControls(c);
            }
        } else if(node instanceof Group) {
            var group = node as Group;
            for(g in group.content) {
                findControls(g);
            }
        }
    }
    
    function onKeyPressed(ke : KeyEvent) : Void {

        if((sizeof controls) == 1) {
            controls[0].requestFocus();
            return;
        }
        
        if(ke.code == KeyCode.VK_TAB) {
            if(ke.shiftDown) {
                if(focusIndex > 0) {
                    focusIndex--;
                } else {
                    focusIndex = (sizeof controls) - 1;
                }
            } else {
                if(focusIndex >= ((sizeof controls) - 1)) {
                    focusIndex = 0;
                } else {
                    focusIndex++;
                }
            }
        }
    }

    public function requestFocusOnDefault() : Void {
        focusIndex = 0;
        controls[focusIndex].requestFocus();
    }
}
