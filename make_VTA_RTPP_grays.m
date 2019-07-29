exper = createTrials('AgRP_reward_day4', 'Conditioning_templates_2',... 
                    'cueL',400, 'grayL', 600, 'arenaL', 8000,...
                    'overlap',2, 'nWorlds', 72,...
                    'movement', @moveWithQuadEncoder, 'experiment', @Trial_code,...
                    'cueList', {['CueDarkTri'], ['CueStripe45']},...
                    'grayCue', {['CueGray']},...
                    'atrandom', true, 'shock', false, 'tiling', 4, 'save', true,...
                    'rewarddelay', 2);
                 