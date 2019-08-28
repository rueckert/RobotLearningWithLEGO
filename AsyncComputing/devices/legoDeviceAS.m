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
% MATLAB EV3 Asyncronous device base class
%
% This handle class creates a timer object which tries to call a sensor
% read function handle every 20ms. If the previous reading process is still
% ongoing (has not terminated within 20ms), the function call is droped.
%
% Public PROPERTIES
% - The measurement values are stored in the public property 'receivedValue'.
% - The flag busy indicates if the reading process is ongoing. 
% 
% Public FUNCTIONS
% - startRec() ... starts the sensor reading processes.
% - stopRec() ... stops the recording.
%
% ADDING A CALLBACK
% - addCallbackForValuesReceived(functionHandle) ... the callback function
% handle is executed after a new sensor value was received. 
% 
% Last Update: July, 2019
% Rueckert Elmar, rueckert@ai-lab.science
% ########################################
classdef legoDeviceAS < handle
    
     %***************************
     % public PROPERTIES
     %***************************
     % - The measurement values are stored in the public property 'receivedValue'.
     % - The variable sentValue is not used.
     % - The flag busy indicates if the reading process is ongoing. 
     % - receivedValueCallback may specify a callback function that is
     % executed after a new sensor value was received. 
     % 
     % STATISTICS:
     % To capture statistics of the reading process the argument
     % 'flgSaveStatistics' has to be set to 1 in the consturctor!
     % 
     % - The last 100 received sensor readings are stored in the vector
     % 'statsValues'. 
     % - The time needed to read the sensor values of the last 100
     % measurements is stored in the vector 'statsReadoutTimes'. 
     properties (Access = 'public')
        
        receivedValue = nan
        sentValue = nan
        busy = nan
        
        receivedValueCallback = []
        
        statsValues = nan(100,1);
        statsReadoutTimes = nan(100,1);
        
        numRec = 0
        
        legoev3Obj = [] %main lego ev3 object
     end
     %***************************
     % protected PROPERTIES
     %***************************
     properties (Access = 'protected')
         timerObj = []
         
         
         statsLastId = 1
         flgSaveStatistics = 0
         
         readValueFunc = [] %function handle that needs to be assigned in a subclass, e.g., readValueFunc = readDistance
         
         numRecSincePeriodUpdate = 0
     end
    
    methods ( Access = 'public' )
        
        %***************************
        % CONSTRUCTOR
        %***************************
        % legoDeviceAS(legoev3Obj, port, flgSaveStatistics)
        %   legoev3Obj          ... EV3 lego (object)
        %   port                ... motor port 'A','B','C','D' (char)
        %   flgSaveStatistics   ... 0,1 (double), has no effect: stats are
        %   always stored.
        % 
        % examples: legoDeviceAS(legoev3Obj), or
        % legoDeviceAS(legoev3Obj, ...)
        %***************************
          function obj = legoDeviceAS(legoev3Obj, port, flgSaveStatistics)
              obj.timerObj = ...
                    timer('BusyMode', 'drop',...           %drop: drop command. error: Completes task; throws error specified by ErrorFcn; stops timer.
                    'Period', round(20*rand(1,1))/1000 + 80/1000, ...                 %every 20ms (in seconds) round(10*rand(1,1))/1000 + 40/1000
                    'ExecutionMode', 'fixedDelay', ...   % fixedSpacing see https://de.mathworks.com/help/matlab/ref/timer-class.html
                    'TasksToExecute', Inf, ...              %how many periodes should the timer run, e.g. 'inf'
                    'StartDelay', round(100*rand(1,1))/1000 ...
                    );
              obj.timerObj.TimerFcn = @(x,y)obj.setReceivedValue();
          end
          
        %***************************
        % DESTRUCTOR
        %***************************
        % delete(mydevice)
        % This function deletes the timer object. If the timer was not
        % stoped by using the function 'stopRec()' a warning will be
        % prompted. 
        %***************************
          function delete ( obj )
                
              obj.stopRec();
              obj.legoev3Obj = [];
              
              if ~isempty(obj.timerObj)
                    delete(obj.timerObj);
                    obj.timerObj = [];
              end
        
          end
          
        %***************************
        % public startRec()
        %***************************
        % This function starts the recording. 
        %***************************
          function startRec(obj)
              
              if ~isempty(obj.legoev3Obj)
                  switch(obj.legoev3Obj.CommunicationType)
                      case 'USB'
                            set(obj.timerObj, 'Period', round(20*rand(1,1))/1000 + 50/1000);
                      case 'Bluetooth'
                            set(obj.timerObj, 'Period', round(20*rand(1,1))/1000 + 200/1000);
                      case 'WiFi'
                            set(obj.timerObj, 'Period', round(20*rand(1,1))/1000 + 100/1000);
                      otherwise
                            error(sprintf('Ev3 CommunicationType [%s] not supported!', obj.legoev3Obj.CommunicationType));
                  end
                  sprintf('period set to %i in ms', get(obj.timerObj, 'Period')*1000)
              end
              
              if ~isempty(obj.timerObj)
                    start(obj.timerObj); 
                    tic
              end
          end
          
        %***************************
        % public stopRec()
        %***************************
        % This function stops the recording. 
        %***************************
          function stopRec(obj)
              disp('........stop timer');
              if ~isempty(obj.timerObj)
                  stop(obj.timerObj); 
              end
          end
          
        %***************************
        % public addCallbackForValuesReceived()
        %***************************
        % This function stops the recording. 
        %***************************
          function addCallbackForValuesReceived(obj, callbackFunction)
             obj.receivedValueCallback = callbackFunction;
          end
    end
    
    %***************************
    % protected FUNCTIONS
    %***************************
    methods (Access = 'protected')
        
        %***************************
        % protected setReceivedValue
        %***************************
        % This function calls the sensor reading function defined in
        % 'readValueFunc'.
        % It also sets the busy flag to 1 prior to the "blocking" read function call. 
        % After the reading process has terminated the busy flag is set to
        % 0. 
        % In addition, statitics are stored in lines 183 to 194.
        function setReceivedValue(obj)
            
              %exit if no reading function handle is defined
              if isempty(obj.readValueFunc) 
                  return;
              end
              %disp('...')
              %exit if the ev3 is busy, (i.e., an ongoing I2C transmission)
              if ~isempty(obj.legoev3Obj)
                  if(obj.legoev3Obj.IsBusy == 1)
                     return;
                  end
              end

              obj.setBusyValue(1);
              
              try
                  obj.legoev3Obj.IsBusy = 1;
                  obj.statsValues(obj.statsLastId,1) = obj.readValueFunc(obj);
                  obj.legoev3Obj.IsBusy = 0;
              catch err
                  obj.legoev3Obj.IsBusy = 0;
                  %sprintf('received timer error: %s', err.message)
              end
              
              obj.statsReadoutTimes(obj.statsLastId,1) = toc;
              obj.receivedValue = obj.statsValues(obj.statsLastId,1); 
              obj.statsLastId = obj.statsLastId + 1;                   
              if obj.statsLastId > size(obj.statsValues,1)
                  obj.statsLastId = 1;
              end
              obj.numRec = obj.numRec + 1;
              obj.handleCallback();
              obj.setBusyValue(0);
              
              tic
              
        end
        
        %***************************
        % protected setBusyValue
        %***************************
        % This function is called whenever the sensor reading process has
        % started and or has terminated.
        function setBusyValue(obj, value)
            obj.busy = value;
