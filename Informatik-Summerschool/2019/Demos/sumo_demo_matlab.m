clear all % ensure previous legoev3 instance is deleted

%% initialize connection
ev3 = legoev3('usb');

%% initialze motors and sensors
motor_r = motor(ev3, 'B');
motor_l = motor(ev3, 'C');
sen_sonic = sonicSensor(ev3, 2);
sen_color = colorSensor(ev3, 3);

%% declare parameters
speed = 100;
turn_speed = 50;
th_sonic = 0.5; % m

%% run program
flag_run = false;
% wait until centered button is pressed (start signal)
while ~flag_run
   flag_run = readButton(ev3, 'up');
   pause(0.1);
end

% start motors
resetRotation(motor_r);
resetRotation(motor_l);
start(motor_r);
start(motor_l);

while flag_run
    % check if programm has to terminate
    if readButton(ev3, 'up')
       flag_run = false; 
       continue
    end
   
    % read color sensor
    color = readColor(sen_color);
    if strcmp(color, 'black')
        % if white boader is detected, drive forward
        motor_r.Speed = speed;
        motor_l.Speed = speed;
        continue
    end
    
    % read ultra sonic sensor
    dist = readDistance(sen_sonic);
    if dist < th_sonic
        % object near by detected: drive towards the object
        motor_r.Speed = speed;
        motor_l.Speed = speed;            
    else
       % if no object is near by in front turn
       motor_r.Speed = - turn_speed;
       motor_l.Speed =   turn_speed;
    end
end

% stop motors
stop(motor_r);
stop(motor_l);

%% terminate connection
clear ev3