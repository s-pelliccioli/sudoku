function out_orientation=rotation_recognition(numbers)
%Funzione per valutare un' eventuale rotazione dell'immagine.
template = load('template.mat');
concomp = bwconncomp(numbers);
stat = regionprops(concomp, 'BoundingBox');
rotazione=0;
for a=1:concomp.NumObjects
    region = ismember(labelmatrix(concomp),a);
    crop = imcrop(region, stat(a).BoundingBox);
    best = -2;
    for r=0:90:270
        for t=1:9
            rot2 = imrotate(template.template{t},r);
            result = corr2(imresize(rot2,size(crop)),crop);
            if result > best
                best = result;
                rotazione=r;
                pos = t;
            end
        end
    end
    %Rimozione numeri invarianti per rotazione.
    if pos ~= 6 && pos ~=8 && pos~= 9
        break
    end
end
out_orientation=rotazione;
end