function serialFix()
    fclose('all');
    fclose(instrfind);
    delete(instrfind);