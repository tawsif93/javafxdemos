
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

package dragndrop.view;

import dragndrop.model.ProductCatalog;
import dragndrop.dnd.SwingDragSource;

import javafx.scene.Node;
import javafx.scene.image.ImageView;
import javafx.scene.text.Text;
import javafx.scene.image.Image;
import javafx.scene.Group;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.TextOrigin;
import javafx.scene.CustomNode;
import javafx.scene.shape.Rectangle;

def font = Font { size: 10 name: "sansserif" };

public class ThumbView extends CustomNode {

    var swingDataSource = SwingDragSource { };

    var bgRect = Rectangle {
        width: 80
        height: 140
        fill: Color.WHITE
    }

    var imageView = ImageView {
        layoutY: 5
    }

    var text = Text {
        layoutX: 5
        layoutY: 90
        font: font
        fill: Color.BLACK
        textOrigin: TextOrigin.TOP
        wrappingWidth: 70
    }

    public var product : ProductCatalog = null on replace {
        update();
    }

    override function create() : Node {

        var group = Group {
            content: [
                bgRect, 
                imageView,
                text
            ]
            layoutInfo: LayoutInfo {
                width: 80
                height: 140
            }
        }

        swingDataSource.content = group;
        return swingDataSource;
    }
    
    override function toString() : String {
        product.productName;
    }

    function update() : Void {

        if(product == null) {
            return;
        }

        swingDataSource.transferData = product;
        
        text.content = "{product.productName}";

        imageView.image = Image {
            url: product.thumbnailURL
            width: 80
            height: 80
            preserveRatio: true
            backgroundLoading: true
        }
    }
}
