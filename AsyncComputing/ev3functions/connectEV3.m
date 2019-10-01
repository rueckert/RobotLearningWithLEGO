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
function mylego = connectEV3(varargin)
%This function tries to establish a connection to the ev3 brick. 
%Priorities are: 1. usb, 2. wifi, 3. bluetooth
%supported are the operating systems: MAC OS, WIN XX?
   

    mylego = struct([]);
    errMsg = '';
    
    if nargin > 0
       try 
           mylego = legoev3AS(varargin{:});
           disp('CONNECTION to the ev3 established.');
           return;
        catch err
            disp('debug msg:could not connect to the ev3 using the provided arguments.');
        end
    end
    
    %1.usb
    try
        mylego = legoev3AS('usb');
        disp('debug msg: connected to the ev3 via usb.');
        return;
    catch err
        disp('debug msg:could not connect to the ev3 via usb.');
    end
    
    %2.wifi
    try
        %mylego = legoev3AS('wifi', '19.168.2.2', '001653651766');
        mylego = legoev3AS('wifi', '192.168.2.2', '00165364afd1');
        
        disp('debug msg: connected to the ev3 via wifi using ip 192.168.2.2.');
        return;
    catch err
        disp('debug msg:could not connect to the ev3 via wifi via 192.168.2.2.');
    end
    
    %3.bluetooth
    try
        mylego = legoev3AS('bluetooth','/dev/tty.EV3_UzL_ROB1-SerialPort');
        disp('debug msg: connected to the ev3 via bluetooth.');
     catch err
         errMsg = 'Es könnte keine Verbindung aufgebaut werden!, Starten sie den Ev3 oder starten sie MATALB neu!';
         error(errMsg);
     end
end

