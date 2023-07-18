%% Crop tiff 

% Specify the file path of the TIFF image and processed file
path = 'D:\CaIm\tibor_test\';
file_tif = 'tibor_1st_test.tif';
file_proc = 'tibor_test _data_processed.mat';
load([path file_proc]);
choose_man = true;
figure(); 
imshow(imaxn); colormap(gray); hold on;

% Specify the file path of the output multipage TIFF image
output_name =  'tibor_1st_test_cropped.tif';



% Pick point to determine the crop, the lowest one on the most left, and
% the highest on the most right
disp('Choose the crop');
rect = getrect;
rectangle('Position', rect, 'EdgeColor', 'r', 'LineWidth', 2);


% Get the information about the multipage TIFF image
tif_info = imfinfo([path file_tif]);
% Get the number of pages
numPages = numel(tif_info);

% Create a Tiff object
tiffObj = Tiff([path output_name], 'w');

% Crop the image based on the drawn rectangle
for i = 1:numPages
    imageData = imread([path file_tif], 'Index', i);  % Read the i-th page
    % Resize the image
    croppedImage = imcrop(imageData, rect);

    % Write the image as a separate page
    tiffObj.setTag('Photometric', Tiff.Photometric.MinIsBlack);
    tiffObj.setTag('Compression', Tiff.Compression.None);
    tiffObj.setTag('BitsPerSample', 16);
    tiffObj.setTag('SamplesPerPixel', 1);
    tiffObj.setTag('SampleFormat', Tiff.SampleFormat.UInt);
    tiffObj.setTag('PlanarConfiguration', Tiff.PlanarConfiguration.Chunky);
    tiffObj.setTag('ImageLength', size(croppedImage, 1));
    tiffObj.setTag('ImageWidth', size(croppedImage, 2));
    tiffObj.setTag('RowsPerStrip', size(croppedImage, 1));
    tiffObj.write(croppedImage);
    
    % Write the next image to a new page
    if i < numPages
        tiffObj.writeDirectory();
    end
end

% Close the TIFF file
tiffObj.close();


