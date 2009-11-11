/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package javafxasync;

import javafx.async.RunnableFuture;

/**
 *
 * @author Rakesh Menon
 */
public class JavaRunnable implements RunnableFuture {

    private Runnable runnable = null;
    private int count = 1;
    
    /**
     * Runnable.run() will be invoked repeatedly in non Event Dispatch Thread
     * 
     * @param runnable
     */
    public JavaRunnable(Runnable runnable) {
        this.runnable = runnable;
    }
    
    @Override
    public void run() throws java.lang.Exception {

        long startTime = System.currentTimeMillis();
        while(count < 20) {
            
            if((System.currentTimeMillis() - startTime) > 2000) {
                // Invoke Runnable.run every 2 seconds
                runnable.run();
                startTime = System.currentTimeMillis();
                count++;
            }
        }
    }
}
