function faceDetectionGUI()
    % Create the main figure
    fig = uifigure('Position', [100 100 400 200], 'Name', 'Projet de Détection de Visage');
    
    % Create a label
    lbl = uilabel(fig, 'Position', [50 150 300 30], 'Text', 'Choisissez une option pour détecter des visages');
    
    % Create buttons for selecting image or webcam
    btnImage = uibutton(fig, 'push', 'Position', [50 100 100 30], 'Text', 'Utiliser Image', ...
                        'ButtonPushedFcn', @(btn,event) useImage());
    btnWebcam = uibutton(fig, 'push', 'Position', [250 100 100 30], 'Text', 'Utiliser Webcam', ...
                         'ButtonPushedFcn', @(btn,event) useWebcam());
end

function useImage()
    % Open file dialog for selecting an image
    [file, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'});
    if isequal(file, 0)
        disp('Utilisateur a sélectionné Annuler');
    else
        imgPath = fullfile(path, file);
        disp(['Fichier sélectionné: ', imgPath]);  % Debugging output
        detectFaces(imgPath);
    end
end

function useWebcam()
    try
        vid = videoinput('winvideo', 1, 'MJPG_1280x720');
        set(vid, 'FramesPerTrigger', 1);
        set(vid, 'TriggerRepeat', Inf);
        start(vid);
        trigger(vid);
        img = getdata(vid, 1);
        stop(vid);
        delete(vid);
        detectFaces(img);
    catch
        uialert(uifigure, "Erreur: impossible d'accéder à la webcam. Assurez-vous que l'Image Acquisition Toolbox est installée.", 'Erreur Webcam');
    end
end

function detectFaces(input)
    faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');
    
    if ischar(input)
        % If input is a file path
        I = imread(input);
    else
        % If input is an image matrix
        I = input;
    end
    
    bboxes = step(faceDetector, I);
    IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Visage');
    
    % Display detected faces
    figure, imshow(IFaces), title('Visages Détectés');
    
    % Display information about detected faces
    if ~isempty(bboxes)
        disp('Visage détecté:');
        for i = 1:size(bboxes, 1)
            fprintf('Visage %d: (x, y, width, height) = (%d, %d, %d, %d)\n', i, bboxes(i,1), bboxes(i,2), bboxes(i,3), bboxes(i,4));
        end
    else
        disp('Aucun visage détecté.');
    end
end

% Run the GUI
faceDetectionGUI();
