function vr = initializeDAQ(vr)
	if vr.daq.state
        % set the daq state
        vr.state.onDAQ = true;

        % start a daq session
        vr.daq.session = daq.createSession('ni');
        % add a digital chaannel
        for c=1:length(vr.daq.channels)
            ch = vr.daq.channels(c);
            vr.daq.di = vr.daq.session.addCounterInputChannel(vr.daq.device, 'ctr0', 'EdgeCount');
            vr.daq.di.ActiveEdge = 'Rising';
            vr.daq.session.resetCounters;
            %vr.daq.di = vr.daq.session.addDigitalChannel(vr.daq.device, ch,'InputOnly');
        end
        
        vr.daq.data = [];
        vr.daq.time = [];
    else
        vr.daq.di = [];
        vr.daq.data = [];
        vr.daq.time = [];
        fprintf('No daq device is used.');
    end
end

function getData(src,event)
         event.Data;
end
%     if vr.daq.state
%         vr.daq.devices = daqhwinfo; %get the available devices 
% 
%         % check if there's a nidaq board connected
%         for d=1:length(vr.daq.devices.InstalledAdaptors)
%             if strcmp(vr.daq.devices.InstalledAdaptors(1), 'nidaq')
%                 vr.state.onDAQ = true;
%             end 
%         end
% 
%         % if there is a nidaq board connected initialize 
%         if vr.state.onDAQ
%             display('b')
%             vr.daq.di = digitalio('nidaq', vr.daq.device);
%             addline(vr.daq.di, vr.daq.channels, 'in');
%             
%             vr.daq.data = [];
%         end
%     else
%         vr.daq.di = [];
%         vr.daq.data = [];
%         fprintf('No daq device is used.');
%     end
    %         %diLines = cell2mat(vr.daq.di.Line.HwLine);
    %         for ch = cell2mat(vr.daq.di.Line.HwLine)'
    %             vr.sessionData.input(ch) = [];
    %         end
    %         % read the channels once
    %         vr.di_data = getvalue(vr.daq.di);
