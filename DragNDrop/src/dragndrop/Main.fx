
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

package dragndrop;

import dragndrop.parser.XMLPullParser;
import dragndrop.view.ThumbView;
import dragndrop.view.ShoppingCart;
import dragndrop.model.ProductCatalog;

import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.io.http.HttpHeader;
import javafx.io.http.HttpRequest;
import javafx.io.http.URLConverter;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.ClipView;
import javafx.scene.control.ScrollBar;
import javafx.scene.layout.VBox;
import javafx.util.Math;
import javafx.scene.control.ListView;
import javafx.scene.Group;
import javafx.animation.transition.FadeTransition;
import javafx.animation.transition.TranslateTransition;
import javafx.scene.effect.MotionBlur;
import javafx.scene.Cursor;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;
import java.lang.Exception;

def appid = "YahooDemo";

var loading = Text {
    layoutX: 20
    layoutY: 60
    content: "Loading Products..."
    font: Font { size: 20 name: "sansserif" }
    textOrigin: TextOrigin.TOP
    visible: true
}

public var products : ProductCatalog[];
var productBox = HBox {
    spacing: 0
    layoutInfo: LayoutInfo {
        width: 300
        height: 100
    }
}

function updateProducts() : Void {
    delete productBox.content;
    for(product in products) {
        insert ThumbView { product: product } into productBox.content;
    }
    loading.visible = false;
}

// Search and load product details
function searchProducts(product:String) {

    loading.visible = true;
    delete products;

    var location = "http://shopping.yahooapis.com/ShoppingService/v3/productSearch?"
    "appid={appid}&query={URLConverter { }.encodeString(product.trim())}&show_numratings=0&results=50";

    println("Loading xml data from {location}");

    try {
        var request = HttpRequest {

            location: location
            method: HttpRequest.GET
            onException: function(e) { }
            onResponseCode: function(e) { }
            onInput: function(input) {
                try {
                    XMLPullParser.processResults(input);
                } finally {
                    input.close();
                }
            }

            onDone: function() {
                FX.deferAction(updateProducts);
            }
        }

        request.setHeader(HttpHeader.USER_AGENT, "Mozilla/4.0");
        request.start();
        
    } catch (e:Exception) {
        println("WARNING: {e}");
    }
}

/**
 * http://www.flickr.com/photos/revamptramp/3324496956/
 */
var bgImage = ImageView {
    image: Image {
        url: "{__DIR__}images/background.jpg"
    }
}

public-read def emptyCartImage = Image {
    url: "{__DIR__}images/empty_cart.png"
}
public-read def fullCartImage = Image {
    url: "{__DIR__}images/full_cart.png"
}

var hScroll = ScrollBar {
    min: 0
    max: bind Math.max(productBox.boundsInLocal.width - 300, 1)
    layoutInfo: LayoutInfo {
        width: 300
    }
}

var productScrollView = ClipView {
    height: 100
    width: 300
    node: productBox
    pannable: false
    layoutInfo: LayoutInfo {
        width: 300
        height: 140
    }
}

var motionBlur = MotionBlur { radius: 30 };
var shoppingCart : ShoppingCart = ShoppingCart {
    layoutY: 170
    layoutX: 5
    effect: bind if(transTransition.running) { motionBlur } else { null }
}

var shoppingList : ListView = ListView {
    layoutX: 5
    layoutY: 5
    items: bind shoppingCart.products
    width: 290
    height: 215
    onMouseReleased: function(e) {
        if(shoppingGroup.opacity < 1.0) {
            fadeTransition.stop();
            fadeTransition.rate = -1;
            fadeTransition.time = 500ms;
            fadeTransition.play();
            shoppingCart.translateX = 0.0;
            checkoutImage.visible = true;
        }
    }
}

var scrollViewClipX = bind hScroll.value on replace {
    productScrollView.clipX = scrollViewClipX;
}

var vBox = VBox {
    content: [
        productScrollView, hScroll
    ]
}

var checkoutImage : ImageView = ImageView {

    layoutX: 245
    layoutY: 180

    image: Image {
        url: "{__DIR__}images/checkout.png"
    }

    cursor: Cursor.HAND
    
    onMouseReleased: function(e) {

        if(sizeof shoppingCart.products <= 0) {
            return;
        }

        if(shoppingGroup.opacity == 1.0) {
            transTransition.playFromStart();
            checkoutImage.visible = false;
        }
    }
}

var transTransition : TranslateTransition = TranslateTransition {
    duration: 1s
    node: shoppingCart
    fromX: 0
    toX: 300
    action: function() {
        fadeTransition.rate = 1;
        fadeTransition.playFromStart();
    }
}

var shoppingGroup : Group = Group {
    content: [
        bgImage, vBox, shoppingCart, checkoutImage, loading
    ]
}

var fadeTransition : FadeTransition = FadeTransition {
    duration: 500ms
    node: shoppingGroup
    fromValue: 1.0
    toValue: 0.0
}

var stage = Stage {
    title: "Drag and Drop"
    scene: Scene {
        content: [ shoppingList, shoppingGroup ]
        width: 300
        height: 225
    }
    resizable: true
    visible: false
}

function run() {
    searchProducts("mobile");
    stage.visible = true;
}
