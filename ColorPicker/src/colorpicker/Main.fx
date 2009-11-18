
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

package colorpicker;

import javafx.geometry.VPos;
import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.Scene;
import javafx.scene.shape.Rectangle;
import javafx.stage.Stage;

/**
 * @author Rakesh Menon
 */

var colorPicker1 = ColorPicker { color: Color.web("#006600") };
var colorPicker2 = ColorPicker { color: Color.web("#009966") };
var colorPicker3 = ColorPicker { color: Color.web("#009999") };
var colorPicker4 = ColorPicker { color: Color.web("#0099CC") };

function getLinearGradient(
    clr1 : Color, clr2 : Color,
    clr3 : Color, clr4: Color ) : LinearGradient {
    LinearGradient {
        startX: 0.0, startY: 0.0, endX: 1.0, endY: 0.0
        proportional: true
        stops: [
            Stop { offset: 0.0 color: clr1 },
            Stop { offset: 0.3 color: clr2 },
            Stop { offset: 0.6 color: clr3 },
            Stop { offset: 0.8 color: clr4 }
        ]
    }
}

var rectangle = Rectangle {
    x: 0 y: 0 width: 400 height: 150
    fill: bind getLinearGradient(
        colorPicker1.color, colorPicker2.color,
        colorPicker3.color, colorPicker4.color
    )
}

var controls = VBox {
    content: [
        HBox {
            content: [
                Label {
                    text: "Color Picker One"
                    layoutInfo: LayoutInfo { width: 110 vpos: VPos.CENTER }
                },
                colorPicker1
            ]
        },
        HBox {
            content: [
                Label {
                    text: "Color Picker Two"
                    layoutInfo: LayoutInfo { width: 110 vpos: VPos.CENTER }
                },
                colorPicker2
            ]
        },
        HBox {
            content: [
                Label {
                    text: "Color Picker Three"
                    layoutInfo: LayoutInfo { width: 110 vpos: VPos.CENTER }
                },
                colorPicker3
            ]
        },
        HBox {
            content: [
                Label {
                    text: "Color Picker Four"
                    layoutInfo: LayoutInfo { width: 110 vpos: VPos.CENTER }
                },
                colorPicker4
            ]
        }
    ]
    translateX: 5
    translateY: 5
}

var view = VBox {
    content: [
        rectangle, controls
    ]
}

Stage {
    title: "Color Picker"
    scene: Scene {
        content: [ view ]
        width: 400
        height: 460
    }
    resizable: false
}