%             if ~isempty(obj.legoev3Obj)
%                 %sprintf('ev3b %i', value)
%                 obj.legoev3Obj.IsBusy = value;
%             end
        end
        
        %***************************
        % protected handleCallback
        %***************************
        % This function calls the callback function to broadcast the last
        % received sensor value. 
        function handleCallback(obj)
            if ~isempty(obj.receivedValueCallback) 
                obj.receivedValueCallback(obj.receivedValue);
            end
        end
        
        %***************************
        % protected adaptTimerPeriod
        %***************************
        % This function dynamically adapts the timer periode based on the past 
        % measured durations of the senor reading processes. 
        function adaptTimerPeriod(obj)
            %'Period', 20/1000
            
            obj.numRecSincePeriodUpdate = obj.numRecSincePeriodUpdate + 1;
            minNumRecSincePeriodUpdate = 20;
            
            if obj.numRecSincePeriodUpdate < minNumRecSincePeriodUpdate
                return;
            else
                obj.numRecSincePeriodUpdate = 0;
            end

            minNumMeasurements = 5;
            minPeriod = 20/1000; %in seconds
            maxPeriod = 200/1000; %in seconds
            learningRate = 0.5; %between 0 and 1, where with 0 no update is applied
            
            if obj.statsLastId > (minNumMeasurements+1)
                
                currentPeriod = get(obj.timerObj, 'Period');
                optimalPeriod = mean(obj.statsReadoutTimes(obj.statsLastId-minNumMeasurements-1:obj.statsLastId-1,1));
                newPeriod = learningRate*optimalPeriod + (1-learningRate)*currentPeriod;
                
                %round to ms precision
                newPeriod = round(1000*newPeriod)/1000;
                %sprintf('new period is %i ms', 1000*newPeriod)
                
                if (newPeriod > minPeriod) && (newPeriod < maxPeriod)
                    sprintf('set new perido to %i ms', 1000*newPeriod)
                    stop(obj.timerObj); set(obj.timerObj, 'Period', newPeriod); start(obj.timerObj);
                end
            end
        end
        
    end
end


          