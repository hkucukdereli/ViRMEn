global vrconfig

vrconfig.rig = 'vr_rig';
vrconfig.basedir = 'C:/Users/hkucukde/Dropbox/Hakan/AndermannLab/code/MATLAB/ViRMEn';

% Serial communication
vrconfig.serial = true;
vrconfig.com = 13;
vrconfig.lick = true;
vrconfig.input_com = 5;

% Habituation
vrconfig.habituationDuration = .2; % min

% Conditioning
vrconfig.conditioningDuration = .2; % min
vrconfig.blackoutDuration = .2; % min

% Trial
vrconfig.numTrial = 1;
vrconfig.trialDuration = 5; % min
vrconfig.timeoutDuration = 0; % sec
vrconfig.paddingDuration = .1   ; % min

% Stress
vrconfig.numStress = 2;
vrconfig.stressDuration = .1; % min
