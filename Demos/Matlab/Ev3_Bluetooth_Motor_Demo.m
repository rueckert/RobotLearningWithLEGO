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

close all;
clear all; 

distance = 0;

figHnd = figure;
%Traget motor speed
T=100;
mVelProfile = 100*sin(2*pi*(1:T)./T)';
mVelProfileTime = nan(T,1);
plot(mVelProfile,'linewidth',2);

%keyboard

mylego = legoev3('bluetooth','/dev/tty.EV3_UzL_ROB1-SerialPort');
mymotor = motor(mylego,'A');
mymotor.Speed = 0;
resetRotation(mymotor);

i=1;

tmpReadoutTimes = nan(T,1);
trueMotorAngles = nan(T,1);

start(mymotor);

while i<= T
    tic
    mymotor.Speed = mVelProfile(i,1);
    trueMotorAngles(i,1) = readRotation(mymotor);
    mVelProfileTime(i,1) = toc;
    %pause(0.01);
    i = i+1;
end
disp('done');
stop(mymotor);

timeXAxis = cumsum(mVelProfileTime);

plot(timeXAxis, mVelProfile,'linewidth',2);
xlabel('Zeit [sek]');
ylabel('Motor Geschw. [prozent]');
set(gca,'fontsize', 20);


clear mylego;

figure; 
plot(timeXAxis, trueMotorAngles,'linewidth',2);
xlabel('Zeit [sek]');
ylabel('Motor Winkel [grad]');
set(gca,'fontsize', 20);


figure; 
hist(mVelProfileTime);
xlabel('motor readout times');
ylabel('frequency');
set(gca,'fontsize', 20);

