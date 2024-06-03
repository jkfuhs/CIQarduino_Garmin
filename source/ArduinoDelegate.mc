import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Timer;
using Toybox.System as Sys;

class ArduinoDelegate extends WatchUi.BehaviorDelegate {

    private var _inProgress = false;

    private var _currentSpeed;
    private var _currentWind;
    private var _currentDuration = 0;

    private var _timer;
    private var _view = getView();
    var session;

    function initialize() {
        BehaviorDelegate.initialize();
        session = ActivityRecording.createSession({
            :name=>"WindRun",
            :sport=>Activity.SPORT_RUNNING
        });
        Sys.println("Delegate init complete");
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

    function onUpdate()
    {
 
    }

    function onBack()
    {
        if (_inProgress) {
            session.addLap();
        } else {
            session.discard();
            exit();
        }
    }

    function onNextPage()
    {
        if (!_inProgress) {
            session.save();
            exit();
        }
    }

    // Starts countdown
    function startRun() {
        _timer = new Timer.Timer();
        _timer.start(method(:updateDurationValue), 1000, true);
        session.start();
    }

    function pauseRun() {
        _timer.stop();
        session.stop();
    }

    function updateDurationValue() {
        _currentDuration++;
        _view.updateElapsedValue(_currentDuration);
    }
}