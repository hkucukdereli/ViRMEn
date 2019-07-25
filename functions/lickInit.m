function vr = lickInit(vr)

    daqreset;
    
%     vr.ai = analoginput('nidaq','dev1');
%     addchannel(vr.ai, 0);
%     set(vr.ai,'samplerate',1000,'samplespertrigger',inf)
%     
%     set(vr.ai,'bufferingconfig',[8 100]);
%     
%     set(vr.ai,'loggingmode','Disk');
%     vr.tempfile = [tempname '.log'];
%     set(vr.ai,'logfilename',vr.tempfile);
%     
%     start(vr.ai);

    vr.ai = daq.createSession('ni');
    ch = vr.ai.addAnalogInputChannel('Dev1', 0, 'Voltage');
    ch.TerminalConfig = 'SingleEnded';
        
    vr.ai.Rate = (1e3);
    vr.ai.IsContinuous = true;
    %vr.ai.NotifyWhenDataAvailableExceeds = 100;  % every 10 ms average lick data
    
    fid1 = fopen('log.bin','w');
    lh1 = vr.ai.addlistener('DataAvailable',@(src, event)logData(src, event, fid1));

    vr.ai.NotifyWhenDataAvailableExceeds = 20;
    vr.ai.startBackground();

    pause(1e-2);
    
    fclose(fid1);
    fid2 = fopen('log.bin','r');
    [data, count] = fread(fid2, [8,inf], 'double');
    fclose(fid2);
    
end

function logData(src, evt, fid)
    data = [evt.TimeStamps, evt.Data]' ;
    fwrite(fid,data,'double');
end
