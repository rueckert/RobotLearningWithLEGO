%% Kalman Filter Tutorial - Odometrie (Differential Drive) und Gyroskop
clear all
close all
clc

%% Modell des Differential Drives
L = 0.06;           % Halber Achsabstand in Meter
D = 0.052;          % Rad Durchmesser in Meter

alpha = [0.1, 0.1, 0.1, 0.1];       % Odometry Fehler (beliebig gewählt)

A = eye(3);

H = [0 0 1]; % Beobachtungsmatrix
R = 0.01; 

%% Verbinde mit dem EV3-Roboter
ev3 = legoev3('usb');
% Motorn
motor_r = motor(ev3, 'C');
motor_l = motor(ev3, 'B');

% Sensoren
gyro_sensor = gyroSensor(ev3, 3);

%start(motor_r);
%start(motor_l);


%% Kalman Filter
z_direct = (2*pi/360) * double(readRotationAngle(gyro_sensor));
x = [0; 0; 0];
x_storage = [];
phi_r = readRotation(motor_r);
phi_l = readRotation(motor_l);
P = zeros(3);
while true
    
    %% Schätze Position

    % 1: Lese Odometrie Daten und berechne geschätze Position
    phi_r_alt = phi_r;
    phi_l_alt = phi_l;
    phi_r = readRotation(motor_r);
    phi_l = readRotation(motor_l);
    
    % Schätze Position
    x_ = kinematischesModell(phi_r, phi_r_alt, phi_l, phi_l_alt);
    
    % Berechne Deltas für Fehlerabschätzung
    dx = x_ - x;
    
    delta_r1 = atan2(dx(2),dx(1)) - x(3);
    delta_t = sqrt(dx(1)^2 + dx(2)^2);
    delta_r2 = dx(3) - delta_r1;

    U = diag([alpha(1)*delta_r1 + alpha(2)*delta_t, alpha(3)*delta_t + ...
                alpha(4)*(delta_r1+delta_r2), alpha(1)*delta_r2 + alpha(2)*delta_t]);

    Fx = [1, 0, -delta_t * sin(x(3) + delta_r1); 0, 1, delta_t * cos(x(3) + delta_r1); 0, 0, 1];
    Fu = [-delta_t * sin(x(3) + delta_r1), cos(x(3) + delta_r1), 0; delta_t * cos(x(3) + delta_r1), sin(x(3) + delta_r1), 0; 1 0 1]; 

    P_ = Fx*P*Fx' + Fu*U*Fu';

    S = H*P_*H' + R;
    K = P_*H'*S^(-1);

    % Messe den Winkel mit dem Gyroskop und resette das Gyroskop
    z_alt = z_direct;
    z_direct = (2*pi/360) * double(readRotationAngle(gyro_sensor));
    z = x(3) + (z_direct-z_alt);

    y = z - H*x_;

    x = x_ + K*y;
    P = P_ - K*S*K';
    x_storage(:, end+1) = x;
end

%% Schließe Verbindung zum EV3
stop(motor_r);
stop(motor_l);
clear ev3