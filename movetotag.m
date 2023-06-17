if abs(tagwzglkamery(i,1))>0.2 || tagwzglkamery(i,2)-0.8>0.2 || abs(tagwzglkamery(i,3))> 0.2
                move(r,[tagwzglkamery(i,2)-0.8 tagwzglkamery(i,1) tagwzglkamery(i,3)]);
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
                %rysuje uaktualnioną poz taga
                drawtag;
            else
                canigo(i) = 0;
                amiontag = 1;
            end