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
% MATLAB Asyncronous sonic sensor interface 
% 
% Last Update: July, 2019
% Rueckert Elmar, rueckert@ai-lab.science
% ########################################
classdef touchSensorAS < legoDeviceAS & touchSensor
    
    methods ( Access = 'public' )
        
        %***************************
        % CONSTRUCTOR
        %***************************
        % gyroSensorAS(legoev3Obj, port, flgSaveStatistics)
        %   legoev3Obj          ... EV3 lego (object)
        %   port                ... sensor port 1,2,3,4 (double)
        %   flgSaveStatistics   ... 0,1 (double), has no effect: stats are
        %   always stored.
        % 
        % examples: touchSensorAS(legoev3Obj) or touchSensorAS(legoev3Obj, 1), or
        % touchSensorAS(legoev3Obj, 1, 0)
        %***************************
          function obj = touchSensorAS(legoev3Obj, port, flgSaveStatistics)
              if nargin < 1
                  error('This constructor requires one input argument: the legoev3Obj!')
              end
              scArgs{1} = legoev3Obj;
              if exist('port','var')
                  scArgs{2} = port; 
              end
              obj = obj@touchSensor(scArgs{:});
              if exist('flgSaveStatistics','var')
                  obj.flgSaveStatistics = flgSaveStatistics;
              end
              obj.legoev3Obj = legoev3Obj;
              
              obj.readValueFunc = @readTouch;
          end

    end
    
end


          