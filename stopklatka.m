test = snapshot(cameraObj); %zrobienie zdj
pause(1);
try
    tagdetection;
catch
    warning('tagdetection did not execute, trying again');
    test = snapshot(cameraObj);
    pause(3);
    tagdetection;
end
pause(0.8);
figure(f1);
imshow(test);
pause(1);