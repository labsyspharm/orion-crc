%% Function for reading imageJ table and convert to 2D array
% Jerry Lin 20160822
%
% all mean values plus Area, Circ, X, Y

function cycifarray = CycIF_readtable(channels,myfilename)

%[filename,pathname] = uigetfile(mypath,'Select a CSV file');

imageJtable = CycIF_importcsv(myfilename,2,inf);

cellno = length(imageJtable{:,1})/channels;

allmeans = imageJtable.Mean;

cycifarray = reshape(allmeans,cellno,channels);

cycifarray(:,channels+1) = imageJtable.Area(1:cellno);
cycifarray(:,channels+2) = imageJtable.Circ(1:cellno);
cycifarray(:,channels+3) = imageJtable.X(1:cellno);
cycifarray(:,channels+4) = imageJtable.Y(1:cellno);

return;




