import Toybox.Application;
import Toybox.Lang;
import Toybox.Activity;

class DataManager {
    private var windSpeed = 8;

    public function getSpeed() {
        return Toybox.Activity.getActivityInfo().currentSpeed;
        // return Application.Properties.getValue("currentSpeed");
        // return 15.724;
    }

    // public function getWindSpeed() {
    //     // return Application.Properties.getValue("windSpeed");
    //     return windSpeed;
    // }

    // public function setWindSpeed(newWindSpeed) {
    //     windSpeed = newWindSpeed;
    // }

    public function getElapsedTime() {
        return Application.Properties.getValue("elapsedTime");
    }
}