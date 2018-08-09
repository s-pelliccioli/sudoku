function out_points =line_finder(img)
%Funzione per l'estrazione delle linee estreme di un sudoku e
%calcolo dei suoi vertici.
img = imclose(img, strel('disk', 3));
filled = imfill(img,'holes');
border = bwmorph(filled,'remove');
border = imdilate(border, strel('square', 3));
[h, t, r] = hough(border);
[row, col] = find(h>=0.3*ceil(max(h(:))));
peaks = cat(2, row, col);
lines = houghlines(border, t, r, peaks);
p1 = vertcat(lines.point1);
p2 = vertcat(lines.point2);
slope = (p2(:,2) - p1(:,2))./(p2(:,1) - p1(:,1));
slope(slope==Inf) = 10000000000000;
xleft = 1;
xright = size(img, 2);
yleft = slope .* (xleft-p1(:,1)) + p1(:,2);
yright = slope .* (xright-p2(:,1)) + p2(:,2);
%Disegno linee trovate.
%figure, imshow(border), hold on,plot([xleft, xright], [yleft, yright], 'LineWidth',2,'Color','green');
rhol=abs([lines.rho]);
thl = [lines.theta];
id1 = find(thl <= -45 | thl >= 45);
id2 = find(thl<45 & thl>-45);
bot = find(rhol==max(rhol(id1)),1);
top = find(rhol==min(rhol(id1)),1);
left = find(rhol==min(rhol(id2)),1);
right = find(rhol==max(rhol(id2)),1);

%Disegno delle rette estreme.
% figure, imshow(border), hold on,
% plot([xleft, xright], [yleft(bot), yright(bot)], 'LineWidth',2,'Color','red');
% plot([xleft, xright], [yleft(right), yright(right)], 'LineWidth',2,'Color','green');
% plot([xleft, xright], [yleft(left), yright(left)], 'LineWidth',2,'Color','blue');
% plot([xleft, xright], [yleft(top), yright(top)], 'LineWidth',2,'Color','magenta');

%Calcolo dei punti di intersezione.
xul = (yleft(left)-yleft(top))/(slope(top)-slope(left));
yul = slope(top)*xul + yleft(top);
xur = (yleft(right)-yleft(top))/(slope(top)-slope(right));
yur = slope(top)*xur + yleft(top);
xlr = (yleft(right)-yleft(bot))/(slope(bot)-slope(right));
ylr = slope(bot)*xlr + yleft(bot);
xll = (yleft(left)-yleft(bot))/(slope(bot)-slope(left));
yll = slope(bot)*xll + yleft(bot);

% Disegno dei punti di intersezione.
% plot(xul, yul, 'ro', 'Markersize', 5);
% plot(xur, yur, 'ro', 'Markersize', 5);
% plot(xlr, ylr, 'ro', 'Markersize', 5);
% plot(xll, yll, 'ro', 'Markersize', 5);

out_points = [xul yul;xur yur;xlr ylr;xll yll];
end