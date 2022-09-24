function [ax] = subplot_er(m,n,p,Listener)
%SUBPLOT_ER Creates subplot axes similar to the subplot function, but
%minimizes the white space between the different axes. The white space
%removal is performed when the figure's 'SizeChangedFcn' callback is
%executed. Initiates after first figure resize or first time figure becomes
%visible.
%
%   ax = subplot_er(m,n,p)
%   ax = subplot_er(m,n,p,'listner')    - Note: Reduces performance
%
% Example code:
%
% t = (-5:0.1:5)';
% f = sin(t);
% figure('name','subplot_er','Visible','off');
% subplot_er(2,2,1);
% plot(t,f);xlabel('Time [s]');title('f(t) = sin(t)');
% subplot_er(2,2,[2 4]);
% plot(t,f);xlabel('Time [s]');legend('f(t) = sin(t)');
% subplot_er(2,2,3);
% plot(t,f);ylabel('f(t)');
% set(gcf,'Visible','on')
%
% Author:           Eduard Reitmann
% Version:          1.0 (2017-04-12)
% Original date:    2017-04-12
if nargin == 0
    m = 1;n = 1;p = 1;
end
% Position matrices [left bottom width height]
left = repmat(0:1/n:1-1/n,m,1);
bottom = repmat(fliplr(0:1/m:1-1/m)',1,n);
% Position
rows = repmat(1:m,n,1);rows = rows(:);
cols = repmat((1:n)',m,1);
row = rows(p);
col = cols(p);
% Perform checks
if max(p) > m*n
    error('Outside of range')
end
nposcomb = sum((rows >= min(row) & rows <= max(row)) & (cols >= min(col) & cols <= max(col)));
if numel(p) ~= nposcomb
    error('Not valid selection')
end
l = left(1,min(col));
b = bottom(max(row),1);
w = (1/n)*numel(unique(col));
h = (1/m)*numel(unique(row));
ax = axes('OuterPosition',[l b w h],...
    'Units','normalized',...
    'NextPlot','replacechildren');
setappdata(ax,'FixedOuterPosition',[l b w h]);
set(gcf,'PaperPositionMode','manual','Units','normalized','SizeChangedFcn',@fillaxes)
%% Add additional listener
if nargin == 4
    % Add lsiterner to fillaxes when adding labels and titles -> Will reduce
    % performance !!! (Alternative: Set figure visible 'off' then 'on')
    if strcmpi(Listener,'listner')
        addlistener(ax,'ChildAdded',@fillaxes);
        addlistener(ax,'MarkedDirty',@fillaxes);
        warning('off','MATLAB:callback:error')
    end
end
end
function fillaxes(~,b)
f = b.Source;
% Default margin
margin = 0.005;
% Fill all axes
ax = findobj(f,'Type','axes');
for i = 1:numel(ax)
    OP = getappdata(ax(i),'FixedOuterPosition');
    if ~isempty(OP)
        TI = ax(i).TightInset;
        NewPosition = [OP(1)+TI(1)+margin ...
            OP(2)+TI(2)+margin ...
            OP(3)-sum(TI([1 3]))-2*margin ...
            OP(4)-sum(TI([2 4]))-2*margin];
        NewPosition(NewPosition<0) = 0;
        if any(ax(i).Position ~= NewPosition)
            ax(i).Position = NewPosition;
        end
    end
end
end