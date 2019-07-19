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
barHnd=bar(distance);axis([0,2,0,3]);
xlabel('');
ylabel('Abstand [m]');
set(gca,'fontsize', 20);


%keyboard

mylego = legoev3('bluetooth','/dev/tty.EV3_UzL_ROB1-SerialPort');
mysonicsensor = sonicSensor(mylego)

i=1;

tmpReadoutTimes = nan(500,1);

while i< 100
    tic
    distance = readDistance(mysonicsensor);
    %pause(0.01);
    i = i+1;
    set(barHnd, 'Ydata', distance);
    %bar(distance);axis([0,2,0,3]);
    tmpReadoutTimes(i,1) = toc;
end
disp('done');

clear mylego;

figure; 
hist(tmpReadoutTimes);
xlabel('sonic readout times');
ylabel('frequency');
set(gca,'fontsize', 20);



