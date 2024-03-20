import Toybox.Application;
import Toybox.Lang;
import Toybox.Activity;

class DataManager {
    static function getSpeed() {
        // return Toybox.Activity.getActivityInfo().currentSpeed;
        // return Application.Properties.getValue("currentSpeed");
        return 10;
    }

    static function getWindSpeed() {
        // return Application.Properties.getValue("windSpeed");
        return 6;
    }

    static function getElapsedTime() {
        return Application.Properties.getValue("elapsedTime");
    }

    // static function setCycleDuration(duration as Number) {
    //     Application.Properties.setValue("cycleDuration", duration);
}