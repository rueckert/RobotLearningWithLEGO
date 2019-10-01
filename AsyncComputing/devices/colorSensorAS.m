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
% MATLAB Asyncronous color sensor interface 
% 
% Last Update: July, 2019
% Rueckert Elmar, rueckert@ai-lab.science
% ########################################
classdef colorSensorAS < legoDeviceAS & colorSensor
    
    properties (Access = 'public')
       %none | black | blue | green | yellow | red | white | brown
       colorStrValues = {'none', 'black', 'blue', 'green', 'yellow', 'red', 'white', 'brown'}
    end
    
    methods ( Access = 'public' )
        
        %***************************
        % CONSTRUCTOR
        %***************************
        % colorSensorAS(legoev3Obj, port, flgSaveStatistics)
        %   legoev3Obj          ... EV3 lego (object)
        %   port                ... sensor port 1,2,3,4 (double)
        %   flgSaveStatistics   ... 0,1 (double), has no effect: stats are
        %   always stored.
        % 
        % examples: colorSensorAS(legoev3Obj) or colorSensorAS(legoev3Obj, 1), or
        % colorSensorAS(legoev3Obj, 1, 0)
        %***************************
          function obj = colorSensorAS(legoev3Obj, port, flgSaveStatistics)
              if nargin < 1
                  error('This constructor requires one input argument: the legoev3Obj!')
              end
              scArgs{1} = legoev3Obj;
              if exist('port','var')
                  scArgs{2} = port; 
              end
              obj = obj@colorSensor(scArgs{:});
              if exist('flgSaveStatistics','var')
                  obj.flgSaveStatistics = flgSaveStatistics;
              end
              obj.legoev3Obj = legoev3Obj;

              obj.readValueFunc = @readColorId;
              
          end

          %***************************
          % public colorId = readColorId(obj)
          %***************************
          % this function reads the sensor value and converts the string
          % to an integer
          function colorId = readColorId(obj)
              colorstr = readColor(obj);
              colorId = obj.getColorIdFromString(colorstr);
          end
          
          %***************************
          % public colorId = getColorIdFromString(obj, colorstr)
          %***************************
          % this function converts the color string (in Line 31, i.e., colorStrValues)
          % to an integer
          function colorId = getColorIdFromString(obj, colorstr)
             for colorId=1:8
                if strcmp(obj.colorStrValues{colorId},colorstr) > 0
                    return;
                end
             end
             colorId = 1;
          end
          
    end
    
end


          