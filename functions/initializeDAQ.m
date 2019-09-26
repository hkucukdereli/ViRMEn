function vr = initializeDAQ(vr)
	if vr.daq.state
        % reset daq
        daqreset
        
        % set the daq state
        vr.state.onDAQ = true;
        
        % initialize daq data with no data
        vr.daq.data = [];

        % start a daq session
        vr.daq.session = daq.createSession('ni');
        % add a channel
        if strcmp(vr.daq.daqtype, 'counter')
            vr.daq.in = vr.daq.session.addCounterInputChannel(vr.daq.device, 'ctr0', 'EdgeCount');
            vr.daq.in.ActiveEdge = 'Rising';
            vr.daq.session.resetCounters;
        elseif strcmp(vr.daq.daqtype, 'analog')
            vr.daq.in  = vr.daq.session.addAnalogInputChannel(vr.daq.device, vr.daq.channels, 'Voltage');
            vr.daq.in.TerminalConfig = 'SingleEnded';
            
            s=[];for k=1:5,s=[s, num2str(randi(10))];end
            vr.daq.temp_path = sprintf('%s/temp_daq_data_%s.bin', vr.session.basedir, s);
            vr.daq.fid = fopen(vr.daq.temp_path,'w');
            vr.daq.lh = vr.daq.session.addlistener('DataAvailable', @(src, event)logDAQData(src, event, vr.daq.fid));

            vr.daq.session.IsContinuous = true;
            vr.daq.session.startBackground;
        end        
    else
        vr.daq.in = [];
        vr.daq.data = [];
        fprintf('No daq device is used.');
    end
end

function logDAQData(src, evt, fid)
    data = [evt.TimeStamps, evt.Data]';
    fwrite(fid, data, 'double');
end