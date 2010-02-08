package deployment;

import java.awt.AlphaComposite;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.MediaTracker;
import java.awt.Paint;
import java.awt.RenderingHints;
import java.awt.Stroke;
import java.awt.Toolkit;
import java.awt.geom.Arc2D;
import java.util.Timer;
import java.util.TimerTask;
import javax.swing.JComponent;

/**
 *
 * @author Rakesh Menon
 */

public class ProgressView extends JComponent {

    private int progress = 0;
    private int subProgress = 1;
    private String message = "Dependent files...";
    private String title = "Downloading";

    private int refreshRate = 60;
    private int speed = 30;
    private Font smallFont = new Font("sansserif", Font.BOLD, 12);
    private Font largeFont = new Font("sansserif", Font.BOLD, 20);
    private Paint fill = Color.WHITE;
    private Paint circleFill = new Color(244, 146, 32);
    private Paint textFill = new Color(107, 145, 169);
    private int progressX = 100;
    private int progressY = 0;
    private int textY = 100;
    private int radius = 60;
    
    private int angle = 0;
    private Image bgImage = null;
    private int imageWidth = 0;
    private int imageHeight = 0;
    
    private int fontAscent = 10;
    private int fontHeight = 10;

    private Dimension prefSize = new Dimension(240, 320);
    private Timer timer = null;

    public ProgressView() {

        initBackground();

        TimerTask timerTask = new TimerTask() {
            @Override
            public void run() {
                Runnable runnable = new Runnable() {
                    @Override
                    public void run() {
                        repaint();
                    }
                };
                EventQueue.invokeLater(runnable);
                angle += speed;
                if(angle > 360) angle = 0;
            }
        };
        timer = new Timer("ProgressListener");
        timer.schedule(timerTask, refreshRate, refreshRate);
    }
    
    private void initBackground() {

        try {

            bgImage = Toolkit.getDefaultToolkit().getImage(
                getClass().getResource("/deployment/images/bg.png"));
            MediaTracker mt = new MediaTracker(this);
            mt.addImage(bgImage, 0);
            mt.waitForID(0);
            
            imageWidth = bgImage.getWidth(this);
            imageHeight = bgImage.getHeight(this);
            //prefSize = new Dimension(width, height);

        } catch (Exception e) { }

        progressX = prefSize.width/2 - radius;
        progressY = prefSize.height/2 - radius - 5;
        textY = progressY + radius + 20;
    }
    
