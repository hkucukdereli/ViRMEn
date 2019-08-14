function vr = initializeShocks(vr)
    % determine the shock times
    vr.sessionData.stressShocks = struct([]);
    for s=1:length(vr.session.numTrials)
        vr.shocktimes = cumsum(rand([1,20])/3.2);
        vr.shocktimes = vr.shocktimes(vr.shocktimes < 3);
        vr.sessionData.stressShocks = vr.shocktimes;
        vr.shocktimes_ = [];
        for i=1:(vr.session.stressDuration/30)-1
            vr.shocktimes = cumsum(rand([1,20])/3.2);
            vr.shocktimes = vr.shocktimes(vr.shocktimes < 3);
            vr.shocktimes = vr.shocktimes + normrnd(3,1)*10*i;
            vr.shocktimes_ = [vr.shocktimes_, vr.shocktimes];
        end
        vr.sessionData.stressShocks = vr.shocktimes_;
    end
    