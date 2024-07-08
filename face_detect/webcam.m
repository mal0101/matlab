% Load the pre-trained face detection model
faceDetector = vision.CascadeObjectDetector();

% Create a video object for the webcam
cam = webcam;

while true
    % Capture a frame from the webcam
    img = snapshot(cam);

    % Detect faces in the frame
    bbox = step(faceDetector, img);

    % Annotate detected faces in the image
    detectedImg = insertObjectAnnotation(img, 'rectangle', bbox, 'Face');

    % Display the frame with detected faces
    imshow(detectedImg);

    % Pause for a short time to allow image to refresh
    pause(0.1);
end

% Clear the webcam object
clear cam;
