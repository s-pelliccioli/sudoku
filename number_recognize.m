function out_sudoku=number_recognize(image)
%Funzione per il riconoscimento dei numeri.
template=load('template.mat'); 
CC = bwconncomp(image);
stat = regionprops(CC, 'BoundingBox', 'Centroid');
coords = vertcat(stat.Centroid);
matrix = zeros(9);
for k=1:CC.NumObjects
    region = ismember(labelmatrix(CC),k);
    crop = imcrop(region, stat(k).BoundingBox);
    best = 0;
    for t=1:9
        corr = corr2(crop,imresize(template.template{t}, size(crop)));
        if corr > best
            best = corr;
            pos = t;
        end
    end
    %Calcolo della posizione corretta in base ai centroidi.
    xc=stat(k).Centroid(1);
    yc = stat(k).Centroid(2);
    %Normalizzazione delle coordinate nel range 1-9.
    row = round((((yc - min(coords(:,2)))/(max(coords(:,2))-min(coords(:,2))))*8)+1);
    column = round((((xc - min(coords(:,1)))/(max(coords(:,1))-min(coords(:,1))))*8)+1);
    matrix(row,column) = pos;
end
transpose = matrix';
out_sudoku = transpose(:)';
end