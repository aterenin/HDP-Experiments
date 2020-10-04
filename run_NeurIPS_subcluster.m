cd Categorical
compile_MEX

addpath('../common');
RandStream.setGlobalStream(RandStream('mt19937ar','Seed', 1));

% [data, dictSize] = generate_bar_data(25, 100, 10);

data = struct('words',[]);
dictSize = 0;
file = fopen('../../data/NeurIPS.csv');
file_idx = 1;
while ~feof(file)
  line = fgets(file);
  data(file_idx).words = uint32(cellfun(@str2num, regexp(line,',','split')));
  dictSize = max(dictSize,double(max(data(file_idx).words))); % cast to double to avoid segfault
  file_idx = file_idx + 1;
end
fclose('all');
dictSize = dictSize + 1; % convert to 1-based

initialClusters = 1;
dispOn = false;
numProcessors = 8;
gamma = 1;
alpha = 0.1;
beta_Dirichlet = 0.01;
num_held_out_words = 0;
endtime = 60*60*24; % amount of time to stop after in seconds
numits = 100000; % the model runs numits*20 total iterations
isBarsDataset = false;

% The code from Chang et al is copyrighted so we cannot publish our modified
% code, thus we instead publish the modifications, which are relatively simple.
% (1) We rename run_HDP_subclusters to run_HDP_subclusters_with_beta on line 1.
% (2) We trivially add another input argument so as to not hardcode the
% \Phi hyperparameter to \beta = 0.5, as the original code does on line 49.
% (3) We add the input argument num_held_out_words to ensure the entire data is
% used for training, rather than only a subset, on line 51.
% (4) We add the following lines after line 193, which write the topic
% indicators to disk so that we may re-import them to MALLET to compute
% log-likelihood.  We note that both the original and modified code does NOT
% include MATLAB IO time in its timings to ensure a fair comparison.
%
% csvwrite(sprintf('../../out/z_%d.csv',it),[]);
% for d=1:numel(model.restaurants)
%   dlmwrite(sprintf('../../out/z_%d.csv',it),model.restaurants(d).customers,'delimiter',',','-append');
% end
% disp('wrote output')

[model, E, EHOW, time, numTopics, nhists] = run_HDP_subclusters_with_beta(data, dictSize, initialClusters, dispOn,  ...
    numProcessors, gamma, alpha, endtime, numits, isBarsDataset, beta_Dirichlet, num_held_out_words);
    csvwrite('../../out/out.csv',horzcat(time,E,numTopics));
    csvwrite(sprintf('../../out/z_%d.csv',(length(time)-1)/20),[]);
    for d=1:numel(model.restaurants)
     dlmwrite(sprintf('../../out/z_%d.csv',(length(time)-1)/20),model.restaurants(d).customers,'delimiter',',','-append');
    end
