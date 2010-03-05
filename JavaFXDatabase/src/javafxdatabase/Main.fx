/*
 * Main.fx
 *
 * Created on Dec 22, 2009, 10:34:05 AM
 */

package javafxdatabase;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafxdatabase.view.CustomerTable;
import javafxdatabase.view.InputForm;
import javafxdatabase.view.Window;
import javafx.scene.control.Button;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Alert;
import javafx.scene.layout.LayoutInfo;
import java.sql.DriverManager;
import javafxdatabase.modal.Customer;

/**
 * @author Rakesh Menon
 */

// Print Apache Derby Information
//org.apache.derby.tools.sysinfo.main(null);

public-read def inputForm = InputForm {
    layoutInfo: LayoutInfo {
        width: 320
        height: 420
    }
    width: 320
    height: 420
};
public-read def inputFormWindow = Window {
    x: 10
    y: 60
    width: 320
    height: 420
    title: "Customer - New"
    content: [ inputForm ]
    visible: false
}

public-read def dbUtils = DBUtils { };
public-read def customerTable = CustomerTable {
    width: 340
    height: 440
};

def newButton = Button {
    text: "New"
    action: function() {
        inputFormWindow.title = "Customer - New";
        inputForm.customer = new Customer();
        inputForm.edit = false;
        inputFormWindow.visible = true;
    }
    layoutInfo: LayoutInfo { width: 70 }
};

def editButton = Button {
    text: "Edit"
    action: function() {
        if(customerTable.selectedIndex >= 0) {
            def customer = customerTable.customerList[customerTable.selectedIndex];
            if(customer != null) {
                inputFormWindow.title = "Customer - Edit";
                inputForm.customer = customer;
                inputForm.edit = true;
                inputFormWindow.visible = true;
            }
        }
    }
    layoutInfo: LayoutInfo { width: 70 }
};

def deleteButton = Button {
    text: "Delete"
    action: function() {
        if(customerTable.selectedIndex >= 0) {
            def customer = customerTable.customerList[customerTable.selectedIndex];
            if(customer != null) {
                dbUtils.deleteCustomer(customer);
                customerTable.deleteRow(customerTable.selectedIndex);
            }
        }
    }
    layoutInfo: LayoutInfo { width: 70 }
};

def populateButton = Button {
    text: "Populate"
    action: function() {
        try {

            // Clear existing Customers
            dbUtils.deleteAllCustomers();
            customerTable.clear();

            // Populate dummy Customers
            dbUtils.populateDummyData();
            var customerList = dbUtils.getCustomerList();
            for(customer in customerList) {
                customerTable.addRow(customer);
            }
            
        } catch (e : java.lang.Exception) {
            Alert.inform("Populate - Customer", "{e.getMessage()}");
        }
    }
    layoutInfo: LayoutInfo { width: 70 }
};

def buttonBox : HBox = HBox {
    translateX: bind (buttonBox.scene.width - buttonBox.layoutBounds.width)/2.0
    translateY: 10
    spacing: 5
    content: [ newButton, editButton, deleteButton, populateButton ]
}

function shutdownDerbDB() : Void {
    try {
        DriverManager.getConnection("jdbc:derby:;shutdown=true");
    } catch (e : java.lang.Exception) { }
}

function run() : Void {

    // Add Shutdown Hook
    FX.addShutdownAction(shutdownDerbDB);

    // Load existing Customers
    var customerList = dbUtils.getCustomerList();
    for(customer in customerList) {
        customerTable.addRow(customer);
    }

    Stage {
        title: "JavaFX - Database"
        resizable: false
        scene: Scene {
            width: 355
            height: 500
            content: [
                VBox {
                    spacing: 20
                    content: [
                        buttonBox, customerTable
                    ]
                },
                inputFormWindow
            ]
        }
    }
}

