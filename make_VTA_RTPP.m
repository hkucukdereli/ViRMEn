exper = createTrials('VTA_RTPP_NoStim_day1', 'Conditioning_templates', 'cueL',800,'arenaL', 8000, 'save', true,...
                     'overlap',2, 'nWorlds', 60, 'movement', @moveWithQuadEncoder, 'experiment', @Trial_code,...
                     'cueList', {['CueStripe45'], ['CueStripe135']}, 'atrandom', true, 'shock', false);
                 
exper = createTrials('VTA_RTPP_NoStim_day2', 'Conditioning_templates', 'cueL',400,'arenaL', 8000, 'save', true,...
                     'overlap',2, 'nWorlds', 60, 'movement', @moveWithQuadEncoder, 'experiment', @Trial_code,...
                     'cueList', {['CueStripe45'], ['CueStripe135']}, 'atrandom', true, 'shock', false);
                 
exper = createTrials('VTA_RTPP_NoStim_day3', 'Conditioning_templates', 'cueL',400,'arenaL', 8000, 'save', true,...
                     'overlap',2, 'nWorlds', 60, 'movement', @moveWithQuadEncoder, 'experiment', @Trial_code,...
                     'cueList', {['CueStripe45'], ['CueStripe135']}, 'atrandom', true, 'shock', false);
                 
exper = createTrials('VTA_RTPP_day1', 'Conditioning_templates', 'cueL',400,'arenaL', 8000, 'save', true,...
                     'overlap',2, 'nWorlds', 60, 'movement', @moveWithQuadEncoder, 'experiment', @Trial_code,...
                     'cueList', {['CueStripe45'], ['CueStripe135']}, 'atrandom', true, 'shock', false);
                  
exper = createTrials('VTA_RTPP_day2', 'Conditioning_templates', 'cueL',400,'arenaL', 8000, 'save', true,...
                     'overlap',2, 'nWorlds', 60, 'movement', @moveWithQuadEncoder, 'experiment', @Trial_code,...
                     'cueList', {['CueStripe45'], ['CueStripe135']}, 'atrandom', true, 'shock', false);
                 
exper = createTrials('VTA_RTPP_day3', 'Conditioning_templates', 'cueL',400,'arenaL', 8000, 'save', true,...
                     'overlap',2, 'nWorlds', 60, 'movement', @moveWithQuadEncoder, 'experiment', @Trial_code,...
                     'cueList', {['CueStripe45'], ['CueStripe135']}, 'atrandom', true, 'shock', false);
                  
exper = createTrials('VTA_RTPP_day4', 'Conditioning_templates', 'cueL',400,'arenaL', 8000, 'save', true,...
                     'overlap',2, 'nWorlds', 60, 'movement', @moveWithQuadEncoder, 'experiment', @Trial_code,...
                     'cueList', {['CueStripe45'], ['CueStripe135']}, 'atrandom', true, 'shock', false);

                 
%%
for i=1:length(sessionData.cueid)
    sessionData.cueid(i)
end



