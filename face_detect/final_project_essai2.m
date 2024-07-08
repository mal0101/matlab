% Clear command window, delete all old variables, close all figure windows
clc; clearvars; close all;

% Display a menu for the user to choose input source
fprintf('Détection des visages\n');
fprintf('1. Entrer une Image\n');
fprintf('2. Utiliser la Webcam\n');
choice = input('Choisissez 1 ou 2: ');

if choice == 1
    % Ask the user for the picture's name
    imageName = input("Faites entrer le nom de l'image (i.e., image.jpg): ", 's');
    % Read the image
    I = imread(imageName);
elseif choice == 2
    % Use the webcam to capture an image
    cam = webcam;
    I = snapshot(cam);
    clear cam; % Release the webcam resource
else
    error('Invalid choice. Please enter 1 or 2.');
end

% Use built-in face detector with a pre-trained model
faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');
bboxes = step(faceDetector, I);

% Draw bounding boxes around detected faces
IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
figure;
imshow(IFaces);
title('Detected Faces');

% Display information about detected faces
if ~isempty(bboxes)
    disp('Faces detected:');
    for i = 1:size(bboxes, 1)
        fprintf('Face %d: (x, y, width, height) = (%d, %d, %d, %d)\n', i, bboxes(i,1), bboxes(i,2), bboxes(i,3), bboxes(i,4));
    end
else
    disp('No faces detected.');
end
