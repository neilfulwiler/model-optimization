function [scores, elapsedtimes]=main(kgvalues, c2values)
% Author: Neil Fulwiler
% Date  : 1.18.2013
% Usage : ?  

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

% compute the scores
scores=zeros(numel(kgvalues),numel(c2values));
%vars=zeros(numel(kgvalues),numel(c2values));
%scores=arrayfun(@(x) objfun(cmd, datafile, targetfile, 'kg', kg), 1:times);


fields = {'x' 'y'};
targetdata = parseAgentData(targetfile, [], fields{:});

elapsedtimes=zeros(numel(kgvalues, numel(c2values)));
for ii=1:numel(kgvalues)
    kg=kgvalues(ii);
    for jj=1:numel(c2values)
        c2=c2values(jj);
        
        tic;
        scores(ii,jj) = objfun(cmd, datafile, targetdata, 'kg', kg, 'c2', c2);
        elapsedtimes(ii,jj) = toc;
    end
end

% scoresfigure = figure;
% surf(c2values, kgvalues, scores);
% xlabel('c2'), ylabel('c1');
% 
% varsfigure = figure;
% surf(c2values, kgvalues, vars);
% xlabel('c2'), ylabel('c1');

end


