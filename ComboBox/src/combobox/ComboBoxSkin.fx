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

package combobox;

import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.Group;
import javafx.scene.control.ListView;
import javafx.scene.control.Skin;
import javafx.scene.input.KeyCode;
import javafx.scene.layout.LayoutInfo;
import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.control.Behavior;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.Resizable;
import javafx.geometry.VPos;
import javafx.scene.control.Label;
import javafx.scene.Node;
import javafx.scene.shape.Polygon;
import javafx.scene.layout.Panel;


/**
 * @author Rakesh Menon
 */

public class ComboBoxSkin extends Skin {

    public var font = Font { name: "sansserif" size: 12 };

    /**
     * Theme
     */
    def baseFill = "#d0d0d0";
    def focusBorderFill = "#0093ff";
    def darkShadowFill = "#858585";
    def liteShadowFill = "#f6f6f6";
    def topFill = "#e0e0e0";
    def bottomFill = "#a9a9a9";
    def arrowFill = "#3f3f3f";
    
    /**
     * Layout
     */
    def cornerRadius = 7;
    def paddingLeft = 10;
    def paddingTop = 4;
    def paddingBottom = 6;
    def paddingRight = 10;
    def paddingText = 2;
    def focusSize = 1;
    def buttonWidth = 20.0;

    override var behavior = ComboBoxBehavior { };

    var animate = true;
    var listY = 0.0;
    
    var timeline : Timeline = Timeline {

        keyFrames: [
            KeyFrame {
                time: 0s
                canSkip: true
                values: [
                    listY => (node.localToScene(node.layoutBounds).maxY) - 120
                ]
                action: function() {
                    list.visible = (timeline.rate == 1);
                }
            },
            KeyFrame {
                time: 200ms
                canSkip: true
                values: [
                    listY => (node.localToScene(node.layoutBounds).maxY) + 2 tween Interpolator.EASEOUT
                ]
            }
        ]
    };
    
    public var showPopup = false on replace {

        if(showPopup) {
            
            if(animate) {
                timeline.rate = 1;
                timeline.playFromStart();
            } else {
                listY = (node.localToScene(node.layoutBounds).maxY) + 2;
            }
            
            list.visible = true;
            listView.requestFocus();
            
        } else if(timeline.running) {
            timeline.stop();
            listY = (node.localToScene(node.layoutBounds).maxY) - 120;
        } else if(animate) {
            timeline.rate = -1;
            timeline.time = 200ms;
            timeline.play();
        } else {
            list.visible = false;
            listY = (node.localToScene(node.layoutBounds).maxY) - 120;
        }
    }

    public-read var listView : ListView = ListView {

        translateY: bind listY
        
        items: bind (control as ComboBox).items

        onMouseClicked: function(e) {
            showPopup = false;
            control.requestFocus();
        }

        layoutInfo: LayoutInfo {
            width: bind control.width - 4
            height: 120
        }
    };

    public-read var list : Panel;

    var listViewFocus = bind listView.focused on replace {
        if(not listViewFocus) {
            showPopup = false;
        }
    }

    var listVisible = bind list.visible on replace {
        if(not listVisible) {
            delete list from list.scene.content;
        }
    }

    var arrow : Node;
    var label : Label;    
    
