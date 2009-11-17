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

package systemmonitor.solaris;

import systemmonitor.DataParser;

public class SolarisDataParser implements DataParser {

    public String[] getCPUData(String line) {

        String cpuStr = line.substring(line.indexOf("CPU states: ") + 12);
        int indexOfIdle = cpuStr.indexOf("% idle,");
        String idle = cpuStr.substring(0, indexOfIdle).trim();
        int indexOfUser = cpuStr.indexOf("% user,");
        String user = cpuStr.substring(indexOfIdle + 8, indexOfUser).trim();
        int indexOfSys = cpuStr.indexOf("% kernel");
        String sys = cpuStr.substring(indexOfUser + 8, indexOfSys).trim();

        return new String[] { user, sys, idle };
    }

    public String[] getMemoryData(String line) {

        String memStr = line.substring(line.indexOf("Memory: ") + 8);

        if(memStr.contains("real, ")) {

            int indexOfReal = memStr.indexOf(" real,");
            String real = memStr.substring(0, indexOfReal).trim();
            if(real.endsWith("G")) {
                real = real.substring(0, real.length() - 1);
                long realLong = Long.parseLong(real);
                real = "" + (realLong * 1024);
            } else {
                real = real.substring(0, real.length() - 1);
            }

            int indexOfFree = memStr.indexOf("M free,");
            String free = memStr.substring(indexOfReal + 6, indexOfFree).trim();

            long realLong = Long.parseLong(real);
            long freeLong = Long.parseLong(free);

            return new String[] { "" + (realLong - freeLong), free };
        }
        
        int indexOfUsed = memStr.indexOf("M phys mem,");
        String physMem = memStr.substring(0, indexOfUsed).trim();
        int indexOfFree = memStr.indexOf("M free mem");
        String free = "0.5";
        if(indexOfFree >= 0) {
            free = memStr.substring(indexOfUsed + 11, indexOfFree).trim();
        }

        long realLong = Long.parseLong(physMem);
        long freeLong = Long.parseLong(free);

        return new String[] { "" + (realLong - freeLong), free };
    }
    
    public boolean isCPULine(String line) {
        return line.startsWith("CPU states: ");
    }

    public boolean isMemoryLine(String line) {
        return line.startsWith("Memory: ");
    }
}
