function sudoku = sudoku_finder(image)
%Funzione per identificare la griglia di un sudoku nell'immagine.
image = im2double(image);
ycbcr = rgb2ycbcr(image);
y = ycbcr(:,:,1);
blurred = imgaussfilt(y, 2);
filtered = imfilter(blurred, fspecial('log'));
bw = imbinarize(filtered);
morph = imdilate(bw, strel('disk', 1));
CC = bwconncomp(morph);
stats = regionprops(CC, 'Area', 'BoundingBox');
[~, id] = max([stats.Area]);
%figure, imshow(image), hold on, rectangle('Position', stats(id).BoundingBox, 'EdgeColor', 'r');
sudoku = ismember(labelmatrix(CC), id);
end