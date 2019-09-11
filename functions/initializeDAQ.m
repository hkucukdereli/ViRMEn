function vr = initializeDAQ(vr, channels)
    vr.daq = [];

    vr.daq.devices = daqhwinfo; %get the available devices 
    
    % check if there's a nidaq board connected
    for d=1:length(vr.daq.devices.InstalledAdaptors)
        if strcmp(vr.daq.devices.InstalledAdaptors(1), 'nidaq')
            vr.state.onDAQ = true;
        end 
    end
    
    % if there is a nidaq board connected initialize th[nframes, bwmask, pupilmask,IRreflectionMask,centroidclicked,frame] = AndrewQaDPupilPreprocess(pathmov)e channels
    if vr.state.onDAQ
        vr.daq.di = digitalio('nidaq', 'Dev1');
        addline(vr.daq.di, channels, 0, 'in');

        vr.sessionData.input = struct();
        %diLines = cell2mat(vr.daq.di.Line.HwLine);
        for ch = cell2mat(vr.daq.di.Line.HwLine)'
            vr.sessionData.input(ch) = [];
        end
        % read the channels once
        vr.di_data = getvalue(vr.daq.di);
    end
    

    
    
