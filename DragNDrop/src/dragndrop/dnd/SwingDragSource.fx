
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

import java.awt.dnd.DnDConstants;
import javafx.scene.Node;
import javafx.scene.CustomNode;
import javafx.ext.swing.SwingComponent;
import javafx.scene.Group;

import javax.swing.JPanel;
import java.awt.dnd.DragGestureEvent;
import java.awt.dnd.DragSource;
import java.awt.dnd.DragGestureListener;
import java.awt.dnd.DragSourceListener;
import java.awt.dnd.DragSourceDropEvent;
import java.awt.dnd.DragSourceEvent;
import java.awt.dnd.DragSourceDragEvent;

def dragSource = new DragSource();

public class SwingDragSource extends CustomNode, DragSourceListener, DragGestureListener {
    
    public var content : Node;    
    public var transferData : java.lang.Object;
    
    public-init var actions = DnDConstants.ACTION_COPY;
    public-init var onDragDropEnd : function (dsde : DragSourceDropEvent);
    public-init var onDragEnter : function (dsde : DragSourceDragEvent);
    public-init var onDragExit : function (dse : DragSourceEvent);
    public-init var onDragOver : function (dsde : DragSourceDragEvent);
    public-init var onDropActionChanged : function (dsde : DragSourceDragEvent);
    public-init var onDragGestureRecognized : function(dge : DragGestureEvent);

    // Swing Drag Source
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
        
        // Initialize Drag Source
        dragSource.createDefaultDragGestureRecognizer(panel, actions, this);
        
        Group {
            content: bind [
                swingComponent,
                content
            ]
        };
    }

    override function dragDropEnd(dsde : DragSourceDropEvent) {
        if(onDragDropEnd != null) {
            onDragDropEnd(dsde);
        }
    }

    override function dragEnter(dsde : DragSourceDragEvent) {
        if(onDragEnter != null) {
            onDragEnter(dsde);
        }
    }

    override function dragExit(dse : DragSourceEvent) {
        if(onDragExit != null) {
            onDragExit(dse);
        }
    }

    override function dragOver(dsde : DragSourceDragEvent) {
        if(onDragOver != null) {
            onDragOver(dsde);
        }
    }

    override function dropActionChanged(dsde : DragSourceDragEvent) {
        if(onDropActionChanged != null) {
            onDropActionChanged(dsde);
        }
    }

    override function dragGestureRecognized(dge : DragGestureEvent) {

        if(transferData == null) {
            return;
        }

        // Start Drag
        dge.startDrag(DragSource.DefaultCopyDrop, 
            new JavaLocalObjectTransferable(transferData));
    }
}
