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

import javafx.scene.chart.LineChart;
import javafx.scene.chart.part.NumberAxis;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.text.Font;
import javafx.scene.Group;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.chart.part.Side;
import systemmonitor.TOPMonitor;
import systemmonitor.solaris.SolarisMonitor;

public class SystemMonitor extends CustomNode, UpdateListener {

    public-init var width = 400.0;
    public-init var height = 200.0;
    
    public-init var interval : String = "1";
    
    var cpuLineChartSeries : LineChart.Series[] = [
        LineChart.Series { name: "User" },
        LineChart.Series { name: "System" },
        LineChart.Series { name: "Idle" }
    ];

    var cpuLineChart = LineChart {

        translateX: 10
        translateY: 10

        title: "CPU"
        showSymbols: false
        data: cpuLineChartSeries
        legendSide: Side.RIGHT

        xAxis: TickNumberAxis {
            lowerBound: 0
            upperBound: 60
            tickUnit: 10
            label: "Time"
            labelFont: Font { size: 10 }
            tickLabelTickGap: 10
            tickLabelFont: Font { size: 9 }
            labelTickGap: 10
            tickMarkLength: 10
            showTicks: false
        }

        yAxis: TickNumberAxis {
            lowerBound: 0
            upperBound: 100
            tickUnit: 20
            label: "CPU %"
            labelFont: Font { size: 10 }
            tickLabelTickGap: 10
            tickLabelFont: Font { size: 9 }
            labelTickGap: 10
            tickMarkLength: 10
            tickMarkVisible: false
        }
        height: height/2.0 - 20
        width: width - 20
    }

    var memLineChartSeries : LineChart.Series[] = [
        LineChart.Series { name: "Used" },
        LineChart.Series { name: "Free" }
    ];

    var memLineChart = LineChart {

        translateX: 10
        translateY: height/2.0 + 15

        title: "Memory"
        showSymbols: false
        data: memLineChartSeries
        legendSide: Side.RIGHT
        
        xAxis: TickNumberAxis {
            lowerBound: 0
            upperBound: 60
            tickUnit: 10
            label: "Time"
            labelFont: Font { size: 10 }
            tickLabelTickGap: 10
            tickLabelFont: Font { size: 9 }
            labelTickGap: 10
            tickMarkLength: 10
            showTicks: false
        }

        yAxis: TickNumberAxis {
            lowerBound: 0
            upperBound: 8
            tickUnit: 1
            label: "Memory - GB"
            labelFont: Font { size: 10 }
            tickLabelTickGap: 10
            tickLabelFont: Font { size: 9 }
            labelTickGap: 10
            tickMarkLength: 10
            tickMarkVisible: false
        }
        height: height/2.0 - 20
        width: width - 20
    }

    public override function create() : Node {
        
        var bgRect = Rectangle {
            width: width
            height: height
            fill: Color.IVORY
            arcWidth: 5
            arcHeight: 5
        }

        var borderCPURect = Rectangle {
            x: cpuLineChart.translateX - 5
            y: cpuLineChart.translateY - 5
            width: cpuLineChart.width + 10
            height: cpuLineChart.height + 5
            stroke: Color.GRAY
            fill: Color.TRANSPARENT
            arcWidth: 5
            arcHeight: 5
        }

        var borderMEMRect = Rectangle {
            x: memLineChart.translateX - 5
            y: memLineChart.translateY - 5
            width: memLineChart.width + 10
            height: memLineChart.height + 5
            stroke: Color.GRAY
            fill: Color.TRANSPARENT
            arcWidth: 5
            arcHeight: 5
        }

        Group {
            translateX: 10
            translateY: 10
            content: [ 
                bgRect,
                borderCPURect, cpuLineChart,
                borderMEMRect, memLineChart
            ]
        }
    }

    public function start() : Void {
        if(DataParserFactory.OS_NAME.startsWith("sunos")) {
            var solarisMonitor = new SolarisMonitor(this, interval);
            solarisMonitor.start();
        } else {
            var topMonitor = new TOPMonitor(this, interval);
            topMonitor.start();
        }

    }

    var cpuIndex = 0;

    public override function updateCPU(user:String, sys:String, idle:String) {

        insert LineChart.Data { 
            xValue: cpuIndex
            yValue: Number.parseFloat(user)
        } into cpuLineChartSeries[0].data;

        insert LineChart.Data { 
            xValue: cpuIndex
            yValue: Number.parseFloat(sys)
        } into cpuLineChartSeries[1].data;

        insert LineChart.Data {
            xValue: cpuIndex
            yValue: Number.parseFloat(idle)
        } into cpuLineChartSeries[2].data;

        if(cpuIndex < cpuLineChart.xAxis.upperBound) {
            cpuIndex += 1;
        } else {
            cpuLineChart.xAxis.lowerBound += 1;
            cpuLineChart.xAxis.upperBound += 1;
            delete cpuLineChartSeries[0].data[0];
            delete cpuLineChartSeries[1].data[0];
            delete cpuLineChartSeries[2].data[0];
        }
    }

    var memIndex = 0;

    public override function updateMemory(used:String, free:String) {

        insert LineChart.Data {
            xValue: memIndex
            yValue: Number.parseFloat(used)/1024.0
        } into memLineChartSeries[0].data;
        
        insert LineChart.Data {
            xValue: memIndex
            yValue: Number.parseFloat(free)/1024.0
        } into memLineChartSeries[1].data;

        if(memIndex < memLineChart.xAxis.upperBound) {
            memIndex += 1;
        } else {
            memLineChart.xAxis.lowerBound += 1;
            memLineChart.xAxis.upperBound += 1;
            delete memLineChartSeries[0].data[0];
            delete memLineChartSeries[1].data[0];
        }
    }
}

class TickNumberAxis extends NumberAxis {

    public-init var showTicks = true;
    
    var firstTime = true;

    override function updateTickMarks() : Void {
        if(firstTime and showTicks) {
            super.updateTickMarks();
            firstTime = false;
        }
    }
}
