function serialFix()
    fclose('all');
    if length(instrfind)
        fclose(instrfind);
        delete(instrfind);
        fprintf('Serial ports are now available.\n');
    end