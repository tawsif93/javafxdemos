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
package dragndrop.parser;

import java.lang.Exception;
import java.io.InputStream;
import java.lang.Float;
import javafx.data.pull.Event;
import javafx.data.pull.PullParser;
import javafx.data.xml.QName;
import dragndrop.model.ProductCatalog;
import dragndrop.Main;

/**
 * Sample FX Script Application for Yahoo!'s Shopping Search Service.
 * This version uses the PullParser API to parse results in XML.
 */

public function processResults(is: InputStream) {
    delete Main.products;
    def parser = PullParser { documentType: PullParser.XML; input: is; onEvent: parseEventCallback };
    parser.parse();
    is.close();
}

def parseEventCallback = function(event: Event) {
    if (event.type == PullParser.START_ELEMENT) {
        processStartEvent(event)
    } else if (event.type == PullParser.END_ELEMENT) {
        processEndEvent(event)
    } else if (event.type == PullParser.END_DOCUMENT) {
        println(Main.products);
    }
}

// temporary variables needed during processing
var productCatalog: ProductCatalog;
            
function processStartEvent(event: Event) {
    if (event.qname.name == "Catalog" and event.level == 3) {
        productCatalog = ProductCatalog {}
        productCatalog.id = event.getAttributeValue(QName{name:"ID"}) as String;
    }
}
    
function processEndEvent(event: Event) {
        
    if (event.qname.name == "Catalog" and event.level == 3) {
        productCatalog.index = sizeof Main.products;
        insert productCatalog into Main.products;
    } else if (event.level == 4) {
        if (event.qname.name == "Url") {
            productCatalog.url = event.text;
        } else if (event.qname.name == "ProductName") {
            productCatalog.productName = ProductCatalog.extractPlainText(event.text);
        } else if (event.qname.name == "PriceFrom") {
            productCatalog.priceFrom = event.text;
        } else if (event.qname.name == "PriceTo") {
            productCatalog.priceTo = event.text;
        } else if (event.qname.name == "Description") {
            productCatalog.description = event.text;
        } else if (event.qname.name == "Summary") {
            productCatalog.summary = event.text;
        }            
    } else if (event.level == 5) {
        if (event.qname.name == "Url") {
            productCatalog.thumbnailURL = event.text;
        } else if (event.qname.name == "Height") {
            try {
                var strHeight = event.text;
                productCatalog.thumbnailHeight = Float.parseFloat(strHeight);
            } catch (e:Exception) { }
        } else if (event.qname.name == "Width") {
            try {
                var strWidth = event.text;
                productCatalog.thumbnailWidth = Float.parseFloat(strWidth);
            } catch (e:Exception) { }
        } else if (event.qname.name == "AverageRating") {
            productCatalog.averageRating = event.text;
        }
    }
}
