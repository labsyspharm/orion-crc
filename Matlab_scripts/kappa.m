function kappa(x,varargin)
% KAPPA: This function computes the Cohen's kappa coefficient.
% Cohen's kappa coefficient is a statistical measure of inter-rater
% reliability. It is generally thought to be a more robust measure than
% simple percent agreement calculation since k takes into account the
% agreement occurring by chance.
% Kappa provides a measure of the degree to which two judges, A and B,
% concur in their respective sortings of N items into k mutually exclusive
% categories. A 'judge' in this context can be an individual human being, a
% set of individuals who sort the N items collectively, or some non-human
% agency, such as a computer program or diagnostic test, that performs a
% sorting on the basis of specified criteria.
% The original and simplest version of kappa is the unweighted kappa
% coefficient introduced by J. Cohen in 1960. When the categories are
% merely nominal, Cohen's simple unweighted coefficient is the only form of
% kappa that can meaningfully be used. If the categories are ordinal and if
% it is the case that category 2 represents more of something than category
% 1, that category 3 represents more of that same something than category
% 2, and so on, then it is potentially meaningful to take this into
% account, weighting each cell of the matrix in accordance with how near it
% is to the cell in that row that includes the absolutely concordant items.
% This function can compute a linear weights or a quadratic weights.
%
% Syntax: 	kappa(X,W,ALPHA)
%      
%     Inputs:
%           X - square data matrix
%           W - Weight (0 = unweighted; 1 = linear weighted; 2 = quadratic
%           weighted; -1 = display all. Default=0)
%           ALPHA - default=0.05.
%
%     Outputs:
%           - Observed agreement percentage
%           - Random agreement percentage
%           - Agreement percentage due to true concordance
%           - Residual not random agreement percentage
%           - Cohen's kappa 
%           - kappa error
%           - kappa confidence interval
%           - Maximum possible kappa
%           - k observed as proportion of maximum possible
%           - k benchmarks by Landis and Koch 
%           - z test results
%
%      Example: 
%
%           x=[88 14 18; 10 40 10; 2 6 12];
%
%           Calling on Matlab the function: kappa(x)
%
%           Answer is:
%
% UNWEIGHTED COHEN'S KAPPA
% --------------------------------------------------------------------------------
% Observed agreement (po) = 0.7000
% Random agreement (pe) = 0.4100
% Agreement due to true concordance (po-pe) = 0.2900
% Residual not random agreement (1-pe) = 0.5900
% Cohen's kappa = 0.4915
% kappa error = 0.0549
% kappa C.I. (alpha = 0.0500) = 0.3839     0.5992
% Maximum possible kappa, given the observed marginal frequencies = 0.8305
% k observed as proportion of maximum possible = 0.5918
% Moderate agreement
% Variance = 0.0031     z (k/sqrt(var)) = 8.8347    p = 0.0000
% Reject null hypotesis: observed agreement is not accidental
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2007) Cohen's kappa: compute the Cohen's kappa ratio on a square matrix.   
% http://www.mathworks.com/matlabcentral/fileexchange/15365

%Input Error handling
p = inputParser;
addRequired(p,'x',@(x) validateattributes(x,{'numeric'},{'square','nonempty','integer','real','finite','nonnan','nonnegative'}));
addOptional(p,'w',0, @(x) isnumeric(x) && isreal(x) && isfinite(x) && isscalar(x) && ismember(x,[-1 0 1 2]));
addOptional(p,'alpha',0.05, @(x) validateattributes(x,{'numeric'},{'scalar','real','finite','nonnan','>',0,'<',1}));
parse(p,x,varargin{:});
x=p.Results.x; w=p.Results.w; alpha=p.Results.alpha;
clear p default* validation*

m=size(x,1);
tr=repmat('-',1,80);
if w==0 || w==-1
    f=diag(ones(1,m)); %unweighted
    disp('UNWEIGHTED COHEN''S KAPPA')
    disp(tr)
    kcomp;
    disp(' ')
end
if w==1 || w==-1
    J=repmat((1:1:m),m,1);
    I=flipud(rot90(J));
    f=1-abs(I-J)./(m-1); %linear weight
    disp('LINEAR WEIGHTED COHEN''S KAPPA')
    disp(tr)
    kcomp;
    disp(' ')
end
if w==2 || w==-1
    J=repmat((1:1:m),m,1);
    I=flipud(rot90(J));
    f=1-((I-J)./(m-1)).^2; %quadratic weight
    disp('QUADRATIC WEIGHTED COHEN''S KAPPA')
    disp(tr)
    kcomp;
end

    function kcomp
        n=sum(x(:)); %Sum of Matrix elements
        x=x./n; %proportion
        r=sum(x,2); %rows sum
        s=sum(x); %columns sum
        Ex=r*s; %expected proportion for random agree
        pom=sum(min([r';s])); %maximum proportion observable
        po=sum(sum(x.*f)); %proportion observed
        pe=sum(sum(Ex.*f)); %proportion expected
        k=(po-pe)/(1-pe); %Cohen's kappa
        km=(pom-pe)/(1-pe); %maximum possible kappa, given the observed marginal frequencies
        ratio=k/km; %observed as proportion of maximum possible
        sek=sqrt((po*(1-po))/(n*(1-pe)^2)); %kappa standard error for confidence interval
        ci=k+([-1 1].*(abs(-realsqrt(2)*erfcinv(alpha))*sek)); %k confidence interval
        wbari=r'*f;
        wbarj=s*f;
        wbar=repmat(wbari',1,m)+repmat(wbarj,m,1);
        a=Ex.*((f-wbar).^2);
        var=(sum(a(:))-pe^2)/(n*((1-pe)^2)); %variance
        z=k/sqrt(var); %normalized kappa
        p=(1-0.5*erfc(-abs(z)/realsqrt(2)))*2;
        %display results
        fprintf('Observed agreement (po) = %0.4f\n',po)
        fprintf('Random agreement (pe) = %0.4f\n',pe)
        fprintf('Agreement due to true concordance (po-pe) = %0.4f\n',po-pe)
        fprintf('Residual not random agreement (1-pe) = %0.4f\n',1-pe)
        fprintf('Cohen''s kappa = %0.4f\n',k)
        fprintf('kappa error = %0.4f\n',sek)
        fprintf('kappa C.I. (alpha = %0.4f) = %0.4f     %0.4f\n',alpha,ci)
        fprintf('Maximum possible kappa, given the observed marginal frequencies = %0.4f\n',km)
        fprintf('k observed as proportion of maximum possible = %0.4f\n',ratio)
        if k<0
            disp('Poor agreement')
        elseif k>=0 && k<=0.2
            disp('Slight agreement')
        elseif k>=0.21 && k<=0.4
            disp('Fair agreement')
        elseif k>=0.41 && k<=0.6
            disp('Moderate agreement')
        elseif k>=0.61 && k<=0.8
            disp('Substantial agreement')
        elseif k>=0.81 && k<=1
            disp('Perfect agreement')
        end
        fprintf('Variance = %0.4f     z (k/sqrt(var)) = %0.4f    p = %0.4f\n',var,z,p)
        if p<alpha
            disp('Reject null hypotesis: observed agreement is not accidental')
        else
            disp('Accept null hypotesis: observed agreement is accidental')
        end
    end
end