function info = makeVirmenInfo(filename, mouse, date, run, experimenter, tags)
    info = struct()
    info.mouse = mouse
    info.date = date
    info.run = run
    info.experimenter = experimenter
    info.tags = tags
    
    save(filename, 'info');
