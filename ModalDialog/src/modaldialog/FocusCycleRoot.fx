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

    public-init var content : Node[];

    var controls : Control[];
    var focusIndex = -1 on replace {
        controls[focusIndex].requestFocus();
    }

    postinit {
        for(node in content) {
            findControls(node);
        }
    }

    function findControls(node : Node) : Void {

        if(node instanceof Container) {
            var container = node as Container;
            for(c in container.content) {
                findControls(c);
            }
        } else if(node instanceof Group) {
            var group = node as Group;
            for(g in group.content) {
                findControls(g);
            }
        } else if(node.focusTraversable) {
            if(node instanceof Control) {
                insert (node as Control) into controls;
                node.focusTraversable = false;
                node.onKeyPressed = onKeyPressed;
            }
        }
    }
    
    function onKeyPressed(ke : KeyEvent) : Void {
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
