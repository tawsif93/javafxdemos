/*
 * WeatherInfo.fx
 *
 * Created on Feb 15, 2010, 4:09:42 PM
 */

package weather;

import java.io.InputStream;
import javafx.data.pull.PullParser;
import javafx.data.pull.Event;

/**
 * @author Rakesh Menon
 */

/**

<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<rss version="2.0" xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#">
  <channel>
    <yweather:location city="Sunnyvale" region="CA"   country="United States"/>
    <yweather:units temperature="F" distance="mi" pressure="in" speed="mph"/>
    <yweather:wind chill="50"   direction="0"   speed="0" />
    <yweather:atmosphere humidity="94"  visibility="3"  pressure="30.27"  rising="1" />
    <yweather:astronomy sunrise="7:17 am"   sunset="4:52 pm"/>
    <image>
      <title>Yahoo! Weather</title>
      <width>142</width>
      <height>18</height>
      <link>http://weather.yahoo.com</link>
      <url>http://l.yimg.com/a/i/us/nws/th/main_142b.gif</url>
    </image>
    <item>
      <geo:lat>37.37</geo:lat>
      <geo:long>-122.04</geo:long>
      <link>http://us.rd.yahoo.com/dailynews/rss/weather/Sunnyvale__CA/*http://weather.yahoo.com/forecast/USCA1116_f.html</link>
      <yweather:condition  text="Mostly Cloudy"  code="28"  temp="50"  date="Fri, 18 Dec 2009 9:38 am PST" />
      <yweather:forecast day="Fri" date="18 Dec 2009" low="49" high="62" text="Partly Cloudy" code="30" />
      <yweather:forecast day="Sat" date="19 Dec 2009" low="49" high="65" text="Partly Cloudy" code="30" />
    </item>
  </channel>
</rss>

**/
public class WeatherInfo {

    /**
     * <yweather:location city="Sunnyvale" region="CA"   country="United States"/>
     */
    public-read var locationCity: String;
    public-read var locationRegion: String;
    public-read var locationCountry: String;
    
    /**
     * <yweather:units temperature="F" distance="mi" pressure="in" speed="mph"/>
     */
    public-read var unitTemperature: String;
    public-read var unitDistance: String;
    public-read var unitPressure: String;
    public-read var unitSpeed: String;
    
    /**
     * <yweather:wind chill="50"   direction="0"   speed="0" />
     */
    public-read var windChill: String;
    public-read var windDirection: String;
    public-read var windSpeed: String;
    
    /**
     * <yweather:atmosphere humidity="94"  visibility="3"  pressure="30.27"  rising="1" />
     */
    public-read var atmosphereHumidity: String;
    public-read var atmosphereVisibility: String;
    public-read var atmospherePressure: String;
    public-read var atmosphereRising: String;
    
    /**
     * <yweather:astronomy sunrise="7:17 am"   sunset="4:52 pm"/>
     */
    public-read var astronomySunrise: String;
    public-read var astronomySunset: String;

    /**
     * <yweather:condition  text="Mostly Cloudy"  code="28"  temp="50"  date="Fri, 18 Dec 2009 9:38 am PST" />
     */
    public-read var conditionText: String;
    public-read var conditionCode: String;
    public-read var conditionTemp: String;
    public-read var conditionDate: String;

    /**
     * <yweather:forecast day="Sat" date="19 Dec 2009" low="49" high="65" text="Partly Cloudy" code="30" />
     */
    public-read var forecast : Forecast[];
}

/**
 * <yweather:forecast day="Sat" date="19 Dec 2009" low="49" high="65" text="Partly Cloudy" code="30" />
 */
public class Forecast {
    public-read var day  : String;
    public-read var date : String;
    public-read var low  : String;
    public-read var high : String;
    public-read var text : String;
    public-read var code : String;
}

public function parse(in : InputStream) : WeatherInfo {

    def weatherInfo = WeatherInfo { };

    PullParser {

        input: in
        
        onEvent: function(event : Event) {

            if(event.type == PullParser.END_ELEMENT) {
                if(event.qname.name == "location") {
                    weatherInfo.locationCountry = "{event.getAttributeValue("country")}";
                    weatherInfo.locationCity = "{event.getAttributeValue("city")}";
                    weatherInfo.locationRegion = "{event.getAttributeValue("region")}";
                } else if(event.qname.name == "units") {
                    weatherInfo.unitSpeed = "{event.getAttributeValue("speed")}";
                    weatherInfo.unitPressure = "{event.getAttributeValue("pressure")}";
                    weatherInfo.unitDistance = "{event.getAttributeValue("distance")}";
                    weatherInfo.unitTemperature = "{event.getAttributeValue("temperature")}";
                } else if(event.qname.name == "wind") {
                    weatherInfo.windSpeed = "{event.getAttributeValue("speed")}";
                    weatherInfo.windDirection = "{event.getAttributeValue("direction")}";
                    weatherInfo.windChill = "{event.getAttributeValue("chill")}";
                } else if(event.qname.name == "atmosphere") {
                    weatherInfo.atmosphereRising = "{event.getAttributeValue("rising")}";
                    weatherInfo.atmospherePressure = "{event.getAttributeValue("pressure")}";
                    weatherInfo.atmosphereVisibility = "{event.getAttributeValue("visibility")}";
                    weatherInfo.atmosphereHumidity = "{event.getAttributeValue("humidity")}";
                } else if(event.qname.name == "astronomy") {
                    weatherInfo.astronomySunrise = "{event.getAttributeValue("sunrise")}";
                    weatherInfo.astronomySunset = "{event.getAttributeValue("sunset")}";
                } else if(event.qname.name == "condition") {
                    weatherInfo.conditionText = "{event.getAttributeValue("text")}";
                    weatherInfo.conditionCode = "{event.getAttributeValue("code")}";
                    weatherInfo.conditionTemp = "{event.getAttributeValue("temp")}";
                    weatherInfo.conditionDate = "{event.getAttributeValue("date")}";
                } else if(event.qname.name == "forecast") {
                    var forecast = Forecast { };
                    forecast.day = "{event.getAttributeValue("day")}";
                    forecast.date = "{event.getAttributeValue("date")}";
                    forecast.low = "{event.getAttributeValue("low")}";
                    forecast.high = "{event.getAttributeValue("high")}";
                    forecast.text = "{event.getAttributeValue("text")}";
                    forecast.code = "{event.getAttributeValue("code")}";
                    insert forecast into weatherInfo.forecast;
                }
            }
        }

    }.parse();

    return weatherInfo;
}
