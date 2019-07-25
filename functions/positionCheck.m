function vr = positionCheck(vr)
    % see if the position is at the start of the overlap
    if vr.position(2) > vr.positions(end-vr.exper.userdata.overlaps)
        % stop all movement until we can figure out what to do
        vr.dp(:) = 0;
        % get the latest position to keep the position info continuous
        vr.lastPos = vr.lastPos + vr.position(2);
        % advance the world unless it's in the last one. 
        % otherwise, teminate the experiment gracefully
        if vr.currentWorld + 1 > vr.exper.userdata.nWorlds
            % make the worlds invisible
            vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;
            % turn the stim off and log
            vr = stimOff(vr);

            % move to the padding block
            vr.state.onTrial = false;
            vr = stimOff(vr);
            vr.endTime = vr.timeElapsed;
            vr.sessionData.endTime = vr.timeElapsed;
            vr = startPadding(vr);
        else
            % advance the world and initialize the position
            vr.currentWorld = round(vr.currentWorld) + 1;
            vr.position(2) = 0;
        end
    end