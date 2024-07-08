% Clear command window, delete all old variables, close all figure windows
clc; clearvars; close all;

% Display a menu for the user to choose input source
fprintf('Projet de détection de visage\n');
fprintf('1. Entrer une image\n');
fprintf('2. Utiliser la Webcam\n');
choice = input('Choisissez 1 ou 2: ');

if choice == 1
    % Ask the user for the picture's name
    imageName = input("Faites entrer le nom de l'image (i.e., image.jpg): ", "s");
    % Read the image
    I = imread(imageName);
elseif choice == 2
    % Use the webcam to capture an image
    try
        vid = videoinput('winvideo', 1, 'MJPG_1280x720');
        set(vid, 'FramesPerTrigger', 1);
        set(vid, 'TriggerRepeat', Inf);
        start(vid);
        trigger(vid);
        I = getdata(vid, 1);
        stop(vid);
        delete(vid);
    catch
        error("Erreur: impossible d'accéder à la webcam. Assurez-vous que l'Image Acquisition Toolbox est installée.");
    end
else
    error('Choix Invalide. Choisissez 1 ou 2.');
end

% Use built-in face detector with a pre-trained model
faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');
bboxes = step(faceDetector, I);

% Draw bounding boxes around detected faces
IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Visage');
figure;
imshow(IFaces);
title('Visages Détectés');

% Display information about detected faces
if ~isempty(bboxes)
    disp('Visage détecté:');
    for i = 1:size(bboxes, 1)
        fprintf('Visage %d: (x, y, width, height) = (%d, %d, %d, %d)\n', i, bboxes(i,1), bboxes(i,2), bboxes(i,3), bboxes(i,4));
    end
else
    disp('Aucun visage détecté.');
end
