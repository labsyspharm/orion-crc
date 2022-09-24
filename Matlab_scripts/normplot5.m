function [pr,db,dfa]=normplot5(datamatrix,number)

%function for plot FOXO ratio time series

%input= datamatrix & number of timeseires used in the plot
%output= pr:period; db:ampitude/energy; dfa:alpha(DFA3)
%
%Jerry Lin 20140826

pr=zeros(number,1);
db=zeros(number,1);
dfa=zeros(number,1);

for n1=1:20:number
    figure
  for i = 1:5
    for j=1:4
      n=n1+(i-1)*4+j-1;
      if n>number
          return;
      end
      subplot(5,4,(i-1)*4+j)
      data = datamatrix(:,n);
      xln = length(data);
      xc = abs(fft(data));
      xc2 = xc(1:floor(xln/2));
      xc2(1:15) = 0;
      [C,maxpeak] = max(xc2);
      maxperiod = xln / maxpeak;
      df =DFA3(data);
      
      pr(n,1)=maxperiod;
      db(n,1)=C;
      dfa(n,1)=df;
      x = 1:xln;
      
      [ax,h1,h2]=plotyy(x,data,x,xc);
      set(ax(1),'XLim',[0 xln])
      set(ax(1),'XTick',[0:20:xln])
      set(ax(1),'YLim',[-0.5 1.5])
      set(ax(1),'YTick',[-0.5:0.5:1.5])
      set(ax(2),'XLim',[0 xln])
      set(ax(2),'XTick',[0:20:xln])
      set(ax(2),'YLim',[0 15])
      set(ax(2),'YTick',[0:5:15])
      
      no = n1+(i-1)*4+j-1;
      title([num2str(no),' db=',num2str(C), ' Alp=',num2str(df), ' Pr=',num2str(maxperiod)])
    end
  end
end