[id , loc , pose] = readAprilTag(test , "tag36h11" , intrinsics , tagSize);

worldPoints = [0 0 0; tagSize/2 0 0; 0 tagSize/2 0; 0 0 tagSize/2];
for i = 1 : length(pose)
    %zapamietanie jakie id tagow bylo
    idpam(i) = id(i);
    % Get image coordinates for axes.
    imagePoints = world2img(worldPoints , pose(i) , intrinsics);

    
    translated = calculateposes(test, [720 960], tagSize, 4, [3 4]);
    str = id(i) +" - x:" + string(translated(1)) + " y:" + string(translated(2)) + " z:"...
        + string(translated(3)); % zlepienie stringa z pose.Translated

    % Draw colored axes.
    test = insertShape(test , Line=[imagePoints(1,:) imagePoints(2,:); ...
        imagePoints(1,:) imagePoints(3,:); imagePoints(1,:) imagePoints(4,:)], ...
        Color=["red","green","blue"],LineWidth=7);
    test = insertText(test,loc(1,:,i),str,BoxOpacity=0.5,FontSize=18);

    isthereatag(id(i)) = 1; %zapamietuje jaki tag zostal zobaczony

    %koordynaty tagu wzgl kamery(moving frame) - wektor x
    tagwzglkamery(id(i),1) = translated(1);
    tagwzglkamery(id(i),2) = translated(3);
    tagwzglkamery(id(i),3) = -translated(2);
    
    %obliczenie bezwzgl kordow tagu
    theta = readOrientation(r);
    R = [cos(-theta(1)) -sin(-theta(1)); sin(-theta(1)) cos(-theta(1))];
    tagpoint = [tagwzglkamery(id(i),1) tagwzglkamery(id(i),2)]';
    tagrotpoint = R*tagpoint;
    
    %koordynaty tagu wzgl poczatku ukl wspol(fixed frame) - wektor X 
    tagbezwzgl(id(i),1) = tagrotpoint(1) + pozdrona(1);
    tagbezwzgl(id(i),2) = tagrotpoint(2) + pozdrona(2);
    %nie potrzeba mnozyc przez rotation matrix bo to wysokosc tagu
    tagbezwzgl(id(i),3) = tagwzglkamery(id(i),3) + pozdrona(3);

    clear tagrotpoint; 
end