    init {

        if("{__PROFILE__}" == "mobile") {
            list = Panel {
                visible: false
                content: [ listView ]
                blocksMouse: true
            };
            animate = false;
        } else {
            list = Panel {
                visible: false
                content: [ listView ]
                blocksMouse: true
                clip: bind Rectangle {
                    x: -2
                    y: bind node.localToScene(node.layoutBounds).maxY
                    width: bind control.width + 4
                    height: 124
                }
            };
        }
        
        node = Group {
            content: [ 
                Rectangle {
                    id: "ComboBox-Focus-Border"
                    x: -focusSize
                    y: -focusSize
                    width: bind (control.width + focusSize + focusSize)
                    height: bind (control.height - 1 + focusSize + focusSize)
                    arcWidth: cornerRadius
                    arcHeight: cornerRadius
                    fill: Color.web(focusBorderFill)
                    opacity: bind if(control.focused or listView.focused) { 1.0 } else { 0 }
                },
                Rectangle {
                    width: bind control.width
                    height: bind control.height - 1
                    arcWidth: cornerRadius
                    arcHeight: cornerRadius
                    fill: Color.web(liteShadowFill)
                },
                Rectangle {
                    width: bind control.width
                    height: bind control.height - 1
                    arcWidth: cornerRadius
                    arcHeight: cornerRadius
                    fill: Color.web(darkShadowFill)
                },
                Rectangle {
                    x: 1
                    y: 1
                    width: bind control.width - 2
                    height: bind control.height - 3
                    arcWidth: cornerRadius - 1
                    arcHeight: cornerRadius - 1
                    fill: Color.web(liteShadowFill)
                },
                Rectangle {
                    x: 2
                    y: 2
                    width: bind control.width - 4
                    height: bind control.height - 5
                    arcWidth: bind cornerRadius - 2
                    arcHeight: bind cornerRadius - 2
                    fill: LinearGradient{
                        endX: 0
                        stops: [
                            Stop { offset: 0 color: Color.web(topFill) },
                            Stop { offset: 1 color: Color.web(bottomFill) },
                        ]
                    }
                },
                label = Label {
                    font: bind font
                    text: bind "{listView.selectedItem}"
                    width: bind control.width - buttonWidth - 8
                    layoutX: bind paddingLeft
                    layoutY: bind (control.height - label.layoutBounds.height)/2.0
                    graphicVPos: VPos.CENTER
                },
                arrow = Polygon {
                    layoutX: bind control.width - paddingRight - (buttonWidth - arrow.layoutBounds.width)/2.0 - paddingText
                    layoutY: bind ((control.height - paddingTop - paddingBottom) - arrow.layoutBounds.height)/2.0
                    id: "ComboBox-Arrow"
                    points: [
                        0, buttonWidth * 0.25,
                        0, buttonWidth * 0.75,
                        buttonWidth * 0.35, buttonWidth * 0.5
                    ]
                    fill: Color.web(arrowFill)
                    rotate: 90
                }
            ]
            focusTraversable: false
            onMousePressed: function(e) {
                var x = e.sceneX - e.x;
                var y = e.sceneY - e.y + node.layoutBounds.height;
                var visible = not showPopup;
                show(x, y, visible);
            }
        }
        
        /**
         * Redirect key events on ListView to Control
         */

        listView.onKeyPressed = function(e) {
            if(e.code == KeyCode.VK_ENTER) {
                list.visible = false;
                control.requestFocus();
            } else if(e.code == KeyCode.VK_ESCAPE) {
                show(0, 0, false);
            } else if(not ((e.code == KeyCode.VK_UP) or (e.code == KeyCode.VK_DOWN))) {
                control.onKeyPressed(e);
            }
        }
        
        listView.onKeyReleased = function(e) {
            if(not ((e.code == KeyCode.VK_UP) or (e.code == KeyCode.VK_DOWN))) {
                control.onKeyReleased(e);
            }
        }

        listView.onKeyTyped = function(e) {
            control.onKeyTyped(e);
        }
    }

    function show(x : Number, y : Number, visible : Boolean) {

        if(not visible) {
            showPopup = false;
            control.requestFocus();
            return;
        }

        // Ensure that we are not adding twice
        delete list from node.scene.content;
        insert list into node.scene.content;

        list.layoutX = x + 2;
        showPopup = true;
    }
    
    override function intersects(x, y, w, h) : Boolean {
        return node.intersects(x, y, w, h);
    }

    override function contains(x, y) : Boolean {
        return node.contains(x, y);
    }

    protected override function getMinWidth() : Number {
        (paddingLeft + (label as Resizable).getMinWidth() + paddingText + buttonWidth + paddingRight) as Integer
    }

    protected override function getMinHeight() : Number {
        (paddingTop + (label as Resizable).getMinHeight() + paddingBottom) as Integer
    }

    protected override function getPrefWidth(height:Number) : Number {
        (paddingLeft + label.getPrefWidth(-1) + paddingText + buttonWidth + paddingRight) as Integer
    }

    protected override function getPrefHeight(width:Number) : Number {
        (paddingTop + label.getPrefHeight(-1) + paddingBottom) as Integer
    }
}

class ComboBoxBehavior extends Behavior {

    public override function callActionForEvent(e: KeyEvent) : Void {
        if(e.code == KeyCode.VK_DOWN) {
            var x = node.localToScene(node.layoutBounds).minX + 2;
            var y = node.localToScene(node.layoutBounds).maxY + 3;
            show(x, y, true);
        } else if(e.code == KeyCode.VK_ESCAPE) {
            show(0, 0, false);
        }
    }
}
