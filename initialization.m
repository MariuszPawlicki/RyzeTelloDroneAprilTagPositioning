focalLength    = [4*720/3 4*960/4];   % te dane trzeba zmienić
principalPoint = [360 480];
imageSize      = [720 960];
intrinsics = cameraIntrinsics(focalLength , principalPoint , imageSize);

tagSize = 0.184;    %wielkosc krawedzi tagu
isthereatag = zeros(1,19);  % id tagow, bez tagu o id = 0
canigo = ones(1,19);        % czy moze leciec do tagu
pozdrona = [0 0 0];     % prawo lewo; przod tyl; wysokosc
tagwzglkamery (19,3) = 0; %kordy tagu wzgl kamery; row - id
tagbezwzgl (19,3) = 0;    %bezwzględne kordy tagu
stop = 0;       %jesli stop==1 to konczy głowną pętlę
amiontag = 0;   %czy dron jest wlasnie przed tagiem
prevangle = 0;
canidrawtag(1:19) = ones;