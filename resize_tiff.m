%% Resize tiff
% Specify the file path of the TIFF image
inputImagePath = 'os71_lawa - 8.tif';

% The new dimensions
newWidth = 512;
newHeight = 512;

% Specify the file path of the output multipage TIFF image
outputPath =  'os71_lawaRE - 8.tiff';

% Get the information about the multipage TIFF image
info = imfinfo(inputImagePath);
% Get the number of pages
numPages = numel(info);

% Create a Tiff object
tiffObj = Tiff(outputPath, 'w');

% Loop to write multiple images as separate pages
for i = 1:numPages
    imageData = imread(inputImagePath, 'Index', i);  % Read the i-th page
    % Resize the image
    resizedImage = imresize(imageData, [newHeight, newWidth]);

    % Write the image as a separate page
    tiffObj.setTag('Photometric', Tiff.Photometric.MinIsBlack);
    tiffObj.setTag('Compression', Tiff.Compression.None);
    tiffObj.setTag('BitsPerSample', 16);
    tiffObj.setTag('SamplesPerPixel', 1);
    tiffObj.setTag('SampleFormat', Tiff.SampleFormat.UInt);
    tiffObj.setTag('PlanarConfiguration', Tiff.PlanarConfiguration.Chunky);
    tiffObj.setTag('ImageLength', size(resizedImage, 1));
    tiffObj.setTag('ImageWidth', size(resizedImage, 2));
    tiffObj.setTag('RowsPerStrip', size(resizedImage, 1));
    tiffObj.write(resizedImage);
    
    % Write the next image to a new page
    if i < numPages
        tiffObj.writeDirectory();
    end
end

% Close the TIFF file
tiffObj.close();

% Display a message
disp('Images written as separate pages to multipage TIFF file successfully.');
