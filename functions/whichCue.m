function vr = whichCue(vr)
    for p=1:length(vr.positions)-1
        if vr.position(2) > vr.positions(p) & vr.position(2) < vr.positions(p+1)
            vr.currentCue = vr.cuelist(p); 
            vr.cueid = vr.cueids(p);
            %fprintf('\b');fprintf('%d', vr.cueid);
        end
    end