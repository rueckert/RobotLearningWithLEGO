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
classdef motorControllerAS < legoDeviceAS & motor

     %***************************
     % public PROPERTIES
     %***************************
     % The speed value between -100 and 100 that can be assigned
     % non-blacking. Note that it replaces the ev3motor.Speed property
     % where the assignment is blocking. 
     properties (Access = 'public')
         SpeedAS = 0
     end
    
    methods ( Access = 'public' )
        
        %***************************
        % CONSTRUCTOR
        %***************************
        % motorControllerAS(legoev3Obj, port, flgSaveStatistics)
        %   legoev3Obj          ... EV3 lego (object)
        %   port                ... motor port 'A','B','C','D' (char)
        %   flgSaveStatistics   ... 0,1 (double), has no effect: stats are
        %   always stored.
        % 
        % examples: motorControllerAS(legoev3Obj, 'A'), or
        % motorControllerAS(legoev3Obj, 'A', 1)
        %***************************
          function obj = motorControllerAS(legoev3Obj, port, flgSaveStatistics)%, motorObj)
              if nargin < 2
                  error('This constructor requires two input arguments: the legoev3Obj and the port character!')
              end
              scArgs{1} = legoev3Obj;
              scArgs{2} = port; 
              
              obj = obj@motor(scArgs{:});
              
%               if exist('motorObj','var')
%                   obj = motorObj;  
%               end
              
              if exist('flgSaveStatistics','var')
                  obj.flgSaveStatistics = flgSaveStatistics;
              end             
              
              obj.timerObj.TimerFcn = @(x,y)obj.setSentValue();
             
          end
          
    end
    
    %***************************
    % protected FUNCTIONS
    %***************************
    methods (Access = 'protected')
        
        %***************************
        % private setSentValue
        %***************************
        % This function ...
        % It also sets the busy flag to 1 prior to the "blocking" read function call. 
        % After the reading process has terminated the busy flag is set to
        % 0. 
        % In addition, statitics are stored in lines 183 to 194.
        function setSentValue(obj)
              
            try
              %obj.setBusyValue(1)
              
              obj.Speed = obj.SpeedAS;
              %obj.handleCallback();
              
              %obj.setBusyValue(0);
            catch err2
                disp('sent timer error!');
                %keyboard
            end
              
        end
        
    end

end
          