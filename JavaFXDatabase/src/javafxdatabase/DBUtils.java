/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package javafxdatabase;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javafxdatabase.modal.Customer;

/**
 *
 * @author Rakesh Menon
 */
public class DBUtils {

    private static final String dir = System.getProperty("user.home") + "/JavaFXDatabase/";
    private static final String dbURL = "jdbc:derby:" + dir + "sample";
    private static final String dbDriver = "org.apache.derby.jdbc.EmbeddedDriver";
    private static final String user = "app";
    private static final String password = "app";

    private static final List<Customer> dummyCustomerList = new ArrayList<Customer>();
    static {
        dummyCustomerList.add(new Customer(1, "JumboCom", "111 E. Las Olas Blvd", "Suite 51", "Fort Lauderdale", "FL", "33015", "305-777-4632", "jumbocom@gmail.com", 100000));
        dummyCustomerList.add(new Customer(2, "Livermore Enterprises", "9754 Main Street", "P.O. Box 567", "Miami", "FL", "33055", "305-456-8888", "www.tsoftt.com", 50000));
        dummyCustomerList.add(new Customer(25, "Oak Computers", "8989 Qume Drive", "Suite 9897", "Houston", "TX", "75200", "214-999-1234", "www.oakc.com", 25000));
        dummyCustomerList.add(new Customer(3, "Nano Apple", "8585 Murray Drive", "P.O. Box 456", "Alanta", "GA", "12347", "555-275-9900", "www.nanoapple.net", 90000));
        dummyCustomerList.add(new Customer(36, "HostProCom", "65653 El Camino", "Suite 2323", "San Mateo", "CA", "94401", "650-456-8876", "www.hostprocom.net", 65000));
        dummyCustomerList.add(new Customer(106, "CentralComp", "829 Flex Drive", "Suite 853", "San Jose", "CA", "95035", "408-987-1256", "www.centralcomp.com", 26500));
        dummyCustomerList.add(new Customer(149, "Golden Valley Computers", "4381 Kelly Ave", "Suite 77", "Santa Clara", "CA", "95117", "408-432-6868", "www.gvc.net", 70000));
        dummyCustomerList.add(new Customer(863, "Top Network Systems", "456 4th Street", "Suite 45", "Redwood City", "CA", "94401", "650-345-5656", "www.hpsys.net", 25000));
        dummyCustomerList.add(new Customer(777, "West Valley Inc.", "88 North Drive", "Building C", "Dearborn", "MI", "48128", "313-563-9900", "www.westv.com", 100000));
        dummyCustomerList.add(new Customer(753, "Ford Motor Co", "2267 Michigan Ave", "Building 21", "Dearborn", "MI", "48128", "313-787-2100", "www.parts@ford.com", 5000000));
        dummyCustomerList.add(new Customer(722, "Big Car Parts", "52963 Outer Dr", "Suite 35", "Detroit", "MI", "48124", "313-788-7682", "www.sparts.com", 50000));
        dummyCustomerList.add(new Customer(409, "New Media Productions", "4400 22nd Street", "Suite 562", "New York", "NY", "10095", "212-222-5656", "www.nymedia.com", 10000));
        dummyCustomerList.add(new Customer(410, "Yankee Computer Repair", "9653 33rd Ave", "Floor 4", "New York", "NY", "10096", "212-535-7000", "www.nycomp@repair.com", 25000));
        dummyCustomerList.add(new Customer(321, "Rakesh Menon", "Address - 1", "Address - 2", "Bangalore", "KA", "560001", "91234567890 ", "rakeshmenon@email.com", 100));
    }

