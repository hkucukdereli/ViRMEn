function vr = loadConfig(vr)
    % get the experiment type
    vr.session.experiment = vr.exper.userdata.experimentType;
    % load the variables from the config file
    run(vr.session.config);
    vr.session.expername = vr.exper.name;
    vr.session.rig = vrconfig.rig;
    vr.session.basedir = vrconfig.basedir;
    vr.session.save = vrconfig.save;
    
    % serial related
    vr.session.serial = vrconfig.serial;
    vr.session.com = vrconfig.com;
    vr.session.input = vrconfig.input;
    if vr.session.input
        vr.session.input_com = vrconfig.input_com;
    end
    
    % nidaq related
    vr.daq.state = vrconfig.daq;
    if vr.daq.state
        vr.daq.daqtype = vrconfig.daqtype;
        vr.daq.device = vrconfig.device;
        vr.daq.channels = vrconfig.channels;
        vr.daq.channelnames = vrconfig.channelnames;
    end
    
    % trial  variables
    vr.session.numTrials = vrconfig.numTrials;
    vr.session.trialDuration = vrconfig.trialDuration * 60; % sec
    if strcmp(vr.session.experiment, 'stress')
        vr.session.stressDuration = vrconfig.stressDuration * 60; % sec
    else
        vr.session.stressDuration = 0;
    end
    vr.session.blackoutDuration = vrconfig.blackoutDuration * 60; % sec
    vr.session.habituationDuration = vrconfig.habituationDuration * 60; % sec
    vr.session.timeoutDuration = vrconfig.timeoutDuration; % sec
    vr.session.conditioningDuration = vrconfig.conditioningDuration * 60; % sec
    vr.session.paddingDuration = vrconfig.paddingDuration * 60; % sec
    
    % cue info
    if strcmp(vr.session.experiment, 'trial') || strcmp(vr.session.experiment, 'stress') || strcmp(vr.session.experiment, 'shock')
        vr.session.cuelengths = vr.exper.userdata.postrack;
        vr.session.transitions = vr.exper.userdata.postrans;
        vr.session.cuetypes = vr.exper.userdata.cuestrack;
        vr.session.cueids = vr.exper.userdata.cueids;
        vr.currentCue = vr.exper.userdata.cues(1,1);
        vr.previousCue = vr.exper.userdata.cues(1,2);
    end
    
    if strcmp(vr.session.experiment, 'shock')
        if isfield(vr.exper.userdata, 'minepos')
            vr.session.shockpos = vr.exper.userdata.minepos;
        else
            warning("Shock positions are not given.");
        end
    end
    
    
    