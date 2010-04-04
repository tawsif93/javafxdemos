/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package modaldialog;

import java.awt.AWTEvent;
import java.awt.EventQueue;
import java.awt.Toolkit;
import java.util.EmptyStackException;

/**
 *
 * @author Rakesh Menon
 */

public class EventQueueUtils {

    private static final DialogEventQueue eventQueue = new DialogEventQueue();

    private EventQueue systemEventQueue;
    private boolean blocked = false;

    public EventQueueUtils() {
        systemEventQueue = Toolkit.getDefaultToolkit().getSystemEventQueue();
    }

    /**
     * Push a new EventQueue and block current Thread
     */
    public void blockEDT() {

        if(blocked) { return; }
        
        systemEventQueue.push(eventQueue);

        try {

            synchronized(EventQueueUtils.this) {
                blocked = true;
                wait();
            }

        } catch (Exception e) {
            //e.printStackTrace();
            blocked = false;
        }
    }

    /**
     * Pop EventQueue and notify all blocked Thread
     */
    public void unblockEDT() {

        if(!blocked) { return; }

        synchronized (EventQueueUtils.this) {
            notifyAll();
        }
        
        Thread thread = new Thread() {

            public void run() {

                try {

                    // Clear EventQueue!
                    while (eventQueue.peekEvent() != null) {
                        eventQueue.getNextEvent();
                    }

                    eventQueue.pop();
                    blocked = false;

                } catch (Exception e) {
                    //e.printStackTrace();
                }
            }
        };
        thread.start();
    }
}

class DialogEventQueue extends EventQueue {

    public void pop() {
        try {
            super.pop();
        } catch (EmptyStackException ese) { }
    }
}
