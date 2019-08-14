global vrconfig

vrconfig.rig = 'vr_rig';
vrconfig.basedir = 'C:/Users/hkucukde/Dropbox/Hakan/AndermannLab/code/MATLAB/ViRMEn';

% Serial communication
vrconfig.serial = true;
vrconfig.com = 5;
vrconfig.lick = false;
vrconfig.input_com = 5;

% Habituation
vrconfig.habituationDuration = .2; % min

% Conditioning
vrconfig.conditioningDuration = .2; % min
vrconfig.blackoutDuration = .2; % min

% Trial
vrconfig.numTrials = 2;
vrconfig.trialDuration = .2; % min
vrconfig.timeoutDuration = 0; % sec
vrconfig.paddingDuration = .05   ; % min

% Stress
vrconfig.stressDuration = .05; % min
