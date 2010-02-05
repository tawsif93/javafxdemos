package alwaysontop;

import java.awt.AWTEvent;
import java.awt.Color;
import java.awt.Point;
import java.awt.Toolkit;
import java.awt.event.AWTEventListener;
import java.awt.event.ContainerEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javafx.lang.FX;
import javax.swing.JDialog;
import javax.swing.JFrame;

/**
 *
 * @author Rakesh Menon
 */

public class FXDialogUtils extends MouseAdapter
        implements AWTEventListener, MouseMotionListener {

    private JDialog dialog = null;

    private Point startPoint = null;
    private int startX = 0;
    private int startY = 0;

    public FXDialogUtils() {
        // Listen to ComponentEvent
        Toolkit.getDefaultToolkit().addAWTEventListener(
                this, AWTEvent.COMPONENT_EVENT_MASK);
    }

    public JDialog getDialog() {
        return dialog;
    }

    public void eventDispatched(AWTEvent event) {

        if(event.getID() == ContainerEvent.COMPONENT_RESIZED) {

            if(event.getSource() instanceof JFrame) {

                // Remove AWT Event Listener
                Toolkit.getDefaultToolkit().removeAWTEventListener(this);

                if(dialog == null) {

                    // Get instance of Stage - Frame
                    JFrame frame = (JFrame) event.getSource();
                    frame.dispose();

                    // Create Dialog instance
                    dialog = new JDialog((JFrame)null, frame.getTitle(), false);
                    dialog.addWindowListener(new WindowAdapter() {
                        @Override
                        public void windowClosing(WindowEvent we) {
                            FX.exit();
                        }
                    });

                    // Set dialog attributes
                    dialog.setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
                    dialog.setAlwaysOnTop(true);
                    dialog.setSize(frame.getSize());
                    dialog.setLocation(frame.getLocation());
                    dialog.setUndecorated(true);
                    dialog.setBackground(Color.BLACK);

                    dialog.setContentPane(frame.getContentPane());
                    dialog.getContentPane().addMouseListener(this);
                    dialog.getContentPane().addMouseMotionListener(this);

                    dialog.setVisible(true);
                }
            }
        }
    }

    public void mousePressed(MouseEvent me) {
        startPoint = dialog.getLocationOnScreen();
        startX = me.getX();
        startY = me.getY();
    }

    public void mouseDragged(MouseEvent me) {
        startPoint.translate(me.getX() - startX, me.getY() - startY);
        dialog.setLocation(startPoint);
    }

    public void mouseMoved(MouseEvent me) {

    }
}
