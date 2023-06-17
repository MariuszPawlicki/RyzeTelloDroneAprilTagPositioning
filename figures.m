f1 = figure('Name','Camera','NumberTitle','off');%obraz z kamery
axes("Position",[0 0 1 1]); %wypelnia cala figure obrazem
f1.Position(1:2) = [5 60];  %ustawia pozycje figury na ekranie
f2 = figure('Name','Position','NumberTitle','off'); %mapa punktów
f2.Position(1:2) = [5 550]; %ustawia pozycje figury na ekranie
plot3(0,0,0,'square','MarkerFaceColor','red'); %plot pozycji poczatkowej
hold on
grid on
text(0.01,0.01,0.01,"dron") %dodaje text obok punktu