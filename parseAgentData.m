function ts = parseAgentData(fpath, agent, varargin)
% Author: Neil Fulwiler
% Date  : 1.18.2013
% Usage :
%   parseAgentData parses the output csv file (fpath) 
%   for a run of an experiment using locomotionMAS and 
%   returns a time series for the given agent 
%   that contains all data points for the specified
%   variables over the entire run. 
% 
%   Parameters:
%       fpath           path to the output file
%
%       agent           name of the agent whose information
%                       is desired. If the name not known, and
%                       the file contains information about 1 agent,
%                       then this field can be []
%
%       fields...       the desired fields, these should be columns
%                       in the csv file, if they are not an error will
%                       be thrown
%   Returns:
%       if n fields are given, then the return result is an 
%       mxn matrix where each row is extracted from one line in the csv
%
%   eg:
%    ts = parseAgentData('data/experiment_output.csv', 'a1', 'x', 'y', 'phi');
%
% Miscellaneous 
%   -- format of the experiment_output.csv file for locomotionMAS
%   -- THIS FUNCTION RELIES ON THIS ASSUMPTION
%   
%   id;x;y;dt;...
%   a1;10;1.3;.1;...


% import the data
data = importdata(fpath);

% the first row of the textdata will contain
% the format that describes the numerical data
formatstring = data.textdata(1,:);

% the function getindex provides a way of constructing
% a closure that will be useful for indexing into the data
% to extract particular variables
getindex     = @(varname) ismember(formatstring, varname); 

% now get the data for the particular agent in question.
% if none was specified, then make sure there's only one
% agent in this data-set, and use that one
idcol = data.textdata([2:end], getindex('id'));
if isempty(agent)
    
    % make sure that there is only one
    % unique id in the id column
    if size(unique(idcol),1) ~= 1
        error(['No agent was specified and the particular '...
               'data file given has mutliple agents']);
    end
    
    % the agentrows will be all of the rows
    agentrows = logical(ones(size(idcol, 1),1));
else
    % otherwise find the rows in the id-column
    % that matches the agent given
    agentrows = ismember(idcol, agent);
end
    
agentdata     = data.data(agentrows, :);
if ~agentdata
    error(['The agent ' agent ' has no data points '...
            'in file: ' fpath]);
end

% we'll index into the numerical data correctly by
% skipping over the text rows. For now, the only 
% text row I know of is the id
textrows    = { 'id' };
textindexes = cellfun( getindex, textrows, 'UniformOutput', 0);
textindexes = any(cell2mat(textindexes'));

% 'or' together the indexes so we have a matrix that looks
% like 0 0 1 1 0 1 0 where the 1's represent the desired columns
% (the cell2mat is required because getIndex returns a logical
% and cellfun normally requires the return of a scalar, which is dumb)
targetindexes = cellfun( getindex, varargin, 'UniformOutput', 0);
targetindexes = any(cell2mat(targetindexes'));
if numel(find(targetindexes)) < numel(varargin)
    error('Not all variables are present in the data file. Exiting...');
end

% now get rid of all the text indexes so that
% we can use the target indexes directly
% to access the data
targetindexes(logical(textindexes)) = [];

% now collect all the data
ts = agentdata(:, targetindexes);

