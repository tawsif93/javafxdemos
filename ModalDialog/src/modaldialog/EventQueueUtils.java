/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package modaldialog;

import java.awt.AWTEvent;
import java.awt.EventQueue;
import java.awt.Toolkit;

/**
 *
 * @author Rakesh Menon
 */

public class EventQueueUtils {

    private final DialogEventQueue eventQueue =
            new DialogEventQueue();
    private boolean blocked = false;

    /**
     * Push a new EventQueue and block current Thread
     */
    public void blockEDT() {

        synchronized(this) {

            EventQueue systemEventQueue =
                Toolkit.getDefaultToolkit().getSystemEventQueue();
            systemEventQueue.push(eventQueue);
            
            try {
                blocked = true;
                wait();
            } catch (Exception e) {
                blocked = false;
                eventQueue.pop();
            }
        }
    }

    /**
     * Pop EventQueue and notify all blocked Thread
     */
    public void unblockEDT() {

        synchronized(this) {

            if(!blocked) { return; }
            
            try {
                eventQueue.pop();
                notifyAll();
            } catch (Exception e) {
                //e.printStackTrace();
            }

            blocked = false;
        }
    }

    class DialogEventQueue extends EventQueue {

        public void pop() { super.pop(); }

        protected void dispatchEvent(AWTEvent event) {
            //System.out.println(event);
            super.dispatchEvent(event);
        }
    }
}
