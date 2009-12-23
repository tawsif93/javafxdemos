/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package javafxdatabase.modal;

import java.util.Random;

/**
 *
 * @author Rakesh Menon
 */
public class Customer {

    private static final Random random = new Random(System.currentTimeMillis());

    private int customerID;
    private String name;
    private String addressLine1;
    private String addressLine2;
    private String city;
    private String state;
    private String zip;
    private String phone;
    private String email;
    private int creditLimit;

    public Customer() {
        this.customerID = random.nextInt(999);
        this.name = "";
        this.addressLine1 = "";
        this.addressLine2 = "";
        this.city = "San Jose";
        this.state = "CA";
        this.zip = "95035";
        this.phone = "";
        this.email = "";
        this.creditLimit = 100;
    }

    public Customer(int customerID, String name,
            String addressLine1, String addressLine2, String city,
            String state, String zip, String phone, String email,
            int creditLimit) {

        this.customerID = customerID;
        this.name = name;
        this.addressLine1 = addressLine1;
        this.addressLine2 = addressLine2;
        this.city = city;
        this.state = state;
        this.zip = zip;
        this.phone = phone;
        this.email = email;
        this.creditLimit = creditLimit;
    }

    public void set(Customer customer) {
        this.customerID = customer.getCustomerID();
        this.name = customer.getName();
        this.addressLine1 = customer.getAddressLine1();
        this.addressLine2 = customer.getAddressLine2();
        this.city = customer.getCity();
        this.state = customer.getState();
        this.zip = customer.getZip();
        this.phone = customer.getPhone();
        this.email = customer.getEmail();
        this.creditLimit = customer.getCreditLimit();
    }
    
    /**
     * Get the value of customerID
     *
     * @return the value of customerID
     */
    public int getCustomerID() {
        return customerID;
    }

    /**
     * Set the value of customerID
     *
     * @param customerID new value of customerID
     */
    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    /**
     * Get the value of name
     *
     * @return the value of name
     */
    public String getName() {
        return name;
    }

    /**
     * Set the value of name
     *
     * @param name new value of name
     */
    public void setName(String name) {

        if((name == null) || (name.trim().length() == 0)) {
            throw new IllegalArgumentException("Name cannot be empty!");
        } else if(name.length() > 30) {
            name = name.substring(0, 30);
        }

        this.name = name;
    }

    /**
     * Get the value of addressLine1
     *
     * @return the value of addressLine1
     */
    public String getAddressLine1() {
        return addressLine1;
    }

    /**
     * Set the value of addressLine1
     *
     * @param addressLine1 new value of addressLine1
     */
    public void setAddressLine1(String addressLine1) {

        if((addressLine1 == null) || (addressLine1.trim().length() == 0)) {
            throw new IllegalArgumentException("Address cannot be empty!");
        } else if(addressLine1.length() > 30) {
            addressLine1 = addressLine1.substring(0, 30);
        }

        this.addressLine1 = addressLine1;
    }

    /**
     * Get the value of addressLine2
     *
     * @return the value of addressLine2
     */
    public String getAddressLine2() {
        return addressLine2;
    }

    /**
     * Set the value of addressLine2
     *
     * @param addressLine2 new value of addressLine2
     */
    public void setAddressLine2(String addressLine2) {

        if((addressLine2 != null) && (addressLine2.length() > 30)) {
            addressLine2 = addressLine2.substring(0, 30);
        }

        this.addressLine2 = addressLine2;
    }

    /**
     * Get the value of city
     *
     * @return the value of city
     */
    public String getCity() {
        return city;
    }

    /**
     * Set the value of city
     *
     * @param city new value of city
     */
    public void setCity(String city) {

        if((city == null) || (city.trim().length() == 0)) {
            throw new IllegalArgumentException("City cannot be empty!");
        } else if(city.length() > 25) {
            city = city.substring(0, 25);
        }

        this.city = city;
    }

    /**
     * Get the value of state
     *
     * @return the value of state
     */
    public String getState() {
        return state;
    }

    /**
     * Set the value of state
     *
     * @param state new value of state
     */
    public void setState(String state) {

        if((state == null) || (state.trim().length() == 0)) {
            throw new IllegalArgumentException("State cannot be empty!");
        } else if(state.length() > 2) {
            state = state.substring(0, 2).toUpperCase();
        }
        
        this.state = state;
    }

    /**
     * Get the value of zip
     *
     * @return the value of zip
     */
    public String getZip() {
        return zip;
    }

    /**
     * Set the value of zip
     *
     * @param zip new value of zip
     */
    public void setZip(String zip) {

        if((zip == null) || (zip.trim().length() == 0)) {
            throw new IllegalArgumentException("Zip cannot be empty!");
        } else if(zip.length() > 25) {
            zip = zip.substring(0, 25);
        }

        this.zip = zip;
    }

    /**
     * Get the value of phone
     *
     * @return the value of phone
     */
    public String getPhone() {
        return phone;
    }

    /**
     * Set the value of phone
     *
     * @param phone new value of phone
     */
    public void setPhone(String phone) {

        if((name == null) || (name.trim().length() == 0)) {
            throw new IllegalArgumentException("Name cannot be empty!");
        }

        this.phone = phone;
    }

    /**
     * Get the value of email
     *
     * @return the value of email
     */
    public String getEmail() {
        return email;
    }

    /**
     * Set the value of email
     *
     * @param email new value of email
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Get the value of creditLimit
     *
     * @return the value of creditLimit
     */
    public int getCreditLimit() {
        return creditLimit;
    }

    /**
     * Set the value of creditLimit
     *
     * @param creditLimit new value of creditLimit
     */
    public void setCreditLimit(int creditLimit) {
        this.creditLimit = creditLimit;
    }

    @Override
    public String toString() {
        return name;
    }
}
