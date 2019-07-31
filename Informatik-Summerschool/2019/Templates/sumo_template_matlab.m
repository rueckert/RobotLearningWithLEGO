clear all % ensure previous legoev3 instance is deleted

%% initialize connection
ev3 = legoev3('usb');

%% initialze motors and sensors
% TODO

%% declare parameters
% TODO

%% run program

flag_run = false;
% wait until centered button is pressed (start signal)
while ~flag_run
   flag_run = readButton(ev3, 'center');
   pause(0.1);
end

% start motors
% TODO

while flag_run
    % TODO implement behavior
    
    % check if programm has to terminate
    if readButton(ev3, 'center')
       flag_run = false; 
    end
end

% stop motors
% TODO

%% terminate connection
clear ev3