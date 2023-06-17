if pozdrona(3) < maxheight - 0.4
    moveup(r,'distance',0.4,'WaitUntilDone',true);
    pause(0.3);
    movedown(r,'distance',0.4,'WaitUntilDone',true)
    pause(0.3);
    moveup(r,'distance',0.4,'WaitUntilDone',true);
    pause(0.3);
    movedown(r,'distance',0.4,'WaitUntilDone',true)
    pause(1);

else
    movedown(r,'distance',0.4,'WaitUntilDone',true)
    pause(0.3);
    moveup(r,'distance',0.4,'WaitUntilDone',true);
    pause(0.3);
    movedown(r,'distance',0.4,'WaitUntilDone',true)
    pause(0.3);
    moveup(r,'distance',0.4,'WaitUntilDone',true);
    pause(1);
end