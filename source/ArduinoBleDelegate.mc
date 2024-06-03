using Toybox.System as Sys;
using Toybox.BluetoothLowEnergy as Ble;
using Toybox.WatchUi as Ui;

// BLE delegate. Interacts with updates from BLE

class ArduinoBLEDelegate extends Ble.BleDelegate {
    var profileManager = null;
    var view = null;
    var queue = null;

    function initialize(pm, topView) {
        Sys.println("Ble delegate initialized");
        BleDelegate.initialize();
        profileManager=pm;
        view=topView;
    }

    // app connected to arduino
    function onConnectedStateChanged(device, state) {
        view.deviceStatus=state;
        if (state==Ble.CONNECTION_STATE_CONNECTED) {
            view.connected=true;
            view.setService();
        } else{
            view.resetConnection(true);
        }
        Ui.requestUpdate();
    }

    function onScanResults(scanResults) {
        Sys.println("Scan results: ");
        for (var result = scanResults.next(); result != null; result = scanResults.next()) {
            
            if ( contains(result.getServiceUuids(), profileManager.WIND_SENSOR_SERVICE)) {
                // found an arduino with a wind sensor
                Ble.setScanState(Ble.SCAN_STATE_OFF);
                view.scanning=false;
                view.device = Ble.pairDevice(result);
                view.curResult=result;
                view.paired=true;
                Ui.requestUpdate();
            }
        }
    }

    function onCharacteristicRead(desc, status, value)
    {
        view.handleCRead(desc, status, value);
    }

    // function onDescriptorWrite(desc, status) {
    //     view.handleDWrite(desc, status);
    // }

    // function onCharacteristicWrite(char, status) {
    //     view.handeCWrite(char, status);
    // }

    // function onCharacteristicChanged(char, value) {
    //    view.handleCChange(char, value);
    // }

    // function onDescriptorRead(desc, status, value) {
    //     queue.run(view);
    // }

    // function onCharacteristicChanged(char, value) {
    //     if (view.demoMode) {
    //         view.demoNotify(char, value);
    //     } else {
    //         view.handleChanged(char, value);
    //     }
    // }

    private function contains(iter, obj) {
        for (var uuid = iter.next(); uuid != null; uuid = iter.next()) {
            Sys.println("\t" + uuid);
            if (uuid.equals(obj)) {
                return true;
            }
        }
        return false;
    }
}