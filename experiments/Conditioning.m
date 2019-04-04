function code = Conditioning
% Conditioning   Code for the ViRMEn experiment tennisCourt.
% code = Conditioning   Returns handles to the functions that ViRMEn
% executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT

% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)
    vr.training = 1;
%     serialFix();
    
    vr.session = struct('mouse', 'HK00',...
                        'date', '190401',...
                        'run', 1,...
                        'rig', 'VR_training',...
                        'startTime', now(),...
                        'trialDuration', 5,...
                        'blackOut', false,...
                        'inTrial', true,...
                        'blackOutDuration', 2);
                    
    vr.sessionData = struct('position',[],...
                            'velocity', [],...
                            'stimOn', [],...
                            'trialDuration', [],...
                            'trialNumber', [1]);
                        
    vr.trialInfo(1:1000) = struct('trialNum', 0,...
                                  'trialType', 0,...
                                  'stimOn', 0);
    
    vr.trialDuration = [vr.session.trialDuration];
    vr.trialNumber = 1;
    vr.lastPos = 0;
    tic;
    vr.trialStart = vr.timeElapsed;
    
% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
    
    if ~vr.session.blackOut && vr.session.inTrial && vr.timeElapsed - vr.trialStart > vr.trialDuration
        vr.currentWorld
        vr.timeElapsed
        % change the world to the next one and teleport to the start
        vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;
        % change states
        vr.session.blackOut = true;
        vr.session.inTrial = false;
        % timestamp
        vr.trialEnd = vr.timeElapsed;
        
        % set the next trial duration
        vr.trialDuration = [vr.trialDuration, normrnd(vr.session.trialDuration, 1, 1)];
    end
    
    if vr.session.blackOut && ~vr.session.inTrial && vr.timeElapsed - vr.trialEnd > vr.session.blackOutDuration
        vr.currentWorld
        vr.timeElapsed - vr.trialEnd
        vr.worlds{vr.currentWorld}.surface.visible(1,:) = 1;
        vr.session.blackOut = false;
        vr.trialStart = vr.timeElapsed;
        
        % change the world to the next one and teleport to the start
        vr.currentWorld = mod(vr.currentWorld, length(vr.exper.worlds)) + 1;
        initPos = vr.worlds{vr.currentWorld}.startLocation;
        vr.position(2) = initPos(2); % set the animal’s y position to 0
        vr.dp(:) = 0; % prevent any additional movement during teleportation
        
        vr.trialNumber = vr.trialNumber + 1;
        vr.sessionData.trialNumber = [vr.sessionData.trialNumber, vr.trialNumber];
        vr.lastPos = 0;
    end
    
%     if vr.session.blackOut == 0 && vr.timeElapsed - vr.trialStart > vr.trialDuration
%         % change the world to the next one and teleport to the start
%         vr.currentWorld = mod(vr.currentWorld, length(vr.exper.worlds)) + 1;
%         initPos = vr.worlds{vr.currentWorld}.startLocation;
%         vr.position(2) = initPos(2); % set the animal’s y position to 0
%         vr.dp(:) = 0; % prevent any additional movement during teleportation
%         vr.trialDuration = [vr.trialDuration, normrnd(vr.session.trialDuration, 1, 1)];
%         
%         vr.trialNumber = vr.trialNumber + 1;
%         vr.sessionData.trialNumber = [vr.sessionData.trialNumber, vr.trialNumber];
%         vr.lastPos = 0;
%         
%         vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;
%         vr.session.blackOut = 1;
%         vr.trialEnd = vr.timeElapsed;
%     end

    vr = teleportCheck(vr);
    
    vr.sessionData.position = [vr.sessionData.position, vr.position(2) + vr.lastPos];
    vr.sessionData.velocity = [vr.sessionData.velocity, vr.velocity(2)];


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
    vr.sessionData.trialDuration = vr.trialDuration;
    assignin('base', 'sessionData', vr.sessionData);
    assignin('base', 'vr', vr);

