import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Lesson1View extends WatchUi.View {
    private var _windTitleElement;
    private var _currentPaceElement;
    private var _windCorrectedElement;
    private var _currentDurationElement;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
  
        _windTitleElement = View.findDrawableById("wind_title");
        _currentPaceElement = View.findDrawableById("current_pace");
        _windCorrectedElement = View.findDrawableById("wind_corrected_pace");
        _currentDurationElement = View.findDrawableById("elapsed_time");


        updateWindDirectionValue(DataManager.getWindSpeed());
        updateSpeedValue(DataManager.getSpeed());
        updateWindCorrectedValue(DataManager.getSpeed(), DataManager.getWindSpeed());
        updateElapsedValue(DataManager.getElapsedTime());
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function updateWindDirectionValue(windSpeed as Number) as Void {
        var label, color;

        if (windSpeed == 0) {
            label = "No Wind";
            color = Graphics.COLOR_BLUE;
        }
        else if (windSpeed > 0)
        {
            label = "Head Wind";
            color = Graphics.COLOR_RED;
        }
        else if (windSpeed < 0)
        {
            label = "Tail Wind";
            color = Graphics.COLOR_GREEN;
        }

        _windTitleElement.setText(label);
        _windTitleElement.setColor(color);

        WatchUi.requestUpdate();
    }

    function updateSpeedValue(speed as Number) as Void {
        var formattedValue;

        if (speed == 0)
        {
            formattedValue = "--:--";
        }
        else {
            var pace = 1000 / speed;
            var minutes = pace / 60;
            var seconds = pace % 60;
            var secondsFormatted = seconds > 9 ? seconds.toString() : "0" + seconds.toString();

            formattedValue = minutes.toString() + ":" + secondsFormatted;
        }

        _currentPaceElement.setText(formattedValue);

        WatchUi.requestUpdate();
    }

    function updateWindCorrectedValue(runSpeed as Number, windSpeed as Number) as Void {
        var formattedValue;

        if (runSpeed == 0) {
            formattedValue = "--:-- WCP";
        }
        else {
            var pace = 1000 / runSpeed;
            
            if (windSpeed > 0) {
                pace -= 12;    
            }
            else if (windSpeed < 0) {
                pace += 6;
            }
            var minutes = pace / 60;
            var seconds = pace % 60;
            var secondsFormatted = seconds > 9 ? seconds.toString() : "0" + seconds.toString();

            formattedValue = minutes.toString() + ":" + secondsFormatted + " WCP";
        }

        _windCorrectedElement.setText(formattedValue);

        WatchUi.requestUpdate();
    }

    function updateElapsedValue(elapsed as Number) {
        var minutes = elapsed / 60;
        var seconds = elapsed % 60;
        var secondsFormatted = seconds > 9 ? seconds.toString() : "0" + seconds.toString();

        var formattedValue = minutes.toString() + ":" + secondsFormatted;

        _currentDurationElement.setText(formattedValue);

        WatchUi.requestUpdate();
    }

}
