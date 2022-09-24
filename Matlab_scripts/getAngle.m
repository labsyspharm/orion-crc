function [Angle,Radian]=getAngle(point_O,point_P)
%Input O-(x1,y1) and P(x2,y2)points
%Output Angle And Radian
%devloper Er.Abbas Manthiri S
%Email-abbasmanthiribe@gmail.com
%Angle get accurate if line length is high
if nargin~=2
    [row_O,col_O]=size(point_O);
    if row_O==4
        point_P= point_O(3:4,:);
        point_O= point_O(1:2,:);
    elseif col_O==4
        point_P= point_O(:,3:4);
        point_O= point_O(1:1:2);
    else
        error('Input Type is Wrong')
    end
end
if ~(isnumeric(point_O) && isnumeric(point_P))
    error('Inputs Must be numeric value')
end
[row_O,col_O]=size(point_O);
[row_P,col_P]=size(point_P);
if ~(isvector(point_O) && isvector(point_P))
    if row_O~=row_P && col_O==col_P && col_O==2
        if row_O>row_P && row_P==1
            point_P=repmat(point_P,row_O,1);
        elseif row_O<row_P && row_O==1
            point_O=repmat(point_O,row_P,1);
        else
            error('Matrix Dimention must agree')
        end
    elseif col_O~=col_P && row_O==row_P && row_O==2
        if col_O>col_P && col_P==1
            point_P=repmat(point_P',col_O,1);
        elseif col_O<col_P && col_O==1
            point_O=repmat(point_O',col_P,1);
        else
            error('Matrix Dimention must agree')
        end
    else
        error('Input format is wrong')
    end
else
    if length(point_O)==length(point_P)
        point_O=transpose(point_O(:));
        point_P=transpose(point_P(:));
    else
        error('Input must be same size')
    end
end
X=point_P(:,1)-point_O(:,1);
Y=point_P(:,2)-point_O(:,2);
Z=sqrt(X.^2+Y.^2);
Angle=zeros(size(Z));
Amax=360;
X1=point_O(:,1);
X2=point_P(:,1);
Y1=point_O(:,2);
Y2=point_P(:,2);
X=X2-X1;
Y=Y2-Y1;
X=X./Z;
Y=Y./Z;
Angle(sign(Y2)>0)=acosd(X(sign(Y2)>0));
Angle(sign(Y2)<0  & sign(X2)>0)=Amax+asind(Y(sign(Y2)<0  & sign(X2)>0));
Angle(~(sign(Y2)>0  | (sign(Y2)<0  & sign(X2)>0)))=Amax-acosd(X(~(sign(Y2)>0  | (sign(Y2)<0  & sign(X2)>0))));
Angle(Angle==Amax)=0;
Radian=Angle*pi/180;