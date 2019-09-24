global vrconfig

vrconfig.rig = 'vr_rig';
vrconfig.basedir = '\\sweetness\User Folders\Hakan\BehaviorData\VR AgRP';
vrconfig.save = true;

% Serial communication
vrconfig.serial = true;
vrconfig.com = 5;
vrconfig.input = false;
vrconfig.input_com = 6;

% NIdaq communication
vrconfig.daq = true;
vrconfig.device = 'Dev1';
vrconfig.channelnames = {'cam'};
vrconfig.channels = [0];

% Habituation
vrconfig.habituationDuration = 60; % min

% Conditioning
vrconfig.numConditioning = 2;
vrconfig.conditioningDuration = 60; % min
vrconfig.blackoutDuration = 15; % min

% Trial
vrconfig.numTrials = 1;
vrconfig.trialDuration = 60; % min
vrconfig.timeoutDuration = 5*60; % sec
vrconfig.paddingDuration = [0, 15]   ; % min

% Stress
vrconfig.stressDuration = 0; % min  

