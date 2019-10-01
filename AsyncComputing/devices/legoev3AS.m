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
% MATLAB EV3 Asyncronous legoev3 object 
%
% This value class extends the original legoev3 object by a semaphore to 
% coordiante and optimize the communication bandwidth.
%
% Public PROPERTIES
% - IsBusy ... 0 or 1. determines an ongoing I2C communication
% 
% Public FUNCTIONS
%
% ADDING A CALLBACK
% 
% Last Update: July, 2019
% Rueckert Elmar, rueckert@ai-lab.science
% ########################################
classdef legoev3AS < legoev3 & handle
    
     %***************************
     % public PROPERTIES
     %***************************
     properties (Access = 'public')
        
        IsBusy = 0
        
     end

    methods ( Access = 'public' )
        
        %***************************
        % CONSTRUCTOR
        %***************************
        % legoDeviceAS(legoev3Obj, port, flgSaveStatistics)
        %   legoev3Obj          ... EV3 lego (object)
        %   port                ... motor port 'A','B','C','D' (char)
        %   flgSaveStatistics   ... 0,1 (double)
        % 
        % examples: legoDeviceAS(legoev3Obj), or
        % legoDeviceAS(legoev3Obj, ...)
        %***************************
          function obj = legoev3AS(varargin)
              obj = obj@legoev3(varargin{:});
              
             
          end
          
    end

end


          