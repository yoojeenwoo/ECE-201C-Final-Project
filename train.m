function [cl] = train(presample_data, td, idx, thr, saver)
% @param presample_data: Training Data (360 x # of samples)
% @param td: Delay Time Output (1 x # of samples)
% @param idx: Relevant feature indices after pruning
% @param thr: Classification Threshold
% @param saver: Save classifier model
% @output cl: SVM Classifier Model


% Generate labels
labels = zeros(1, length(presample_data));
for i=1:length(td)
    if td(i) >= thr
        labels(i) = 1;
    end
end


% cl = fitcsvm(presample_data(idx,:).', labels.', 'KernelFunction', 'rbf', 'Cost', [0,1;1000,0], 'ClassNames', [0, 1]);
cl = fitcsvm(presample_data(idx,:).', labels.', 'KernelFunction', 'rbf', 'BoxConstraint', Inf, 'ClassNames', [0, 1]);
if saver
    saveCompactModel(cl, 'SVM_2_1k');
end
end
