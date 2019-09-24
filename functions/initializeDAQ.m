function vr = initializeDAQ(vr)
	if vr.daq.state
        % reset daq
        daqreset
        
        % set the daq state
        vr.state.onDAQ = true;

        % start a daq session
        vr.daq.session = daq.createSession('ni');
        % add a digital channel
        vr.daq.in = vr.daq.session.addCounterInputChannel(vr.daq.device, 'ctr0', 'EdgeCount');
        vr.daq.in.ActiveEdge = 'Rising';
        vr.daq.session.resetCounters;
%         for c=1:length(vr.daq.channels)
%             ch = vr.daq.channels(c);
%             vr.daq.in = vr.daq.session.addDigitalChannel(vr.daq.device, ch,'InputOnly');
%         end
        
        vr.daq.data = [];
        vr.daq.time = [];
    else
        vr.daq.in = [];
        vr.daq.data = [];
        vr.daq.time = [];
        fprintf('No daq device is used.');
    end
end