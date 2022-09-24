function h1=imagesctext(data_array,fontsize,fontcolor,fontformat)
%% imagesc with text label
% usage imagesctext(data_array,title_text);
% 2014/10/10 Jerry Lin

%% Initilization of parameters
if nargin < 2 
    fontsize = 12;
    fontcolor = 'k';
    fontformat = '%0.2f';
elseif nargin <3
    fontcolor = 'k';
    fontformat = '%0.2f';
elseif nargin <4
    fontformat = '%0.2f';
end

%% actual plot function
[m,n]=size(data_array);

x = repmat(1:n,m,1);
y = repmat((1:m)',1,n);

imAlpha=ones(size(data_array));
imAlpha(isnan(data_array))=0;
alltext = num2str(data_array(:),fontformat);
%alltext = strrep(alltext,'NaN','');

h1=imagesc(data_array,'AlphaData',imAlpha);
text(x(:),y(:),alltext,'HorizontalAlignment','center','FontSize',fontsize,'Color',fontcolor,'FontWeight','bold');

return;

