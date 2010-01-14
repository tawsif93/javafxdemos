/*
 * Main.fx
 *
 * Created on 12 Jan, 2010, 11:36:57 AM
 */

package javafxprint;

import javafx.scene.Scene;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.part.NumberAxis;
import javafx.scene.control.Button;
import javafx.scene.control.RadioButton;
import javafx.scene.control.ToggleGroup;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import javafxprint.CustomLineChart;
import javafxprint.Utils;
import javax.swing.JFileChooser;
import javafx.scene.layout.LayoutInfo;


/**
 * @author rakesh
 */

def series1 = LineChart.Series {
    name: "2009"
    data: [
        LineChart.Data { xValue: 8 yValue: 15.6 },
        LineChart.Data { xValue: 9 yValue: 15.1 },
        LineChart.Data { xValue: 10 yValue: 14.4 },
        LineChart.Data { xValue: 11 yValue: 16.6 },
        LineChart.Data { xValue: 12 yValue: 17.5 }
    ]
}

def series2 = LineChart.Series {
    name: "2008"
    data: [
        LineChart.Data { xValue: 8 yValue: 14.7 },
        LineChart.Data { xValue: 9 yValue: 15.6 },
        LineChart.Data { xValue: 10 yValue: 16.9 },
        LineChart.Data { xValue: 11 yValue: 16.6 },
        LineChart.Data { xValue: 12 yValue: 15.0 }
    ]
}

def lineChart = CustomLineChart {
    
    xAxis: NumberAxis {
        tickUnit:1
        lowerBound:8
        upperBound: 12
        label: "Day (in July)"
        labelTickGap: 5
    }

    yAxis: NumberAxis {
        lowerBound: 0
        upperBound: 30
        label: "Temperature"
        labelTickGap: 5
        tickMarkLength: 10
        tickMarkVisible: false
    }

    layoutInfo: LayoutInfo {
        width: 320
        height: 320
    }

}

def toggleGroup = ToggleGroup { };
def selectedButton = bind toggleGroup.selectedButton on replace {

    delete lineChart.data;

    if(selectedButton.text == "Series 1") {
        lineChart.data = [ series1 ];
    } else if(selectedButton.text == "Series 2") {
        lineChart.data = [ series2 ];
    } else {
        lineChart.data = [ series1, series2 ];
    }
}

def fileChooser = new JFileChooser();
fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);

def allButton = RadioButton { text: "All" toggleGroup: toggleGroup selected: true };
def series1Button = RadioButton { text: "Series 1" toggleGroup: toggleGroup };
def series2Button = RadioButton { text: "Series 2" toggleGroup: toggleGroup };

def saveButton = Button {
    text: "Save"
    action: function() {
        def option = fileChooser.showSaveDialog(null);
        if(option == JFileChooser.APPROVE_OPTION) {
            Utils.saveNode(lineChart, fileChooser.getSelectedFile());
        }
    }
}

def printButton = Button {
    text: "Print"
    action: function() {
        Utils.printNode(lineChart);
    }
}

def hBox = HBox {
    spacing: 10
    content: [ allButton, series1Button, series2Button, saveButton, printButton ]
}

Stage {
    title: "JavaFX - Printing"
    scene: Scene {
        width: 320
        height: 320
        content: [
            VBox {
                layoutX: 10
                layoutY: 10
                spacing: 10
                content: [ hBox, lineChart ]
            }
        ]
    }
}
