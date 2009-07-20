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
package dragndrop.model;

/**
 * Hold data related to Product catalog
 */

public class ProductCatalog {
    
    public var index: Integer = 0;
    public var id: String;
    public var url: String;
    public var productName: String;
    public var priceFrom: String;
    public var priceTo: String;
    public var thumbnailURL: String;
    public var thumbnailHeight: Number = 65.0;
    public var thumbnailWidth: Number = 65.0;
    public var description: String;
    public var summary: String;
    public var averageRating: String;
    
    override function toString() {
        return extractPlainText("{productName}");
    }
}

/**
 * Very basic implementation to remove HTML tags
 * and return just the plain text contents
 */
public function extractPlainText(string:String) : String {

    var startIndex = 0;
    var endIndex = 0;
    var index = -1;
    var returnString = string;
    var buffer:java.lang.StringBuffer;

    while(true) {

        index = returnString.indexOf("<");
        if(index != -1) {
            endIndex = returnString.indexOf(">", index);
            buffer = new java.lang.StringBuffer();
            buffer.append(returnString.substring(0, index));
            buffer.append(returnString.substring((endIndex + 1), returnString.length()));
            returnString = buffer.toString();
            startIndex = endIndex + 1;
        } else {
            break;
        }
    }

    return returnString;
}
