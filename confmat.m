function out=confmat(gt,predicted)
order = {'0' '1' '2' '3' '4' '5' '6' '7' '8' '9'};
cm_raw=confusionmat(gt(:),predicted(:), 'order', order);
out.cm_raw = cm_raw;
out.cm = cm_raw./repmat(sum(cm_raw,2),1,size(cm_raw,2));
out.cm(isnan(out.cm)) = 0;
out.labels = order;
out.accuracy = sum(diag(cm_raw))/numel(gt);
end