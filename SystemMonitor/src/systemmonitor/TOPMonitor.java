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

import java.io.File;
import java.util.Map;

public class TOPMonitor implements Runnable {

    private String interval = "1";

    private UpdateListener updateListener = null;
    private Thread thread = null;

    public TOPMonitor(UpdateListener ul, String interval) {
        thread = new Thread(this);
        this.updateListener = ul;
        this.interval = interval;
    }

    public void start() {
        thread.start();
    }

    public void run() {

        System.out.println("TopMonitor : Start");
        
        try {

            ProcessBuilder pb = null;

            if(DataParserFactory.OS_NAME.startsWith("linux")) {
                pb = new ProcessBuilder("/usr/bin/top", "-b", "-d", interval);
            } else if(DataParserFactory.OS_NAME.startsWith("sunos")) {
                pb = new ProcessBuilder("/usr/bin/top", "-s" + interval);
            } else {
                pb = new ProcessBuilder("/usr/bin/top", "-s", interval);
            }

            Map<String, String> env = pb.environment();
            env.put("TERM", "xterm");
            env.put("LANG", "en_US.UTF-8");
            env.put("LC_ALL", "en_US.UTF-8");

            Process process = pb.start();

            StreamReader srIn = new StreamReader(
                    process.getInputStream(), updateListener);
            srIn.start();
            StreamReader srErr = new StreamReader(
                    process.getErrorStream(), null);
            srErr.start();
            process.waitFor();
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println("TopMonitor : End");
    }
}
