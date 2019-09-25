function vr = testDAQ(vr)
    % reset daq
    daqreset

    % start a daq session
    vr.s = daq.createSession('ni');
    % add a digital channel
    % vr.ch = vr.s.addCounterInputChannel(vr.device, 'ctr0', 'EdgeCount');
    % vr.ch.ActiveEdge = 'Rising';
    % vr.s.resetCounters;
    
    % vr.ch = vr.s.addDigitalChannel(vr.device, 'Port0/Line0', 'InputOnly');
    
    vr.ch = vr.s.addAnalogInputChannel(vr.device, 'ai0', 'Voltage');
    vr.ch.TerminalConfig = 'SingleEnded';
    
    vr.fid = fopen('C:\Users\hkucukde\Dropbox\Hakan\AndermannLab\code\MATLAB\ViRMEn\data\data.bin','w');
    vr.lh = vr.s.addlistener('DataAvailable', @(src, event)logData(src, event, vr.fid));
    
    vr.s.IsContinuous = true;
    vr.s.startBackground;

end

function logData(src, evt, fid)
    data = [evt.TimeStamps, evt.Data]';
    fwrite(fid, data, 'double');
end