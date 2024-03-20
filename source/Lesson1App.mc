import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class Lesson1App extends Application.AppBase {
    private var _view;

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
        _view = new Lesson1View();
        return [ _view, new Lesson1Delegate() ] as Array<Views or InputDelegates>;
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
function getView() as Lesson1View {
    return Application.getApp().getView();
}