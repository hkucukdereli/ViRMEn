function vr = initializeSave(vr)
    if vr.session.save
        vr.savedir = sprintf('%s/%s/%s_%s',...
                                vr.session.basedir, vr.session.mouse, vr.session.date, vr.session.mouse);
        vr.savepath = sprintf('%s/%s/%s_%s/%s_%s_%i_%s.mat',...
                                vr.session.basedir, vr.session.mouse, vr.session.date, vr.session.mouse,...
                                vr.session.mouse, vr.session.date, vr.session.run, vr.session.experiment);
        if exist(vr.savepath)
            error(sprintf('%s exists. Please, update the experiment info.', vr.savepath));
        else
            if ~isfolder(vr.savedir) 
                mkdir(vr.savedir);
            end
        end
    else
        fprintf('Data will not be saved.\n');
    end