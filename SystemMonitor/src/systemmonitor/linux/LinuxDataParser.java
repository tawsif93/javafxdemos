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

package systemmonitor.linux;

import systemmonitor.DataParser;

public class LinuxDataParser implements DataParser {

    public String[] getCPUData(String line) {

        String cpuStr = line.substring(line.indexOf("Cpu(s): ") + 8);
        int indexOfUser = cpuStr.indexOf("%us,");
        String user = cpuStr.substring(0, indexOfUser).trim();
        int indexOfSys = cpuStr.indexOf("%sy,");
        String sys = cpuStr.substring(indexOfUser + 5, indexOfSys).trim();
        int indexOfIdle = cpuStr.indexOf("%id,");
        int indexOfNi = cpuStr.indexOf("%ni,");
        String idle = cpuStr.substring(indexOfNi + 5, indexOfIdle).trim();

        return new String[] { user, sys, idle };
    }

    public String[] getMemoryData(String line) {

        String memStr = line.substring(line.indexOf("total, ") + 7);
        int indexOfUsed = memStr.indexOf("k used,");
        String used = memStr.substring(0, indexOfUsed).trim();
        double usedN = Double.parseDouble(used);
        used = "" + (usedN/1024.0);
        int indexOfFree = memStr.indexOf("k free.");
        String free = "0.5";
        if(indexOfFree >= 0) {
            free = memStr.substring(indexOfUsed + 7, indexOfFree).trim();
            double freeN = Double.parseDouble(free);
            free = "" + (freeN/1024.0);
        }

        return new String[] { used, free };
    }

    public boolean isCPULine(String line) {
        return line.startsWith("Cpu(s): ");
    }

    public boolean isMemoryLine(String line) {
        return line.startsWith("Mem: ");
    }
}
