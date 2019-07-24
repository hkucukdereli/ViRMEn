global vrconfig

vrconfig.rig = 'vr_rig';
vrconfig.basedir = 'C:/Users/andermann/Documents/MATLAB/ViRMEn';

% Serial communication
vrconfig.serial = true;
vrconfig.com = 5;
vrconfig.lick = false;
vrconfig.input_com = 6;

% Habituation
vrconfig.habituationDuration = 60; % min

% Conditioning
vrconfig.numConditioning = 2;
vrconfig.conditioningDuration = 60; % min
vrconfig.blackoutDuration = 15; % min

% Trial
vrconfig.numTrial = 1;
vrconfig.trialDuration = 60; % min
vrconfig.timeoutDuration = 0; % sec
vrconfig.paddingDuration = 5; % min

% Stress
vrconfig.numStress = 2;
vrconfig.stressDuration = 5; % min  

