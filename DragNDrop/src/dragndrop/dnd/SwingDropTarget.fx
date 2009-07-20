
/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER
 * Copyright 2009 Sun Microsystems, Inc. All rights reserved. Use is subject to license terms.
 *
 * This file is available and licensed under the following license:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   * Redistributions of source code must retain the above copyright notice,
 *     this list of conditions and the following disclaimer.
 *
 *   * Redistributions in binary form must reproduce the above copyright notice,
 *     this list of conditions and the following disclaimer in the documentation
 *     and/or other materials provided with the distribution.
 *
 *   * Neither the name of Sun Microsystems nor the names of its contributors
 *     may be used to endorse or promote products derived from this software
 *     without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package dragndrop.dnd;

import javafx.scene.Node;
import javafx.scene.CustomNode;
import javafx.ext.swing.SwingComponent;
import javafx.scene.Group;

import java.awt.dnd.DropTargetDragEvent;
import java.awt.dnd.DropTargetDropEvent;
import java.awt.dnd.DropTargetEvent;
import java.awt.dnd.DropTargetListener;
import java.awt.dnd.DnDConstants;
import javax.swing.JPanel;
import java.awt.dnd.DropTarget;

public class SwingDropTarget extends CustomNode, DropTargetListener {
    
    public-init var content : Node;
    public-init var dropActions = DnDConstants.ACTION_COPY;
    public-init var onDragEnter : function(dtde : DropTargetDragEvent);
    public-init var onDragExit : function(dte : DropTargetEvent);
    public-init var onDragOver : function(dtde : DropTargetDragEvent);
    public-init var onDrop : function(dtde : DropTargetDropEvent);
    public-init var onDropActionChanged : function(dtde : DropTargetDragEvent);

    // Swing Drop Target
    var panel = new JPanel();
    var swingComponent = SwingComponent.wrap(panel);
    var bounds = bind content.boundsInParent on replace {
        swingComponent.layoutX = bounds.minX;
        swingComponent.layoutY = bounds.minY;
        swingComponent.width = bounds.width;
        swingComponent.height = bounds.height;
    }

    override function create() : Node {

        // Set Transparent Background
        panel.setBackground(new java.awt.Color(0, 0, 0, 0));

        // Initialize Drop Target
        new DropTarget(panel, dropActions, this);

        Group {
            content: [
                swingComponent,
                content
            ]
        };
    }

    override function dragEnter(dtde : DropTargetDragEvent) {
        if(onDragEnter != null) {
            onDragEnter(dtde);
        } else {
            dtde.acceptDrag(dropActions);
        }
    }

    override function dragExit(dte : DropTargetEvent) {
        if(onDragExit != null) {
            onDragExit(dte);
        }
    }

    override function dragOver(dtde : DropTargetDragEvent) {
        if(onDragOver != null) {
            onDragOver(dtde);
        } else {
            dtde.acceptDrag(dropActions);
        }
    }

    override function drop(dtde : DropTargetDropEvent) {
        if(onDrop != null) {
            onDrop(dtde);
        } else {
            dtde.rejectDrop();
        }
    }

    override function dropActionChanged(dtde : DropTargetDragEvent) {
        if(onDropActionChanged != null) {
            onDropActionChanged(dtde);
        }
    }
}
