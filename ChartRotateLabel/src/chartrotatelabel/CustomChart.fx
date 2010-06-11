/**
 * CustomChart.fx
 *
 * Created on 11 Jun, 2010, 9:59:04 PM
 */

package chartrotatelabel;

import javafx.scene.chart.BarChart;
import javafx.scene.layout.Container;
import javafx.scene.chart.part.NumberAxis;
import javafx.scene.chart.part.Side;

/**
 * @author Rakesh Menon
 */

public class CustomChart extends Container {

    /* Percentage usages */
    def category = [ "C++", "C", "Java", "Perl", "PHP", "SQL", "Others" ];
    def value = [ 15, 20, 25, 15, 8, 7, 10 ];

    def series = BarChart.Series {
        name: "Language Usage"
    };
    def barChart = BarChart {
        data: bind series
        categoryAxis: CustomCategoryAxis {
            categories: category
        }
        valueAxis: NumberAxis {
            lowerBound: 0
            upperBound: 50
            tickUnit: 10
        }
        legendSide: Side.TOP
        legendVisible: true
    };
    
    init {
        
        content = barChart;

        for(i in [0..6]) {
            insert BarChart.Data {
                category: category[i]
                value: value[i]
            } into series.data;
        }
    }
    
    override function doLayout() : Void {
        layoutNode(barChart, 0, 0, width, height - 20);
    }
}
