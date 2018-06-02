data = load('900k_presamples_withtd.mat');
prune = load('pruned_indices.mat');
presample_data = data.presample_data_new;
labels = data.labels_new;
idxs = prune.idxs;

folds = 4;
N = length(labels);
accuracy = zeros(1,folds);
tp = 0;
fp = 0;
tn = 0;
fn = 0;
for k=1:4
    k
    test_data = presample_data(:, (k-1)*N/folds+1:k*N/folds).';
    test_labels = labels((k-1)*N/folds+1:k*N/folds).';
    train_data = presample_data.';
    train_data((k-1)*N/folds+1:k*N/folds, :) = [];
    train_labels = labels.';
    train_labels((k-1)*N/folds+1:k*N/folds) = [];

    cl = fitcsvm(train_data(:, idxs), train_labels, 'KernelFunction', 'rbf', 'BoxConstraint', Inf, 'ClassNames', [0, 1]);

    pred = predict(cl, test_data(:, idxs));
    accuracy(k) = sum(pred & test_labels)/sum(test_labels);

    for i=1:length(pred)
        if pred(i) == 1 && labels(i) == 1
            tp = tp + 1;
        elseif pred(i) == 1 && labels(i) == 0
            fp = fp + 1;
        elseif pred(i) == 0 && labels(i) == 1
            fn = fn + 1;
        else
            tn = tn + 1;
        end
    end
end
disp(accuracy);
