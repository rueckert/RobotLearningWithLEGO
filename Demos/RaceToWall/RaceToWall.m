% ~~~~~~~~~~~~~~~~~~~~~~
% Parameter
% ~~~~~~~~~~~~~~~~~~~~~~

% IP Adresse des Bricks (kann sich änderen)
ipaddr = '192.168.137.225';
% ID des Bricks
brickid = '001653651766';

% minimaler Abstand
min_d = 0.15;
% maximale Geschwindigkeit
max_v = 100;

% ~~~~~~~~~~~~~~~~~~~~~~
% Program
% ~~~~~~~~~~~~~~~~~~~~~~

% Initializie Wlan-Verbindung zum EV3
% ev3 = legoev3('WiFi', ipaddr, brickid);
ev3 = legoev3('usb');

% Initializiere Motoren
motor_r = motor(ev3, 'C');
motor_l = motor(ev3, 'B');

% Initializiere Ultraschallsensor
sonic_sensor = sonicSensor(ev3, 4);
% lese Distanz
d = readDistance(sonic_sensor);

% Warte auf Startsignal (obere Taste gedrückt)
writeStatusLight(ev3, 'green', 'pulsing');
while ~readButton(ev3, 'up')
    pause(0.1);
end
writeStatusLight(ev3, 'red');
% Starte Motoren
start(motor_r);
start(motor_l);

% Fahre gerade aus
motor_r.Speed = max_v;
motor_l.Speed = max_v;

% Fahre solange bis minimale distanz erreicht ist
while d > min_d
    % Warte
    pause(0.1);
    
    % Lese distanz
    d = readDistance(sonic_sensor);
    
    % Wenn Wand näher kommt fahre langsamer
    if d < 2*min_d
       motor_r.Speed = 0.5 * max_v;
       motor_l.Speed = 0.5 * max_v;
    end
end

% stoppe Motoren
stop(motor_r);
stop(motor_l);
writeStatusLight(ev3, 'green');
% Schließe Verbindung zum EV3
clear ev3