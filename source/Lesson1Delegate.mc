import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Timer;

class Lesson1Delegate extends WatchUi.BehaviorDelegate {

    private var _inProgress = false;

    private var _currentSpeed;
    private var _currentWind;
    private var _currentDuration = 0;

    private var _timer;
    private var _view = getView();

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        if (_inProgress == false) {
            _inProgress = true;
            startRun();
        } 
        else {
            _inProgress = false;
            pauseRun();
        }

        return true;
    }

    // Starts countdown
    function startRun() {
        // _currentSpeed = DataManager.getSpeed();
        // _currentWind = DataManager.getWindSpeed();
        // _view.updateCyclesValue(_currentSpeed);
        // _view.updateCyclesValue(_currentWind);
        // _view.setTimerValue(_currentDuration);

        _timer = new Timer.Timer();
        _timer.start(method(:updateDurationValue), 1000, true);
    }

    function pauseRun() {
        _timer.stop();
    }

    function updateDurationValue() {
        _currentDuration++;
        _view.updateElapsedValue(_currentDuration);
    }
}