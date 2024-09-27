%{
FINAL PROJECT

Eshaan Jayant Deshpande, ed6939@rit.edu
Anushka Yadav, ay4034@rit.edu
Vedika Vishwanath Painjane, vp2312@rit.edu

File Name: createMontage.m
%}

function createMontage()
% Load the trained network
load('trained_network.mat', 'net')

% name of the folder where the segmented images will be stored for creating
% a montage.
folder_name = 'images_for_montage'; 
if exist(folder_name, 'dir')
    % this line deletes the entire folder if it already exists and then creates 
    % a new folder.    
    rmdir(folder_name, 's'); 
end

% creates a new folder called processed_images
mkdir(folder_name);

montage_folder = [folder_name, '/'];

processed_img_folder = 'processed_images/';


% the following four lines selects six names of the images randomly of each type to
% create a montage.
list1_img = randi([560,1005], 1, 6);
list2_img = randi([1020, 1440], 1, 6);
list3_img = randi([1465, 1900], 1, 6);
list4_img = randi([1930, 2780], 1, 6);


% this loop runs for 6 times and stores 4 images to the folder called 
% 'images_for_montage' in each iteration.
for n = 1 : 6
    
    img_1 = strcat(num2str(list1_img(n)), '.TIF');
    img_path1 = fullfile(processed_img_folder, img_1);
    disp(img_path1);
    name_1 = imread(img_path1);
    imwrite(name_1, [montage_folder img_1]);

    img_2 = strcat(num2str(list2_img(n)), '.TIF');
    img_path2 = fullfile(processed_img_folder, img_2);
    name_2 = imread(img_path2);
    imwrite(name_2, [montage_folder img_2]);

    img_3 = strcat(num2str(list3_img(n)), '.TIF');
    img_path3 = fullfile(processed_img_folder, img_3);
    name_3 = imread(img_path3);
    imwrite(name_3, [montage_folder img_3]);

    img_4 = strcat(num2str(list4_img(n)), '.TIF');
    img_path4 = fullfile(processed_img_folder, img_4);
    name_4 = imread(img_path4);
    imwrite(name_4, [montage_folder img_4]);

end




file_list = dir('images_for_montage/*.TIF');

% Create Figure
figure,
for counter = 1 : length( file_list )
    % Read in the image to predict on
    fn = file_list(counter).name;
    directory = 'images_for_montage/';
    img = imread(append(directory,fn));

    % For showing the image
    rgb_img = img(:,:,1:3);

    % Resize the image to match the input size of the network
    inputSize = net.Layers(1).InputSize;
    img = imresize(img, [inputSize(1), inputSize(2)]);

    % Predict the label of the image using the loaded network
    label = classify(net, img);

    predicted_class = '';

    % Get irrigation value associated with the class
    switch char(label)
        case '1'
            predicted_class = 'Rainfed';
        case '2'
            predicted_class = 'Fully irrigated';
        case '3'
            predicted_class = 'Percent deficit';
        case '4'
            predicted_class = 'Time delay';
    end
    
    % Display the predicted label along with the image.
    subplot(4, 6, counter);
    imshow(rgb_img);
    title(predicted_class);
end
end