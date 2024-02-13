%% A tool for evaluation of neurons based on their traces and appearance
% Plots the overall trace of the neuronal activity, plays a video of the
% close up of a neuron and shows the neuron on the overall picture


%% Load the data: post-processed reg and data_processed
clear variables;
% Ask for user input for the post_reg file and set its directory 
[file_reg, path_name] = uigetfile("Choose the post_reg file");
cd(path_name);

load(file_reg);

reg = frame_all;

%% Prep the figure
figure(1);
for fn = 1:2000
     imshow(reg(:,:,fn), 'InitialMagnification', 1000); hold on;

        pause(0.1)

end

