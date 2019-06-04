global vrconfig

vrconfig.rig = 'vr_rig';
vrconfig.basedir = 'C:/Users/hkucukde/Dropbox/Hakan/AndermannLab/code/MATLAB/ViRMEn';

% Serial communication
vrconfig.serial = true;
vrconfig.com = 13;

% Habituation
vrconfig.habituationDuration = .2; % min

% Conditioning
vrconfig.conditioningDuration = .2; % min
vrconfig.blackoutDuration = .2; % min

% Trial
vrconfig.trialDuration = 5; % min
vrconfig.timeoutDuration = .2; % sec
vrconfig.paddingDuration = .2   ; % min

% Stress
vrconfig.stressDuration = .2; % min
