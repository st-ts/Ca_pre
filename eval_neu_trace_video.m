%% A tool for evaluation of neurons based on their traces and appearance
% Plots the overall trace of the neuronal activity, plays a video of the
% close up of a neuron and shows the neuron on the overall picture


%% Load the data: post-processed reg and data_processed
clear variables;
% Ask for user input for the post_reg file and set its directory 
[file_reg, path_name] = uigetfile("Choose the post_reg file");
cd(path_name);
% Search for the data_processed file using wildcard '*' in this directory
searchPattern = [file_reg(1:7) '*' '_data_processed.mat'];
matchingFiles = dir(fullfile(path_name, searchPattern));
% Check if any matching files were found
if isempty(matchingFiles)
    error('No "data_processed" file found.');
% If there is more than 1 matfching file, throw an error because there
% should be one and only
elseif numel(matchingFiles) ~= 1
    error('more than 1 "data_processed" file found, correct that');
% If there is we're good
else
    file_processed = matchingFiles(1).name;
end

% Load the post-processed video
load(file_reg);
% From data processed, load the calcium traces (sigfn), the centers of the
% identified neurons (seedsfn) and the pic of the window overall
load(file_processed, 'sigfn', 'seedsfn', 'imaxn');
data = sigfn;

%% Prep the figure
% set(0, 'DefaultFigureWindowStyle', 'docked');
neu_qual = zeros(size(data,1),1);
total_n_neu = size(data,1 );
% Get the resolution of the post reg images
res = size(reg);


%% Choose a polygon of interest, everything outside will be discarded
% Display the image
figure(12);
choice = "No";
while choice == "No"
    imshow(imaxn);
    title('Draw a polygon where neurons could be found. Double-click to finish.');
    
    % Let the user draw a multi-angle shape interactively
    roi = impoly();
    
    % Wait for the user to double-click to finish drawing the shape
    % wait(roi);
    
    % Get the coordinates of the drawn shape
    shapeCoordinates = getPosition(roi);
    
    % Display a dialog box asking if the user is happy with the drawn shape
    choice = questdlg('Are you happy with the drawn shape?', 'Confirmation', "Yes", "No", "Yes");
end
close(12);


%%
for neu = 1:total_n_neu
    % Make a figure with 1 long subplot on the top with neuronal trace, and
    % 2 small subplots below: close up video of a neuron's activity & a pic
    % with its overall position
    
    % Discard the neurons outside the ROI
    % Get the coordinates of the neuron
    [neu_x, neu_y] = ind2sub([res(1),res(2)], seedsfn(neu));

    isInShape = inpolygon(neu_x, neu_y, shapeCoordinates(:, 1), shapeCoordinates(:, 2));

    if isInShape
        figure(11); title(['Neuron #' num2str(neu) ' of ' num2str(total_n_neu)])
        % Calcium signal trace
        subplot(2, 2, [1 2]);
        plot(data(neu,:)); xlim([0 size(data,2)]);
    
        % The position of the neuron on top of the whole window
        subplot(2,2,3);
        imshow(imaxn); hold on;
        plot(neu_x,neu_y, 'ro');
        plot(neu_x,neu_y, 'ro', 'MarkerFaceColor', 'none', 'MarkerSize', 7, ...
            'LineWidth', 1.5);
    
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
        hold off;
    else
        neu_qual(neu) = 0;
    end
end


% 
% save([path name_base '_neu_qual.mat'], 'neu_qual');

disp([num2str(length(neu_qual(neu_qual==0))) ' not neurons']);
disp([num2str(length(neu_qual(neu_qual==1))) ' terrible neurons']);
disp([num2str(length(neu_qual(neu_qual==2))) ' good neurons']);
disp([num2str(length(neu_qual(neu_qual==3))) ' great neurons']);


