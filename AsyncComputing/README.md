# AsyncComputing
This is an extension of the Matlab Support Package for the EV3 brick ([https://de.mathworks.com/hardware-support/lego-mindstorms-ev3-matlab.html](https://de.mathworks.com/hardware-support/lego-mindstorms-ev3-matlab.html)).
Instead providing only blocking calls in the API, the communication with the EV3 brick runs in the background and the user can always accress the last known data from the EV3 brick.
Below the Async API in introduced in detail.

## Requierements
The Matlab Addon for the EV3 brick has do be installed: [https://de.mathworks.com/hardware-support/lego-mindstorms-ev3-matlab.html](https://de.mathworks.com/hardware-support/lego-mindstorms-ev3-matlab.html)

## API
Below the methods provided by this package are shown. 
In general you can allways use the blocking calls from the Matlab Support Package, since our implementation is based on it, which are also shown in this documentation. 
Addtionally you can read how to use the asyncron calls.

### Connect to EV3 brick
You are able to build a connection to the EV3 brick via WiFi, Bluetooth and USB using the following commands respectivly.
```matlab
% WiFi
ip_addr = xxx.xxx.xxx.xxx;
brick_id = xxxxxxxxxxxx;
myev3_wifi = connectEV3('wifi', ip_addr, brick_id);

% Bluetooth
port = 'portname';
myev3_bt = connectEV3('bluetooth', port);

% USB
myev3_usb = connectEV3('usb');
```
In the following we use `myev3 = connectEV3(...)`.

### Enable async readings from EV3
- TOTO implement and getcurrentvalue
- TODO documentate startRec and stopRec

### Motor Controll
To controll the moters you can use `motorControllerAS`
```matlab
motor = motorControllerAS(myev3, 'B'); % Motor at port B
% enable the motor
start(motor1)
%Set motor speed
motor.SpeedAS = 30; % range is [-100, 100]
% disable motor
stop(motor)
```
### Motor Sensor
TODO

### Sonic Sensor
TODO

### Touch Sensor
TODO

### Color Sensor
TODO update

To read colors from the color sensor you can use `readColor` and `readColorID`. The light intensity is accessed with `readLightIntensity`.
#### readColor
Returns a string with containing the name of the current seen color: `'none', 'black', 'blue', 'green', 'yellow', 'red', 'white', 'brown'`.
TODO example

### Light Intensity Sensor
TODO

### Gyro Sensor
TODO
