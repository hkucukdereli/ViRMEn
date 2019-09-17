function vr = checkTimeout(vr)
        if strcmp(vr.currentCue, vr.session.cueList.('stim'))
            if ~isempty(vr.sessionData.stimon)
                if vr.timeElapsed - vr.sessionData.stimon(end-1) >= vr.session.timeoutDuration
                    [r, c] = find(vr.exper.userdata.cueids(vr.currentWorld,:) == vr.cueid+1);
                    vr.position(2) = vr.exper.userdata.positions(vr.currentWorld, c)+1;
                    vr.dp(:) = 0; % prevent any additional movement during teleportation
                end
            end
        elseif strcmp(vr.currentCue, vr.session.cueList.('neutral'))
            if ~isempty(vr.sessionData.stimoff)
                if vr.timeElapsed - vr.sessionData.stimoff(end-1) >= vr.session.timeoutDuration
                    [r, c] = find(vr.exper.userdata.cueids(vr.currentWorld,:) == vr.cueid+1);
                    vr.position(2) = vr.exper.userdata.positions(vr.currentWorld, c)+1;
                    vr.dp(:) = 0; % prevent any additional movement during teleportation
                end
            end
        end