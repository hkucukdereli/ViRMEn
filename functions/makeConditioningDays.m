%% make conditioning
createConditioning('Conditioning_day1', 'Conditioning_templates', 'save',true,...
    'experiment',@Conditioning, 'movement',@moveWithQuadEncoder,...
    'cueList', {['CueStripe45'], ['CueStripe135']}, 'arenaL', 5000);

createConditioning('Conditioning_day2', 'Conditioning_templates', 'save',true,...
    'experiment',@Conditioning, 'movement',@moveWithQuadEncoder,...
    'cueList', {['CueStripe135'], ['CueStripe45']}, 'arenaL', 5000);

createConditioning('Conditioning_day3', 'Conditioning_templates', 'save',true,...
    'experiment',@Conditioning, 'movement',@moveWithQuadEncoder,...
    'cueList', {['CueStripe45'], ['CueStripe135']}, 'arenaL', 5000);

createConditioning('Conditioning_day4', 'Conditioning_templates', 'save',true,...
    'experiment',@Conditioning, 'movement',@moveWithQuadEncoder,...
    'cueList', {['CueStripe45'], ['CueStripe135']}, 'arenaL', 5000);

createConditioning('Conditioning_day5', 'Conditioning_templates', 'save',true,...
    'experiment',@Conditioning, 'movement',@moveWithQuadEncoder,...
    'cueList', {['CueStripe135'], ['CueStripe45']}, 'arenaL', 5000);

createConditioning('Conditioning_day6', 'Conditioning_templates', 'save',true,...
    'experiment',@Conditioning, 'movement',@moveWithQuadEncoder,...
    'cueList', {['CueStripe135'], ['CueStripe45']}, 'arenaL', 5000);

%% make trials
createTrials('Trial_day1', 'Conditioning_templates', 'save',true,...
    'experiment', @TrialStim, 'movement',@moveWithQuadEncoder,...
    'cueList', {['CueStripe135'], ['CueStripe45']}, 'arenaL', 5000,...
    'cueL', 500, 'nWorlds', 10, 'overlap', 3);

createTrials('Trial_day2', 'Conditioning_templates', 'save',true,...
    'experiment', @TrialStim, 'movement',@moveWithQuadEncoder,...
    'cueList', {['CueStripe135'], ['CueStripe45']}, 'arenaL', 5000,...
    'cueL', 500, 'nWorlds', 10, 'overlap', 3);

createTrials('Trial_day3', 'Conditioning_templates', 'save',true,...
    'experiment', @TrialStim, 'movement',@moveWithQuadEncoder,...
    'cueList', {['CueStripe45'], ['CueStripe135']}, 'arenaL', 5000,...
    'cueL', 500, 'nWorlds', 10, 'overlap', 3);

createTrials('Trial_day4', 'Conditioning_templates', 'save',true,...
    'experiment', @TrialStim, 'movement',@moveWithQuadEncoder,...
    'cueList', {['CueStripe135'], ['CueStripe45']}, 'arenaL', 5000,...
    'cueL', 500, 'nWorlds', 10, 'overlap', 3);

createTrials('Trial_day5', 'Conditioning_templates', 'save',true,...
    'experiment', @TrialStim, 'movement',@moveWithQuadEncoder,...
    'cueList', {['CueStripe45'], ['CueStripe135']}, 'arenaL', 5000,...
    'cueL', 500, 'nWorlds', 10, 'overlap', 3);

createTrials('Trial_day6', 'Conditioning_templates', 'save',true,...
    'experiment', @TrialStim, 'movement',@moveWithQuadEncoder,...
    'cueList', {['CueStripe45'], ['CueStripe135']}, 'arenaL', 5000,...
    'cueL', 500, 'nWorlds', 10, 'overlap', 3);