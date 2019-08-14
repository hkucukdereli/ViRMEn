function vr = selectCue(vr)
    % only do something if the cue has changed
    if ~strcmp(vr.previousCue, vr.currentCue)
        % fprintf('\n');display(vr.position(2));
        if any(strcmp(fieldnames(vr.session.cueList), 'stim'))
            if vr.currentCue == vr.session.cueList.('stim')
                vr.state.onStim = true;
                vr.state.onTimeout = true;
                vr.state.onITI = false;
                vr = stimOn(vr);
                vr.stimTime = vr.timeElapsed;
            end
        elseif any(strcmp(fieldnames(vr.session.cueList), 'nostim'))
            if vr.currentCue == vr.session.cueList.('nostim')
                vr.state.onStim = false;
                vr.state.onITI = false;
                vr = stimOff(vr);
            end
        elseif any(strcmp(fieldnames(vr.session.cueList), 'reward'))
            if vr.currentCue == vr.session.cueList.('reward')
                vr.state.onStim = true;
                vr.state.onTimeout = true;
                vr.state.onITI = false;
                vr = stimOn(vr);
                vr.state.onReward = true; % send out a reward next cycle
                % vr.rewardDelay = hist(normrnd(vr.rewardDelay, vr.rewardDelay*.2)); % set the reward delay
                vr.stimTime = vr.timeElapsed;
            else
                vr.state.onReward = false; % send out a reward next cycle
            end
        end
        if any(strcmp(fieldnames(vr.session.cueList), 'neutral'))
            if vr.currentCue == vr.session.cueList.('neutral')
                vr.state.onStim = false;
                vr.state.onITI = false;
                vr = stimOff(vr);
            end
        end
        if any(strcmp(fieldnames(vr.session.cueList), 'gray'))
            if vr.currentCue == vr.session.cueList.('gray')
                vr.state.onStim = false;
                vr.state.onITI = true;
                vr = ITIon(vr);
            end
        end

        % update the previous cue because the cue has changed
        vr.previousCue = vr.currentCue;
    end