%% Kalman Filter Tutorial - Odometrie (Differential Drive) und Gyroskop
clear all
close all
clc

%% Verbinde mit dem EV3-Roboter
ev3 = legoev3('usb');

% Motoren
motor_r = motor(ev3, 'D');
motor_l = motor(ev3, 'C');

start(motor_r);
start(motor_l);

% Sensoren
gyro_sensor = gyroSensor(ev3, 4);

%% Initializiere
% Beschleunigungsprofil

speed_l = [ones(100, 1)*30; ones(100, 1)*50; ones(100, 1)*50];

speed_r = [ones(100, 1)*50; ones(100, 1)*50; ones(100, 1)*30];

% lese winkel des Roboters aus
resetRotationAngle(gyro_sensor);
resetRotation(motor_r);
resetRotation(motor_l);

% Lese Daten
phi_gyro_alt = double(readRotationAngle(gyro_sensor));
phi_r_alt = readRotation(motor_r);
phi_l_alt = readRotation(motor_l);

%% Initializiere Position und Varianz
x = [0; 0; 0];
P = zeros(3);

x_storage = [];

%% Wende Kalman Filter mehrfach an
for i=1:length(speed_r)
    motor_r.Speed = speed_r(i);
    motor_l.Speed = speed_l(i);
    
    %% Sch‰tze Position

    % 1: Lese Odometrie Daten und berechne gesch‰tze Position
    phi_r = readRotation(motor_r);
    phi_l = readRotation(motor_l);
    phi_gyro = double(readRotationAngle(gyro_sensor));
    
    % Berechne Pose und Varianz durch KalmanFilter
    [x, P] = kalmanFilterEV3(phi_r, phi_l, phi_gyro, phi_r_alt, ...
        phi_l_alt, phi_gyro_alt, x, P);
    
    % Aktualisiere Zwischenspeicher
    phi_gyro_alt = phi_gyro;
    phi_r_alt = phi_r;
    phi_l_alt = phi_l;
    
    % Speichere Pose zum Plotten
    x_storage(:, end+1) = x;
    
    % Kurz warten
    %pause(0.01);
end

%% Schlieﬂe Verbindung zum EV3
stop(motor_r);
stop(motor_l);
clear ev3

%% Plotte Weg
plot(x_storage(2,:), x_storage(1,:));
axis equal
xlabel('x');
ylabel('y');