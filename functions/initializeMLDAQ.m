function vr = initializeMLDAQ(vr)
    if vr.daq.state
        vr.daq.devices = daqhwinfo; %get the available devices 

        % check if there's a nidaq board connected
        for d=1:length(vr.daq.devices.InstalledAdaptors)
            if strcmp(vr.daq.devices.InstalledAdaptors(1), 'nidaq')
                vr.state.onDAQ = true;
            end 
        end

        % if there is a nidaq board connected initialize 
        if vr.state.onDAQ
            vr.daq.in = analoginput('nidaq', vr.daq.device);
            addchannel(vr.daq.in, vr.daq.channels);
            
            vr.daq.data = [];
        end
    else
        vr.daq.in = [];
        vr.daq.data = [];
        fprintf('No daq device is used.');
    end
