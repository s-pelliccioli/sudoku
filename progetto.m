function [string,data]=progetto(filename)
%Funzione per il riconoscimento di uno schema Sudoku.
%String contiene la codifica dello schema.
%Data contiene la matrice di confusione calcolata da confmat per l'analisi dei risultati;
image = imread(filename);
grid = sudoku_finder(image);
vertex = line_finder(grid);

%Trasformazione dell'immagine
tform = fitgeotrans(vertex,[100 100;1000 100;1000 1000;100 1000], 'projective');
warped = imwarp(grid, tform);
stat = regionprops(warped, 'Area', 'BoundingBox');
[~, id] = max([stat.Area]);
cr = imcrop(imwarp(image,tform),stat(id).BoundingBox);

%Identificazione dei numeri e dell'angolo di rotazione dell'immagine.
numbers = number_finder(cr);
angle=rotation_recognition(numbers);
straight=imrotate(numbers,-angle);
digits= number_recognize(straight);

%Stampa della stringa di output.
car=num2str(digits);
nospaces=regexprep(car,'(\s)','');
final=replace(nospaces,'0',' ');
text = replace(filename, 'jpg', 'txt');

data = controllo(nospaces, text);%Matrice di confusione.
string = final;
end