    @Override
    public void paintComponent(Graphics g) {
        
        Dimension size = getSize();
        
        Graphics2D g2d = (Graphics2D) g;
        g2d.setPaint(fill);
        g2d.fillRect(0, 0, size.width, size.height);
        
        if((size.width > prefSize.width) || (size.height > prefSize.height)) {
            int tx = (size.width - prefSize.width)/2;
            int ty = (size.height - prefSize.height)/2;
            g2d.translate(tx, ty);
        }
        
        if(bgImage != null) {
            int imageX = (size.width - imageWidth)/2;
            int imageY = (size.height - imageHeight)/2;
            g2d.drawImage(bgImage, imageX, imageY, this);
        }
         
        g2d.translate(progressX, progressY);
        
        Stroke stroke = new BasicStroke(
            10, BasicStroke.CAP_BUTT, BasicStroke.CAP_BUTT);
        
        g2d.setRenderingHint(
            RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setStroke(stroke);
        g2d.setPaint(circleFill);
        
        AlphaComposite alphaComposite = AlphaComposite.getInstance(
            AlphaComposite.SRC_OVER, 0);
        Arc2D arc = new Arc2D.Float(
            20, 20, (radius * 2) - 40, (radius * 2) - 40, 0, 60, Arc2D.OPEN);
        
        for(int i=0; i<360; i+=60) {
            arc.setAngleStart(i);
            float alpha = (360-angle-i)/(float)360;
            if(alpha <= 0) {
                alpha = (float)(1.0 + alpha);
            }
            g2d.setComposite(alphaComposite.derive(alpha));
            g2d.draw(arc);
        }
        
        g2d.setComposite(alphaComposite.derive(1.0f));
        g2d.setPaint(textFill);
        g2d.setFont(largeFont);
        g2d.setRenderingHint(
            RenderingHints.KEY_TEXT_ANTIALIASING,
            RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        
        // Progress
        FontMetrics fm = g2d.getFontMetrics();
        String progressText = "" + progress + "%";
        int sw = fm.stringWidth(progressText);
        fontAscent = Math.max(fontAscent, fm.getMaxAscent());
        fontHeight = Math.max(fontHeight, fm.getHeight());
        if(progress > 0) {
            g2d.drawString(progressText,
                           ((radius * 2) - sw)/2 + 5, ((radius * 2) - fontHeight)/2 + fontAscent);
        }
        
        g2d.setFont(smallFont);
        fm = g2d.getFontMetrics();
        fontAscent = fm.getMaxAscent();
        fontHeight = fm.getHeight();
        
        // Title
        title = clipString(this, fm, title, prefSize.width - 30);
        sw = fm.stringWidth(title);
        g2d.drawString(title, ((radius * 2) - sw)/2, textY + fontAscent);
        g2d.translate(0, fontHeight);
        
        // Message
        message = clipString(this, fm, message, prefSize.width - 30);
        sw = fm.stringWidth(message);
        g2d.drawString(message, ((radius * 2) - sw)/2, textY + fontAscent);
        
        // Sub Progress Bar
        g2d.translate(-progressX, textY + fontHeight + 5);
        
        g2d.setPaint(textFill);
        g2d.fillRoundRect(20, 5, prefSize.width - 40, 8, 5, 5);
        
        g2d.setPaint(circleFill);
        g2d.fillRoundRect(21, 6, (int)((prefSize.width - 42) * subProgress/100.0), 6, 5, 5);
    }
    
    @Override
    public Dimension getPreferredSize() {
        return prefSize;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getProgress() {
        return progress;
    }

    public void setProgress(int progress) {
        if(progress > 100) {
            this.progress = 100;
        } else {
            this.progress = progress;
        }
    }
    
    public Paint getCircleFill() {
        return circleFill;
    }

    public void setCircleFill(Paint circleFill) {
        this.circleFill = circleFill;
    }

    public Paint getFill() {
        return fill;
    }

    public void setFill(Paint fill) {
        this.fill = fill;
    }

    public int getRadius() {
        return radius;
    }

    public void setRadius(int radius) {
        this.radius = radius;
    }

    public int getSpeed() {
        return speed;
    }

    public void setSpeed(int speed) {
        this.speed = speed;
    }

    public Paint getTextFill() {
        return textFill;
    }

    public void setTextFill(Paint textFill) {
        this.textFill = textFill;
    }

    public int getTextY() {
        return textY;
    }

    public void setTextY(int textY) {
        this.textY = textY;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getSubProgress() {
        return subProgress;
    }
    
    public void setSubProgress(int subProgress) {
        
        if(subProgress < 0) {
            this.subProgress = 1;
        } else if(subProgress > 100) {
            this.subProgress = 100;
        } else {
            this.subProgress = subProgress;
        }
    }

    /**
     *  Copied from sun.swing.SwingUtilities2
     */
    
    //all access to  charsBuffer is to be synchronized on charsBufferLock
    private static final int CHAR_BUFFER_SIZE = 100;
    private static final Object charsBufferLock = new Object();
    private static char[] charsBuffer = new char[CHAR_BUFFER_SIZE];
    
    /**
     * Clips the passed in String to the space provided.  NOTE: this assumes
     * the string does not fit in the available space.
     *
     * @param c JComponent that will display the string, may be null
     * @param fm FontMetrics used to measure the String width
     * @param string String to display
     * @param availTextWidth Amount of space that the string can be drawn in
     * @return Clipped string that can fit in the provided space.
     */
    private static String clipString(
        JComponent c, FontMetrics fm, String string, int availTextWidth) {

        int stringWidth = fm.stringWidth(string);
        if(stringWidth <= availTextWidth) {
            return string;
        }
        
        // c may be null here.
        String clipString = "...";
        int stringLength = string.length();
        stringWidth = 0;
        if (!(string == null || string.equals(""))) {
            stringWidth = fm.stringWidth(clipString);
        }
        availTextWidth -= stringWidth;
        if (availTextWidth <= 0) {
            //can not fit any characters
            return clipString;
        }
        
        synchronized (charsBufferLock) {
            if (charsBuffer == null || charsBuffer.length < stringLength) {
                charsBuffer  = string.toCharArray();
            } else {
                string.getChars(0, stringLength, charsBuffer, 0);
            }
            int width = 0;
            for (int nChars = 0; nChars < stringLength; nChars++) {
                width += fm.charWidth(charsBuffer[nChars]);
                if (width > availTextWidth) {
                    string = string.substring(0, nChars);
                    break;
                }
            }
        }
        
        return string + clipString;
    }
}
