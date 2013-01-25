function cmd = locomotionMAScmd(locomotionMASdir, config, outputdir, varargin)
% Author: Neil Fulwiler
% Date  : 1.18.2013
% Usage : This deals with the annoying task of exporting
%         environment variable that matlab annoyingly messes 
%         interfering with any system call that relies on them. 
%
% Parameters:
%    locomotionMASdir   the locomotionMAS base directory
%
%    config             the xml file that configures the simulation
%
%    outputdir          the output directory
%   
%    varargin           parameter-value pairs that can be used to
%                       redefine model parameters in the system

dyld       = 'export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:/usr/local/AReVi/lib:./lib:/Users/neilfulwiler/dev/VENLab/boost_1_49_0/stage/lib"';
simul      = 'export SIMULATOR_DIR="/Users/neilfulwiler/dev/VENlab/locomotionMAS"';
simullib   = 'export SIMULATOR_LIB_DIR="/Users/neilfulwiler/dev/VENlab/locomotionMAS/lib"';
setup      = [dyld ';' simul ';' simullib];

prefix     = ['cd ' locomotionMASdir '; ' setup];   
executable = [locomotionMASdir '/start/experiment'];
redefine   = redefineParameter(varargin{:});
cmd        = [prefix ';' executable ' ' config ' ' outputdir ' ' redefine];