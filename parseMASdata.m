function agents = parseMASdata(fpath)
% Author: Neil Fulwiler
% Date  : 1.18.2013
% Usage :
%   parseAgentData parses the output csv file (fpath) 
%   for a run of an experiment using locomotionMAS and 
%   returns a struct of structs that correspond
%   to the individual agents, the fields of which
%   are the data variables
% 
%   Parameters:
%       fpath           path to the output file
%
%   Returns:
%       a struct of structs where each struct
%       contains all data for an individual agent
%
%   eg:
%    agents = parseAgentData('data/experiment_output.csv');
%    dist = sqrt(sum( [agents.a1.x agents.a1.y] - [agents.a2.x
%    agents.a2.y]));
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
getindex = @(varname) ismember(formatstring, varname); 

% get the id-column which will match data to 
% each particular agent in the data set
idcol = data.textdata([2:end], getindex('id'));

% make a struct where each field is named by the
% agent and the value is a struct with the fields
% being variable names from the data
agentnames          = unique(idcol);
agents              = cell2struct(cell(size(agentnames)), agentnames, 1);
% variablestruct    = cell2struct(cell(size(formatstring)), formatstring, 2);
% variabledata      = cell(1,numel(agents));
% [variabledata{:}] = deal(variablestruct);
% agentdata         = cell2struct(variabledata, agents, 2);

for agent=agentnames'
    
    % select the data rows for this agent
    agentdata      = data.data(ismember(idcol, agent), :);
    
    % split the data into columns 
    agentdata      = mat2cell(...
                        agentdata,...
                        [size(agentdata, 1)],...
                        repmat([1],1, size(agentdata,2))...
                     ); 
    
    % use each column as the value of a field
    % in a struct representing all data for this agent
    agents.(char(agent)) = cell2struct(...
        agentdata,...
        formatstring(not(getindex('id'))),...
        2 ...
    );
    
end


% done
end

