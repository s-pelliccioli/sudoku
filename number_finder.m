function out_numbers=number_finder(image)
ycbcr = rgb2ycbcr(image);
y = ycbcr(:,:,1);
blurred = imgaussfilt(y,2);
filtered = imfilter(blurred, fspecial('log'));
bw = imbinarize(filtered);
morph = imclose(bw,strel('square', 6));
CC = bwconncomp(morph);
stat = regionprops(CC,'Area');
areas = [stat.Area];
id = find(areas>250 & areas<2000);
out_numbers= ismember(labelmatrix(CC), id);
end