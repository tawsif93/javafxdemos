/*
 * JavaFXTask.fx
 *
 * Created on 11 Nov, 2009, 8:44:45 AM
 */

package javafxasync;

import javafx.async.JavaTaskBase;
import javafx.async.RunnableFuture;
import java.lang.Runnable;

/**
 * @author Rakesh Menon
 */

public class JavaTask extends JavaTaskBase, Runnable {

    public var onFailed : function(cause : Object) : Void;
    public var repeatTask: function() : Void;
    
    override function create() : RunnableFuture {
        new JavaRunnable(this);
    }

    override function run() {
        if(repeatTask != null) {
            // Execute in Event Dispatch Thread
            FX.deferAction(repeatTask);
        }
    }
    
    def taskFailed = bind failed on replace {
        if(onFailed != null) {
            onFailed(causeOfFailure);
        }
    }
}
