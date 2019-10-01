% The MIT License (MIT)
% Copyright (c) 2017 Elmar Rueckert
% 
% Permission is hereby granted, free of charge, to any person obtaining a 
% copy of this software and associated documentation files (the "Software"), 
% to deal in the Software without restriction, including without limitation 
% the rights to use, copy, modify, merge, publish, distribute, sublicense, 
% and/or sell copies of the Software, and to permit persons to whom the 
% Software is furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
% THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
% DEALINGS IN THE SOFTWARE.
% ########################################
% MATLAB EV3 Bluetooth Demo 
% 
% Last Update: July, 2019
% Rueckert Elmar, rueckert@ai-lab.science
% ########################################
clear all;
close all;

addpath(genpath([pwd filesep 'devices']));
addpath(genpath([pwd filesep 'ev3functions']));
addpath(genpath([pwd filesep 'helper']));

%*********************
%optional figure handle to plot incomming sensor data in real time
figHnd = figure;
barHnd=bar([0, 0]);%axis([0,2,0,3]);
xlabel('');
ylabel('Messwert [Einheit]');
set(gca,'fontsize', 20);
%*********************

%*********************
%Connect to the ev3 hardware via USB, WiFi or Bluetooth (in that order!)
%default settings: mylego = connectEV3();
mylego = connectEV3('wifi', '192.168.2.2', '00165364afd1');%custom settings
%*********************

try
    %*********************
    %Create Sensor Devices
    motorS1 = motorSensorAS(mylego, 'B');
    motorS2 = motorSensorAS(mylego, 'C');
    touchS1 = touchSensorAS(mylego,1);
    sonicS = sonicSensorAS(mylego, 2);
    colorS = colorSensorAS(mylego, 3);
   
    
    %Create Motor Devices
    motor1 = motorControllerAS(mylego, 'B');
    myDevices = { motorS1, motorS2, touchS1, sonicS, colorS, motor1 };
    disp('devices created')
    %*********************
    
    %*********************
    %Start the MOTORS
    start(motor1);
    %*********************

    %*********************
    %ADD all callback events
    touchS1.addCallbackForValuesReceived(@(distance)set(barHnd, 'Ydata', distance));
    %*********************
    
    %*********************
    %Start the Sensor Recording
    %*********************
    for devId=1:size(myDevices,2)
        myDevices{devId}.startRec();
    end
    beep 
    disp('Sensor recording STARTED...');
    %*********************
    
    
    %*********************
    %Set some motor commands
    motor1.SpeedAS = 30;
    %*********************
    
    pause(10);
    
    if 1
        %*********************
        %Optional Plot Frame rates
        numMeasure = 0;
        for devId=1:size(myDevices,2)
            myDevices{devId}.stopRec();

            numMeasure = numMeasure + myDevices{devId}.numRec;
            %plot stats
            figure; 
            hist(1000*myDevices{devId}.statsReadoutTimes, 30);
            xlabel('Messdauer [ms]');
            ylabel('Anzahl d. MW');
            set(gca,'fontsize', 20);
        end
        numMeasure
    end
        
    %*********************
    %STOP the MOTORS
    motor1.SpeedAS = 0;
    stop(motor1);
    %*********************

    %*********************
    %REmove all devices from the memory
    for devId=1:size(myDevices,2)
        delete(myDevices{devId});
        myDevices{devId} = [];
    end
    myDevices = [];
    %*********************
    
 catch err
     err
end
  
%*********************
%Close the ev3 connetcion
clear mylego;
%*********************


