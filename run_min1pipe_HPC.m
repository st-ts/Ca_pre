mouse_id  = 65;
exp_type = 'mix';
% path_name = [ 'D:\CaIm\' exp_type '\os'  num2str(mouse_id) '\' ];
% file_name = [ 'os' num2str(mouse_id) '_' exp_type ' - 1.tif'];


path_name =  'D:\CaIm\tibor_test\';
file_name = 'tibor_2nd_test_cropped.tif';
% file_name_to_save = [ 'os' num2str(mouse_id) '_' exp_type '_data_processed.mat'];
% filename_raw = [ 'os' num2str(mouse_id) '_' exp_type '_frame_all.mat'];
% filename_reg = [ 'os' num2str(mouse_id) '_' exp_type '_reg.mat'];
if mouse_id == 666
    Fsi = 6; Fsi_new = 6;
else
    Fsi = 10; Fsi_new = 10;
end
spatialr = 1;


% Decide the size of a neuron
tifinf = imfinfo([path_name file_name]);
tifwidf = tifinf.Width;
% the size of the window = 3175 micron, I film 2x -> 1588, average size of
% PYR neuron ~ 20 micron, with 512 pix -> 3.2 pix radius, make it 4 for
% blurry ones
if tifwidf(1) == 512
    se = 4; %%% structure element for background removal %%%
elseif tifwidf(1) == 1024
    se = 8; %%% structure element for background removal %%%
else
    se = 4;
    disp("WTF");
end



ismc = true; %%% run movement correction %%%
flag = 1; %%% use auto seeds selection; 2 if manual g%%
% isvis = true; %%% do visualize %%%
ifpost = false; %%% set true if want to see post-process %%%

[file_name_to_save, filename_raw, filename_reg] = min1pipe_HPC(Fsi, Fsi_new, ...
                spatialr, se, ismc, flag, path_name, file_name);