    public DBUtils() throws Exception {

        System.out.println("JavaFXDatabase - \"" + dir + "\"");

        try {
            DriverManager.getConnection("jdbc:derby:;shutdown=true");
        } catch (Exception e) { }
        
        try {
            // Load Driver
            Class.forName(dbDriver).newInstance();
        } catch (Exception e) {
            System.err.println("ERROR: Could not load driver!");
            e.printStackTrace(System.err);
        }
    
        // Test The Connection
        Connection con = DriverManager.getConnection(
                dbURL + ";create=true", user, password);
        
        try {
            createCustomerTable(con);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        con.close();
    }
    
    private Connection getConnection() throws Exception {
        return DriverManager.getConnection(
                dbURL, user, password);
    }

    private void createCustomerTable(Connection con) throws Exception {
        
        Statement statement = con.createStatement();
        //statement.execute("DROP TABLE CUSTOMER");
        
        statement.execute("CREATE TABLE CUSTOMER (" +
                            "CUSTOMER_ID int," +
                            "NAME varchar(30)," +
                            "ADDRESSLINE1 varchar(30)," +
                            "ADDRESSLINE2 varchar(30)," +
                            "CITY varchar(25)," +
                            "STATE char(2)," +
                            "ZIP varchar(10)," +
                            "PHONE char(12)," +
                            "EMAIL varchar(40)," +
                            "CREDIT_LIMIT int)");
    }

    public void dropCustomerTable() throws Exception {
        Connection con = getConnection();
        Statement statement = con.createStatement();
        statement.execute("DROP TABLE CUSTOMER");
        con.close();
    }

    public void deleteAllCustomers() throws Exception {
        Connection con = getConnection();
        Statement statement = con.createStatement();
        statement.execute("DELETE FROM APP.CUSTOMER");
        con.close();
    }

    public void deleteCustomer(Customer customer) throws Exception {
        Connection con = getConnection();
        PreparedStatement prepStatement = con.prepareStatement(
            "DELETE FROM APP.CUSTOMER WHERE CUSTOMER_ID=? AND \"NAME\"=? AND PHONE=?"
        );
        prepStatement.setInt(1, customer.getCustomerID());
        prepStatement.setString(2, customer.getName());
        prepStatement.setString(3, customer.getPhone());
        prepStatement.executeUpdate();
        con.close();
    }

    public void populateDummyData() throws Exception {

        Connection con = getConnection();
        PreparedStatement prepStatement = con.prepareStatement(
            "INSERT INTO APP.CUSTOMER (CUSTOMER_ID, \"NAME\", ADDRESSLINE1, ADDRESSLINE2, CITY, \"STATE\", ZIP, PHONE, EMAIL, CREDIT_LIMIT) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        );

        for(Customer customer : dummyCustomerList) {
            prepStatement.setInt(1, customer.getCustomerID());
            prepStatement.setString(2, customer.getName());
            prepStatement.setString(3, customer.getAddressLine1());
            prepStatement.setString(4, customer.getAddressLine2());
            prepStatement.setString(5, customer.getCity());
            prepStatement.setString(6, customer.getState());
            prepStatement.setString(7, customer.getZip());
            prepStatement.setString(8, customer.getPhone());
            prepStatement.setString(9, customer.getEmail());
            prepStatement.setInt(10, customer.getCreditLimit());
            prepStatement.executeUpdate();
        }

        con.close();
    }

    public void saveCustomer(Customer customer) throws Exception {

        Connection con = getConnection();

        Statement statement = con.createStatement();
        statement.execute("INSERT INTO APP.CUSTOMER (CUSTOMER_ID, \"NAME\", ADDRESSLINE1, ADDRESSLINE2, CITY, \"STATE\", ZIP, PHONE, EMAIL, CREDIT_LIMIT) VALUES (" +
                customer.getCustomerID() + ", " +
                "'" + customer.getName() + "', " +
                "'" + customer.getAddressLine1() + "', " +
                "'" + customer.getAddressLine2() + "', " +
                "'" + customer.getCity() + "', " +
                "'" + customer.getState() + "', " +
                "'" + customer.getZip() + "', " +
                "'" + customer.getPhone() + "', " +
                "'" + customer.getEmail() + "', " +
                customer.getCreditLimit() + ")");

        con.close();
    }

    public void editCustomer(Customer customer) throws Exception {

        Connection con = getConnection();

        Statement statement = con.createStatement();
        statement.execute("UPDATE APP.CUSTOMER SET " +
                "CUSTOMER_ID=" + customer.getCustomerID() + ", " +
                "\"NAME\"='" + customer.getName() + "', " +
                "ADDRESSLINE1='" + customer.getAddressLine1() + "', " +
                "ADDRESSLINE2='" + customer.getAddressLine2() + "', " +
                "CITY='" + customer.getCity() + "', " +
                "\"STATE\"='" + customer.getState() + "', " +
                "ZIP='" + customer.getZip() + "', " +
                "PHONE='" + customer.getPhone() + "', " +
                "EMAIL='" + customer.getEmail() + "', " +
                "CREDIT_LIMIT=" + customer.getCreditLimit() + " " +
                "WHERE CUSTOMER_ID=" + customer.getCustomerID());

        con.close();
    }

    public List<Customer> getCustomerList() throws Exception {

        List<Customer> customerList = new ArrayList<Customer>();

        Connection con = getConnection();
        Statement statement = con.createStatement();
        ResultSet resultSet = statement.executeQuery("Select * From APP.CUSTOMER");
        while(resultSet.next()) {
            customerList.add(new Customer(
                resultSet.getInt("CUSTOMER_ID"),
                resultSet.getString("NAME"),
                resultSet.getString("ADDRESSLINE1"),
                resultSet.getString("ADDRESSLINE2"),
                resultSet.getString("CITY"),
                resultSet.getString("STATE"),
                resultSet.getString("ZIP"),
                resultSet.getString("PHONE"),
                resultSet.getString("EMAIL"),
                resultSet.getInt("CREDIT_LIMIT")
            ));
        }
        con.close();
        
        return customerList;
    }
}
