global vrconfig

vrconfig.rig = 'vr_rig';
vrconfig.basedir = 'C:/Users/hkucukde/Dropbox/Hakan/AndermannLab/code/MATLAB/ViRMEn/data';
vrconfig.save = true;

% Serial communication
vrconfig.serial = false;
vrconfig.com = 5;
vrconfig.input = false;
vrconfig.input_com = 5;

% NIdaq communication
vrconfig.daq = true;
vrconfig.daqtype = 'analog';
vrconfig.device = 'Dev1';
vrconfig.channelnames = {'cam', 'stim'};
vrconfig.channels = [0, 1];

% Habituation
vrconfig.habituationDuration = .2; % min

% Conditioning
vrconfig.conditioningDuration = .2; % min
vrconfig.blackoutDuration = .2; % min

% Trial
vrconfig.numTrials = 1;
vrconfig.trialDuration = 1; % min
vrconfig.timeoutDuration = 5; % sec
vrconfig.paddingDuration = [0, 0]   ; % min

% Stress
vrconfig.stressDuration = 15; % min
