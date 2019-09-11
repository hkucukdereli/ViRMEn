function vr = initializePlot(vr)
    if size(vr.windows, 1) > 1
        vr.state.onPlot = true;
        % X-position of the symbol on the screen (0 is center)
        symbolXPosition = 0;
        % Symbol size as fraction of the screen
        vr.symbolSize = 0.02;
        % Track minimum and maximum positions
        vr.trackMinY = -10;

        total_length = 0;
        for n=1:length(vr.exper.worlds)
            total_length = total_length + vr.exper.worlds{1, 1}.objects{1, 1}.height;
        end
        vr.trackMaxY = total_length;
        % Create a square symbol and assign color to it
        vr.plot(1).x = [-1 0 1 -1]*vr.symbolSize + symbolXPosition;
        vr.plot(1).y = [-1 1 -1 -1]*vr.symbolSize;
        vr.plot(1).color = [1 0 0];
        vr.plot(1).window = 2; % display plot in the first window
    end