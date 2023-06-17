            initialization; %ustalenie wartosci pewnych zmiennych
            r = ryze();
            cameraObj = camera(r);  %do obslugi kamery
            figures;        %wywoluje okienka w ktorych bedzie mapa oraz obraz z kamery
            takeoff(r);     %wzlot drona
            pause(3)        %pauza by się ustabilizował
            [sheight,~] = readHeight(r); %odczyt wysokosci 
            pozdrona(3) = sheight;       %aktualizacja poz drona (wysokosci)
            drawdrone;
            maxheight = 2;
            ruch_zrobiony = 0;

            %głowna pętla programu
            while(true)
                wykryto = 0;
                %sprawdzamy czy ma tag przed sobą
                stopklatka;

                %rysuje tag na mapie - jesli ma pozwolenie
                for i = 1:length(isthereatag)
                    if isthereatag(i) == 1 && canidrawtag(i) == 1
                        wykryto = 1;
                        drawtag;
                        canidrawtag(i) = 0;
                        %wyświetlenie na konsoli
                        %event = "tag wykryty";
                        %EditFieldValueChanging(app , event);
                    end
                end

                %przemiezczenie drona
             for i = 1:length(isthereatag)
                if isthereatag(i) == 1 && canigo(i) == 1
                    wykryto = 1;
                    %obl ruch, wykresla poz tagow i drona, ruch drona
                    %sprawdza czy może się ruszyć
                    if abs(tagwzglkamery(i,1))>0.2 || tagwzglkamery(i,2)-0.8>0.2 || abs(tagwzglkamery(i,3))> 0.2
                        move(r,[tagwzglkamery(i,2)-0.8 tagwzglkamery(i,1) tagwzglkamery(i,3)]);
                        pause(0.5);
                        canigo(i) = 0;
                        amiontag = 1;
                    
                        %obliczenie bezwzgl pozycji drona
                        theta = readOrientation(r); %odczyt orientacji
                        r = [cos(-theta(1)) -sin(-theta(1)); sin(-theta(1)) cos(-theta(1))]; %rot matrix
                        dronpoint = [tagwzglkamery(i,1) tagwzglkamery(i,2)-0.8]'; %ile się przemieści w x i y
                        dronrotpoint = r*dronpoint;
        
                        %aktualizacja pozycji drona
                        pozdrona(1) = pozdrona(1)+dronrotpoint(1);
                        pozdrona(2) = pozdrona(2)+dronrotpoint(2);
                        pozdrona(3) = pozdrona(3)+tagwzglkamery(i,3);
                        %app.HeightmGauge.Value = pozdrona(3);
                        %rysuje poz drona
                        drawdrone;
                        %stopklatka;
                        %rysuje uaktualnioną poz taga; z jakiegoś powodu nie chce rysowac :/
                        %drawtag;
                        %akcja
                        pause(1)
                        
                        %--------Akcja specjalna---------
                        %try
                        %   doanaction;
                        %catch
                            %rysuowanie warningow
                        %   warning('nie udalo sie zrobic akcji');
                         %  event = "Nie udalo sie zrobic akcji";
                          % EditFieldValueChanging(app , event);
                        %end
    
                        %tutaj musi zbadać tag i policzyć swoją pozycję
                        %względem niego (jeśli robi flip
    
    
                   else %nie może podlecieć więc robi warning że tag jest za blisko
                        canigo(i) = 0;
                        amiontag = 1;
                        %akcja
                        pause(1)
    
                        %event = "Nie udalo sie zrobic akcji , tag jest zbyt blisko";
                        %EditFieldValueChanging(app , event);
                        
                        %--------Akcja specjalna---------
                        %try
                        %   doanaction;
                        %catch
                        %rysuowanie warningow
                        %   warning('nie udalo sie zrobic akcji');
                         %  event = "Nie udalo sie zrobic akcji";
                          % EditFieldValueChanging(app , event);
                        %end
    
                        %tutaj musi zbadać tag i policzyć swoją pozycję
                        %względem niego (jeśli robi flip


                   end

                   %powrot do pierwotnej pozycji
                   %if abs(pozdrona(1))>0.2 || abs(pozdrona(2))>0.2 % sheight pzdrona - przesuw = sheight
                    %   move(r,[-tagwzglkamery(i,2)+0.8 -tagwzglkamery(i,1) -tagwzglkamery(i,3)]);  % przesuw = pozdrona - sheight
                     %  pozdrona(1:3) = [0 0 sheight];
                       %app.HeightmGauge.Value = pozdrona(3);
                      % drawdrone;
                   %end

                end
             end

                if wykryto == 0
                    for tfi = 1:8
                        turn(r,pi/4)
                        pause(0.5)
                        stopklatka;
                        for i = 1:length(isthereatag)

                        if all([isthereatag(i) , canidrawtag(i)] == 1)
                            wykryto = 1;
                            drawtag;
                            canidrawtag(i) = 0;
                        end
                        pause(0.5)
                        if all([isthereatag(i) , canigo(i)] == 1)
                            pause(0.5)
                            if abs(tagwzglkamery(i,1))>0.2 || tagwzglkamery(i,2)-0.8>0.2 || abs(tagwzglkamery(i,3))> 0.2
                                move(r,[tagwzglkamery(i,2)-0.8 tagwzglkamery(i,1) tagwzglkamery(i,3)]);
                                pause(0.5);
                                canigo(i) = 0;
                                amiontag = 1;
                                        
                                %obliczenie bezwzgl pozycji drona
                                theta = readOrientation(r); %odczyt orientacji
                                r = [cos(-theta(1)) -sin(-theta(1)); sin(-theta(1)) cos(-theta(1))]; %rot matrix
                                dronpoint = [tagwzglkamery(i,1) tagwzglkamery(i,2)-0.8]'; %ile się przemieści w x i y
                                dronrotpoint = r*dronpoint;
                            
                               %aktualizacja pozycji drona
                               pozdrona(1) = pozdrona(1)+dronrotpoint(1);
                               pozdrona(2) = pozdrona(2)+dronrotpoint(2);
                               pozdrona(3) = pozdrona(3)+tagwzglkamery(i,3);
                               %app.HeightmGauge.Value = pozdrona(3);
                               %rysuje poz drona
                               drawdrone;
                               %stopklatka;
                               %rysuje uaktualnioną poz taga; z jakiegoś powodu nie chce rysowac :/
                               %drawtag;
                               %akcja
                               pause(0.5)
                                            
                               %--------Akcja specjalna---------
                               %try
                               %   doanaction;
                               %catch
                               %rysuowanie warningow
                               %   warning('nie udalo sie zrobic akcji');
                                %  event = "Nie udalo sie zrobic akcji";
                                 % EditFieldValueChanging(app , event);
                               %end
                        
                               %tutaj musi zbadać tag i policzyć swoją pozycję
                               %względem niego (jeśli robi flip
                                               
                           else %nie może podlecieć więc robi warning że tag jest za blisko
                               canigo(i) = 0;
                               amiontag = 1;
                               %akcja
                               pause(1)
                               %event = "Nie udalo sie zrobic akcji , tag jest zbyt blisko";
                               %EditFieldValueChanging(app , event);
                                            
                               %--------Akcja specjalna---------
                                %try
                               %   doanaction;
                               %catch
                               %rysuowanie warningow
                               %   warning('nie udalo sie zrobic akcji');
                                %  event = "Nie udalo sie zrobic akcji";
                                 % EditFieldValueChanging(app , event);
                               %end
                        
                               %tutaj musi zbadać tag i policzyć swoją pozycję
                               %względem niego (jeśli robi flip
                            end
                            %powrot do pierwotnej pozycji
                            %if abs(pozdrona(1))>0.2 || abs(pozdrona(2))>0.2 % sheight pzdrona - przesuw = sheight
                             %  move(r,[-tagwzglkamery(i,2)+0.8 -tagwzglkamery(i,1) -tagwzglkamery(i,3)]); % przesuw = pozdrona - sheight
                              % pozdrona(1:3) = [0 0 sheight];
                               %app.HeightmGauge.Value = pozdrona(3);
                               %drawdrone;
                            %end
                        end
                        end
                        if wykryto == 1
                            break
                        end
                    end
                end
                

                %Jeśli nie przekroczył maksymalnej wysokości to leci do
                %góry
                [sheight,~] = readHeight(r);
                if sheight + 0.5 < maxheight
                   moveup(r,'Distance',0.5);
                   pause(1);
                   [sheight,~] = readHeight(r);
                   pozdrona(3) = sheight;
                  %app.HeightmGauge.Value = pozdrona(3);
                   drawdrone;
                   pause(1);
                %else
                   %app.stop = 1;

                end   
            end
            %Koniec
            land(r);
            clear(r);