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

package systemmonitor;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import javax.swing.SwingUtilities;

public class StreamReader implements Runnable {

    private UpdateListener updateListener;
    private InputStream in = null;
    private Thread thread = null;
    private DataParser dataParser = null;

    public StreamReader(InputStream in, UpdateListener ul) {
        thread = new Thread(this);
        this.in = in;
        updateListener = ul;
        dataParser = DataParserFactory.getInstance();
    }

    public void start() {
        thread.start();
    }

    public void run() {

        //System.out.println("StreamReader : Start");
        
        try {

            //
            // CPU usage: 13.94% user,  7.21% sys, 78.85% idle
            // PhysMem:  982M wired, 1175M active, 1617M inactive, 4030M used,   66M free.
            //
            BufferedReader reader = new BufferedReader(new InputStreamReader(in));
            String line = reader.readLine();
            while(line != null) {
                if(updateListener == null) {
                    System.out.println(line);
                } else {
                    update(line);
                }
                line = reader.readLine();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        //System.out.println("StreamReader : End");
    }

    private void update(String line) {

        try {

            if(dataParser.isCPULine(line)) {

                final String[] data = dataParser.getCPUData(line);

                SwingUtilities.invokeLater(new Runnable() {
                    public void run() {
                        updateListener.updateCPU(data[0], data[1], data[2]);
                    }
                });
                
            } else if(dataParser.isMemoryLine(line)) {

                final String[] data = dataParser.getMemoryData(line);

                SwingUtilities.invokeLater(new Runnable() {
                    public void run() {
                        updateListener.updateMemory(data[0], data[1]);
                    }
                });
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
