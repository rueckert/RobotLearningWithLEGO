clear all % ensure previous legoev3 instance is deleted

%% initialize connection
ev3 = legoev3('usb');

%% initialze motors and sensors
motor_r = motor(ev3, 'B');
motor_l = motor(ev3, 'C');
motor_gripper = motor(ev3, 'A');
sen_sonic = sonicSensor(ev3, 2);
sen_color = colorSensor(ev3, 3);

%% declare parameters
speed = 100;
turn_speed = 50;
gripper_speed = 50;
th_sonic = 0.5; % m
th_gripper = 0.05; % m
gripper_min = 0;
gripper_max = 90;

%% move gripper into its initial position
move_gripper_to_init_pos(motor_gripper, gripper_speed);
    
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
resetRotation(motor_gripper);
start(motor_r);
start(motor_l);
start(motor_gripper);

while flag_run
    % check if programm has to terminate
    if readButton(ev3, 'up')
       flag_run = false; 
       continue
    end
    
    % read color sensor
    color = readColor(sen_color);
    if strcmp(color, 'black ')
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
        % if there is a very close object move gripper upwards
        gripper_pos = readRotation(motor_gripper);
        if dist < th_gripper                     
           % move gripper only to a mximum hight
           if gripper_pos < gripper_max
               motor_gripper.Speed = gripper_speed; 
           else
               motor_gripper.Speed = 0;
           end
        else
            % move the grippe in lower position
            if gripper_pos > gripper_min
               motor_gripper.Speed = -gripper_speed; 
            else
               motor_gripper.Speed = 0;
            end
        end
    else
       % if no object is near by in front turn
       motor_r.Speed = - turn_speed;
       motor_l.Speed =   turn_speed;
    end
end

% stop motors
stop(motor_r);
stop(motor_l);
stop(motor_gripper);

%% terminate connection
clear ev3

%% deleacre on functions
function move_gripper_to_init_pos(motor_gripper, speed)
% moves gripper in lower position
gripper_pos = readRotation(motor_gripper);
motor_gripper.Speed = -speed; 
start(motor_gripper);
pause(0.001);
new_pos = readRotation(motor_gripper);

% move until floor is reached
while gripper_pos ~= new_pos
    gripper_pos = new_pos;
    pause(0.1);
    new_pos = readRotation(motor_gripper);
end
motor_gripper.Speed = 0;
stop(motor_gripper)
end