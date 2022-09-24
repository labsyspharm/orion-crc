function h=imagescorr(r,labels)
%% plot diagonal correlation matrix
%  modified from https://www.mathworks.com/matlabcentral/answers/699755-fancy-correlation-plots-in-matlab


n = size(r, 1);
y = triu(repmat(n+1, n, n) - (1:n)') + 0.5;
x = triu(repmat(1:n, n, 1)) + 0.5;
x(x == 0.5) = NaN;
scatter(x(:), y(:), 100.*sqrt(abs(r(:)))+2, r(:), 'filled', 'MarkerFaceAlpha', 0.6);

% enclose markers in a grid
xl = [1:n+1;repmat(n+1, 1, n+1)];
xl = [xl(:, 1), xl(:, 1:end-1)];
yl = repmat(n+1:-1:1, 2, 1);
line(xl, yl, 'color', 'k') % horizontal lines
line(yl, xl, 'color', 'k') % vertical lines

% show labels
text(1:n, (n:-1:1) + 0.5, labels, 'HorizontalAlignment', 'right','Interpreter','none')
text((1:n) + 0.5, repmat(n + 1, n, 1), labels, ...
    'HorizontalAlignment', 'right', 'Rotation', 270,'Interpreter','none')
h = gca;
colorbar(h);
h.Visible = 'off';
h.Position(4) = h.Position(4)*0.9;
axis(h, 'equal')

return;

