/*
 * Utils.fx
 *
 * Created on Feb 15, 2010, 3:09:32 PM
 */
package weather;

import javafx.io.http.URLConverter;
import javafx.io.http.HttpRequest;
import javafx.data.pull.PullParser;
import javafx.data.pull.Event;

/**
 * @author Rakesh Menon
 */

def appID = "91ZBV83V34F8nTjx7pBGQOhlX6INdjfsEKmpJJx3Dnfuwnc6PLBoO2qT3RjtPXvgp9ub";
def urlConverter = URLConverter { };

/**
 * Input:
 *
 * http://where.yahooapis.com/v1/places.q('{location}')?appid={appID}
 *
 *
 * Response:
 *
 * <places yahoo:start="0" yahoo:count="1" yahoo:total="63">
 *   <place yahoo:uri="http://where.yahooapis.com/v1/place/2488836" xml:lang="en-us">
 *     <woeid>2488836</woeid>
 *     <placeTypeName code="7">Town</placeTypeName>
 *     <name>Santa Clara</name>
 *     <country type="Country" code="US">United States</country>
 *     <admin1 type="State" code="US-CA">California</admin1>
 *     <admin2 type="County" code="">Santa Clara</admin2>
 *     <admin3/>
 *   </place>
 * <place>
 *
 */
public function getLocationWOEID(location: String, callBack: function(String)): Void {

    def url = "http://where.yahooapis.com/v1/places.q('"
        "{urlConverter.encodeString(location)}')?appid={appID}";
    
    def httpRequest = HttpRequest {

        location: "{urlConverter.encodeURL(url)}"

        onInput: function (is) {
            var woeid: String;
            def pullParser = PullParser {
                input: is
                onEvent: function (event: Event) {
                    if ((event.level == 2) and (event.type == PullParser.TEXT)) {
                        if (event.qname.name == "woeid") {
                            woeid = "{event.text}";
                        }
                    }
                }
            };
            pullParser.parse();
            is.close();
            callBack(woeid);
        }
    };

    httpRequest.start();
}

/**
 * For the Weather RSS feed there are two parameters:
 * 
 *  * w for WOEID.
 *  * u for degrees units (Fahrenheit or Celsius).
 * 
 *  Input: 
 *
 *  http://weather.yahooapis.com/forecastrss?w={location}&u={unit}
 */
public function getWeatherInfo(
    woeid: String, unit: String, callBack: function(WeatherInfo)) : Void {

    def url = "http://weather.yahooapis.com/forecastrss?"
        "w={woeid}&u={unit}";

    def httpRequest = HttpRequest {

        location: "{urlConverter.encodeURL(url)}"

        onInput: function (is) {
            callBack(WeatherInfo.parse(is));
            is.close();
        }
    };

    httpRequest.start();
}

public function getForecastImageURL(code : String) : String {

    var dnSuffix = "d";

    if(code == "27") { //mostly cloudy (night)
        dnSuffix = "n";
    } else if(code == "29") { //partly cloudy (night)
        dnSuffix = "n";
    } else if(code == "31") { //clear (night)
        dnSuffix = "n";
    } else if(code == "33") { //fair (night)
        dnSuffix = "n";
    }

    "http://l.yimg.com/a/i/us/nws/weather/gr/{code}{dnSuffix}.png";
}

public function getForecastImageURL(code : String, size:Number) : String {
    "http://l.yimg.com/a/i/us/we/52/{code}.gif"
}
