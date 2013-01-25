function redefine = redefineParameter(varargin)
% Author: Neil Fulwiler
% Date  : 1.18.2013
% Usage : 
%   creates a string that the locomotionMAS system will
%   recognize as a redefinition argument when appended to
%   a call to locomotionMAS
%   
% Parameters:
%   varargin    variable-value pairs representing the parameters
% 
% Returns:
%   redefine    a string representing an option that may
%               be passed in to the lMAS system for redefining
%               the desired parameters
% 
% MISCELLANEOUS
%  accepted parameters are:
%       bg
%       kg
%       c1
%       c2
% 
%       ko
%       c3
%       c4
% 
%       bm
%       km
% 
%       kmo 
%       c5
%       c6

% check the simple case
if nargin==0
    redefine='';
    return
end  

% validate arguments
if mod(numel(varargin),2) ~= 0
    error(['redefineParameter requires parameter-value pairs following '...
           'the positional path argument.']);
end

% NOTE: Redefining within the locomotionMAS system
% works by constructing a string that represents
% a path to the individual node in the configuration
% structure that is to be redefinted. 

locomotionModel = 'virtual_world:environment:model(name=locomotionModel)';

% so much repetition, lets use lots of anonymous functions
componentFactory   = @(component) ...
                        @(param, value) sprintf('%s:component(name=%s):param(name=%s):value=%f',...
                            locomotionModel,...
                            component,...
                            param,...
                            value);

% create the factories that will generate the
% actual strings for redefinintion
stationaryGoalFactory       = componentFactory('stationaryGoal');
stationaryObstacleFactory   = componentFactory('stationaryObstacle');
movingTargetFactory         = componentFactory('movingTarget');
movingObstacleFactory       = componentFactory('movingObstacle');
                        
                        
parameters = struct(...
    'bg', stationaryGoalFactory,...
    'kg', stationaryGoalFactory,...
    'c1', stationaryGoalFactory,...
    'c2', stationaryGoalFactory,...
    'ko', stationaryObstacleFactory,...
    'c3', stationaryObstacleFactory,...
    'c4', stationaryObstacleFactory,...
    'bm', movingTargetFactory,...
    'km', movingTargetFactory,...
    'kmo',movingObstacleFactory,...
    'c5', movingObstacleFactory,...
    'c6', movingObstacleFactory...
);

% the string that will be appended to the command
redefstring = '';

% now redefine the parameters
for ii=1:2:numel(varargin)
    param=varargin{ii};
    value=varargin{ii+1};
    
    % make sure this is a valid parameter
    if ~isfield(parameters, param)
        error(['invalid parameter: ' param]);
    end
    
    % generate the string and 
    generator = parameters.(param);
    redefstring = [redefstring '+' generator(param, value)];
end
redefstring(1) = []; % strip the leading '+'

% craft the final string (the redef string must be single quoted
% because it contains '('
redefine = ['-redefine ''' redefstring ''''];

end


