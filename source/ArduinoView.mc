import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.System as Sys;
using Toybox.BluetoothLowEnergy as Ble;
using Toybox.WatchUi as Ui;

class ArduinoView extends WatchUi.View {
    private var _windTitleElement;
    private var _currentPaceElement;
    private var _windCorrectedElement;
    private var _currentDurationElement;

    private var _windspeed;
    var scanning = false;
    var connected = false;
    var gotWindData = false;
    var readPending = false;
    var windSpeed = 0;
    var deviceName;
    var device;
    var curResult;
    var paired;
    var deviceStatus;
    var arduinoService = null;
    var windThreshold = 0.06;
    var profileManager;

    var timer;

    function initialize(pm) {
        View.initialize();
        profileManager = pm;
        // queue = q;

        resetConnection(true);
        
        // add timeout timer here
        // timer = new Timer.Timer();
        
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
  
        _windTitleElement = View.findDrawableById("wind_title");
        _currentPaceElement = View.findDrawableById("current_pace");
        _windCorrectedElement = View.findDrawableById("wind_corrected_pace");
        _currentDurationElement = View.findDrawableById("elapsed_time");

        var runSpeed = DataManager.getSpeed();
        updateWindDirectionValue(runSpeed, windSpeed);
        updateSpeedValue(runSpeed);
        updateWindCorrectedValue(runSpeed, windSpeed);
        updateElapsedValue(DataManager.getElapsedTime());
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        if (connected && deviceStatus==Ble.CONNECTION_STATE_DISCONNECTED) {
            resetConnection(true);
        }

        if (arduinoService != null && !readPending)
        {
            var characteristic = (arduinoService!=null) ? arduinoService.getCharacteristic(profileManager.WIND_SENSOR_DATA) : null;
            // var cccd = characteristic.getDescriptor(Ble.cccdUuid());
            // Sys.println("cccd: " + cccd);
            characteristic.requestRead();
            // Sys.println("cccd: " + cccd);
            readPending = true;
        }
    
        var runSpeed = DataManager.getSpeed();
        updateWindDirectionValue(runSpeed, windSpeed);
        updateSpeedValue(runSpeed);
        updateWindCorrectedValue(runSpeed, windSpeed);

        View.onUpdate(dc);
    }

    function handleCRead(characteristic, status, value)
    {
        if (status == Ble.STATUS_READ_FAIL)
        {
        } else {
            windSpeed = value.decodeNumber(NUMBER_FORMAT_UINT16, {:endianness =>Lang.ENDIAN_LITTLE}) / 100.0;
        }
        readPending = false;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function updateWindDirectionValue(runSpeed, windSpeed) as Void {
        var label, color;

        // Sys.println("Run speed = " + DataManager.getSpeed());

        if (scanning)
        {
            label = "Scanning...";
            color = Graphics.COLOR_DK_GREEN;
        }
        else if ((runSpeed - windSpeed).abs() < 0.1) {
            label = "No Wind";
            color = Graphics.COLOR_BLUE;
        }
        else if (windSpeed > windThreshold)
        {
            label = "Head Wind";
            color = Graphics.COLOR_RED;
        }
        else if (windSpeed < windThreshold)
        {
            label = "Tail Wind";
            color = Graphics.COLOR_GREEN;
        }

        if (label != null && color != null)
        {
            _windTitleElement.setText(label);
            _windTitleElement.setColor(color);
        }

        WatchUi.requestUpdate();
    }

    function updateSpeedValue(speed) as Void {
        var formattedValue;

        if (speed  == null)
        {
            speed = 0;
        }
        if (speed == 0)
        {
            formattedValue = "--:--";
        }
        else {
            var pace = 1000 / speed;
            var minutes = (pace / 60).toNumber();
            var seconds = pace.toNumber() % 60;

            var secondsFormatted = seconds > 9 ? seconds.toString() : "0" + seconds.toString();

            formattedValue = minutes.toString() + ":" + secondsFormatted;
        }

        _currentPaceElement.setText(formattedValue);

        WatchUi.requestUpdate();
    }

    function updateWindCorrectedValue(runSpeed, windSpeed) as Void {

        /*
        Formula: 
        Headwind:
        Wv in (5, 15) mps : Pace += 0.109 * (Wv)^2

        Wv in >15 mps     : Pace += 0.00034 * (Wv)^3

        Tailwind:
        Pace -= 0.655 * (Wv)^2
        */
        var formattedValue;

        if (runSpeed == null)
        {
            runSpeed = 0;
        }
        if (runSpeed == 0) {
            formattedValue = "--:-- WCP";
        }
        else {

            windSpeed = windSpeed - runSpeed;

            if (windSpeed > 5)
            {
                if (windSpeed < 15)
                {
                    runSpeed += 0.109 * windSpeed * windSPeed;
                } else
                {
                    runSpeed += 0.00034 * windSpeed * windSpeed * windSpeed;
                }
            }
            else 
            {
                runSpeed -= 0.655 * windSpeed * windSpeed;
            }

            
            var pace = 1000 / runSpeed;
            var minutes = (pace / 60).toNumber();
            var seconds = pace.toNumber() % 60;
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

    function setService() {
        if (arduinoService == null)
        {
            arduinoService = device.getService(profileManager.WIND_SENSOR_SERVICE);
        }
    }

    function resetConnection(doClear) {
        Sys.println("Resetting connection");
        if (scanning) {
            Ble.setScanState(Ble.SCAN_STATE_OFF);
        }
        scanning = false;
        connected = false;
        paired = false;
        gotWindData = false;

        if (device != null) {
            Ble.unpairDevice(device);
        }
        device = null;
        deviceName="??";

        curResult=null;
        deviceStatus=Ble.CONNECTION_STATE_DISCONNECTED;
        
        scanning = true;
        Ble.setScanState(Ble.SCAN_STATE_SCANNING);

        if (doClear) {
            _windspeed = 0;
        }
        Ui.requestUpdate();
    }

}
