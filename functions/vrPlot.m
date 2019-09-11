function vr = vrPlot(vr)
    if vr.state.onPlot
        % Normalize animal’s y-position to range from -1 to 1 (the monitor range)
        symbolYPosition = 2*(vr.position(2)-vr.trackMinY)/(vr.trackMaxY-vr.trackMinY) - 1;
        % Update the y-position of the symbol
        vr.plot(1).y = [-1 1 -1 -1]*vr.symbolSize + symbolYPosition;
    end