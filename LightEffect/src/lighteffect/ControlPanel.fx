   /*
 * ControlPanel.fx
 *
 * Created on 16 Mar, 2009, 11:18:23 AM
 */

package lighteffect;

import javafx.scene.CustomNode;
import javafx.scene.effect.light.DistantLight;
import javafx.scene.effect.light.PointLight;
import javafx.scene.effect.light.SpotLight;
import javafx.scene.effect.Lighting;
import javafx.scene.layout.VBox;
import javafx.scene.Node;
import javafx.scene.paint.Color;

/**
 * @author Rakesh Menon
 */

public class ControlPanel extends CustomNode {

    // Light Attributes
    public var color = Color.WHITE;
    public var colorDef = "#FFFFFF";

    var diffuseConstantSlider = SliderControl {
        title: "Diffuse Constant"
        minimum: 0
        maximum: 20
        scaleFactor: 10.0
        default: 1.0
    }

    var specularConstantSlider = SliderControl {
        title: "Specular Constant"
        minimum: 0
        maximum: 20
        scaleFactor: 10.0
        default: 0.3
    }

    var specularExponentSlider = SliderControl {
        title: "Specular Exponent"
        minimum: 0
        maximum: 40
        scaleFactor: 1
        default: 20
    }

    var surfaceScaleSlider = SliderControl {
        title: "Surface Scale"
        minimum: 0
        maximum: 100
        scaleFactor: 10.0
        default: 1.5
    }

    // DistantLight Attributes
    var azimuthSlider = SliderControl {
        title: "DistantLight.azimuth"
        minimum: 0
        maximum: 360
        scaleFactor: 1
        default: 45
    }
    var elevationSlider = SliderControl {
        title: "DistantLight.elevation"
        minimum: 0
        maximum: 180
        scaleFactor: 1
        default: 45
    }

    // PointLight Attributes
    var pointXSlider = SliderControl {
        title: "PointLight.x"
        minimum: -500
        maximum: 500
        scaleFactor: 1
        default: 80
    }
    var pointYSlider = SliderControl {
        title: "PointLight.y"
        minimum: -500
        maximum: 500
        scaleFactor: 1
        default: 180
    }
    var pointZSlider = SliderControl {
        title: "PointLight.z"
        minimum: -500
        maximum: 500
        scaleFactor: 1
        default: 40
    }

    // SpotLight Attributes
    var pointsAtXSlider = SliderControl {
        title: "SpotLight.pointsAtX"
        minimum: -500
        maximum: 500
        scaleFactor: 1
        default: 400
    }
    var pointsAtYSlider = SliderControl {
        title: "SpotLight.pointsAtY"
        minimum: -500
        maximum: 500
        scaleFactor: 1
        default: 0
    }
    var pointsAtZSlider = SliderControl {
        title: "SpotLight.pointsAtZ"
        minimum: -500
        maximum: 500
        scaleFactor: 1
        default: 0
    }

    public var lighting = bind Lighting {
        diffuseConstant: bind diffuseConstantSlider.value
        specularConstant: bind specularConstantSlider.value
        specularExponent: bind specularExponentSlider.value
        surfaceScale: bind surfaceScaleSlider.value
    }

    var lightType = "DistantLight";

    public var lightingCode = bind ""
        "effect: Lighting \{\n"
        "    diffuseConstant: {diffuseConstantSlider.value}\n"
        "    specularConstant: {specularConstantSlider.value}\n"
        "    specularExponent: {specularExponentSlider.value}\n"
        "    surfaceScale: {surfaceScaleSlider.value}\n"
        "{
        getLightCode(
        lightType, azimuthSlider.value, elevationSlider.value,
        pointXSlider.value, pointYSlider.value, pointZSlider.value,
        pointsAtXSlider.value, pointsAtYSlider.value, pointsAtZSlider.value, colorDef )
        }"
    "\}";

    override function create() : Node {

        var sliderBox = VBox {
            content: [
                diffuseConstantSlider,
                specularConstantSlider,
                specularExponentSlider,
                surfaceScaleSlider,
                azimuthSlider,
                elevationSlider,
                pointXSlider,
                pointYSlider,
                pointZSlider,
                pointsAtXSlider,
                pointsAtYSlider,
                pointsAtZSlider
            ]
            spacing: 5
        };

        updateLight("DistantLight");
        return sliderBox;
    }

    public function updateLight(lightType : String) : Void {

        this.lightType = lightType;

        if("DistantLight".equalsIgnoreCase(lightType)) {

            azimuthSlider.disable = false;
            elevationSlider.disable = false;
            pointXSlider.disable = true;
            pointYSlider.disable = true;
            pointZSlider.disable = true;
            pointsAtXSlider.disable = true;
            pointsAtYSlider.disable = true;
            pointsAtZSlider.disable = true;

            lighting.light = DistantLight {
                azimuth: bind azimuthSlider.value
                elevation: bind elevationSlider.value
                color: bind color
            };

        } else if("PointLight".equalsIgnoreCase(lightType)) {

            azimuthSlider.disable = true;
            elevationSlider.disable = true;
            pointXSlider.disable = false;
            pointYSlider.disable = false;
            pointZSlider.disable = false;
            pointsAtXSlider.disable = true;
            pointsAtYSlider.disable = true;
            pointsAtZSlider.disable = true;

            lighting.light = PointLight {
                x: bind pointXSlider.value
                y: bind pointYSlider.value
                z: bind pointZSlider.value
                color: bind color
            };

        } else {

            azimuthSlider.disable = true;
            elevationSlider.disable = true;
            pointXSlider.disable = false;
            pointYSlider.disable = false;
            pointZSlider.disable = false;
            pointsAtXSlider.disable = false;
            pointsAtYSlider.disable = false;
            pointsAtZSlider.disable = false;

            lighting.light = SpotLight {
                x: bind pointXSlider.value
                y: bind pointYSlider.value
                z: bind pointZSlider.value
                pointsAtX: bind pointsAtXSlider.value
                pointsAtY: bind pointsAtYSlider.value
                pointsAtZ: bind pointsAtZSlider.value
                color: bind color
            };
        }
    }

    public function getLightCode(
        lightType : String,
        azimuth : Number, elevation : Number,
        pointX : Number, pointY : Number, pointZ : Number,
        pointsAtX : Number, pointsAtY : Number, pointsAtZ : Number,
        colorDef : String
    ) : String {

        var lightCode = "";

        if("DistantLight".equalsIgnoreCase(lightType)) {

            lightCode = ""
                "    light: DistantLight \{\n"
                "        azimuth: {azimuth}\n"
                "        elevation: {elevation}\n"
                "        color: Color.web(\"{colorDef}\")\n"
            "    \}\n";

        } else if("PointLight".equalsIgnoreCase(lightType)) {

            lightCode = ""
                "    light: PointLight \{\n"
                "        x: {pointX}\n"
                "        y: {pointY}\n"
                "        z: {pointZ}\n"
                "        color: Color.web(\"{colorDef}\")\n"
            "    \}\n";

        } else {

            lightCode = ""
                "    light: PointLight \{\n"
                "        x: {pointX}\n"
                "        y: {pointY}\n"
                "        z: {pointZ}\n"
                "        pointsAtX: {pointsAtX}\n"
                "        pointsAtY: {pointsAtY}\n"
                "        pointsAtZ: {pointsAtZ}\n"
                "        color: Color.web(\"{colorDef}\")\n"
            "    \}\n";
        }

        lightCode;
    }
}
