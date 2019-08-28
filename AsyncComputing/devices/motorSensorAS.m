% The MIT License (MIT)
% Copyright (c) 2019 Elmar Rueckert
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
% MATLAB Asyncronous motor encoder interface 
% 
% Last Update: July, 2019
% Rueckert Elmar, rueckert@ai-lab.science
% ########################################
classdef motorSensorAS < legoDeviceAS & motor

    methods ( Access = 'public' )
        
        %***************************
        % CONSTRUCTOR
        %***************************
        % motorSensorAS(legoev3Obj, port, flgSaveStatistics)
        %   legoev3Obj          ... EV3 lego (object)
        %   port                ... motor port 'A','B','C','D' (char)
        %   flgSaveStatistics   ... 0,1 (double), has no effect: stats are
        %   always stored.
        % 
        % examples: motorSensorAS(legoev3Obj, 'A'), or
        % motorSensorAS(legoev3Obj, 'A', 1)
        %***************************
          function obj = motorSensorAS(legoev3Obj, port, flgSaveStatistics)
              if nargin < 2
                  error('This constructor requires two input arguments: the legoev3Obj and the port character!')
              end
              scArgs{1} = legoev3Obj;
              scArgs{2} = port; 
              
              obj = obj@motor(scArgs{:});
              if exist('flgSaveStatistics','var')
                  obj.flgSaveStatistics = flgSaveStatistics;
              end
              obj.legoev3Obj = legoev3Obj;
              
              %THE MOTOR ENCODER IS A RELATIVE SENSOR, so we need to set it
              %to zero
              %resetRotation(obj);                %set the relative sensor value reading to 0
              
              obj.readValueFunc = @readRotation; %mean sensor interface call
              
          end
          
    end
    
end


          