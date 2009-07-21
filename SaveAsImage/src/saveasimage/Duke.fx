/*
 * Duke.fx
 *
 * Created on 21 Jul, 2009, 9:04:10 AM
 */

package saveasimage;

import javafx.scene.paint.Color;
import javafx.scene.paint.RadialGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.SVGPath;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.effect.DropShadow;

/**
 * @author Rakesh Menon
 */

public class Duke extends CustomNode {

    public-read var svgPath : SVGPath[];

    override function create() : Node {

        // Head + Body
        insert
        SVGPath {
            content: "M48.859,43.518c8.424,17.64,2.736,140.832-7.128,184.032"
                     "c-9.864,43.272-19.728,98.28-22.032,144.576c-1.008,19.728,"
                     "2.016,27.504,14.904,27.504c22.752,0,51.624-47.952,87.84-46.872"
                     "c36.288,1.08,47.808,55.008,64.8,54.648c16.992-0.36,30.672-6.264,"
                     "30.816-58.752C218.563,191.981,87.235,64.973,48.859,43.518"
                     "L48.859,43.518L48.859,43.518L48.859,43.518z"
            fill: Color.BLACK
            strokeWidth: 3.0
            strokeDashArray: [ 10, 5, 10 ]
        } into svgPath;

        // Duke Shape
        insert
        SVGPath {
            content: "M162.763,168.726c7.992,13.464,28.368,3.096,29.232-12.096"
                     "c0.864-15.192-1.368-34.344-11.232-35.064c-9.864-0.72-16.92-"
                     "10.584-26.784-11.304c-9.864-0.72-20.448,9.144-25.056-3.96"
                     "s12.384-18.648,25.056-20.736c-11.304-11.304-17.928-23.832-"
                     "22.896-36.864c-4.968-13.032-8.64-24.984,5.256-30.096c13.896-"
                     "5.112,12.744,21.168,28.656,33.192c-4.68-17.712-6.408-25.056-"
                     "6.048-35.352s-0.36-18.144,14.256-16.128c14.616,2.016,8.28,32.4,"
                     "19.656,44.784c3.456-11.736,5.544-26.64,13.896-32.76s27.36-6.264,"
                     "15.264,18.864c-12.096,25.128,3.528,38.736-0.144,58.536c-3.672,"
                     "19.8-15.048,16.2-19.944,28.944c-4.896,12.744,2.88,41.76-6.336,"
                     "54.792c-9.216,13.032-10.872,33.048-4.896,49.032C172.339,205.374,"
                     "162.763,168.726,162.763,168.726L162.763,168.726L162.763,168.726"
                     "L162.763,168.726z"
            fill: Color.BLACK
            strokeWidth: 3.0
            strokeDashArray: [ 10, 5, 10 ]
        } into svgPath;

        // Left Hand
        insert
        SVGPath {
            content: "M48.355,185.646c-7.416,50.832-33.192,56.88-34.488,77.976"
                     "c-1.296,21.096,6.84,23.112,6.336,42.624c-0.504,19.512-17."
                     "856,27.432-19.944,38.016s8.928,13.968,15.336,13.968c6.408,"
                     "0,12.816-28.08,15.408-45.936s-8.496-28.368-8.496-40.608c0-"
                     "12.24,16.056-34.632,13.104-14.976C48.931,235.686,55.268,208"
                     ".901,48.355,185.646L48.355,185.646L48.355,185.646L48.355,185.646z"
            fill: Color.BLACK
            strokeWidth: 3.0
            strokeDashArray: [ 10, 5, 10 ]
        } into svgPath;

        // Body
        insert
        SVGPath {
            content: "M58.292,205.013c-5.616,27.504-40.68,181.08-22.824,183.024"
                     "c17.856,1.944,43.272-47.52,84.888-47.16c41.688,0.36,58.104,"
                     "55.44,68.256,55.08c10.152-0.36,16.848,3.6,17.928-58.464"
                     "c1.08-62.064-36.792-141.336-59.184-176.256C116.971,163.181,"
                     "84.283,187.518,58.292,205.013L58.292,205.013L58.292,205.013"
                     "L58.292,205.013z"
            fill: Color.WHITE
            strokeWidth: 3.0
            strokeDashArray: [ 10, 5, 10 ]
        } into svgPath;

        // Nose
        insert
        SVGPath {
            content: "M147.082,171.533c-1.662-17.195-14.407-27.988-30.895-30.627c-15."
                     "924-2.549-33.26,4.998-44.408,16.146c-12.538,12.538-13.039,29.978-"
                     "4.26,44.833c8.661,14.657,27.847,19.501,43.563,15.835C132.588,212"
                     ".705,148.48,193.896,147.082,171.533"
            fill: RadialGradient {
                centerX: 0.75
                centerY: 0.5
                radius: 1.0
                stops: [
                    Stop {
                        offset: 0.0
                        color: Color.LIGHTGRAY
                    },
                    Stop {
                        offset: 0.5
                        color: Color.RED
                    }
                ]
            }
            strokeWidth: 3.0
            strokeDashArray: [ 10, 5, 10 ]
        } into svgPath;

        Group {
            content: svgPath
            effect: DropShadow {
                offsetX: 10
                offsetY: 10
                color: Color.color(0.4, 0.4, 0.4)
            }
        }
    }
}
