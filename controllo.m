function out_mat = controllo(array, groundtruth)
%Funzione per valutare la correttezza del risultato di un sudoku.
file=fopen(groundtruth,'r');
filestring=fscanf(file,'%c');
filestring=replace(filestring,' ','0');
out_mat = confmat(filestring,array);
end