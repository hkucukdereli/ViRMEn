global vrconfig

vrconfig.rig = 'vr_rig';
vrconfig.basedir = 'C:/Users/hkucukde/Dropbox/Hakan/AndermannLab/code/MATLAB/ViRMEn/data';
vrconfig.save = false;

% Serial communication
vrconfig.serial = false;
vrconfig.com = 5;
vrconfig.input = false;
vrconfig.input_com = 5;

% Habituation
vrconfig.habituationDuration = .2; % min

% Conditioning
vrconfig.conditioningDuration = .2; % min
vrconfig.blackoutDuration = .2; % min

% Trial
vrconfig.numTrials = 1;
vrconfig.trialDuration = 5; % min
vrconfig.timeoutDuration = 5; % sec
vrconfig.paddingDuration = [.01, .1]   ; % min

% Stress
vrconfig.stressDuration = .1; % min
