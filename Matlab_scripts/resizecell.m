function NewMat=resizecell(OldMat,step)

%% function to resize the cell array with Matrices
%% Jerry Lin 20140925

temp = OldMat{1,1}(:,1);

NewMat=cellfun(@(x) x(1:step:length(temp)),OldMat,'UniformOutput',false);

return;

