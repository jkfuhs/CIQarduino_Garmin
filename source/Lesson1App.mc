import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.BluetoothLowEnergy as Ble;

class Lesson1App extends Application.AppBase {
    private var _view;
    private var profileManager;
    private var queue;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        profileManager = new WindSensorProfile();
        _view = new ArduinoView(profileManager);
        Ble.setDelegate(new ArduinoBLEDelegate(profileManager, _view));
        profileManager.registerProfiles();
        return [ _view, new ArduinoDelegate() ] as Array<Views or InputDelegates>;
    }

    // Returns main view instance
    function getView() as Void {
        return _view;
    }
}

function getApp() as Lesson1App {
    return Application.getApp() as Lesson1App;
}

// Returns main view instance
function getView() as ArduinoView {
    return Application.getApp().getView();
}