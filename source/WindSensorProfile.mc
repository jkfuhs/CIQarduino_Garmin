using Toybox.System as Sys;
using Toybox.WatchUi;
using Toybox.BluetoothLowEnergy as Ble;

class WindSensorProfile
{
    var uuid1 = 0x0000000000001000L;/*TODO: find this*/ // firt part of default UUID
    var uuid2 = 0x800000805f9b34fbL;/*TODO: find this*/ // second part of default UUID
    private var _bleDelegate;

    var _device;
    private var _profileManagerInfo;
    private var _windSpeed = 0l;

    private var _windSpeedOffset = 2;
    private var _isConnected = false;

    public const WIND_SENSOR_SERVICE        = Ble.stringToUuid("0000181a-0000-1000-8000-00805f9b34fb");
    public const WIND_SENSOR_DATA           = Ble.stringToUuid("00002a72-0000-1000-8000-00805f9b34fb");

    function isConnected()
    {
        return _isConnected;
    }

    function getWindSpeed()
    {
        return _windSpeed;
    }

    private var _windSensorProfileDef = 
    {
        :uuid => WIND_SENSOR_SERVICE,
        :characteristics => [
            {
                :uuid => WIND_SENSOR_DATA,
                :descriptors => [Ble.cccdUuid()]
            }
        ]
    };

    function registerProfiles() {
        Ble.registerProfile(_windSensorProfileDef);
    }
    
}