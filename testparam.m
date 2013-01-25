function scores = testparam(param, values)
% Author: Neil Fulwiler
% Date  : 1.18.2013
% Usage : tester for either kg, c1, c2, holding
%         the other parameters constant in order to 
%         delineate a reasonable bound for the parameter

% these are related to the system and
% not to my individual usage of it
outputlabel = 'experiment_output.csv';

% these are related to my customized paths,etc.
% in order of decreasing variability
project           = 'stationaryObstacles';

basedir           = '/Users/neilfulwiler/dev/VENLab/neil/';
projectdir        = [basedir '/' project '/'];
targetdir         = [projectdir '/target'];
locoMASdir        = [basedir '/locomotionMAS/'];
datadir           = [projectdir '/data'];

configfile        = [projectdir '/config.xml'];
targetfile        = [targetdir '/' outputlabel];
datafile          = [datadir '/' outputlabel];

% the command the runs locomotionMAS (without the redefinition
% of the parameters, those should be added by the objective function)
cmd = locomotionMAScmd(locoMASdir, configfile, datadir);

fields = {'x' 'y'};
targetdata = parseAgentData(targetfile, [], fields{:});

times = 2; 
objf = @(p) mean(arrayfun(@(X) objfun(cmd, datafile, targetdata, param, p), 1:times));

scores = arrayfun(objf, values);
plot(values, scores);
xlabel(param);
ylabel('score');

end


