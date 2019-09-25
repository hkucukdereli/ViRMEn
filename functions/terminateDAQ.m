function vr = terminateDAQ(vr)
    if vr.state.onDAQ
        vr.daq.session.stop;
        delete(vr.daq.lh);
        fclose(vr.daq.fid);
        vr.state.onDAQ = false;
    end
