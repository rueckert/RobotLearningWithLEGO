# AsyncComputing
This is an extension of the Matlab Support Package for the EV3 brick ([https://de.mathworks.com/hardware-support/lego-mindstorms-ev3-matlab.html](https://de.mathworks.com/hardware-support/lego-mindstorms-ev3-matlab.html)).
Instead providing only blocking calls in the API, the communication with the EV3 brick runs in the background and the user can always accress the last known data from the EV3 brick.
Below the Async API in introduced in detail.

## Requierements
The Matlab Support Package for the EV3 brick has do be installed: [https://de.mathworks.com/hardware-support/lego-mindstorms-ev3-matlab.html](https://de.mathworks.com/hardware-support/lego-mindstorms-ev3-matlab.html)

## API
Below the methods provided by this package are shown. 
In general you can allways use the blocking calls from the Matlab Support Package, since our implementation is based on it, which are also shown in this documentation. 
If activaed sensor values are called in the background from the EV3 and are stored. By reading the stored values one can read the latest data from the EV3 avoiding blocking calls

### Connect to EV3 brick
You are able to build a connection to the EV3 brick via WiFi, Bluetooth and USB using the following commands respectivly. Please note that the object created by `connectEV3()` has to be deleted in the end, using for example `clear myev3`. Otherwise new connections will fail.
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
In the following we use `myev3 = connectEV3(...)` and `port_id` as the name of the port where a device is connected to the EV3.

### Enable async readings from EV3
Each Sensor and MotorController has both methods `startRec` and `stopRec`. To enable asyncron readings call `startRec` on a certain device (sensor or motor controller). Then every 20ms it is tried to request data from the EV3 for the device. If a privious reading process is still on going the latest reading is canceled. After completing a read process the data is stored in the property `receivedValue`, which can be accessed at any time. To stop automatic reading data use `stopRec`. Example:
```matalb
sensor = sonicSensorAS(myev3, port_id); % or use an other intializer from below
sensor.startRec(); % start async readings
for i=1:100
   data = sensor.receivedValue % read current data from sensor
   pause(0.1);
end
sensor.stopRec(); % stop async readings
```
In the background blocking calls are used which are descriped in the following sections, since the sensors provide different types of data. **In order to use asyc readings you have use the API as descript above. Examples below only show only blocking calls to read the data.**

### Motor Controll
To controll the moters you can use `motorControllerAS`. To enable or disable a motor use the `start` and `stop` mehtods. To set the speed of a motor use the property `SpeedAS`.
```matlab
motor = motorControllerAS(myev3, 'B'); % Motor at port B
motor.startRec();
% enable the motor
start(motor1)
%Set motor speed
motor.SpeedAS = 30; % range is [-100, 100]
% disable motor
motor.stopRec();
stop(motor)
```

### Motor Sensor
To read the rotation of a motor use the `motorSensorAS` class. The method `readRotation` returns the total rotation in degrees. To reset the rotation to zero use `resetRotation`.
```matlab
motor_sensor = motorSensorAS(myev3, port_id);
r = readRotation(motor_sensor); % in [deg]
resetRotation(motor_sensor); % sets the rotation to zero
```

### Sonic Sensor
To read the distance from a sonic sensor use the `sonicSensorAS` class. `readDistance` returns the distance as a double. The range is 0 to 2.55m.
```matlab
sonic_sensor = sonicSensorAS(myev3, port_id);
dist = readDistance(sonic_sensor);
```

### Touch Sensor
To read if a touch sensor is pressed use the `touchSensorAC` class. `readTouch` returns `1` if the sensor is pressed, otherwise `0`.
```matalb
touch_sensor = touchSensorAS(myev3, port_id);
is_pressed = readTouch(touch_sensor);
```

### Color Sensor
To read colors from the color sensor  use the `colorSensorAS` class. `readColorId` returns the current seen color as an intiger:
 - 1: none
 - 2: black
 - 3: blue
 - 4: green
 - 5: yellow
 - 6: red
 - 7: white
 - 8: brown
```matalb
color_sensor = colorSensorAS(myev3, port_id);
color = readColor(color_sensor); % number from 1 to 8
```

### Light Intensity Sensor
To read the light intensity from a colorSensor use the `lightIntensitySensorAS` class. `readLightIntensity` returns the measured light intensity as a decimal number from 0 to 100. Currently only the ambient mode is supported.
```matalb
li_sensor = lightIntensitySensorAS(myev3, port_id);
light_intensity = readLightIntensity(li_sensor); % intiger from 0 to 100
```

### Gyro Sensor
To read the total amount of rotation from a gyro sensor use the `gyroSensorAS` class. `readRotationAngle` returns the angle in degrees. With the sensor upright, positive values indicate clockwise rotation. Negative values indicate counterclockwise rotation. To reset the angle use the `resetRotationAngle` method.
```matlab
gyro_sensor = gyroSensorAS(myev3, port_id);
r = readRotationAngle(gyro_sensor); % in [deg]
resetRotationAngle(gyro_sensor); % sets the rotation to zero
```
