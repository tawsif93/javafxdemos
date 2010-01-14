/*
 * CustomLineChart.fx
 *
 * Created on 12 Jan, 2010, 12:07:05 PM
 */

package javafxprint;

import javafx.scene.chart.LineChart;
import javafx.scene.Group;
import javafx.scene.shape.Line;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;

/**
 * @author rakesh
 */

public class CustomLineChart extends LineChart {
    
    def background = Rectangle {
        width: bind plot.width
        height: bind plot.height
        fill: Color.ALICEBLUE
    }
    
    def horizontalGridLines:Group = Group {
        content: bind if (not horizontalGridLineVisible) then null else for(tickMark in xyAxisY.tickMarks) {
            if (tickMark.position > 1 and tickMark.position < (plot.height-1)) {
                Line {
                    stroke: horizontalGridLineStroke
                    strokeWidth: horizontalGridLineStrokeWidth
                    strokeDashArray: horizontalGridLineStrokeDashArray
                    startY: tickMark.position
                    endY: tickMark.position
                    startX: 0
                    endX: plot.width
                }
            } else { null }
        }
    }

    def verticalGridLines: Group = Group {
        content: bind if (not verticalGridLineVisible) then null else for(tickMark in xyAxisX.tickMarks) {
            if (tickMark.position > 1 and tickMark.position < (plot.width-1)) {
                Line {
                    stroke: verticalGridLineStroke
                    strokeWidth: verticalGridLineStrokeWidth
                    strokeDashArray: verticalGridLineStrokeDashArray
                    startX: tickMark.position
                    endX: tickMark.position
                    startY: 0
                    endY: plot.height
                }
            } else { null }
        }
    }
    
    override var customBackgroundContent = Group {
        content: bind [
            background,
            horizontalGridLines,
            verticalGridLines
        ]
    };
}
