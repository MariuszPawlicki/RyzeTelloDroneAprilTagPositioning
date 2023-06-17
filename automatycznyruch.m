%WAŻNA UWAGA! NA PLOT3 TRZECIA WSPÓŁRZĘDNA TO WYSOKOŚĆ, A WIĘC U NAS TO
%BĘDZIE T2
maxheight = 1.9;  %określenie max wysokości
initialization; %ustalenie wartosci pewnych zmiennych
r = ryze();     %polaczenie drona z kompem
cameraObj = camera(r);  %do obslugi kamery
figures;        %wywoluje okienka w ktorych bedzie mapa oraz obraz z kamery
takeoff(r);     %wzlot drona
pause(4)        %pauza by się ustabilizował
[sheight,~] = readHeight(r); %odczyt wysokosci 
pozdrona(3) = sheight;       %aktualizacja poz drona (wysokosci)
drawdrone;
r.BatteryLevel;
while(stop<1)   %glowna petla programu
    %obraz kamery/detekcja tagów
    stopklatka;
    %rysuje tag na mapie - jesli ma pozwolenieland(r
    for i = 1:length(isthereatag)
        if isthereatag(i) == 1 && canidrawtag(i) == 1
            drawtag;
            canidrawtag(i) = 0;
        end
    end
    for i = 1:length(isthereatag)
        if isthereatag(i) == 1 && canigo(i) == 1
            %obl ruch, wykresla poz tagow i drona, ruch drona
            %sprawdza czy może się ruszyć
            if abs(tagwzglkamery(i,1))>0.2 || tagwzglkamery(i,2)-0.8>0.2 || abs(tagwzglkamery(i,3))> 0.2
                move(r,[tagwzglkamery(i,2)-0.8 tagwzglkamery(i,1) -tagwzglkamery(i,3)]);
                pause(0.5);
                canigo(i) = 0;
                amiontag = 1;
                
                %obliczenie bezwzgl pozycji drona
                theta = readOrientation(r); %odczyt orientacji
                R = [cos(-theta(1)) -sin(-theta(1)); sin(-theta(1)) cos(-theta(1))]; %rot matrix
                dronpoint = [tagwzglkamery(i,1) tagwzglkamery(i,2)-0.8]'; %ile się przemieści w x i y
                dronrotpoint = R*dronpoint;
                %aktualizacja pozycji drona
                pozdrona(1) = pozdrona(1)+dronrotpoint(1);
                pozdrona(2) = pozdrona(2)+dronrotpoint(2);
                pozdrona(3) = pozdrona(3)+tagwzglkamery(i,3);
                %rysuje poz drona
                drawdrone;
                stopklatka;
                %rysuje uaktualnioną poz taga; z jakiegoś powodu nie chce rysowac :/
                drawtag;
                %akcja
                pause(1)
                try
                    doanaction;
                catch
                    warning('nie udalo sie zrobic akcji');
                end
            else
                canigo(i) = 0;
                amiontag = 1;
                stopklatka;
                %rysuje uaktualnioną poz taga; z jakiegoś powodu nie chce rysowac :/
                drawtag;
                %akcja
                pause(1)
                try
                    doanaction;
                catch
                    warning('nie udalo sie zrobic akcji');
                end
            end
            
        end
    end
    %obliczyc o ile dron ma sie poruszyc by dotrzec do taga
    %po dotarciu do taga jeszcze raz wykreslic jego polozenie na mapie
    %oraz sprawdzic czy nie musi jeszcze sie jakos do niego zblizyc.
    %=======done tyle ze trzeba tam jeszcze dodac wykonanieakcji(fikolek)
    %Teraz ma sie obracac przed tagiem w poszukiwaniu innych tagow.
    %Jesli nie znajdzie to wraca na poczatek i znowu sie obraca po tagi
    
    if amiontag == 1
        for tfi = 1:6
            turn(r,pi/4)
            pause(0.5)
            stopklatka;
            for i = 1:length(isthereatag)
                if isthereatag(i) == 1 && canidrawtag(i) == 1
                    drawtag;
                    canidrawtag(i) = 0;
                end
            end
            for i = 1:length(isthereatag)
                if isthereatag(i) == 1 && canigo(i) == 1
                    movetotag;
                    stopklatka;
                    %rysuje uaktualnioną poz taga;
                    drawtag;
                    %akcja
                    pause(1)
                    try
                        doanaction;
                    catch
                        warning('nie udalo sie zrobic akcji');
                    end
                    canigo(i) = 0;
                    tfi = 1;
                end
            end
        end
        %powrot do pierwotnej orientacji
        theta = readOrientation(r); %czyta kąt theta
        turn(r,-theta(1));
        pause(1);
        if abs(pozdrona(1))>0.2 || abs(pozdrona(2))>0.2 % sheight pzdrona - przesuw = sheight
            move(r,[-pozdrona(2) -pozdrona(1) pozdrona(3) - sheight]);                        % przesuw = pozdrona - sheight
            pozdrona(1:3) = [0 0 sheight];
            drawdrone;
        end
        amiontag = 0;
        turn(r,prevangle);
    end
    %to teraz obrot
    turn(r,pi/4);
    [sheight,~] = readHeight(r);
    theta = readOrientation(r); %czyta kąt theta
    prevangle = theta(1);
    pause(0.5);
    if abs(theta(1))<0.6  
        if sheight + 0.5<maxheight
            moveup(r,'Distance',0.5);
            pause(1);
            [sheight,~] = readHeight(r);
            pozdrona(3) = sheight;
            drawdrone;
            pause(0.5)
        elseif maxheight - sheight > 0.2
            moveup(r,'Distance',maxheight - sheight);
            pause(1);
            pozdrona(2) = sheight;
            drawdrone;
            pause(0.5)
        else
            stop = 1;
        end
    end
end
land(r);