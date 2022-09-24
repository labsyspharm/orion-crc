%% my 


myDIR = slideDIR;

myName = slideName;

startI = input('Please input start number (default=1):');

tic;
for i = startI:length(slideDIR)
    disp(myDIR{i});
    cd(myDIR{i});
    myCommand = strcat({'"c:\Program Files\stitcher-0.4.2\bin\stitcher.bat" create_pyramid --input '},...
        myDIR{i},{'\scan*.tif --output '},myName{i},{'.ome.tif --mergeChannels'});

    disp(myCommand);
    dos(myCommand{1},'-echo');
    toc;
end

    
