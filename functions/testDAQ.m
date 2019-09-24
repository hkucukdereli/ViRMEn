function [s, ch] = testDAQ(device)
    % reset daq
    daqreset

    % start a daq session
    s = daq.createSession('ni');
    % add a digital channel
    ch = s.addCounterInputChannel(device, 'ctr0', 'EdgeCount');
    ch.ActiveEdge = 'Rising';
    s.resetCounters;

    vr.daq.data = [];