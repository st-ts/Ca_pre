% Plot neuronal traces
close all;
% path = 'D:\CaIm\discr\os65\';
% name_base = 'os65_discr _data_processed.mat'; % 'os63_laser_water';
%% For Tibor
path = 'D:\CaIm\mix\os65\';
name_base = 'os65_mix'; % 'os63_laser_water';
name_end = '_data_processed.mat';
load([path name_base name_end], 'sigfn');
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


