%% transperant scatter plot?
% Jerry Lin 2014/11/05

function tsp=transcatter(x,y,dotcolor,dotsize,opacity)

%x=randn(5000,1);
%y= randn(5000,1);

t= 0:pi/10:2*pi;

for i=1:size(x)
    tsp=patch((sin(t)+ x(i)),(cos(t)+y(i)),dotcolor,'edgecolor','none');
    alpha(tsp,opacity);
end

return
