function [cl] = train(presample_data, td, idx, thr, saver)

%     load(data_file);
labels = zeros(1, length(presample_data));
for i=1:length(td)
    if td(i) >= thr
        labels(i) = 1;
    end
end


cl = fitcsvm(presample_data(idx,:).', labels.', 'KernelFunction', 'rbf', 'BoxConstraint', Inf, 'ClassNames', [0, 1]);
if saver
    saveCompactModel(cl, 'SVM_900k_pruned');
end
end
