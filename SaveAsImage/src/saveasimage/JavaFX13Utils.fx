/*
 * JavaFX13Utils.fx
 *
 * Created on Jan 14, 2010, 11:17:30 AM
 */

package saveasimage;

import javafx.geometry.Bounds;
import javafx.scene.Node;
import javafx.scene.layout.Resizable;

import java.awt.image.BufferedImage;
import java.applet.Applet;
import java.awt.Frame;
import javax.swing.JFrame;
import javafx.geometry.BoundingBox;
import javafx.reflect.FXLocal;
import javafx.scene.layout.Container;
import java.awt.Graphics2D;
import java.io.File;
import java.lang.Void;
import javax.imageio.ImageIO;
import saveasimage.PrintUtils;

/**
 * @author Rakesh Menon
 */

def context = FXLocal.getContext();
def nodeClass = context.findClass("javafx.scene.Node");
def getFXNode = nodeClass.getFunction("impl_getPGNode");

public function getContainer() : java.awt.Container {

    var container : java.awt.Container;

    if("{__PROFILE__}" == "browser") { // Applet
        container = FX.getArgument("javafx.applet") as Applet;
    } else { // Standalone
        var frames = Frame.getFrames();
        // We may improve this logic so as to find the
        // exact Stage (Frame) based on its title
        container = (frames[0] as JFrame).getContentPane();
    }

    return container;
}

public function nodeToImage(
    node : Node, bounds : Bounds) : BufferedImage {

    var g2:Graphics2D;

    if(node instanceof Container) {
        (node as Resizable).width = bounds.width;
        (node as Resizable).height = bounds.height;
        (node as Container).layout();
    } else if(node instanceof Resizable) {
        (node as Resizable).width = bounds.width;
        (node as Resizable).height = bounds.height;
    }

    def nodeBounds = node.layoutBounds;

    def sgNode = (getFXNode.invoke(
        context.mirrorOf(node)) as FXLocal.ObjectValue).asObject();
    def g2dClass = (context.findClass(
        "java.awt.Graphics2D") as FXLocal.ClassType).getJavaImplementationClass();
    def boundsClass = (context.findClass(
        "com.sun.javafx.geom.Bounds2D")
            as FXLocal.ClassType).getJavaImplementationClass();
    def affineClass = (context.findClass(
        "com.sun.javafx.geom.transform.BaseTransform")
            as FXLocal.ClassType).getJavaImplementationClass();

    def getBounds = sgNode.getClass().getMethod(
        "getContentBounds", boundsClass, affineClass);
    def bounds2D = getBounds.invoke(
        sgNode, new com.sun.javafx.geom.Bounds2D(),
            new com.sun.javafx.geom.transform.Affine2D());

    var paintMethod = sgNode.getClass().getMethod(
        "render", g2dClass, boundsClass, affineClass);
    def bufferedImage = new java.awt.image.BufferedImage(
        nodeBounds.width, nodeBounds.height,
        java.awt.image.BufferedImage.TYPE_INT_ARGB);

    g2 = (bufferedImage.getGraphics() as Graphics2D);
    g2.setPaint(java.awt.Color.WHITE);
    g2.fillRect(0, 0, bufferedImage.getWidth(), bufferedImage.getHeight());
    paintMethod.invoke(sgNode, g2, bounds2D,
        new com.sun.javafx.geom.transform.Affine2D());
    g2.dispose();

    return bufferedImage;
}

public function saveAsImage(node : Node, file : File) : Void {
    if(file == null) { return; }
    def image = nodeToImage(node, BoundingBox { 
        width: node.layoutBounds.width
        height: node.layoutBounds.height
    });
    ImageIO.write(image, "png", file);
}

public function printNode(node : Node) : Void {
    def image = nodeToImage(node, BoundingBox {
        width: node.layoutBounds.width
        height: node.layoutBounds.height
    });
    PrintUtils.print(image);
}
