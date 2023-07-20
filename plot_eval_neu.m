%% A tool for evaluation of neurons based on their traces and appearance
% Plots the overall trace of the neuronal activity, plays a video of the
% close up of a neuron and shows the neuron on the overall picture


%% Load the data: post-processed reg and data_processed
clear variables;
[file_reg, path_name] = uigetfile("Choose the post_reg file");
cd(path_name);
% Search for the data_processed file using wildcard '*'
searchPattern = [file_reg(1:7) '*' '_data_processed.mat'];

% Search for files matching the pattern in the specified folder
matchingFiles = dir(fullfile(path_name, searchPattern));

% Check if any matching files were found
if isempty(matchingFiles)
    disp('No matching files found.');
% If there is more than 1 matfching file, throw an error
elseif numel(matchingFiles) ~= 1
    error('more than 1 matching file found, correct that');
else
    file_processed = matchingFiles(1).name;
end

load(file_reg);
load(file_processed, 'sigfn', 'seedsfn', 'imaxn');

data = sigfn;

set(0, 'DefaultFigureWindowStyle', 'docked');
% load([path name_base '_neu_qual.mat']);
neu_qual = zeros(size(data,1),1);
figure(1);

for neu = 1:size(data,1)
    figure(1); 
    plot(sigfn(neu,:)); xlim([0 size(data,2)]);
    pause(.5);
    %scrollplot('Axis', 'X'); 
    nq = input(['Quality of neuron #' num2str(neu) ' of ' num2str(size(data, 1)) ...
        ': (0 - not a neuron, 1(.) - terrible, 2(;) - good, 3(") - great:\n'], "s");
    if isempty(nq)
        nq = 0;
    elseif nq == '.' || nq == '1'
        nq = 1;
    elseif nq == ';' || nq == '2'
        nq = 2;
    elseif nq == "'" || nq == '3'
        nq = 3;
    end
    neu_qual(neu) = nq;
end



save([path name_base '_neu_qual.mat'], 'neu_qual');

disp([num2str(length(neu_qual(neu_qual==0))) ' not neurons']);
disp([num2str(length(neu_qual(neu_qual==1))) ' terrible neurons']);
disp([num2str(length(neu_qual(neu_qual==2))) ' good neurons']);
disp([num2str(length(neu_qual(neu_qual==3))) ' great neurons']);


