clear all % ensure previous legoev3 instance is deleted

%% initialize connection
ev3 = legoev3('usb');

%% initialze motors and sensors
motor_l = motor(ev3, 'B');
motor_r = motor(ev3, 'C');

sen_sonic_l = sonicSensor(ev3, 1);
sen_sonic_r = sonicSensor(ev3, 4);
sen_color = colorSensor(ev3, 3);

%% declare parameters
speed = 50;
turn_speed = 50;
th_us = 0.5; % m

%% run program
flag_run = true;
% start motors (please note that setting motor.Speed is enough to
%               to change the speed and direction)
motor_l.Speed = 0;
motor_r.Speed = 0;
start(motor_l);
start(motor_r);

while flag_run
    color = readColor(sen_color);
    if strcmp(color, 'white')
        % White underground detected, assume border of arena
        % drive forward at full speed
        motor_r.Speed = speed;
        motor_l.Speed = speed;
    else
        % read ultra sonic sensors
        dist_l = readDistance(sen_sonic_l);
        dist_r = readDistance(sen_sonic_r);
        
        % check if any sensor sees an object closer than th_us
        if dist_l <= th_us || dist_r <=th_us
            % if an object is detected, turn towards the closer object
            if dist_l <= dist_r
                % turn left
                motor_r.Speed = 0;
                motor_l.Speed = turn_speed;
            else
                % turn right
                motor_r.Speed = turn_speed;
                motor_l.Speed = 0;
            end
        else
            % if no object is detected turn at the current position
            motor_r.Speed = 0.5 * turn_speed;
            motor_l.Speed = -0.5 * turn_speed;
        end
    end
    if readButton(ev3, 'center')
       flag_run = false; 
    end
end

% stop motors
stop(motor_l);
stop(motor_r);

%% terminate connection
clear ev3